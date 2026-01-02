-- GUI de Login
local loginBrowser = nil
local screenWidth, screenHeight = guiGetScreenSize()

function showLoginGUI()
    outputChatBox("[DEBUG] showLoginGUI() llamado", 255, 255, 0)
    
    if loginBrowser then
        destroyElement(loginBrowser)
        loginBrowser = nil
    end
    
    outputChatBox("[DEBUG] Creando navegador...", 255, 255, 0)
    loginBrowser = createBrowser(screenWidth, screenHeight, true, true)
    
    if not loginBrowser then
        outputChatBox("[ERROR] No se pudo crear el navegador. Verifica que el navegador esté habilitado en MTA.", 255, 0, 0)
        return
    end
    
    addEventHandler("onClientBrowserCreated", loginBrowser, function()
        outputChatBox("[DEBUG] Navegador creado, cargando URL...", 255, 255, 0)
        loadBrowserURL(loginBrowser, "http://mta/local/login.html")
        showCursor(true)
        guiSetInputEnabled(true)
    end)
    
    addEventHandler("onClientBrowserDocumentReady", loginBrowser, function(url)
        outputChatBox("[DEBUG] Documento listo: " .. tostring(url), 255, 255, 0)
        if url == "http://mta/local/login.html" then
            -- Exponer funciones al navegador usando callRemote
            executeBrowserJavascript(loginBrowser, [[
                window.login = function(username, password) {
                    callRemote('onPlayerLogin', username, password);
                };
                window.register = function(username, password, email) {
                    callRemote('onPlayerRegister', username, password, email);
                };
            ]])
            outputChatBox("[DEBUG] Funciones JavaScript expuestas", 0, 255, 0)
        end
    end)
end

function hideLoginGUI()
    if loginBrowser then
        destroyElement(loginBrowser)
        loginBrowser = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Eventos del servidor
addEvent("showLoginGUI", true)
addEventHandler("showLoginGUI", resourceRoot, function()
    outputChatBox("Mostrando GUI de login...", 255, 255, 0)
    if not loginBrowser then
        showLoginGUI()
    end
end)

-- También mostrar login cuando el recurso se inicia y el jugador ya está conectado
addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("Recurso iniciado, verificando login...", 255, 255, 0)
    setTimer(function()
        local loggedIn = getElementData(localPlayer, "account:loggedIn")
        outputChatBox("[DEBUG] Estado de login: " .. tostring(loggedIn), 255, 255, 0)
        
        if loggedIn ~= true then
            if not loginBrowser then
                outputChatBox("Mostrando login automáticamente...", 255, 255, 0)
                showLoginGUI()
            else
                outputChatBox("Login ya está mostrado", 0, 255, 0)
            end
        else
            outputChatBox("Ya estás logueado", 0, 255, 0)
        end
    end, 3000, 1)
end)

addEvent("loginResponse", true)
addEventHandler("loginResponse", resourceRoot, function(success, message)
    if success then
        hideLoginGUI()
    else
        -- Mostrar mensaje de error en el navegador
        if loginBrowser then
            executeBrowserJavascript(loginBrowser, "showError('" .. message:gsub("'", "\\'") .. "')")
        end
    end
end)

addEvent("registerResponse", true)
addEventHandler("registerResponse", resourceRoot, function(success, message)
    if loginBrowser then
        local safeMessage = message:gsub("'", "\\'")
        if success then
            executeBrowserJavascript(loginBrowser, "showSuccess('" .. safeMessage .. "')")
        else
            executeBrowserJavascript(loginBrowser, "showError('" .. safeMessage .. "')")
        end
    end
end)

-- callRemote handlers (se llaman directamente desde el navegador)
addEvent("onPlayerLogin", true)
addEventHandler("onPlayerLogin", root, function(username, password)
    triggerServerEvent("onPlayerLogin", localPlayer, username, password)
end)

addEvent("onPlayerRegister", true)
addEventHandler("onPlayerRegister", root, function(username, password, email)
    triggerServerEvent("onPlayerRegister", localPlayer, username, password, email)
end)

addEvent("onClientBrowserNavigate", true)
addEventHandler("onClientBrowserNavigate", loginBrowser, function(url, isBlocked, isMainFrame)
    if url ~= "http://mta/local/login.html" and isMainFrame then
        cancelEvent()
    end
end)

-- Renderizar el navegador
addEventHandler("onClientRender", root, function()
    if loginBrowser then
        dxDrawImage(0, 0, screenWidth, screenHeight, loginBrowser, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end)
