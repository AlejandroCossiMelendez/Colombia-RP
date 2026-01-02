-- Sistema de Personajes
-- Nota: Los eventos están registrados en server/events.lua
addEventHandler("requestCharacters", getRootElement(), function()
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
addEventHandler("createCharacter", getRootElement(), function(name, surname, age, gender, skin)
    -- Verificar que source sea un jugador
    if not isElement(source) or getElementType(source) ~= "player" then
        outputServerLog("[CHARACTERS] ERROR: createCharacter recibido de elemento inválido")
        return
    end
    
    outputServerLog("[CHARACTERS] Evento createCharacter recibido de " .. getPlayerName(source))
    outputServerLog("[CHARACTERS] Datos recibidos - Nombre: " .. tostring(name) .. ", Apellido: " .. tostring(surname) .. ", Edad: " .. tostring(age))
    
    local userId = getElementData(source, "account:userId")
    local username = getElementData(source, "account:username")
    
    outputServerLog("[CHARACTERS] userId: " .. tostring(userId) .. ", username: " .. tostring(username))
    
    if not userId or not username then
        outputServerLog("[CHARACTERS] ERROR: Usuario no logueado")
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
    outputServerLog("[CHARACTERS] Ejecutando INSERT en base de datos...")
    outputServerLog("[CHARACTERS] Query: " .. insertQuery)
    outputServerLog("[CHARACTERS] Parámetros: username=" .. username .. ", name=" .. name .. ", surname=" .. surname .. ", age=" .. age)
    
    local success = executeDatabase(insertQuery, 
        username, name, surname, age, gender, skin, 
        Config.Server.defaultMoney, dateString,
        Config.Server.defaultPosX, Config.Server.defaultPosY, Config.Server.defaultPosZ,
        Config.Server.defaultRotation, Config.Server.defaultInterior, Config.Server.defaultDimension,
        Config.Server.defaultHealth, Config.Server.defaultHunger, Config.Server.defaultThirst
    )
    
    outputServerLog("[CHARACTERS] Resultado de executeDatabase: " .. tostring(success))
    
    if success then
        -- Obtener el ID del personaje recién creado
        local getCharQuery = "SELECT id FROM characters WHERE username = ? AND name = ? AND surname = ? ORDER BY created DESC LIMIT 1"
        local charResult = queryDatabase(getCharQuery, username, name, surname)
        
        if charResult and #charResult > 0 then
            local newCharacterId = charResult[1].id
            outputServerLog("[CHARACTERS] Personaje creado con ID: " .. newCharacterId .. " para " .. username)
            
            -- Spawnear automáticamente el personaje recién creado
            setTimer(function()
                if isElement(source) then
                    -- Llamar directamente a la función de selección para spawnearlo
                    local userId = getElementData(source, "account:userId")
                    if userId then
                        local query = "SELECT * FROM characters WHERE id = ? AND username = (SELECT username FROM users WHERE id = ?) LIMIT 1"
                        local result = queryDatabase(query, newCharacterId, userId)
                        
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
                            
                            outputServerLog("[CHARACTERS] Spawneando personaje recién creado ID: " .. newCharacterId .. " para " .. getPlayerName(source))
                            
                            -- Spawnear personaje con altura segura
                            local spawnZ = character.posZ
                            -- Si la altura es muy baja, aumentarla para evitar caídas
                            if spawnZ < 5.0 then
                                spawnZ = 15.0
                            end
                            spawnPlayer(source, character.posX, character.posY, spawnZ, character.rotation, character.skin, character.interior, character.dimension)
                            setElementHealth(source, character.health)
                            setElementModel(source, character.skin)
                            
                            -- Asegurar que el jugador esté en una posición segura después del spawn
                            setTimer(function()
                                if isElement(source) then
                                    local x, y, z = getElementPosition(source)
                                    -- Usar processLineOfSight para encontrar el suelo
                                    local hit, hitX, hitY, hitZ = processLineOfSight(x, y, z + 50, x, y, z - 50, true, true, false, true, false, false, false, false, source)
                                    if hit then
                                        -- Si está muy cerca del suelo o debajo, ajustar altura
                                        if z - hitZ < 2.0 or z < hitZ then
                                            setElementPosition(source, x, y, hitZ + 2.0)
                                        end
                                    elseif z < 5.0 then
                                        -- Si no hay suelo detectado y la altura es muy baja, aumentar
                                        setElementPosition(source, x, y, 15.0)
                                    end
                                end
                            end, 100, 1)
                            
                            -- Activar cámara del jugador
                            setTimer(function()
                                if isElement(source) then
                                    setCameraTarget(source, source)
                                    fadeCamera(source, true, 1.0)
                                end
                            end, 500, 1)
                            
                            -- Actualizar último login
                            executeDatabase("UPDATE characters SET lastLogin = NOW() WHERE id = ?", newCharacterId)
                            
                            -- Ocultar GUI y mostrar HUD
                            triggerClientEvent(source, "hideCharacterGUI", resourceRoot)
                            triggerClientEvent(source, "showHUD", resourceRoot)
                            
                            -- Actualizar dinero
                            setCharacterMoney(source, character.money)
                            
                            outputChatBox("¡Bienvenido, " .. character.name .. " " .. character.surname .. "!", source, 0, 255, 0)
                            outputChatBox("Has aparecido en el mundo. ¡Disfruta tu aventura!", source, 0, 255, 255)
                        end
                    end
                end
            end, 500, 1)
            
            triggerClientEvent(source, "characterCreateResponse", resourceRoot, true, "Personaje creado exitosamente")
        else
            triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "Error al obtener el personaje creado")
        end
    else
        triggerClientEvent(source, "characterCreateResponse", resourceRoot, false, "Error al crear el personaje")
    end
end)

