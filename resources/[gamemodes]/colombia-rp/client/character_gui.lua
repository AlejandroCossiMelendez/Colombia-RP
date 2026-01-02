-- GUI de Selección de Personajes usando Navegador Web
local characterBrowser = nil
local browserContent = nil
local screenWidth, screenHeight = guiGetScreenSize()
local cursorCheckTimer = nil

function loadCharacterBrowser() 
    loadBrowserURL(source, "http://mta/local/html/character.html")
end

function whenCharacterBrowserReady()
    -- El navegador está listo, asegurar que el cursor esté visible
    showCursor(true)
    guiSetInputEnabled(true)
    guiSetInputMode("no_binds_when_editing")
    
            -- Forzar cursor múltiples veces después de que el navegador esté listo
            setTimer(function()
                showCursor(true)
                guiSetInputEnabled(true)
                guiSetInputMode("no_binds_when_editing")
            end, 50, 3)
            
            -- Asegurar que el timer de verificación esté activo
            if not cursorCheckTimer or not isTimer(cursorCheckTimer) then
                cursorCheckTimer = setTimer(ensureCursorVisible, 100, 0)
            end
    
    -- Solicitar lista de personajes
    triggerServerEvent("requestCharacters", localPlayer)
end

function showCharacterGUI()
    -- Si ya existe, no crear otra vez
    if characterBrowser then
        if isElement(characterBrowser) then
            guiSetVisible(characterBrowser, true)
            -- Forzar cursor múltiples veces para asegurar
            showCursor(true)
            guiSetInputEnabled(true)
            guiSetInputMode("no_binds_when_editing")
            setTimer(function()
                showCursor(true)
                guiSetInputEnabled(true)
            end, 50, 3)
            -- Recargar personajes
            triggerServerEvent("requestCharacters", localPlayer)
            return
        end
    end
    
    -- Crear navegador
    characterBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
    browserContent = guiGetBrowser(characterBrowser)
    
    if not characterBrowser or not browserContent then
        outputChatBox("Error: No se pudo crear el navegador de personajes", 255, 0, 0)
        return
    end
    
    -- Configurar input mode inmediatamente
    guiSetInputMode("no_binds_when_editing")
    
    -- Eventos del navegador
    addEventHandler("onClientBrowserCreated", characterBrowser, loadCharacterBrowser)
    addEventHandler("onClientBrowserDocumentReady", characterBrowser, whenCharacterBrowserReady)
    
    -- Mostrar cursor y habilitar input de manera agresiva con múltiples timers
    showCursor(true)
    guiSetInputEnabled(true)
    
    -- Múltiples timers para asegurar que el cursor se muestre
    setTimer(function()
        showCursor(true)
        guiSetInputEnabled(true)
        guiSetInputMode("no_binds_when_editing")
    end, 50, 1)
    
    setTimer(function()
        showCursor(true)
        guiSetInputEnabled(true)
        guiSetInputMode("no_binds_when_editing")
    end, 200, 1)
    
    setTimer(function()
        showCursor(true)
        guiSetInputEnabled(true)
        guiSetInputMode("no_binds_when_editing")
    end, 500, 1)
    
    -- Timer continuo para verificar que el cursor esté visible
    if cursorCheckTimer and isTimer(cursorCheckTimer) then
        killTimer(cursorCheckTimer)
    end
    cursorCheckTimer = setTimer(ensureCursorVisible, 100, 0)
end

function hideCharacterGUI()
    -- Detener el timer de verificación del cursor
    if cursorCheckTimer and isTimer(cursorCheckTimer) then
        killTimer(cursorCheckTimer)
        cursorCheckTimer = nil
    end
    
    if characterBrowser and isElement(characterBrowser) then
        removeEventHandler("onClientBrowserCreated", characterBrowser, loadCharacterBrowser)
        removeEventHandler("onClientBrowserDocumentReady", characterBrowser, whenCharacterBrowserReady)
        guiSetInputMode("allow_binds")
        destroyElement(characterBrowser)
        characterBrowser = nil
        browserContent = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Función para verificar y forzar el cursor visible
function ensureCursorVisible()
    if characterBrowser and isElement(characterBrowser) and guiGetVisible(characterBrowser) then
        if not isCursorShowing() then
            showCursor(true)
            guiSetInputEnabled(true)
            guiSetInputMode("no_binds_when_editing")
        end
    end
end

-- Eventos desde el navegador
addEvent("selectCharacter", true)
addEventHandler("selectCharacter", root, function(characterId)
    if not characterId then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('ID de personaje inválido');")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("selectCharacter", localPlayer, characterId)
end)

addEvent("deleteCharacter", true)
addEventHandler("deleteCharacter", root, function(characterId)
    if not characterId then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('ID de personaje inválido');")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("deleteCharacter", localPlayer, characterId)
end)

