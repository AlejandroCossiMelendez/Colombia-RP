-- Sistema de Controles de Vehículos - Servidor
-- Maneja los eventos de motor, bloqueo y luces

-- Cargar funciones del sistema de vehículos
-- Nota: playerHasVehicleKey se define en vehicles_system.lua
-- Si no está disponible, se mostrará un error pero el sistema seguirá funcionando

-- Evento: Solicitar llaves del jugador
addEvent("vehicle:requestKeys", true)
addEventHandler("vehicle:requestKeys", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    local characterId = getElementData(source, "character:id")
    if not characterId then
        triggerClientEvent(source, "vehicle:receiveKeys", source, {})
        return
    end
    
    -- Obtener todas las llaves del jugador (item 1 = Llave de Coche)
    local query = queryDatabase("SELECT value FROM items WHERE owner = ? AND item = 1", characterId)
    local keys = {}
    
    if query and #query > 0 then
        for _, row in ipairs(query) do
            if row.value and row.value ~= "" then
                table.insert(keys, row.value)
            end
        end
    end
    
    -- Enviar llaves al cliente
    triggerClientEvent(source, "vehicle:receiveKeys", source, keys)
end)

-- Evento: Verificar si el jugador tiene las llaves
addEvent("vehicle:checkKey", true)
addEventHandler("vehicle:checkKey", root, function(vehicle)
    if not isElement(source) or not isElement(vehicle) then
        return
    end
    
    local hasKey = playerHasVehicleKey(source, vehicle)
    triggerClientEvent(source, "vehicle:keyCheckResult", source, hasKey)
end)

-- Evento: Verificar llaves al intentar entrar
addEvent("vehicle:checkKeyForEnter", true)
addEventHandler("vehicle:checkKeyForEnter", root, function(vehicle)
    if not isElement(source) or not isElement(vehicle) then
        return
    end
    
    local hasKey = playerHasVehicleKey(source, vehicle)
    triggerClientEvent(source, "vehicle:enterCheckResult", source, hasKey)
end)

-- Evento: Prender/Apagar motor
addEvent("vehicle:toggleEngine", true)
addEventHandler("vehicle:toggleEngine", root, function(vehicle, newState)
    if not isElement(source) or not isElement(vehicle) then
        return
    end
    
    -- Verificar si tiene las llaves
    if not playerHasVehicleKey(source, vehicle) then
        outputChatBox("No tienes las llaves de este vehículo.", source, 255, 0, 0)
        return
    end
    
    -- Verificar que esté en el vehículo como conductor
    if getPedOccupiedVehicle(source) ~= vehicle or getPedOccupiedVehicleSeat(source) ~= 0 then
        outputChatBox("Debes ser el conductor para controlar el motor.", source, 255, 0, 0)
        return
    end
    
    -- Obtener estado actual si no se especificó
    if newState == nil then
        newState = not getVehicleEngineState(vehicle)
    end
    
    -- Cambiar estado del motor
    setVehicleEngineState(vehicle, newState)
    
    -- Actualizar en base de datos
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    if vehicleDbId then
        executeDatabase("UPDATE vehicles SET engine = ? WHERE id = ?", newState and 1 or 0, vehicleDbId)
    end
    
    local stateText = newState and "encendido" or "apagado"
    outputChatBox("Motor " .. stateText, source, 0, 255, 0)
end)

