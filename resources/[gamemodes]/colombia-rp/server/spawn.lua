-- Sistema de Spawn
function spawnPlayerAtLocation(player, x, y, z, rotation, interior, dimension)
    if not isElement(player) then
        return false
    end
    
    -- Asegurar altura mínima para evitar caídas al vacío
    local spawnZ = z
    if spawnZ < 5.0 then
        spawnZ = 15.0
    end
    
    spawnPlayer(player, x, y, spawnZ, rotation, 0, interior, dimension)
    setCameraTarget(player, player)
    fadeCamera(player, true)
    
    -- Ajustar posición después del spawn para asegurar que esté en una altura segura
    setTimer(function()
        if isElement(player) then
            local px, py, pz = getElementPosition(player)
            -- Usar processLineOfSight para encontrar el suelo
            local hit, hitX, hitY, hitZ = processLineOfSight(px, py, pz + 50, px, py, pz - 50, true, true, false, true, false, false, false, false, player)
            if hit then
                -- Si está muy cerca del suelo o debajo, ajustar altura
                if pz - hitZ < 2.0 or pz < hitZ then
                    setElementPosition(player, px, py, hitZ + 2.0)
                end
            elseif pz < 5.0 then
                -- Si no hay suelo detectado y la altura es muy baja, aumentar
                setElementPosition(player, px, py, 15.0)
            end
        end
    end, 100, 1)
    
    return true
end

-- Prevenir spawn automático
addEventHandler("onPlayerJoin", root, function()
    fadeCamera(source, false)
    setCameraTarget(source, nil)
end)

-- Comando para respawn
addCommandHandler("respawn", function(player)
    if not getElementData(player, "character:selected") then
        return
    end
    
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return
    end
    
    local query = "SELECT posX, posY, posZ, rotation, interior, dimension, skin FROM characters WHERE id = ? LIMIT 1"
    local result = queryDatabase(query, characterId)
    
    if result and #result > 0 then
        local char = result[1]
        spawnPlayerAtLocation(player, char.posX, char.posY, char.posZ, char.rotation, char.interior, char.dimension)
        setElementModel(player, char.skin)
        setElementHealth(player, 100)
        outputChatBox("Has reaparecido en tu última ubicación.", player, 0, 255, 0)
    end
end)

-- Guardar posición periódicamente
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player, "character:selected") then
            local characterId = getElementData(player, "character:id")
            if characterId then
                local x, y, z = getElementPosition(player)
                local rotation = getPedRotation(player)
                local interior = getElementInterior(player)
                local dimension = getElementDimension(player)
                
                executeDatabase("UPDATE characters SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ? WHERE id = ?",
                    x, y, z, rotation, interior, dimension, characterId)
            end
        end
    end
end, 300000, 0) -- Cada 5 minutos

-- Sistema de Muerte y Respawn
local deathTimers = {} -- Tabla para almacenar los timers de muerte
local deathPositions = {} -- Tabla para almacenar las posiciones de muerte

-- Función para revivir al jugador en el hospital
function respawnAtHospital(player)
    if not isElement(player) then
        return false
    end
    
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return false
    end
    
    -- Revivir al jugador
    spawnPlayer(player, Config.Death.hospitalX, Config.Death.hospitalY, Config.Death.hospitalZ, 
                Config.Death.hospitalRotation, 0, Config.Death.hospitalInterior, Config.Death.hospitalDimension)
    
    -- Restaurar salud y modelo
    local skin = getElementModel(player)
    setElementModel(player, skin)
    setElementHealth(player, 100)
    setElementData(player, "character:health", 100)
    
    -- Activar cámara
    setCameraTarget(player, player)
    fadeCamera(player, true, 1.0)
    
    -- Actualizar posición en la base de datos
    executeDatabase("UPDATE characters SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, health = ? WHERE id = ?",
        Config.Death.hospitalX, Config.Death.hospitalY, Config.Death.hospitalZ, 
        Config.Death.hospitalRotation, Config.Death.hospitalInterior, Config.Death.hospitalDimension, 100, characterId)
    
    -- Notificar al cliente que fue revivido
    triggerClientEvent(player, "onClientPlayerRevived", resourceRoot)
    
    outputChatBox("Has sido trasladado al hospital.", player, 0, 255, 255)
    outputChatBox("Estás vivo nuevamente. ¡Ten más cuidado!", player, 0, 255, 0)
    
    -- Limpiar el timer y la posición de muerte
    if deathTimers[player] then
        if isTimer(deathTimers[player]) then
            killTimer(deathTimers[player])
        end
        deathTimers[player] = nil
    end
    
    if deathPositions[player] then
        deathPositions[player] = nil
    end
    
    return true
