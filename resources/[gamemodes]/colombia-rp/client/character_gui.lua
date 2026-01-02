-- GUI de Selección de Personajes usando Navegador Web (igual que phone-example)
local characterBrowser = nil
local browserContent = nil
local screenWidth, screenHeight = guiGetScreenSize()

function loadBrowser() 
    -- VERIFICACIÓN: Solo cargar el HTML si el jugador está logueado
    local loggedIn = getElementData(localPlayer, "account:loggedIn")
    local userId = getElementData(localPlayer, "account:userId")
    
    if loggedIn == true and userId then
        -- Solo cargar el HTML si el jugador está logueado
        loadBrowserURL(source, "http://mta/local/html/characters.html")
    else
        -- Si no está logueado, no cargar el HTML y destruir el navegador
        outputChatBox("Error: Debes iniciar sesión primero", 255, 0, 0)
        if characterBrowser and isElement(characterBrowser) then
            destroyElement(characterBrowser)
            characterBrowser = nil
            browserContent = nil
        end
        if showLoginGUI then
            showLoginGUI()
        end
    end
end

function whenBrowserReady()
    -- El navegador está listo
    -- VERIFICACIÓN CRÍTICA: Solo proceder si el jugador está logueado
    local loggedIn = getElementData(localPlayer, "account:loggedIn")
    local userId = getElementData(localPlayer, "account:userId")
    
    -- Doble verificación: debe estar logueado Y tener userId
    if loggedIn == true and userId then
        -- NO mostrar el navegador todavía - solo solicitar personajes
        -- El navegador se mostrará cuando se reciban los personajes en receiveCharacters
        if characterBrowser and isElement(characterBrowser) then
            -- El navegador permanece oculto hasta que se carguen los personajes
            -- Solicitar personajes del usuario logueado
            triggerServerEvent("requestCharacters", localPlayer)
        end
    else
        -- Si no está logueado, DESTRUIR el navegador y mostrar login
        outputChatBox("Error: Debes iniciar sesión primero", 255, 0, 0)
        hideCharacterGUI()
        -- Mostrar login si no está logueado
        if showLoginGUI then
            showLoginGUI()
        end
    end
end

function showCharacterGUI()
    -- VERIFICACIÓN ESTRICTA: Solo mostrar personajes si el jugador está logueado
    -- Esta función SOLO debe llamarse después de un login exitoso
    local loggedIn = getElementData(localPlayer, "account:loggedIn")
    local userId = getElementData(localPlayer, "account:userId")
    
    -- TRIPLE verificación: debe estar logueado, tener userId, y no tener personaje seleccionado
    if not loggedIn or loggedIn ~= true or not userId then
        outputChatBox("Error: Debes iniciar sesión primero", 255, 0, 0)
        -- Destruir cualquier navegador de personajes que pueda existir
        hideCharacterGUI()
        -- Mostrar login si no está logueado
        if showLoginGUI then
            showLoginGUI()
        end
        return
    end
    
    -- Solo proceder si el jugador está logueado
    
    -- Si ya existe, no crear otra vez
    if characterBrowser then
        if isElement(characterBrowser) then
            -- Verificar nuevamente que esté logueado antes de mostrar
            local loggedInCheck = getElementData(localPlayer, "account:loggedIn")
            local userIdCheck = getElementData(localPlayer, "account:userId")
            if loggedInCheck == true and userIdCheck then
                guiSetVisible(characterBrowser, true)
                triggerServerEvent("requestCharacters", localPlayer)
            else
                -- Si no está logueado, destruir el navegador
                hideCharacterGUI()
                if showLoginGUI then
                    showLoginGUI()
                end
            end
            return
        else
            -- Si el elemento fue destruido, limpiar la referencia
            characterBrowser = nil
            browserContent = nil
        end
    end
    
    -- IMPORTANTE: El navegador SOLO se crea después de un login exitoso confirmado
    -- Crear navegador usando el mismo método que phone-example
    characterBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
    browserContent = guiGetBrowser(characterBrowser)
    
    if not characterBrowser or not browserContent then
        outputChatBox("Error: No se pudo crear el navegador", 255, 0, 0)
        return
    end
    
    -- IMPORTANTE: Ocultar el navegador hasta que se carguen los personajes
    -- El navegador NO se mostrará hasta que receiveCharacters lo muestre
    guiSetVisible(characterBrowser, false)
    
    -- Configurar input mode
    guiSetInputMode("no_binds_when_editing")
    
    -- Eventos del navegador
    addEventHandler("onClientBrowserCreated", characterBrowser, loadBrowser)
    addEventHandler("onClientBrowserDocumentReady", characterBrowser, whenBrowserReady)
    
    -- Mostrar cursor y habilitar input
    showCursor(true)
    guiSetInputEnabled(true)