addEvent("createCharacter", true)
addEventHandler("createCharacter", root, function(name, surname, age, gender, skin)
    -- outputChatBox("[DEBUG] createCharacter recibido: name=" .. tostring(name) .. ", surname=" .. tostring(surname) .. ", age=" .. tostring(age) .. ", gender=" .. tostring(gender) .. ", skin=" .. tostring(skin), 255, 255, 0)
    
    -- Convertir age a número si es necesario
    if type(age) == "string" then
        age = tonumber(age)
    end
    
    -- outputChatBox("[DEBUG] Validación 1: Verificando campos requeridos...", 255, 255, 0)
    if not name or not surname or not age then
        -- outputChatBox("[DEBUG] Error: Faltan campos requeridos - name=" .. tostring(name) .. ", surname=" .. tostring(surname) .. ", age=" .. tostring(age), 255, 0, 0)
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('Por favor completa todos los campos');")
        end
        return
    end
    
    -- outputChatBox("[DEBUG] Validación 2: Verificando longitud del nombre...", 255, 255, 0)
    if string.len(name) < 2 or string.len(name) > 20 then
        -- outputChatBox("[DEBUG] Error: Nombre inválido - longitud=" .. string.len(name), 255, 0, 0)
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('El nombre debe tener entre 2 y 20 caracteres');")
        end
        return
    end
    
    -- outputChatBox("[DEBUG] Validación 3: Verificando longitud del apellido...", 255, 255, 0)
    if string.len(surname) < 2 or string.len(surname) > 20 then
        -- outputChatBox("[DEBUG] Error: Apellido inválido - longitud=" .. string.len(surname), 255, 0, 0)
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('El apellido debe tener entre 2 y 20 caracteres');")
        end
        return
    end
    
    -- outputChatBox("[DEBUG] Validación 4: Verificando edad... age=" .. tostring(age) .. ", tipo=" .. type(age), 255, 255, 0)
    if not age or age < 18 or age > 100 then
        -- outputChatBox("[DEBUG] Error: Edad inválida - age=" .. tostring(age) .. ", tipo=" .. type(age), 255, 0, 0)
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('La edad debe estar entre 18 y 100 años');")
        end
        return
    end
    
    -- outputChatBox("[DEBUG] Todas las validaciones pasaron. Enviando al servidor...", 0, 255, 0)
    
    -- Enviar evento al servidor
    -- outputChatBox("[DEBUG] Enviando createCharacter al servidor: name=" .. tostring(name) .. ", surname=" .. tostring(surname) .. ", age=" .. tostring(age) .. ", gender=" .. tostring(gender) .. ", skin=" .. tostring(skin or 0), 0, 255, 255)
    local success = triggerServerEvent("createCharacter", localPlayer, name, surname, age, gender, skin or 0)
    if not success then
        -- outputChatBox("[DEBUG] ERROR: No se pudo enviar el evento al servidor", 255, 0, 0)
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('Error al enviar los datos al servidor');")
        end
    else
        -- outputChatBox("[DEBUG] Evento enviado correctamente al servidor", 0, 255, 0)
    end
end)

-- Eventos del servidor
addEvent("showCharacterGUI", true)
addEventHandler("showCharacterGUI", resourceRoot, function()
    showCharacterGUI()
end)

addEvent("hideCharacterGUI", true)
addEventHandler("hideCharacterGUI", resourceRoot, function()
    hideCharacterGUI()
end)

addEvent("receiveCharacters", true)
addEventHandler("receiveCharacters", resourceRoot, function(charList)
    if browserContent and isElement(browserContent) then
        -- Convertir la lista de personajes a JSON para JavaScript
        local json = "["
        if charList and #charList > 0 then
            for i, char in ipairs(charList) do
                if i > 1 then
                    json = json .. ","
                end
                json = json .. "{"
                json = json .. "\"id\":" .. (char.id or 0) .. ","
                json = json .. "\"name\":\"" .. (char.name or ""):gsub("\"", "\\\"") .. "\","
                json = json .. "\"surname\":\"" .. (char.surname or ""):gsub("\"", "\\\"") .. "\","
                json = json .. "\"age\":" .. (char.age or 18) .. ","
                json = json .. "\"money\":" .. (char.money or 0) .. ","
                json = json .. "\"lastLogin\":\"" .. (char.lastLogin or "Nunca"):gsub("\"", "\\\"") .. "\""
                json = json .. "}"
            end
        end
        json = json .. "]"
        
        executeBrowserJavascript(browserContent, "loadCharacters(" .. json .. ");")
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
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message):gsub("'", "\\'") .. "');")
        end
    end
end)

addEvent("characterSelectResponse", true)
addEventHandler("characterSelectResponse", resourceRoot, function(success, message)
    if browserContent and isElement(browserContent) then
        if not success then
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message):gsub("'", "\\'") .. "');")
        else
            -- Ocultar GUI cuando se selecciona exitosamente
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
            executeBrowserJavascript(browserContent, "showSuccess('" .. tostring(message):gsub("'", "\\'") .. "');")
            -- Recargar lista de personajes
            setTimer(function()
                triggerServerEvent("requestCharacters", localPlayer)
            end, 1000, 1)
        else
            executeBrowserJavascript(browserContent, "showError('" .. tostring(message):gsub("'", "\\'") .. "');")
        end
    end
end)
