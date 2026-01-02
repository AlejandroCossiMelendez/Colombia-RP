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

-- Evento para teleportar a un jugador (desde el panel)
addEvent("admin:teleportToPlayer", true)
addEventHandler("admin:teleportToPlayer", root, function(characterId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        triggerClientEvent(source, "admin:teleportResponse", source, false, "No tienes permiso para usar esta función.")
        return
    end
    
    if not characterId or not tonumber(characterId) then
        triggerClientEvent(source, "admin:teleportResponse", source, false, "ID de personaje inválido.")
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
        triggerClientEvent(source, "admin:teleportResponse", source, false, "No se encontró ningún jugador con el ID de personaje " .. characterId .. ".")
        return
    end
    
    if target == source then
        triggerClientEvent(source, "admin:teleportResponse", source, false, "No puedes teleportarte a ti mismo.")
        return
    end
    
    -- Obtener posición del jugador objetivo
    local targetX, targetY, targetZ = getElementPosition(target)
    local targetRotation = getPedRotation(target)
    local targetInterior = getElementInterior(target)
    local targetDimension = getElementDimension(target)
    
    -- Calcular posición detrás del jugador objetivo
    -- Convertir rotación a radianes
    local rotationRad = math.rad(targetRotation)
    -- Distancia detrás del jugador (2 metros)
    local distanceBehind = 2.0
    -- Calcular posición detrás basada en la rotación
    local behindX = targetX - math.sin(rotationRad) * distanceBehind
    local behindY = targetY + math.cos(rotationRad) * distanceBehind
    local behindZ = targetZ
    
    -- Teleportar al admin detrás del jugador objetivo
    setElementPosition(source, behindX, behindY, behindZ)
    -- Rotar al admin para que mire hacia el jugador objetivo
    setPedRotation(source, targetRotation)
    setElementInterior(source, targetInterior)
    setElementDimension(source, targetDimension)
    
    -- Ajustar altura para evitar caídas
    setTimer(function()
        if isElement(source) then
            local px, py, pz = getElementPosition(source)
            local hit, hitX, hitY, hitZ = processLineOfSight(px, py, pz + 50, px, py, pz - 50, true, true, false, true, false, false, false, false, source)
            if hit then
                if pz - hitZ < 2.0 or pz < hitZ then
                    setElementPosition(source, px, py, hitZ + 2.0)
                end
            elseif pz < 5.0 then
                setElementPosition(source, px, py, 15.0)
            end
        end
    end, 100, 1)
    
    local charName = getElementData(target, "character:name")
    local charSurname = getElementData(target, "character:surname")
    local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
    
    triggerClientEvent(source, "admin:teleportResponse", source, true, "Te has teleportado a " .. displayName .. " (ID: " .. characterId .. ").")
    outputServerLog("[ADMIN] " .. getPlayerName(source) .. " se teleportó a " .. displayName .. " (ID: " .. characterId .. ")")
end)

-- Evento para toggle invisibilidad (desde el panel)
addEvent("admin:toggleInvisibility", true)
addEventHandler("admin:toggleInvisibility", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        outputChatBox("No tienes permiso para usar esta función.", source, 255, 0, 0)
        return
    end
    
    local isInvisible = getElementData(source, "admin:invisible") or false
    
    if isInvisible then
        -- Hacer visible
        setElementAlpha(source, 255)
        setPlayerNametagShowing(source, true)
        setElementData(source, "admin:invisible", false)
        triggerClientEvent(source, "admin:invisibilityUpdate", source, false, "Invisibilidad desactivada. Ahora eres visible.")
        outputServerLog("[ADMIN] " .. getPlayerName(source) .. " desactivó la invisibilidad")
    else
        -- Hacer invisible
        setElementAlpha(source, 0)
        setPlayerNametagShowing(source, false)
        setElementData(source, "admin:invisible", true)
        triggerClientEvent(source, "admin:invisibilityUpdate", source, true, "Invisibilidad activada. Ahora eres invisible.")
        outputServerLog("[ADMIN] " .. getPlayerName(source) .. " activó la invisibilidad")
    end
end)

-- Evento para curar jugador (desde el panel)
addEvent("admin:healPlayer", true)
addEventHandler("admin:healPlayer", root, function(characterId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        triggerClientEvent(source, "admin:healResponse", source, false, "No tienes permiso para usar esta función.")
        return
    end
    
    if not characterId or not tonumber(characterId) then
        triggerClientEvent(source, "admin:healResponse", source, false, "ID de personaje inválido.")
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
        triggerClientEvent(source, "admin:healResponse", source, false, "No se encontró ningún jugador con el ID de personaje " .. characterId .. ".")
        return
    end
    
    -- Curar completamente al jugador
    setElementHealth(target, 100)
    setPedArmor(target, 100)
    
    -- Actualizar en la base de datos
    local charId = getElementData(target, "character:id")
    if charId then
        executeDatabase("UPDATE characters SET health = ? WHERE id = ?", 100, charId)
    end
    
    local charName = getElementData(target, "character:name")
    local charSurname = getElementData(target, "character:surname")
    local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
    
    triggerClientEvent(source, "admin:healResponse", source, true, "Has curado completamente a " .. displayName .. " (ID: " .. characterId .. ").")
    outputChatBox("Un administrador te ha curado completamente.", target, 0, 255, 0)
    outputServerLog("[ADMIN] " .. getPlayerName(source) .. " curó completamente a " .. displayName .. " (ID: " .. characterId .. ")")
end)

-- Restaurar visibilidad al desconectar
addEventHandler("onPlayerQuit", root, function()
    if getElementData(source, "admin:invisible") then
        setElementData(source, "admin:invisible", nil)
    end
end)

-- Restaurar visibilidad al cambiar de personaje
addEventHandler("onPlayerLogout", root, function()
    if getElementData(source, "admin:invisible") then
        setElementAlpha(source, 255)
        setPlayerNametagShowing(source, true)
        setElementData(source, "admin:invisible", nil)
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

