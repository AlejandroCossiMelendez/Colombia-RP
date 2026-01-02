-- Panel de Administración - Servidor
-- Funciones del servidor para el panel F10

-- Función para verificar si un jugador es admin
function isPlayerAdmin(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    local role = getElementData(player, "account:role")
    return role == "admin"
end

-- Función para verificar si un jugador es staff
function isPlayerStaff(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    local role = getElementData(player, "account:role")
    return role == "staff" or role == "moderator" or role == "admin"
end

-- Evento para revivir jugador (desde el panel)
addEvent("admin:revivePlayer", true)
addEventHandler("admin:revivePlayer", root, function(characterId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        triggerClientEvent(source, "admin:reviveResponse", source, false, "No tienes permiso para usar esta función.")
        return
    end
    
    if not characterId or not tonumber(characterId) then
        triggerClientEvent(source, "admin:reviveResponse", source, false, "ID de personaje inválido.")
        return
    end
    
    characterId = tonumber(characterId)
    
    -- Buscar jugador con ese ID de personaje
    local target = nil
    for _, p in ipairs(getElementsByType("player")) do
        if getElementData(p, "character:selected") then
            local pCharId = getElementData(p, "character:id")
            if pCharId and tonumber(pCharId) == characterId then
                target = p
                break
            end
        end
    end
    
    if not target then
        triggerClientEvent(source, "admin:reviveResponse", source, false, "No se encontró ningún jugador con el ID de personaje " .. characterId .. ".")
        return
    end
    
    -- Intentar revivir en el lugar donde murió
    if respawnAtDeathLocation(target) then
        local charName = getElementData(target, "character:name")
        local charSurname = getElementData(target, "character:surname")
        local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
        
        triggerClientEvent(source, "admin:reviveResponse", source, true, "Has revivido a " .. displayName .. " (ID: " .. characterId .. ") en el lugar donde murió.")
        outputChatBox("Un administrador te ha revivido en el lugar donde moriste.", target, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(source) .. " revivió al personaje ID " .. characterId .. " (" .. displayName .. ") en el lugar donde murió")
    else
        triggerClientEvent(source, "admin:reviveResponse", source, false, "No se pudo revivir al personaje ID " .. characterId .. ". El jugador no está muerto o no hay posición de muerte guardada.")
    end
end)

-- Evento para obtener coordenadas (desde el panel)
addEvent("admin:getCoords", true)
addEventHandler("admin:getCoords", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        outputChatBox("No tienes permiso para usar esta función.", source, 255, 0, 0)
        return
    end
    
    local x, y, z = getElementPosition(source)
    local rotation = getPedRotation(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)
    
    -- Mostrar coordenadas en el chat
    outputChatBox("═══════════════════════════════════", source, 0, 255, 255)
    outputChatBox("Coordenadas actuales:", source, 255, 255, 0)
    outputChatBox("X: " .. string.format("%.2f", x), source, 255, 255, 255)
    outputChatBox("Y: " .. string.format("%.2f", y), source, 255, 255, 255)
    outputChatBox("Z: " .. string.format("%.2f", z), source, 255, 255, 255)
    outputChatBox("Rotación: " .. string.format("%.2f", rotation), source, 255, 255, 255)
    outputChatBox("Interior: " .. interior, source, 255, 255, 255)
    outputChatBox("Dimensión: " .. dimension, source, 255, 255, 255)
    outputChatBox("═══════════════════════════════════", source, 0, 255, 255)
    
    -- También mostrar en consola del servidor
    outputServerLog("[COORDS] " .. getPlayerName(source) .. " - X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ", Rotación: " .. rotation .. ", Interior: " .. interior .. ", Dimensión: " .. dimension)
end)

