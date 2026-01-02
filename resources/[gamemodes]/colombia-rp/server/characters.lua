-- Sistema de Personajes
-- Nota: Los eventos están registrados en server/events.lua
addEventHandler("requestCharacters", root, function()
    local userId = getElementData(source, "account:userId")
    if not userId then
        triggerClientEvent(source, "receiveCharacters", resourceRoot, {})
        return
    end
    
    local query = "SELECT * FROM characters WHERE username = (SELECT username FROM users WHERE id = ?) ORDER BY created DESC"
    local result = queryDatabase(query, userId)
    
    if result then
        triggerClientEvent(source, "receiveCharacters", resourceRoot, result)
    else
        triggerClientEvent(source, "receiveCharacters", resourceRoot, {})
    end
end)

-- Crear nuevo personaje
addEventHandler("createCharacter", root, function(name, surname, age, gender, skin)
    local userId = getElementData(source, "account:userId")
    local username = getElementData(source, "account:username")
    
    if not userId or not username then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "Debes estar logueado")
        return
    end
    
    -- Validaciones
    if not name or string.len(name) < 2 or string.len(name) > 20 then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "El nombre debe tener entre 2 y 20 caracteres")
        return
    end
    
    if not surname or string.len(surname) < 2 or string.len(surname) > 20 then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "El apellido debe tener entre 2 y 20 caracteres")
        return
    end
    
    if not age or age < 18 or age > 100 then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "La edad debe estar entre 18 y 100 años")
        return
    end
    
    gender = gender or 0
    skin = skin or Config.Server.defaultSkin
    
    -- Verificar límite de personajes
    local countQuery = "SELECT COUNT(*) as count FROM characters WHERE username = ?"
    local countResult = queryDatabase(countQuery, username)
    
    if countResult and countResult[1] and countResult[1].count >= Config.Server.maxCharacters then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "Has alcanzado el límite de personajes (" .. Config.Server.maxCharacters .. ")")
        return
    end
    
    -- Verificar si el nombre ya existe
    local nameCheck = "SELECT id FROM characters WHERE name = ? AND surname = ? LIMIT 1"
    local nameResult = queryDatabase(nameCheck, name, surname)
    
    if nameResult and #nameResult > 0 then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "Ya existe un personaje con ese nombre y apellido")
        return
    end
    
    -- Crear personaje
    local createdDate = getRealTime()
    local dateString = string.format("%04d-%02d-%02d %02d:%02d:%02d", 
        createdDate.year + 1900, createdDate.month + 1, createdDate.monthday,
        createdDate.hour, createdDate.minute, createdDate.second)
    
    local insertQuery = "INSERT INTO characters (username, name, surname, age, gender, skin, money, created, posX, posY, posZ, rotation, interior, dimension, health, hunger, thirst) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    local success = executeDatabase(insertQuery, 
        username, name, surname, age, gender, skin, 
        Config.Server.defaultMoney, dateString,
        Config.Server.defaultPosX, Config.Server.defaultPosY, Config.Server.defaultPosZ,
        Config.Server.defaultRotation, Config.Server.defaultInterior, Config.Server.defaultDimension,
        Config.Server.defaultHealth, Config.Server.defaultHunger, Config.Server.defaultThirst
    )
    
    if success then
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, true, "Personaje creado exitosamente")
        -- Recargar lista de personajes
        triggerEvent("requestCharacters", source)
    else
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "Error al crear el personaje")
    end
end)

-- Seleccionar personaje
addEventHandler("selectCharacter", root, function(characterId)
    local userId = getElementData(source, "account:userId")
    if not userId then
        return
    end
    
    local query = "SELECT * FROM characters WHERE id = ? AND username = (SELECT username FROM users WHERE id = ?) LIMIT 1"
    local result = queryDatabase(query, characterId, userId)
    
    if result and #result > 0 then
        local character = result[1]
        
        -- Guardar datos del personaje en el elemento
        setElementData(source, "character:selected", true)
        setElementData(source, "character:id", character.id)
        setElementData(source, "character:name", character.name)
        setElementData(source, "character:surname", character.surname)
        setElementData(source, "character:age", character.age)
        setElementData(source, "character:gender", character.gender)
        setElementData(source, "character:money", character.money)
        setElementData(source, "character:hunger", character.hunger)
        setElementData(source, "character:thirst", character.thirst)
        setElementData(source, "character:health", character.health)
        
        -- Spawnear personaje
        spawnPlayer(source, character.posX, character.posY, character.posZ, character.rotation, character.skin, character.interior, character.dimension)
        setElementHealth(source, character.health)
        setElementModel(source, character.skin)
        
        -- Activar cámara del jugador
        setCameraTarget(source, source)
        fadeCamera(source, true, 1.0)
        
        -- Actualizar último login
        executeDatabase("UPDATE characters SET lastLogin = NOW() WHERE id = ?", characterId)
        
        -- Ocultar GUI y mostrar HUD
        triggerClientEvent(source, "hideCharacterGUI", resourceRoot)
        triggerClientEvent(source, "showHUD", resourceRoot)
        
        -- Actualizar dinero
        setPlayerMoney(source, character.money)
        
        outputChatBox("¡Bienvenido, " .. character.name .. " " .. character.surname .. "!", source, 0, 255, 0)
    else
        triggerClientEvent(source, "characterSelectResponse", resourceRoot, false, "Personaje no encontrado")
    end
end)

-- Eliminar personaje
addEventHandler("deleteCharacter", root, function(characterId)
    local userId = getElementData(source, "account:userId")
    if not userId then
        return
    end
    
    -- Verificar que el personaje pertenece al usuario
    local checkQuery = "SELECT id FROM characters WHERE id = ? AND username = (SELECT username FROM users WHERE id = ?) LIMIT 1"
    local checkResult = queryDatabase(checkQuery, characterId, userId)
    
    if checkResult and #checkResult > 0 then
        -- Eliminar inventario del personaje
        executeDatabase("DELETE FROM inventory WHERE characterId = ?", characterId)
        
        -- Eliminar personaje
        local success = executeDatabase("DELETE FROM characters WHERE id = ?", characterId)
        
        if success then
            triggerClientEvent(source, "characterDeleteResponse", resourceRoot, true, "Personaje eliminado")
            triggerEvent("requestCharacters", source)
        else
            triggerClientEvent(source, "characterDeleteResponse", resourceRoot, false, "Error al eliminar el personaje")
        end
    else
        triggerClientEvent(source, "characterDeleteResponse", resourceRoot, false, "No tienes permiso para eliminar este personaje")
    end
end)

