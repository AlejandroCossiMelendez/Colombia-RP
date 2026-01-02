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

-- Función para verificar si un jugador es admin o staff
function isPlayerAdminOrStaff(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    local role = getElementData(player, "account:role")
    return role == "admin" or role == "staff" or role == "moderator"
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
    
    if not isPlayerAdminOrStaff(source) then
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
    
    if not isPlayerAdminOrStaff(source) then
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
    -- En MTA, rotación 0 = mirando al norte (Y+), así que detrás es la dirección opuesta
    local behindX = targetX + math.sin(rotationRad) * distanceBehind
    local behindY = targetY - math.cos(rotationRad) * distanceBehind
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

-- Evento para traer a un jugador (desde el panel)
addEvent("admin:bringPlayer", true)
addEventHandler("admin:bringPlayer", root, function(characterId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdminOrStaff(source) then
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
        triggerClientEvent(source, "admin:teleportResponse", source, false, "No puedes traerte a ti mismo.")
        return
    end
    
    -- Obtener posición del admin
    local adminX, adminY, adminZ = getElementPosition(source)
    local adminRotation = getPedRotation(source)
    local adminInterior = getElementInterior(source)
    local adminDimension = getElementDimension(source)
    
    -- Calcular posición delante del admin (2 metros)
    local rotationRad = math.rad(adminRotation)
    local distanceFront = 2.0
    local frontX = adminX - math.sin(rotationRad) * distanceFront
    local frontY = adminY + math.cos(rotationRad) * distanceFront
    local frontZ = adminZ
    
    -- Teleportar al jugador objetivo delante del admin
    setElementPosition(target, frontX, frontY, frontZ)
    setPedRotation(target, adminRotation)
    setElementInterior(target, adminInterior)
    setElementDimension(target, adminDimension)
    
    -- Ajustar altura para evitar caídas
    setTimer(function()
        if isElement(target) then
            local px, py, pz = getElementPosition(target)
            local hit, hitX, hitY, hitZ = processLineOfSight(px, py, pz + 50, px, py, pz - 50, true, true, false, true, false, false, false, false, target)
            if hit then
                if pz - hitZ < 2.0 or pz < hitZ then
                    setElementPosition(target, px, py, hitZ + 2.0)
                end
            elseif pz < 5.0 then
                setElementPosition(target, px, py, 15.0)
            end
        end
    end, 100, 1)
    
    local charName = getElementData(target, "character:name")
    local charSurname = getElementData(target, "character:surname")
    local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
    
    triggerClientEvent(source, "admin:teleportResponse", source, true, "Has traído a " .. displayName .. " (ID: " .. characterId .. ").")
    outputChatBox("Un administrador te ha traído a su ubicación.", target, 0, 255, 0)
    outputServerLog("[ADMIN] " .. getPlayerName(source) .. " trajo a " .. displayName .. " (ID: " .. characterId .. ")")
end)

-- Evento para toggle invisibilidad (desde el panel)
addEvent("admin:toggleInvisibility", true)
addEventHandler("admin:toggleInvisibility", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdminOrStaff(source) then
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
    
    if not isPlayerAdminOrStaff(source) then
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

-- Evento para dar dinero a un jugador (desde el panel)
addEvent("admin:giveMoney", true)
addEventHandler("admin:giveMoney", root, function(characterId, amount)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        triggerClientEvent(source, "admin:giveMoneyResponse", source, false, "No tienes permiso para usar esta función.")
        return
    end
    
    if not characterId or not tonumber(characterId) then
        triggerClientEvent(source, "admin:giveMoneyResponse", source, false, "ID de personaje inválido.")
        return
    end
    
    if not amount or not tonumber(amount) or tonumber(amount) <= 0 then
        triggerClientEvent(source, "admin:giveMoneyResponse", source, false, "La cantidad debe ser un número mayor a 0.")
        return
    end
    
    characterId = tonumber(characterId)
    amount = tonumber(amount)
    
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
        triggerClientEvent(source, "admin:giveMoneyResponse", source, false, "No se encontró ningún jugador con el ID de personaje " .. characterId .. ".")
        return
    end
    
    -- Dar dinero al jugador
    if giveCharacterMoney(target, amount) then
        local charName = getElementData(target, "character:name")
        local charSurname = getElementData(target, "character:surname")
        local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
        
        triggerClientEvent(source, "admin:giveMoneyResponse", source, true, "Has dado $" .. amount .. " a " .. displayName .. " (ID: " .. characterId .. ").")
        outputChatBox("Un administrador te ha dado $" .. amount .. ".", target, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(source) .. " dio $" .. amount .. " a " .. displayName .. " (ID: " .. characterId .. ")")
    else
        triggerClientEvent(source, "admin:giveMoneyResponse", source, false, "Error al dar el dinero. Inténtalo más tarde.")
    end
end)

-- Evento para teleportar desde freecam (click derecho)
addEvent("admin:freecamTeleport", true)
addEventHandler("admin:freecamTeleport", root, function(x, y, z)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdminOrStaff(source) then
        return
    end
    
    if not x or not y or not z then
        return
    end
    
    -- Teleportar al admin
    setElementPosition(source, x, y, z)
    
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
    
    outputServerLog("[ADMIN] " .. getPlayerName(source) .. " se teleportó desde freecam a " .. string.format("%.2f, %.2f, %.2f", x, y, z))
end)

-- Evento para obtener coordenadas (desde el panel)
addEvent("admin:getCoords", true)
addEventHandler("admin:getCoords", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdminOrStaff(source) then
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

-- Evento para crear vehículo (desde el panel)
addEvent("admin:createVehicle", true)
addEventHandler("admin:createVehicle", root, function(vehicleId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        outputChatBox("No tienes permiso para usar esta función.", source, 255, 0, 0)
        return
    end
    
    if not vehicleId or not tonumber(vehicleId) then
        outputChatBox("ID de vehículo inválido.", source, 255, 0, 0)
        return
    end
    
    vehicleId = tonumber(vehicleId)
    
    -- Validar que el ID del vehículo esté en el rango válido (400-611)
    if vehicleId < 400 or vehicleId > 611 then
        outputChatBox("ID de vehículo inválido. Debe estar entre 400 y 611.", source, 255, 0, 0)
        return
    end
    
    -- Obtener posición y rotación del admin
    local adminX, adminY, adminZ = getElementPosition(source)
    local adminRotation = getPedRotation(source)
    local adminInterior = getElementInterior(source)
    local adminDimension = getElementDimension(source)
    
    -- Solicitar al cliente que calcule la posición delante usando la cámara
    -- Esto es más preciso que usar solo la rotación del ped
    triggerClientEvent(source, "admin:calculateVehiclePosition", source, vehicleId, adminX, adminY, adminZ, adminRotation, adminInterior, adminDimension)
end)

-- Evento mejorado para crear vehículo con opciones
addEvent("admin:createVehicleWithOptions", true)
addEventHandler("admin:createVehicleWithOptions", root, function(vehicleId, generateForPlayer, playerId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        return
    end
    
    -- Validar ID del vehículo
    if vehicleId < 400 or vehicleId > 611 then
        outputChatBox("ID de vehículo inválido. Debe estar entre 400 y 611.", source, 255, 0, 0)
        return
    end
    
    -- Solicitar al cliente que calcule la posición
    triggerClientEvent(source, "admin:calculateVehiclePosition", source, vehicleId, generateForPlayer, playerId)
end)

-- Evento del cliente para calcular la posición y crear el vehículo
addEvent("admin:createVehicleAtPosition", true)
addEventHandler("admin:createVehicleAtPosition", root, function(vehicleId, x, y, z, rotation, interior, dimension, generateForPlayer, playerId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        return
    end
    
    -- Cargar el sistema de vehículos
    if not createVehicleWithoutOwner or not createVehicleForPlayer then
        outputChatBox("Error: Sistema de vehículos no disponible.", source, 255, 0, 0)
        return
    end
    
    local vehicle, plate
    local vehicleName = getVehicleNameFromModel(vehicleId) or "Vehículo " .. vehicleId
    
    if generateForPlayer and playerId then
        -- Verificar que el jugador existe
        local targetPlayer = nil
        for _, player in ipairs(getElementsByType("player")) do
            local charId = getElementData(player, "character:id")
            if charId and charId == playerId then
                targetPlayer = player
                break
            end
        end
        
        if not targetPlayer then
            outputChatBox("Error: No se encontró un jugador con ID de personaje " .. playerId, source, 255, 0, 0)
            return
        end
        
        -- Crear vehículo para el jugador
        vehicle, plate = createVehicleForPlayer(vehicleId, x, y, z, rotation, interior, dimension, playerId)
        
        if vehicle then
            outputChatBox("✓ Vehículo '" .. vehicleName .. "' creado para el jugador (ID: " .. playerId .. ")", source, 0, 255, 0)
            outputChatBox("Matrícula: " .. plate, source, 255, 255, 0)
            outputChatBox("✓ El vehículo ha sido generado y las llaves han sido entregadas al jugador.", source, 0, 255, 0)
            
            -- Notificar al jugador objetivo
            if targetPlayer then
                outputChatBox("✓ Has recibido un vehículo nuevo con matrícula: " .. plate, targetPlayer, 0, 255, 0)
                outputChatBox("✓ Las llaves han sido agregadas a tu inventario.", targetPlayer, 0, 255, 0)
            end
        else
            outputChatBox("Error al crear el vehículo: " .. (plate or "Error desconocido"), source, 255, 0, 0)
        end
    else
        -- Crear vehículo sin dueño
        vehicle, plate = createVehicleWithoutOwner(vehicleId, x, y, z, rotation, interior, dimension)
        
        if vehicle then
            outputChatBox("✓ Vehículo '" .. vehicleName .. "' creado sin dueño (cualquiera puede manejarlo)", source, 0, 255, 0)
            outputChatBox("Matrícula: " .. plate, source, 255, 255, 0)
        else
            outputChatBox("Error al crear el vehículo: " .. (plate or "Error desconocido"), source, 255, 0, 0)
        end
    end
    
    if vehicle then
        outputServerLog("[ADMIN] " .. getPlayerName(source) .. " creó el vehículo " .. vehicleName .. " (ID: " .. vehicleId .. ") en " .. string.format("%.2f, %.2f, %.2f", x, y, z))
        outputServerLog("[ADMIN] Matrícula: " .. plate .. " | Dueño: " .. (playerId or "Ninguno"))
    end
end)

-- Evento para crear vehículo (versión antigua - mantener por compatibilidad)
addEvent("admin:createVehicleOld", true)
addEventHandler("admin:createVehicleOld", root, function(vehicleId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not isPlayerAdmin(source) then
        outputChatBox("No tienes permiso para usar esta función.", source, 255, 0, 0)
        return
    end
    
    if not vehicleId or not tonumber(vehicleId) then
        outputChatBox("ID de vehículo inválido.", source, 255, 0, 0)
        return
    end
    
    vehicleId = tonumber(vehicleId)
    
    -- Validar que el ID del vehículo esté en el rango válido (400-611)
    if vehicleId < 400 or vehicleId > 611 then
        outputChatBox("ID de vehículo inválido. Debe estar entre 400 y 611.", source, 255, 0, 0)
        return
    end
    
    -- Obtener posición y rotación del admin
    local adminX, adminY, adminZ = getElementPosition(source)
    local adminRotation = getPedRotation(source)
    local adminInterior = getElementInterior(source)
    local adminDimension = getElementDimension(source)
    
    -- Calcular posición 5 metros delante del admin
    -- En MTA, rotación 0 = mirando al norte (Y+), 90 = este (X+), 180 = sur (Y-), 270 = oeste (X-)
    local rotationRad = math.rad(adminRotation)
    local distanceFront = 5.0
    
    -- Calcular dirección hacia adelante usando la fórmula correcta
    -- En MTA, para ir "adelante" desde la rotación del ped:
    -- -sin(rotación) para X (este es positivo)
    -- cos(rotación) para Y (norte es positivo)
    local frontX = adminX - math.sin(rotationRad) * distanceFront
    local frontY = adminY + math.cos(rotationRad) * distanceFront
    local frontZ = adminZ
    
    -- Verificar altura del suelo en la posición calculada
    -- Usar un rango más amplio para detectar el suelo
    local hit, hitX, hitY, hitZ = processLineOfSight(frontX, frontY, adminZ + 20, frontX, frontY, adminZ - 50, true, true, false, true, false, false, false, false, source)
    if hit and hitZ then
        frontZ = hitZ + 0.5
    else
        -- Si no hay suelo detectado, usar la altura del admin + un pequeño offset
        frontZ = adminZ + 0.5
    end
    
    -- Asegurar que la altura mínima sea razonable
    if frontZ < 5.0 then
        frontZ = adminZ + 0.5
    end
    
    -- Crear el vehículo
    local vehicle = createVehicle(vehicleId, frontX, frontY, frontZ, 0, 0, adminRotation)
    
    if not vehicle then
        outputChatBox("Error al crear el vehículo. Verifica que el ID sea válido.", source, 255, 0, 0)
        return
    end
    
    -- Configurar dimensiones e interior del vehículo (IMPORTANTE: debe coincidir con el admin)
    setElementDimension(vehicle, adminDimension)
    setElementInterior(vehicle, adminInterior)
    
    -- Asegurar que el vehículo sea visible
    setElementAlpha(vehicle, 255)
    
    -- Obtener nombre del vehículo
    local vehicleName = getVehicleNameFromModel(vehicleId) or "Vehículo " .. vehicleId
    
    -- Mensaje de confirmación con coordenadas
    outputChatBox("✓ Vehículo '" .. vehicleName .. "' (ID: " .. vehicleId .. ") creado correctamente.", source, 0, 255, 0)
    outputChatBox("Posición: X=" .. string.format("%.2f", frontX) .. " Y=" .. string.format("%.2f", frontY) .. " Z=" .. string.format("%.2f", frontZ), source, 255, 255, 255)
    outputChatBox("Tu posición: X=" .. string.format("%.2f", adminX) .. " Y=" .. string.format("%.2f", adminY) .. " Z=" .. string.format("%.2f", adminZ), source, 255, 255, 255)
    outputChatBox("Distancia: " .. string.format("%.2f", getDistanceBetweenPoints3D(adminX, adminY, adminZ, frontX, frontY, frontZ)) .. " metros", source, 255, 255, 255)
    outputServerLog("[ADMIN] " .. getPlayerName(source) .. " creó el vehículo " .. vehicleName .. " (ID: " .. vehicleId .. ") en " .. string.format("%.2f, %.2f, %.2f", frontX, frontY, frontZ))
    outputServerLog("[ADMIN] Posición del admin: " .. string.format("%.2f, %.2f, %.2f", adminX, adminY, adminZ) .. " Rotación: " .. adminRotation)
    outputServerLog("[ADMIN] Dimensión admin: " .. adminDimension .. " Interior admin: " .. adminInterior)
    outputServerLog("[ADMIN] Dimensión vehículo: " .. getElementDimension(vehicle) .. " Interior vehículo: " .. getElementInterior(vehicle))
end)