end

-- Función para revivir al jugador en el lugar donde murió
function respawnAtDeathLocation(player)
    if not isElement(player) then
        return false
    end
    
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return false
    end
    
    -- Verificar si hay posición de muerte guardada
    if not deathPositions[player] then
        return false
    end
    
    local deathPos = deathPositions[player]
    
    -- Revivir al jugador en el lugar donde murió
    spawnPlayer(player, deathPos.x, deathPos.y, deathPos.z, 
                deathPos.rotation, 0, deathPos.interior, deathPos.dimension)
    
    -- Restaurar salud y modelo
    local skin = getElementModel(player)
    setElementModel(player, skin)
    setElementHealth(player, 100)
    setElementData(player, "character:health", 100)
    
    -- Activar cámara
    setCameraTarget(player, player)
    fadeCamera(player, true, 1.0)
    
    -- Actualizar posición en la base de datos
    executeDatabase("UPDATE characters SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, health = ? WHERE id = ?",
        deathPos.x, deathPos.y, deathPos.z, 
        deathPos.rotation, deathPos.interior, deathPos.dimension, 100, characterId)
    
    -- Notificar al cliente que fue revivido
    triggerClientEvent(player, "onClientPlayerRevived", resourceRoot)
    
    outputChatBox("Has sido revivido en el lugar donde moriste.", player, 0, 255, 0)
    
    -- Limpiar el timer y la posición de muerte
    if deathTimers[player] then
        if isTimer(deathTimers[player]) then
            killTimer(deathTimers[player])
        end
        deathTimers[player] = nil
    end
    
    deathPositions[player] = nil
    
    return true
end

-- Evento cuando el jugador muere
addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
    if not getElementData(source, "character:selected") then
        return
    end
    
    outputServerLog("[DEATH] " .. getPlayerName(source) .. " ha muerto")
    
    -- Notificar al cliente que el jugador ha muerto
    triggerClientEvent(source, "onClientPlayerDeath", resourceRoot, Config.Death.respawnTime / 1000)
    
    -- Deshabilitar el efecto de "alma volando" - mantener la cámara fija en el lugar de la muerte
    setTimer(function()
        if isElement(source) then
            -- Desactivar la cámara del jugador para evitar el efecto de "alma volando"
            setCameraTarget(source, nil)
            fadeCamera(source, true, 1.0)
        end
    end, 100, 1)
    
    -- Guardar posición de muerte
    local x, y, z = getElementPosition(source)
    local rotation = getPedRotation(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)
    
    -- Guardar posición de muerte para poder revivir ahí
    deathPositions[source] = {
        x = x,
        y = y,
        z = z,
        rotation = rotation,
        interior = interior,
        dimension = dimension
    }
    
    -- Mostrar mensaje de muerte
    outputChatBox("═══════════════════════════════════", source, 255, 0, 0)
    outputChatBox("Has muerto. Serás trasladado al hospital en 6 minutos...", source, 255, 0, 0)
    outputChatBox("═══════════════════════════════════", source, 255, 0, 0)
    
    -- Guardar posición de muerte en la base de datos
    local characterId = getElementData(source, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, health = 0 WHERE id = ?",
            x, y, z, rotation, interior, dimension, characterId)
    end
    
    -- Cancelar timer anterior si existe
    if deathTimers[source] then
        if isTimer(deathTimers[source]) then
            killTimer(deathTimers[source])
        end
    end
    
    -- Crear timer para respawn después de 6 minutos
    deathTimers[source] = setTimer(function()
        if isElement(source) then
            outputServerLog("[DEATH] Respawn automático para " .. getPlayerName(source))
            respawnAtHospital(source)
        end
    end, Config.Death.respawnTime, 1)
    
    -- Actualizar tiempo en el cliente cada segundo
    local totalSeconds = Config.Death.respawnTime / 1000
    
    for i = 1, totalSeconds do
        setTimer(function()
            if isElement(source) and deathTimers[source] then
                local remainingSeconds = totalSeconds - i
                if remainingSeconds > 0 then
                    -- Enviar actualización al cliente para mostrar en pantalla
                    triggerClientEvent(source, "updateDeathTime", resourceRoot, remainingSeconds)
                end
            end
        end, i * 1000, 1)
    end
end)

-- Limpiar timers cuando el jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    if deathTimers[source] then
        if isTimer(deathTimers[source]) then
            killTimer(deathTimers[source])
        end
        deathTimers[source] = nil
    end
    
    if deathPositions[source] then
        deathPositions[source] = nil
    end
end)

