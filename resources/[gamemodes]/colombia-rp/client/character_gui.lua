-- GUI de Selección de Personajes
local characterBrowser = nil
local screenWidth, screenHeight = guiGetScreenSize()

function showCharacterGUI()
    if characterBrowser then
        destroyElement(characterBrowser)
    end
    
    characterBrowser = createBrowser(screenWidth, screenHeight, true, true)
    
    addEventHandler("onClientBrowserCreated", characterBrowser, function()
        loadBrowserURL(characterBrowser, "http://mta/local/character.html")
        showCursor(true)
        guiSetInputEnabled(true)
    end)
    
    addEventHandler("onClientBrowserDocumentReady", characterBrowser, function(url)
        if url == "http://mta/local/character.html" then
            -- Exponer funciones al navegador usando callRemote
            executeBrowserJavascript(characterBrowser, [[
                window.selectCharacter = function(characterId) {
                    callRemote('selectCharacter', characterId);
                };
                window.createCharacter = function(name, surname, age, gender, skin) {
                    callRemote('createCharacter', name, surname, parseInt(age), parseInt(gender), parseInt(skin));
                };
                window.deleteCharacter = function(characterId) {
                    callRemote('deleteCharacter', characterId);
                };
            ]])
        end
    end)
    
    -- Solicitar lista de personajes
    triggerServerEvent("requestCharacters", localPlayer)
end

function hideCharacterGUI()
    if characterBrowser then
        destroyElement(characterBrowser)
        characterBrowser = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

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
addEventHandler("receiveCharacters", resourceRoot, function(characters)
    if characterBrowser then
        local json = toJSON(characters)
        executeBrowserJavascript(characterBrowser, "loadCharacters(" .. json .. ")")
    end
end)

addEvent("characterCreateResponse", true)
addEventHandler("characterCreateResponse", resourceRoot, function(success, message)
    if characterBrowser then
        local safeMessage = message:gsub("'", "\\'")
        if success then
            executeBrowserJavascript(characterBrowser, "showSuccess('" .. safeMessage .. "')")
            triggerServerEvent("requestCharacters", localPlayer)
        else
            executeBrowserJavascript(characterBrowser, "showError('" .. safeMessage .. "')")
        end
    end
end)

addEvent("characterSelectResponse", true)
addEventHandler("characterSelectResponse", resourceRoot, function(success, message)
    if characterBrowser and not success then
        local safeMessage = message:gsub("'", "\\'")
        executeBrowserJavascript(characterBrowser, "showError('" .. safeMessage .. "')")
    end
end)

addEvent("characterDeleteResponse", true)
addEventHandler("characterDeleteResponse", resourceRoot, function(success, message)
    if characterBrowser then
        local safeMessage = message:gsub("'", "\\'")
        if success then
            executeBrowserJavascript(characterBrowser, "showSuccess('" .. safeMessage .. "')")
            triggerServerEvent("requestCharacters", localPlayer)
        else
            executeBrowserJavascript(characterBrowser, "showError('" .. safeMessage .. "')")
        end
    end
end)

-- callRemote handlers (se llaman directamente desde el navegador)
addEvent("selectCharacter", true)
addEventHandler("selectCharacter", root, function(characterId)
    triggerServerEvent("selectCharacter", localPlayer, characterId)
end)

addEvent("createCharacter", true)
addEventHandler("createCharacter", root, function(name, surname, age, gender, skin)
    triggerServerEvent("createCharacter", localPlayer, name, surname, tonumber(age), tonumber(gender), tonumber(skin))
end)

addEvent("deleteCharacter", true)
addEventHandler("deleteCharacter", root, function(characterId)
    triggerServerEvent("deleteCharacter", localPlayer, characterId)
end)

-- Renderizar el navegador
addEventHandler("onClientRender", root, function()
    if characterBrowser then
        dxDrawImage(0, 0, screenWidth, screenHeight, characterBrowser, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end)