-- Evento: Bloquear/Desbloquear puertas de un vehículo cercano (buscar automáticamente)
addEvent("vehicle:toggleLockNearby", true)
addEventHandler("vehicle:toggleLockNearby", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    local characterId = getElementData(source, "character:id")
    if not characterId then
        outputChatBox("Tu personaje no está completamente cargado.", source, 255, 0, 0)
        return
    end
    
    -- Obtener todas las llaves del jugador (item 1 = Llave de Coche)
    local query = queryDatabase("SELECT value FROM items WHERE owner = ? AND item = 1", characterId)
    local keys = {}
    
    if query and #query > 0 then
        for _, row in ipairs(query) do
            if row.value and row.value ~= "" then
                table.insert(keys, row.value)
            end
        end
    end
    
    if #keys == 0 then
        outputChatBox("No tienes llaves de vehículos en tu inventario.", source, 255, 255, 0)
        return
    end
    
    -- Buscar vehículo cercano para el que tenga llaves
    local px, py, pz = getElementPosition(source)
    local nearbyVehicle = nil
    local minDistance = 10.0
    
    for _, veh in ipairs(getElementsByType("vehicle")) do
        if isElement(veh) then
            -- Obtener matrícula del vehículo
            local plate = getElementData(veh, "vehicle:plate")
            if not plate then
                plate = getVehiclePlateText(veh)
            end
            
            if plate and plate ~= "" and plate ~= " " then
                -- Normalizar la matrícula
                plate = tostring(plate):gsub("%s+", "")
                
                -- Verificar si tenemos la llave de este vehículo
                local hasKey = false
                for _, keyPlate in ipairs(keys) do
                    local normalizedKeyPlate = tostring(keyPlate):gsub("%s+", "")
                    if plate == normalizedKeyPlate then
                        hasKey = true
                        break
                    end
                end
                
                -- Si tenemos la llave, verificar distancia
                if hasKey then
                    local vx, vy, vz = getElementPosition(veh)
                    local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
                    if distance < minDistance then
                        nearbyVehicle = veh
                        minDistance = distance
                    end
                end
            end
        end
    end
    
    if not nearbyVehicle then
        outputChatBox("No hay ningún vehículo cerca (máximo 10 metros) para el que tengas llaves.", source, 255, 255, 0)
        return
    end
    
    -- Usar el vehículo encontrado para bloquear/desbloquear
    local isLocked = getElementData(nearbyVehicle, "vehicle:locked") or false
    local newState = not isLocked
    
                -- Cambiar estado del bloqueo
                setVehicleLocked(nearbyVehicle, newState)
                setElementData(nearbyVehicle, "vehicle:locked", newState)
                
                -- Sincronizar con todos los clientes para que el bloqueo funcione correctamente
                triggerClientEvent("vehicle:syncLockState", root, nearbyVehicle, newState)
                
                -- Actualizar en base de datos
                local vehicleDbId = getElementData(nearbyVehicle, "vehicle:db_id") or getElementData(nearbyVehicle, "vehicle:id")
                if vehicleDbId then
                    executeDatabase("UPDATE vehicles SET locked = ? WHERE id = ?", newState and 1 or 0, vehicleDbId)
                end
                
                -- Reproducir sonido de bloqueo/desbloqueo
                local vx, vy, vz = getElementPosition(nearbyVehicle)
                triggerClientEvent("vehicle:playLockSound", root, vx, vy, vz)
    
    local stateText = newState and "bloqueado" or "desbloqueado"
    outputChatBox("Vehículo " .. stateText, source, 0, 255, 0)
end)

-- Evento: Bloquear/Desbloquear puertas
addEvent("vehicle:toggleLock", true)
addEventHandler("vehicle:toggleLock", root, function(vehicle, newState)
    if not isElement(source) or getElementType(source) ~= "player" then
        outputServerLog("[VEHICLE] ERROR: source inválido en vehicle:toggleLock")
        return
    end
    
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        outputChatBox("Vehículo inválido.", source, 255, 0, 0)
        outputServerLog("[VEHICLE] ERROR: vehículo inválido en vehicle:toggleLock para " .. getPlayerName(source))
        return
    end
    
    -- Verificar si tiene las llaves
    if not playerHasVehicleKey then
        outputChatBox("Error del sistema: función de llaves no disponible.", source, 255, 0, 0)
        outputServerLog("[VEHICLE] ERROR: playerHasVehicleKey no está disponible")
        return
    end
    
    local hasKey = playerHasVehicleKey(source, vehicle)
    local plate = getElementData(vehicle, "vehicle:plate") or "Sin matrícula"
    outputServerLog("[VEHICLE] " .. getPlayerName(source) .. " intenta bloquear vehículo " .. plate .. " - ¿Tiene llaves? " .. tostring(hasKey))
    
    if not hasKey then
        outputChatBox("No tienes las llaves de este vehículo.", source, 255, 0, 0)
        return
    end
    
    -- Cambiar estado del bloqueo
    setVehicleLocked(vehicle, newState)
    setElementData(vehicle, "vehicle:locked", newState)
    
    -- Sincronizar con todos los clientes para que el bloqueo funcione correctamente
    triggerClientEvent("vehicle:syncLockState", root, vehicle, newState)
    
    -- Actualizar en base de datos
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    if vehicleDbId then
        executeDatabase("UPDATE vehicles SET locked = ? WHERE id = ?", newState and 1 or 0, vehicleDbId)
        outputServerLog("[VEHICLE] Estado de bloqueo actualizado en BD para vehículo " .. plate .. ": " .. tostring(newState))
    end
    
    -- Reproducir sonido de bloqueo/desbloqueo
    local vx, vy, vz = getElementPosition(vehicle)
    triggerClientEvent("vehicle:playLockSound", root, vx, vy, vz)
    
    local stateText = newState and "bloqueado" or "desbloqueado"
    outputChatBox("Vehículo " .. stateText, source, 0, 255, 0)
    outputServerLog("[VEHICLE] " .. getPlayerName(source) .. " " .. stateText .. " vehículo " .. plate)
end)