-- Seleccionar personaje
addEventHandler("selectCharacter", getRootElement(), function(characterId)
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
        
        outputServerLog("[CHARACTERS] Spawneando personaje ID: " .. characterId .. " para " .. getPlayerName(source))
        
        -- Spawnear personaje con altura segura
        local spawnZ = character.posZ
        -- Si la altura es muy baja, aumentarla para evitar caídas
        if spawnZ < 5.0 then
            spawnZ = 15.0
        end
        spawnPlayer(source, character.posX, character.posY, spawnZ, character.rotation, character.skin, character.interior, character.dimension)
        setElementHealth(source, character.health)
        setElementModel(source, character.skin)
        
        outputServerLog("[CHARACTERS] Personaje spawneado en: " .. character.posX .. ", " .. character.posY .. ", " .. spawnZ)
        
        -- Asegurar que el jugador esté en una posición segura después del spawn
        setTimer(function()
            if isElement(source) then
                local x, y, z = getElementPosition(source)
                -- Usar processLineOfSight para encontrar el suelo
                local hit, hitX, hitY, hitZ = processLineOfSight(x, y, z + 50, x, y, z - 50, true, true, false, true, false, false, false, false, source)
                if hit then
                    -- Si está muy cerca del suelo o debajo, ajustar altura
                    if z - hitZ < 2.0 or z < hitZ then
                        setElementPosition(source, x, y, hitZ + 2.0)
                    end
                elseif z < 5.0 then
                    -- Si no hay suelo detectado y la altura es muy baja, aumentar
                    setElementPosition(source, x, y, 15.0)
                end
            end
        end, 100, 1)
        
        -- Activar cámara del jugador
        setTimer(function()
            if isElement(source) then
                setCameraTarget(source, source)
                fadeCamera(source, true, 1.0)
                outputServerLog("[CHARACTERS] Cámara activada para " .. getPlayerName(source))
            end
        end, 500, 1)
        
        -- Actualizar último login
        executeDatabase("UPDATE characters SET lastLogin = NOW() WHERE id = ?", characterId)
        
        -- Ocultar GUI y mostrar HUD
        triggerClientEvent(source, "hideCharacterGUI", resourceRoot)
        triggerClientEvent(source, "showHUD", resourceRoot)
        
        -- Actualizar dinero
        setCharacterMoney(source, character.money)
        
        outputChatBox("¡Bienvenido, " .. character.name .. " " .. character.surname .. "!", source, 0, 255, 0)
        outputChatBox("Has aparecido en el mundo. ¡Disfruta tu aventura!", source, 0, 255, 255)
    else
        triggerClientEvent(source, "characterSelectResponse", resourceRoot, false, "Personaje no encontrado")
    end
end)

-- Eliminar personaje
addEventHandler("deleteCharacter", getRootElement(), function(characterId)
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
            -- Recargar lista de personajes
            setTimer(function()
                if isElement(source) then
                    triggerClientEvent(source, "requestCharacters", resourceRoot)
                end
            end, 100, 1)
        else
            triggerClientEvent(source, "characterDeleteResponse", resourceRoot, false, "Error al eliminar el personaje")
        end
    else
        triggerClientEvent(source, "characterDeleteResponse", resourceRoot, false, "No tienes permiso para eliminar este personaje")
    end
end)