end

function hideCharacterGUI()
    if characterBrowser and isElement(characterBrowser) then
        removeEventHandler("onClientBrowserCreated", characterBrowser, loadBrowser)
        removeEventHandler("onClientBrowserDocumentReady", characterBrowser, whenBrowserReady)
        guiSetInputMode("allow_binds")
        destroyElement(characterBrowser)
        characterBrowser = nil
        browserContent = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Eventos desde el navegador
addEvent("selectCharacter", true)
addEventHandler("selectCharacter", resourceRoot, function(characterId)
    if characterId then
        triggerServerEvent("selectCharacter", localPlayer, characterId)
    end
end)

addEvent("createCharacter", true)
addEventHandler("createCharacter", resourceRoot, function(name, surname, age, gender, skin)
    if not name or not surname then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('Por favor completa todos los campos');")
        end
        return
    end
    
    if string.len(name) < 2 or string.len(name) > 20 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('El nombre debe tener entre 2 y 20 caracteres');")
        end
        return
    end
    
    if string.len(surname) < 2 or string.len(surname) > 20 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('El apellido debe tener entre 2 y 20 caracteres');")
        end
        return
    end
    
    local ageNum = tonumber(age)
    if not ageNum or ageNum < 18 or ageNum > 100 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('La edad debe estar entre 18 y 100 años');")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("createCharacter", localPlayer, name, surname, ageNum, tonumber(gender) or 0, tonumber(skin) or 0)
end)

addEvent("deleteCharacter", true)
addEventHandler("deleteCharacter", resourceRoot, function(characterId)
    if characterId then
        triggerServerEvent("deleteCharacter", localPlayer, characterId)
    end
end)

-- Eventos del servidor
-- IMPORTANTE: Este evento SOLO debe ser llamado después de un login exitoso
addEvent("showCharacterGUI", true)
addEventHandler("showCharacterGUI", resourceRoot, function()
    -- VERIFICACIÓN ESTRICTA: Solo mostrar personajes si el jugador está logueado
    local loggedIn = getElementData(localPlayer, "account:loggedIn")
    local userId = getElementData(localPlayer, "account:userId")
    
    -- Verificación triple: debe estar logueado Y tener userId
    if loggedIn == true and userId then
        -- Login confirmado, mostrar panel de personajes
        showCharacterGUI()
    else
        -- Si no está logueado, BLOQUEAR completamente
        outputChatBox("Error: Debes iniciar sesión primero", 255, 0, 0)
        -- Destruir cualquier navegador de personajes
        hideCharacterGUI()
        -- Mostrar login
        if showLoginGUI then
            showLoginGUI()
        end
    end
end)

addEvent("hideCharacterGUI", true)
addEventHandler("hideCharacterGUI", resourceRoot, function()
    hideCharacterGUI()
end)

-- Función helper para escapar strings JSON
local function escapeJSON(str)
    if not str then return "" end
    str = tostring(str)
    str = string.gsub(str, "\\", "\\\\")
    str = string.gsub(str, "\"", "\\\"")
    str = string.gsub(str, "\n", "\\n")
    str = string.gsub(str, "\r", "\\r")
    str = string.gsub(str, "\t", "\\t")
    return str
