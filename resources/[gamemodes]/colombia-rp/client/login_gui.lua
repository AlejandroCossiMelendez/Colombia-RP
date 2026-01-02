-- GUI de Login usando Navegador Web (HTML/CSS/JS)
local loginBrowser = nil
local isBrowserReady = false

function showLoginGUI()
    -- Si ya existe, no crear otra vez
    if loginBrowser then
        if isElement(loginBrowser) then
            guiSetVisible(loginBrowser, true)
            return
        end
    end
    
    outputChatBox("Cargando interfaz de login...", 255, 255, 0)
    
    -- Crear navegador web
    local screenWidth, screenHeight = guiGetScreenSize()
    loginBrowser = createBrowser(screenWidth, screenHeight, true, true)
    
    if not loginBrowser then
        outputChatBox("Error: No se pudo crear el navegador. Usando GUI alternativa.", 255, 0, 0)
        -- Fallback a GUI nativa si el navegador no está disponible
        showLoginGUIFallback()
        return
    end
    
    -- Cargar HTML
    loadBrowserURL(loginBrowser, "http://mta/local/login.html")
    
    -- Mostrar cursor y habilitar input
    showCursor(true)
    guiSetInputEnabled(true)
    
    -- Esperar a que el navegador esté listo
    addEventHandler("onClientBrowserCreated", loginBrowser, function()
        isBrowserReady = true
        -- Inyectar funciones JavaScript para comunicación con Lua
        injectBrowserFunctions()
    end)
    
    -- Manejar cuando el navegador se carga completamente
    addEventHandler("onClientBrowserDocumentReady", loginBrowser, function(url)
        if url == "http://mta/local/login.html" then
            isBrowserReady = true
            injectBrowserFunctions()
        end
    end)
end

-- Inyectar funciones JavaScript para comunicación
function injectBrowserFunctions()
    if not loginBrowser or not isElement(loginBrowser) then
        return
    end
    
    -- Las funciones window.login y window.register ya están definidas en el HTML
    -- Solo necesitamos asegurarnos de que el navegador esté listo
    -- La comunicación se hace a través de eventos MTA nativos
end

-- Función de fallback (GUI nativa) si el navegador no está disponible
function showLoginGUIFallback()
    -- Implementación básica de GUI nativa como respaldo
    outputChatBox("Por favor, contacta a un administrador si ves este mensaje.", 255, 255, 0)
end

-- Eventos desde el navegador
addEvent("doLogin", true)
addEventHandler("doLogin", resourceRoot, function(username, password)
    if not username or not password then
        if loginBrowser and isElement(loginBrowser) then
            executeJavaScript(loginBrowser, "showError('Por favor completa todos los campos'); setLoading('loginBtn', false);")
        end
        return
    end
    
    if string.len(username) < 3 then
        if loginBrowser and isElement(loginBrowser) then
            executeJavaScript(loginBrowser, "showError('El usuario debe tener al menos 3 caracteres'); setLoading('loginBtn', false);")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("colombiaRP:playerLogin", localPlayer, username, password)
end)

addEvent("doRegister", true)
addEventHandler("doRegister", resourceRoot, function(username, password, email)
    if not username or not password or not email then
        if loginBrowser and isElement(loginBrowser) then
            executeJavaScript(loginBrowser, "showError('Por favor completa todos los campos'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if string.len(username) < 3 or string.len(username) > 20 then
        if loginBrowser and isElement(loginBrowser) then
            executeJavaScript(loginBrowser, "showError('El usuario debe tener entre 3 y 20 caracteres'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if string.len(password) < 6 then
        if loginBrowser and isElement(loginBrowser) then
            executeJavaScript(loginBrowser, "showError('La contraseña debe tener al menos 6 caracteres'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        if loginBrowser and isElement(loginBrowser) then
            executeJavaScript(loginBrowser, "showError('Email inválido'); setLoading('registerBtn', false);")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("colombiaRP:playerRegister", localPlayer, username, password, email)
end)

function hideLoginGUI()
    if loginBrowser and isElement(loginBrowser) then
        guiSetVisible(loginBrowser, false)
        destroyElement(loginBrowser)
        loginBrowser = nil
        isBrowserReady = false
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Eventos del servidor
addEvent("showLoginGUI", true)
addEventHandler("showLoginGUI", resourceRoot, function()
    showLoginGUI()
end)

addEvent("loginResponse", true)
addEventHandler("loginResponse", resourceRoot, function(success, message)
    if loginBrowser and isElement(loginBrowser) then
        if success then
            executeJavaScript(loginBrowser, "showSuccess('Login exitoso'); setLoading('loginBtn', false);")
            setTimer(function()
                hideLoginGUI()
            end, 1000, 1)
        else
            executeJavaScript(loginBrowser, "showError('" .. tostring(message) .. "'); setLoading('loginBtn', false);")
        end
    end
end)

addEvent("registerResponse", true)
addEventHandler("registerResponse", resourceRoot, function(success, message)
    if loginBrowser and isElement(loginBrowser) then
        if success then
            executeJavaScript(loginBrowser, "showSuccess('" .. tostring(message) .. "'); setLoading('registerBtn', false);")
            -- Cambiar a modo login después de registro exitoso
            setTimer(function()
                if loginBrowser and isElement(loginBrowser) then
                    executeJavaScript(loginBrowser, "switchTab('login'); hideMessage();")
                    executeJavaScript(loginBrowser, [[
                        document.getElementById('loginUsername').value = '';
                        document.getElementById('loginPassword').value = '';
                        document.getElementById('registerUsername').value = '';
                        document.getElementById('registerEmail').value = '';
                        document.getElementById('registerPassword').value = '';
                    ]])
                end
            end, 2000, 1)
        else
            executeJavaScript(loginBrowser, "showError('" .. tostring(message) .. "'); setLoading('registerBtn', false);")
        end
    end
end)

-- Mostrar login cuando el recurso se inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        local loggedIn = getElementData(localPlayer, "account:loggedIn")
        if loggedIn ~= true then
            showLoginGUI()
        end
    end, 2000, 1)
end)

-- Limpiar al cerrar el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    if loginBrowser and isElement(loginBrowser) then
        destroyElement(loginBrowser)
        loginBrowser = nil
    end
end)
