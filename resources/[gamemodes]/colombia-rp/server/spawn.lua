-- Sistema de Spawn
function spawnPlayerAtLocation(player, x, y, z, rotation, interior, dimension)
    if not isElement(player) then
        return false
    end
    
    spawnPlayer(player, x, y, z, rotation, 0, interior, dimension)
    setCameraTarget(player, player)
    fadeCamera(player, true)
    
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