end

addEvent("receiveCharacters", true)
addEventHandler("receiveCharacters", resourceRoot, function(charList)
    -- Verificar que el jugador esté logueado antes de mostrar personajes
    local loggedIn = getElementData(localPlayer, "account:loggedIn")
    local userId = getElementData(localPlayer, "account:userId")
    
    if not loggedIn or not userId then
        -- Si no está logueado, ocultar navegador y mostrar login
        hideCharacterGUI()
        if showLoginGUI then
            showLoginGUI()
        end
        return
    end
    
    if browserContent and isElement(browserContent) then
        -- Convertir tabla Lua a JSON manualmente
        local json = "["
        local first = true
        for i, char in ipairs(charList or {}) do
            if not first then
                json = json .. ","
            end
            first = false
            json = json .. "{"
            json = json .. "\"id\":" .. (char.id or 0) .. ","
            json = json .. "\"name\":\"" .. escapeJSON(char.name or "") .. "\","
            json = json .. "\"surname\":\"" .. escapeJSON(char.surname or "") .. "\","
            json = json .. "\"age\":" .. (char.age or 18) .. ","
            json = json .. "\"money\":" .. (char.money or 0) .. ","
            json = json .. "\"lastLogin\":\"" .. escapeJSON(char.lastLogin or "") .. "\""
            json = json .. "}"
        end
        json = json .. "]"
        executeBrowserJavascript(browserContent, "loadCharacters(" .. json .. ");")
        
        -- IMPORTANTE: Mostrar el navegador SOLO después de cargar los personajes
        if characterBrowser and isElement(characterBrowser) then
            guiSetVisible(characterBrowser, true)
        end
    end
end)

addEvent("characterCreateResponse", true)
addEventHandler("characterCreateResponse", resourceRoot, function(success, message)
    if browserContent and isElement(browserContent) then
        if success then
            executeBrowserJavascript(browserContent, "showSuccess('Personaje creado exitosamente');")
            -- Recargar lista de personajes
            setTimer(function()
                triggerServerEvent("requestCharacters", localPlayer)
            end, 1000, 1)
        else
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message) .. "');")
        end
    end
end)

addEvent("characterSelectResponse", true)
addEventHandler("characterSelectResponse", resourceRoot, function(success, message)
    if browserContent and isElement(browserContent) then
        if not success then
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message) .. "');")
        else
            -- Ocultar GUI al seleccionar exitosamente
            setTimer(function()
                hideCharacterGUI()
            end, 500, 1)
        end
    end
end)

addEvent("characterDeleteResponse", true)
addEventHandler("characterDeleteResponse", resourceRoot, function(success, message)
    if browserContent and isElement(browserContent) then
        if success then
            executeBrowserJavascript(browserContent, "showSuccess('Personaje eliminado exitosamente');")
            -- Recargar lista de personajes
            setTimer(function()
                triggerServerEvent("requestCharacters", localPlayer)
            end, 1000, 1)
        else
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message) .. "');")
        end
    end
end)

-- Limpiar al cerrar el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    hideCharacterGUI()
end)

-- IMPORTANTE: El panel de personajes NO debe cargarse ni mostrarse hasta después del login
-- Este script se carga pero NO hace nada hasta que se llame explícitamente showCharacterGUI() después de un login exitoso
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- FORZAR: Destruir cualquier navegador de personajes que pueda existir
    if characterBrowser and isElement(characterBrowser) then
        destroyElement(characterBrowser)
        characterBrowser = nil
        browserContent = nil
    end
    -- Asegurarse de que el cursor esté oculto
    showCursor(false)
    guiSetInputEnabled(false)
    -- NO hacer nada más - el panel de personajes solo se mostrará después del login
end)
