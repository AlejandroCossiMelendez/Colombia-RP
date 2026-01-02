-- GUI de Login usando Navegador Web (igual que phone-example)
local loginBrowser = nil
local browserContent = nil
local screenWidth, screenHeight = guiGetScreenSize()

function loadBrowser() 
    loadBrowserURL(source, "http://mta/local/html/login.html")
end

function whenBrowserReady()
    -- El navegador está listo, podemos inyectar funciones si es necesario
end

function showLoginGUI()
    -- Si ya existe, no crear otra vez
    if loginBrowser then
        if isElement(loginBrowser) then
            guiSetVisible(loginBrowser, true)
            return
        end
    end
    
    -- Crear navegador usando el mismo método que phone-example
    loginBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
    browserContent = guiGetBrowser(loginBrowser)
    
    if not loginBrowser or not browserContent then
        outputChatBox("Error: No se pudo crear el navegador", 255, 0, 0)
        return
    end
    
    -- Configurar input mode
    guiSetInputMode("no_binds_when_editing")
    
    -- Eventos del navegador
    addEventHandler("onClientBrowserCreated", loginBrowser, loadBrowser)
    addEventHandler("onClientBrowserDocumentReady", loginBrowser, whenBrowserReady)
    
    -- Mostrar cursor y habilitar input
    showCursor(true)
    guiSetInputEnabled(true)
end

function hideLoginGUI()
    if loginBrowser and isElement(loginBrowser) then
        removeEventHandler("onClientBrowserCreated", loginBrowser, loadBrowser)
        removeEventHandler("onClientBrowserDocumentReady", loginBrowser, whenBrowserReady)
        guiSetInputMode("allow_binds")
        destroyElement(loginBrowser)
        loginBrowser = nil
        browserContent = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Eventos desde el navegador
addEvent("doLogin", true)
addEventHandler("doLogin", resourceRoot, function(username, password)
    if not username or not password then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('Por favor completa todos los campos'); setLoading('loginBtn', false);")
        end
        return
    end
    
    if string.len(username) < 3 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('El usuario debe tener al menos 3 caracteres'); setLoading('loginBtn', false);")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("colombiaRP:playerLogin", localPlayer, username, password)
end)

addEvent("doRegister", true)
addEventHandler("doRegister", resourceRoot, function(username, password, email)
    if not username or not password or not email then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('Por favor completa todos los campos'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if string.len(username) < 3 or string.len(username) > 20 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('El usuario debe tener entre 3 y 20 caracteres'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if string.len(password) < 6 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('La contraseña debe tener al menos 6 caracteres'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('Email inválido'); setLoading('registerBtn', false);")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("colombiaRP:playerRegister", localPlayer, username, password, email)
end)

-- Eventos del servidor
addEvent("showLoginGUI", true)
addEventHandler("showLoginGUI", resourceRoot, function()
    showLoginGUI()
end)

addEvent("loginResponse", true)
addEventHandler("loginResponse", resourceRoot, function(success, message)
    if browserContent and isElement(browserContent) then
        if success then
            executeBrowserJavascript(browserContent, "showSuccess('Login exitoso'); setLoading('loginBtn', false);")
            -- Ocultar login y mostrar panel de personajes SOLO después de confirmar login exitoso
            setTimer(function()
                -- Verificar que el login fue exitoso ANTES de ocultar login
                local loggedIn = getElementData(localPlayer, "account:loggedIn")
                local userId = getElementData(localPlayer, "account:userId")
                
                if loggedIn == true and userId then
                    -- Login confirmado, ocultar login
                    hideLoginGUI()
                    -- Esperar un momento y luego mostrar panel de personajes
                    setTimer(function()
                        -- Verificar nuevamente antes de mostrar personajes
                        local loggedIn2 = getElementData(localPlayer, "account:loggedIn")
                        local userId2 = getElementData(localPlayer, "account:userId")
                        
                        if loggedIn2 == true and userId2 then
                            -- Ahora sí, mostrar panel de personajes
                            if showCharacterGUI then
                                showCharacterGUI()
                            end
                        else
                            outputChatBox("Error: No se pudo verificar el login", 255, 0, 0)
                            -- Volver a mostrar login si falla la verificación
                            if showLoginGUI then
                                showLoginGUI()
                            end
                        end
                    end, 300, 1)
                else
                    outputChatBox("Error: No se pudo verificar el login", 255, 0, 0)
                end
            end, 1500, 1)
        else
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message) .. "'); setLoading('loginBtn', false);")
        end
    end
end)

addEvent("registerResponse", true)
addEventHandler("registerResponse", resourceRoot, function(success, message)
    if browserContent and isElement(browserContent) then
        if success then
            executeBrowserJavascript(browserContent, "showSuccess('" .. tostring(message) .. "'); setLoading('registerBtn', false);")
            -- Cambiar a modo login después de registro exitoso
            setTimer(function()
                if browserContent and isElement(browserContent) then
                    executeBrowserJavascript(browserContent, "switchTab('login'); hideMessage();")
                    executeBrowserJavascript(browserContent, [[
                        document.getElementById('loginUsername').value = '';
                        document.getElementById('loginPassword').value = '';
                        document.getElementById('registerUsername').value = '';
                        document.getElementById('registerEmail').value = '';
                        document.getElementById('registerPassword').value = '';
                        document.getElementById('confirmPassword').value = '';
                    ]])
                end
            end, 2000, 1)
        else
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message) .. "'); setLoading('registerBtn', false);")
        end
    end
end)

-- NO mostrar login automáticamente al iniciar el recurso
-- El servidor se encarga de mostrar el login cuando el jugador se conecta
-- Esto evita conflictos cuando el recurso se recarga

-- Limpiar al cerrar el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    hideLoginGUI()
end)
