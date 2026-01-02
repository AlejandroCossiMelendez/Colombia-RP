-- GUI de Selección de Personajes usando Navegador Web
local characterBrowser = nil
local browserContent = nil
local screenWidth, screenHeight = guiGetScreenSize()

function loadCharacterBrowser() 
    loadBrowserURL(source, "http://mta/local/html/character.html")
end

function whenCharacterBrowserReady()
    -- El navegador está listo, solicitar lista de personajes
    triggerServerEvent("requestCharacters", localPlayer)
end

function showCharacterGUI()
    -- Si ya existe, no crear otra vez
    if characterBrowser then
        if isElement(characterBrowser) then
            guiSetVisible(characterBrowser, true)
            showCursor(true)
            guiSetInputEnabled(true)
            guiSetInputMode("no_binds_when_editing")
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
    
    -- Configurar input mode
    guiSetInputMode("no_binds_when_editing")
    
    -- Eventos del navegador
    addEventHandler("onClientBrowserCreated", characterBrowser, loadCharacterBrowser)
    addEventHandler("onClientBrowserDocumentReady", characterBrowser, whenCharacterBrowserReady)
    
    -- Mostrar cursor y habilitar input
    showCursor(true)
    guiSetInputEnabled(true)
end

function hideCharacterGUI()
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

-- Eventos desde el navegador
addEvent("selectCharacter", true)
addEventHandler("selectCharacter", resourceRoot, function(characterId)
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
addEventHandler("deleteCharacter", resourceRoot, function(characterId)
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
addEventHandler("createCharacter", resourceRoot, function(name, surname, age, gender, skin)
    if not name or not surname or not age then
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
    
    if not age or age < 18 or age > 100 then
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "showError('La edad debe estar entre 18 y 100 años');")
        end
        return
    end
    
    -- Enviar evento al servidor
    triggerServerEvent("createCharacter", localPlayer, name, surname, age, gender, skin or 0)
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