-- Evento: Prender/Apagar luces
addEvent("vehicle:toggleLights", true)
addEventHandler("vehicle:toggleLights", root, function(vehicle, newState)
    if not isElement(source) or not isElement(vehicle) then
        return
    end
    
    -- Verificar si tiene las llaves
    if not playerHasVehicleKey(source, vehicle) then
        outputChatBox("No tienes las llaves de este vehículo.", source, 255, 0, 0)
        -- Revertir el cambio en el cliente
        local currentState = getVehicleOverrideLights(vehicle)
        triggerClientEvent(source, "vehicle:revertLights", source, vehicle, currentState)
        return
    end
    
    -- Verificar que esté en el vehículo como conductor
    if getPedOccupiedVehicle(source) ~= vehicle or getPedOccupiedVehicleSeat(source) ~= 0 then
        outputChatBox("Debes ser el conductor para controlar las luces.", source, 255, 0, 0)
        -- Revertir el cambio en el cliente
        local currentState = getVehicleOverrideLights(vehicle)
        triggerClientEvent(source, "vehicle:revertLights", source, vehicle, currentState)
        return
    end
    
    -- Cambiar estado de las luces (ya se cambió en el cliente, pero lo confirmamos aquí)
    setVehicleOverrideLights(vehicle, newState)
    
    -- Actualizar en base de datos
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    if vehicleDbId then
        executeDatabase("UPDATE vehicles SET lights = ? WHERE id = ?", newState == 2 and 1 or 0, vehicleDbId)
    end
    
    local stateText = (newState == 2) and "encendidas" or "apagadas"
    outputChatBox("Luces " .. stateText, source, 0, 255, 0)
end)

-- Evento: Activar/Desactivar freno de mano
addEvent("vehicle:toggleHandbrake", true)
addEventHandler("vehicle:toggleHandbrake", root, function(vehicle, newState)
    if not isElement(source) or not isElement(vehicle) then
        return
    end
    
    -- Verificar que esté en el vehículo como conductor
    if getPedOccupiedVehicle(source) ~= vehicle or getPedOccupiedVehicleSeat(source) ~= 0 then
        return
    end
    
    -- Verificar velocidad del vehículo (solo permitir activar si está quieto)
    if newState then
        local vx, vy, vz = getElementVelocity(vehicle)
        local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180 -- Convertir a km/h aproximado
        if speed > 5 then
            outputChatBox("Debes estar detenido para activar el freno de mano.", source, 255, 255, 0)
            -- Revertir en el cliente
            triggerClientEvent(source, "vehicle:revertHandbrake", source, vehicle, false)
            return
        end
    end
    
    -- Aplicar freno de mano en el servidor (congelar el vehículo)
    setElementFrozen(vehicle, newState)
    setElementData(vehicle, "vehicle:handbrake", newState)
    
    -- Actualizar en base de datos (solo si la columna existe)
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    if vehicleDbId then
        -- Intentar actualizar, pero no fallar si la columna no existe aún
        pcall(function()
            executeDatabase("UPDATE vehicles SET handbrake = ? WHERE id = ?", newState and 1 or 0, vehicleDbId)
        end)
    end
end)

-- Prevenir que los jugadores salgan del vehículo si está bloqueado (servidor)
-- Usar alta prioridad para asegurar que se ejecute antes que otros handlers
addEventHandler("onPlayerVehicleExit", root, function(vehicle, seat)
    if not vehicle or not isElement(vehicle) then
        return
    end
    
    -- Verificar que el jugador realmente esté dentro del vehículo antes de cancelar la salida
    local currentVehicle = getPedOccupiedVehicle(source)
    if currentVehicle ~= vehicle then
        -- El jugador no está en este vehículo, no hacer nada
        return
    end
    
    -- Verificar si el vehículo está bloqueado (verificar múltiples formas)
    local isLocked = false
    local lockedData = getElementData(vehicle, "vehicle:locked")
    if lockedData == true or lockedData == 1 then
        isLocked = true
    end
    
    if isLocked then
        -- Cancelar la salida
        cancelEvent()
        outputChatBox("El vehículo está bloqueado. Desbloquéalo con K para salir.", source, 255, 0, 0)
        
        -- Forzar al jugador a quedarse en el vehículo (múltiples intentos para asegurar)
        setTimer(function()
            if isElement(vehicle) and isElement(source) and getPedOccupiedVehicle(source) ~= vehicle then
                warpPedIntoVehicle(source, vehicle, seat)
            end
        end, 50, 1)
        
        setTimer(function()
            if isElement(vehicle) and isElement(source) and getPedOccupiedVehicle(source) ~= vehicle then
                warpPedIntoVehicle(source, vehicle, seat)
            end
        end, 100, 1)
        
        setTimer(function()
            if isElement(vehicle) and isElement(source) and getPedOccupiedVehicle(source) ~= vehicle then
                warpPedIntoVehicle(source, vehicle, seat)
            end
        end, 200, 1)
        
        setTimer(function()
            if isElement(vehicle) and isElement(source) and getPedOccupiedVehicle(source) ~= vehicle then
                warpPedIntoVehicle(source, vehicle, seat)
            end
        end, 500, 1)
    end
end, true, "high") -- Alta prioridad para asegurar que se ejecute primero

-- Prevenir que los jugadores entren a vehículos bloqueados sin llaves (servidor)
addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat)
    if vehicle and isElement(vehicle) then
        local isLocked = getElementData(vehicle, "vehicle:locked") or false
        if isLocked then
            -- Verificar si tiene las llaves
            if playerHasVehicleKey and playerHasVehicleKey(source, vehicle) then
                -- Tiene llaves, permitir entrada
                return
            else
                -- No tiene llaves, cancelar entrada
                cancelEvent()
                outputChatBox("Este vehículo está bloqueado y no tienes las llaves.", source, 255, 0, 0)
            end
        end
    end
end)

