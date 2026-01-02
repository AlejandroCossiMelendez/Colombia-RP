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
    
    outputChatBox("Has sido trasladado al hospital.", player, 0, 255, 255)
    outputChatBox("Estás vivo nuevamente. ¡Ten más cuidado!", player, 0, 255, 0)
    
    -- Limpiar el timer
    if deathTimers[player] then
        if isTimer(deathTimers[player]) then
            killTimer(deathTimers[player])
        end
        deathTimers[player] = nil
    end
    
    return true
end

-- Evento cuando el jugador muere
addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
    if not getElementData(source, "character:selected") then
        return
    end
    
    outputServerLog("[DEATH] " .. getPlayerName(source) .. " ha muerto")
    
    -- Deshabilitar el efecto de "alma volando" - mantener la cámara fija en el lugar de la muerte
    setTimer(function()
        if isElement(source) then
            local x, y, z = getElementPosition(source)
            -- Configurar cámara fija en el lugar de la muerte
            setCameraTarget(source, nil)
            fadeCamera(source, true, 1.0)
            -- La cámara se mantendrá en el lugar de la muerte
        end
    end, 100, 1)
    
    -- Mostrar mensaje de muerte
    outputChatBox("Has muerto. Serás trasladado al hospital en 6 minutos...", source, 255, 0, 0)
    
    -- Guardar posición de muerte en la base de datos
    local characterId = getElementData(source, "character:id")
    if characterId then
        local x, y, z = getElementPosition(source)
        local rotation = getPedRotation(source)
        local interior = getElementInterior(source)
        local dimension = getElementDimension(source)
        
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
    
    -- Mostrar cuenta regresiva cada minuto
    local minutesLeft = Config.Death.respawnTime / 60000
    for i = 1, minutesLeft - 1 do
        setTimer(function()
            if isElement(source) and deathTimers[source] then
                local remaining = minutesLeft - i
                if remaining > 0 then
                    outputChatBox("Serás trasladado al hospital en " .. remaining .. " minuto(s)...", source, 255, 255, 0)
                end
            end
        end, i * 60000, 1)
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
end)

