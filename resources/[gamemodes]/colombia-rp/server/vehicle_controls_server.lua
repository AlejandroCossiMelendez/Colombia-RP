-- Sistema de Controles de Vehículos - Servidor
-- Maneja los eventos de motor, bloqueo y luces

-- Cargar funciones del sistema de vehículos
-- Nota: playerHasVehicleKey se define en vehicles_system.lua
-- Si no está disponible, se mostrará un error pero el sistema seguirá funcionando

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

-- Evento: Bloquear/Desbloquear puertas
addEvent("vehicle:toggleLock", true)
addEventHandler("vehicle:toggleLock", root, function(vehicle, newState)
    outputServerLog("[VEHICLE] Evento vehicle:toggleLock recibido de " .. (isElement(source) and getPlayerName(source) or "DESCONECTADO"))
    
    if not isElement(source) or getElementType(source) ~= "player" then
        outputServerLog("[VEHICLE] ERROR: source inválido en vehicle:toggleLock")
        return
    end
    
    outputServerLog("[VEHICLE] Vehículo recibido: " .. tostring(vehicle) .. " | Tipo: " .. (isElement(vehicle) and getElementType(vehicle) or "NO ES ELEMENTO"))
    outputServerLog("[VEHICLE] Nuevo estado: " .. tostring(newState))
    
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        outputChatBox("Vehículo inválido.", source, 255, 0, 0)
        outputServerLog("[VEHICLE] ERROR: vehículo inválido en vehicle:toggleLock para " .. getPlayerName(source))
        return
    end
    
    local plate = getElementData(vehicle, "vehicle:plate") or "Sin matrícula"
    outputServerLog("[VEHICLE] Matrícula del vehículo: " .. plate)
    
    -- Verificar si tiene las llaves
    if not playerHasVehicleKey then
        outputServerLog("[VEHICLE] ERROR: playerHasVehicleKey no está disponible")
        outputChatBox("Error del sistema: función de llaves no disponible.", source, 255, 0, 0)
        return
    end
    
    local hasKey = playerHasVehicleKey(source, vehicle)
    outputServerLog("[VEHICLE] ¿Tiene llaves? " .. tostring(hasKey))
    
    if not hasKey then
        outputChatBox("No tienes las llaves de este vehículo.", source, 255, 0, 0)
        outputServerLog("[VEHICLE] " .. getPlayerName(source) .. " intentó bloquear vehículo sin llaves: " .. plate)
        return
    end
    
    -- Cambiar estado del bloqueo
    setVehicleLocked(vehicle, newState)
    outputServerLog("[VEHICLE] Estado del bloqueo cambiado a: " .. tostring(newState))
    
    -- Actualizar en base de datos
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    outputServerLog("[VEHICLE] ID del vehículo en DB: " .. tostring(vehicleDbId))
    
    if vehicleDbId then
        executeDatabase("UPDATE vehicles SET locked = ? WHERE id = ?", newState and 1 or 0, vehicleDbId)
        setElementData(vehicle, "vehicle:locked", newState)
        outputServerLog("[VEHICLE] Base de datos actualizada")
    else
        outputServerLog("[VEHICLE] WARNING: No se encontró ID en DB, solo se actualizó en memoria")
    end
    
    -- Reproducir sonido de bloqueo/desbloqueo
    local vx, vy, vz = getElementPosition(vehicle)
    triggerClientEvent("vehicle:playLockSound", root, vx, vy, vz)
    outputServerLog("[VEHICLE] Sonido enviado a clientes")
    
    local stateText = newState and "bloqueado" or "desbloqueado"
    outputChatBox("Vehículo " .. stateText, source, 0, 255, 0)
    outputServerLog("[VEHICLE] " .. getPlayerName(source) .. " " .. stateText .. " vehículo: " .. plate)
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
        return
    end
    
    -- Verificar que esté en el vehículo como conductor
    if getPedOccupiedVehicle(source) ~= vehicle or getPedOccupiedVehicleSeat(source) ~= 0 then
        outputChatBox("Debes ser el conductor para controlar las luces.", source, 255, 0, 0)
        return
    end
    
    -- Cambiar estado de las luces
    setVehicleOverrideLights(vehicle, newState)
    
    -- Actualizar en base de datos
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    if vehicleDbId then
        executeDatabase("UPDATE vehicles SET lights = ? WHERE id = ?", newState == 2 and 1 or 0, vehicleDbId)
    end
    
    local stateText = (newState == 2) and "encendidas" or "apagadas"
    outputChatBox("Luces " .. stateText, source, 0, 255, 0)
end)

