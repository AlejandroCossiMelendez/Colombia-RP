-- GUI de Login usando Navegador Web (HTML/CSS/JS)
local loginBrowser = nil
local loginBrowserElement = nil -- Referencia al elemento browser interno
local isBrowserReady = false

function showLoginGUI()
    -- Si ya existe, no crear otra vez
    if loginBrowser then
        if isElement(loginBrowser) then
            guiSetVisible(loginBrowser, true)
            setBrowserRenderingPaused(loginBrowser, false)
            return
        end
    end
    
    outputChatBox("Cargando interfaz de login...", 255, 255, 0)
    
    -- Crear navegador web usando guiCreateBrowser (se dibuja automáticamente)
    local screenWidth, screenHeight = guiGetScreenSize()
    loginBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, false)
    
    if not loginBrowser then
        outputChatBox("Error: No se pudo crear el navegador. Usando GUI alternativa.", 255, 0, 0)
        -- Fallback a GUI nativa si el navegador no está disponible
        showLoginGUIFallback()
        return
    end
    
    -- Obtener el elemento browser del GUI browser
    local browser = guiGetBrowser(loginBrowser)
    
    if not browser then
        outputChatBox("Error: No se pudo obtener el navegador del GUI.", 255, 0, 0)
        showLoginGUIFallback()
        return
    end
    
    -- Hacer visible el navegador
    guiSetVisible(loginBrowser, true)
    setBrowserRenderingPaused(browser, false)
    
    -- Cargar HTML
    loadBrowserURL(browser, "http://mta/local/login.html")
    
    -- Mostrar cursor y habilitar input
    showCursor(true)
    guiSetInputEnabled(true)
    
    -- Guardar referencia al browser para uso posterior
    loginBrowserElement = browser
    
    -- Manejar cuando el navegador se carga completamente
    addEventHandler("onClientBrowserDocumentReady", browser, function(url)
        if url == "http://mta/local/login.html" then
            isBrowserReady = true
            outputChatBox("Interfaz de login cargada correctamente", 0, 255, 0)
            injectBrowserFunctions()
        end
    end)
    
    -- Manejar errores de carga
    addEventHandler("onClientBrowserCreated", browser, function()
        isBrowserReady = true
        outputChatBox("Navegador creado, cargando interfaz...", 255, 255, 0)
    end)
end

-- Inyectar funciones JavaScript para comunicación
function injectBrowserFunctions()
    local browser = loginBrowserElement or (loginBrowser and guiGetBrowser(loginBrowser))
    
    if not browser or not isElement(browser) then
        outputChatBox("Error: Navegador no disponible para inyectar funciones", 255, 0, 0)
        return
    end
    
    -- Las funciones window.login y window.register ya están definidas en el HTML
    -- Solo necesitamos asegurarnos de que el navegador esté listo
    -- La comunicación se hace a través de eventos MTA nativos
    outputChatBox("Funciones JavaScript listas", 0, 255, 0)
end

-- Función de fallback (GUI nativa) si el navegador no está disponible
function showLoginGUIFallback()
    -- Implementación básica de GUI nativa como respaldo
    outputChatBox("Por favor, contacta a un administrador si ves este mensaje.", 255, 255, 0)
end

-- Función helper para obtener el browser element
local function getBrowserElement()
    return loginBrowserElement or (loginBrowser and guiGetBrowser(loginBrowser))
end

-- Eventos desde el navegador
addEvent("doLogin", true)
addEventHandler("doLogin", resourceRoot, function(username, password)
    local browser = getBrowserElement()
    
    if not username or not password then
        if browser and isElement(browser) then
            executeJavaScript(browser, "showError('Por favor completa todos los campos'); setLoading('loginBtn', false);")
        end
        return
    end
    
    if string.len(username) < 3 then
        if browser and isElement(browser) then
            executeJavaScript(browser, "showError('El usuario debe tener al menos 3 caracteres'); setLoading('loginBtn', false);")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("colombiaRP:playerLogin", localPlayer, username, password)
end)

addEvent("doRegister", true)
addEventHandler("doRegister", resourceRoot, function(username, password, email)
    local browser = getBrowserElement()
    
    if not username or not password or not email then
        if browser and isElement(browser) then
            executeJavaScript(browser, "showError('Por favor completa todos los campos'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if string.len(username) < 3 or string.len(username) > 20 then
        if browser and isElement(browser) then
            executeJavaScript(browser, "showError('El usuario debe tener entre 3 y 20 caracteres'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if string.len(password) < 6 then
        if browser and isElement(browser) then
            executeJavaScript(browser, "showError('La contraseña debe tener al menos 6 caracteres'); setLoading('registerBtn', false);")
        end
        return
    end
    
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        if browser and isElement(browser) then
            executeJavaScript(browser, "showError('Email inválido'); setLoading('registerBtn', false);")
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
        loginBrowserElement = nil
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
    local browser = getBrowserElement()
    
    if browser and isElement(browser) then
        if success then
            executeJavaScript(browser, "showSuccess('Login exitoso'); setLoading('loginBtn', false);")
            setTimer(function()
                hideLoginGUI()
            end, 1000, 1)
        else
            executeJavaScript(browser, "showError('" .. tostring(message) .. "'); setLoading('loginBtn', false);")
        end
    end
end)

addEvent("registerResponse", true)
addEventHandler("registerResponse", resourceRoot, function(success, message)
    local browser = getBrowserElement()
    
    if browser and isElement(browser) then
        if success then
            executeJavaScript(browser, "showSuccess('" .. tostring(message) .. "'); setLoading('registerBtn', false);")
            -- Cambiar a modo login después de registro exitoso
            setTimer(function()
                local browser2 = getBrowserElement()
                if browser2 and isElement(browser2) then
                    executeJavaScript(browser2, "switchTab('login'); hideMessage();")
                    executeJavaScript(browser2, [[
                        document.getElementById('loginUsername').value = '';
                        document.getElementById('loginPassword').value = '';
                        document.getElementById('registerUsername').value = '';
                        document.getElementById('registerEmail').value = '';
                        document.getElementById('registerPassword').value = '';
                    ]])
                end
            end, 2000, 1)
        else
            executeJavaScript(browser, "showError('" .. tostring(message) .. "'); setLoading('registerBtn', false);")
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
        loginBrowserElement = nil
    end
end)
