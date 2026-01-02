-- GUI de Selección de Personajes (Clásico sin navegador)
local characterWindow = nil
local characterList = nil
local createButton = nil
local selectButton = nil
local deleteButton = nil
local characters = {}
local selectedCharacterId = nil
local screenWidth, screenHeight = guiGetScreenSize()

function showCharacterGUI()
    -- Si ya existe, no crear otra vez
    if characterWindow then
        return
    end
    
    -- Calcular posición centrada
    local windowWidth = 500
    local windowHeight = 400
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    -- Crear ventana
    characterWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Seleccionar Personaje", false)
    guiWindowSetMovable(characterWindow, true)
    guiWindowSetSizable(characterWindow, false)
    guiSetAlpha(characterWindow, 0.95)
    
    -- Lista de personajes
    local listLabel = guiCreateLabel(20, 30, 200, 20, "Tus Personajes:", false, characterWindow)
    guiLabelSetColor(listLabel, 255, 255, 255)
    characterList = guiCreateGridList(20, 50, 450, 250, false, characterWindow)
    guiGridListAddColumn(characterList, "Nombre", 0.3)
    guiGridListAddColumn(characterList, "Apellido", 0.3)
    guiGridListAddColumn(characterList, "Edad", 0.15)
    guiGridListAddColumn(characterList, "Dinero", 0.25)
    
    -- Botones
    selectButton = guiCreateButton(20, 310, 150, 40, "Seleccionar", false, characterWindow)
    createButton = guiCreateButton(180, 310, 150, 40, "Crear Nuevo", false, characterWindow)
    deleteButton = guiCreateButton(340, 310, 130, 40, "Eliminar", false, characterWindow)
    
    -- Mostrar cursor
    showCursor(true)
    guiSetInputEnabled(true)
    
    -- Eventos
    addEventHandler("onClientGUIClick", selectButton, function()
        local selectedRow = guiGridListGetSelectedItem(characterList)
        if selectedRow ~= -1 then
            local characterId = guiGridListGetItemData(characterList, selectedRow, 1)
            if characterId then
                triggerServerEvent("selectCharacter", resourceRoot, characterId)
            else
                outputChatBox("Selecciona un personaje de la lista", 255, 0, 0)
            end
        else
            outputChatBox("Selecciona un personaje de la lista", 255, 0, 0)
        end
    end, false)
    
    addEventHandler("onClientGUIClick", createButton, function()
        showCreateCharacterGUI()
    end, false)
    
    addEventHandler("onClientGUIClick", deleteButton, function()
        local selectedRow = guiGridListGetSelectedItem(characterList)
        if selectedRow ~= -1 then
            local characterId = guiGridListGetItemData(characterList, selectedRow, 1)
            if characterId then
                if confirm("¿Estás seguro de eliminar este personaje?") then
                    triggerServerEvent("deleteCharacter", resourceRoot, characterId)
                end
            end
        else
            outputChatBox("Selecciona un personaje para eliminar", 255, 0, 0)
        end
    end, false)
    
    -- Solicitar lista de personajes
    triggerServerEvent("requestCharacters", resourceRoot)
end

function hideCharacterGUI()
    if characterWindow then
        destroyElement(characterWindow)
        characterWindow = nil
        characterList = nil
        createButton = nil
        selectButton = nil
        deleteButton = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

local createWindow = nil
local createNameEdit = nil
local createSurnameEdit = nil
local createAgeEdit = nil
local createGenderCombo = nil

