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