function showCreateCharacterGUI()
    if createWindow then
        return
    end
    
    local windowWidth = 400
    local windowHeight = 300
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    createWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Crear Nuevo Personaje", false)
    guiWindowSetMovable(createWindow, true)
    guiWindowSetSizable(createWindow, false)
    
    local nameLabel = guiCreateLabel(20, 30, 100, 20, "Nombre:", false, createWindow)
    guiLabelSetColor(nameLabel, 255, 255, 255)
    createNameEdit = guiCreateEdit(20, 50, 350, 30, "", false, createWindow)
    
    local surnameLabel = guiCreateLabel(20, 90, 100, 20, "Apellido:", false, createWindow)
    guiLabelSetColor(surnameLabel, 255, 255, 255)
    createSurnameEdit = guiCreateEdit(20, 110, 350, 30, "", false, createWindow)
    
    local ageLabel = guiCreateLabel(20, 150, 100, 20, "Edad:", false, createWindow)
    guiLabelSetColor(ageLabel, 255, 255, 255)
    createAgeEdit = guiCreateEdit(20, 170, 350, 30, "25", false, createWindow)
    
    local genderLabel = guiCreateLabel(20, 210, 100, 20, "Género:", false, createWindow)
    guiLabelSetColor(genderLabel, 255, 255, 255)
    createGenderCombo = guiCreateComboBox(20, 230, 350, 30, "Masculino", false, createWindow)
    guiComboBoxAddItem(createGenderCombo, "Masculino")
    guiComboBoxAddItem(createGenderCombo, "Femenino")
    
    local createConfirmButton = guiCreateButton(20, 270, 170, 30, "Crear", false, createWindow)
    local createCancelButton = guiCreateButton(200, 270, 170, 30, "Cancelar", false, createWindow)
    
    addEventHandler("onClientGUIClick", createConfirmButton, function()
        local name = guiGetText(createNameEdit)
        local surname = guiGetText(createSurnameEdit)
        local age = tonumber(guiGetText(createAgeEdit))
        local genderSelected = guiComboBoxGetSelected(createGenderCombo)
        local gender = genderSelected or 0
        
        if name == "" or surname == "" then
            outputChatBox("Completa todos los campos", 255, 0, 0)
            return
        end
        
        if not age or age < 18 or age > 100 then
            outputChatBox("La edad debe estar entre 18 y 100", 255, 0, 0)
            return
        end
        
        triggerServerEvent("createCharacter", resourceRoot, name, surname, age, gender, 0)
        hideCreateCharacterGUI()
    end, false)
    
    addEventHandler("onClientGUIClick", createCancelButton, function()
        hideCreateCharacterGUI()
    end, false)
end

function hideCreateCharacterGUI()
    if createWindow then
        destroyElement(createWindow)
        createWindow = nil
        createNameEdit = nil
        createSurnameEdit = nil
        createAgeEdit = nil
        createGenderCombo = nil
    end
end

-- Función helper para confirmación
function confirm(message)
    -- Usar inputBox de MTA o simplemente retornar true
    -- Por ahora retornamos true directamente
    return true
end

-- Eventos del servidor
addEvent("showCharacterGUI", true)
addEventHandler("showCharacterGUI", resourceRoot, function()
    outputChatBox("[DEBUG] Evento showCharacterGUI recibido - mostrando panel", 0, 255, 0)
    showCharacterGUI()
end)

-- Registrar el evento al cargar el recurso
addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("[DEBUG] character_gui.lua cargado - showCharacterGUI registrado", 0, 255, 255)
end)

addEvent("hideCharacterGUI", true)
addEventHandler("hideCharacterGUI", resourceRoot, function()
    hideCharacterGUI()
end)

addEvent("receiveCharacters", true)
addEventHandler("receiveCharacters", resourceRoot, function(charList)
    characters = charList or {}
    outputChatBox("Recibidos " .. #characters .. " personajes", 255, 255, 0)
    
    if characterList then
        guiGridListClear(characterList)
        
        for i, char in ipairs(characters) do
            local row = guiGridListAddRow(characterList)
            guiGridListSetItemText(characterList, row, 1, char.name or "", false, false)
            guiGridListSetItemText(characterList, row, 2, char.surname or "", false, false)
            guiGridListSetItemText(characterList, row, 3, tostring(char.age or 18), false, false)
            guiGridListSetItemText(characterList, row, 4, "$" .. tostring(char.money or 0), false, false)
            guiGridListSetItemData(characterList, row, 1, char.id)
        end
    end
end)

addEvent("characterCreateResponse", true)
addEventHandler("characterCreateResponse", resourceRoot, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
        triggerServerEvent("requestCharacters", resourceRoot)
    else
        outputChatBox("Error: " .. message, 255, 0, 0)
    end
end)

addEvent("characterSelectResponse", true)
addEventHandler("characterSelectResponse", resourceRoot, function(success, message)
    if not success then
        outputChatBox("Error: " .. message, 255, 0, 0)
    end
end)

addEvent("characterDeleteResponse", true)
addEventHandler("characterDeleteResponse", resourceRoot, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
        triggerServerEvent("requestCharacters", resourceRoot)
    else
        outputChatBox("Error: " .. message, 255, 0, 0)
    end
end)
