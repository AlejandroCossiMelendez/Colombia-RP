-- Sistema de Controles de Vehículos
-- J: Prender/Apagar motor
-- K: Bloquear/Desbloquear puertas
-- L: Prender/Apagar luces

-- Variables
local vehicleControlsEnabled = true

-- Control J: Prender/Apagar motor
bindKey("j", "down", function()
    if not vehicleControlsEnabled then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
        return
    end
    
    -- Obtener estado actual y enviar al servidor (el servidor verifica llaves y permisos de admin)
    local engineState = getVehicleEngineState(vehicle)
    triggerServerEvent("vehicle:toggleEngine", localPlayer, vehicle, not engineState)
end)

-- Control K: Bloquear/Desbloquear puertas
bindKey("k", "down", function()
    -- Debug: confirmar que la tecla se presionó
    outputChatBox("[DEBUG] Tecla K presionada", 255, 255, 0)
    
    if not vehicleControlsEnabled then 
        outputChatBox("[DEBUG] Controles deshabilitados", 255, 0, 0)
        return 
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    outputChatBox("[DEBUG] Vehículo ocupado: " .. tostring(vehicle ~= nil), 255, 255, 0)
    
    -- Si no está en un vehículo, buscar el más cercano
    if not vehicle then
        local px, py, pz = getElementPosition(localPlayer)
        local nearbyVehicle = nil
        local minDistance = 5.0
        
        outputChatBox("[DEBUG] Buscando vehículo cercano...", 255, 255, 0)
        
        for _, veh in ipairs(getElementsByType("vehicle")) do
            -- Verificar que sea un vehículo del sistema (tiene matrícula o dueño)
            local plate = getElementData(veh, "vehicle:plate")
            local ownerId = getElementData(veh, "vehicle:owner_id")
            
            if plate or ownerId then
                local vx, vy, vz = getElementPosition(veh)
                local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
                if distance < minDistance then
                    nearbyVehicle = veh
                    minDistance = distance
                end
            end
        end
        
        if nearbyVehicle then
            vehicle = nearbyVehicle
            outputChatBox("[DEBUG] Vehículo cercano encontrado: " .. (getElementData(vehicle, "vehicle:plate") or "Sin matrícula"), 0, 255, 0)
        else
            outputChatBox("[DEBUG] No hay vehículo cerca (máx 5m)", 255, 0, 0)
            return
        end
    end
    
    if not vehicle or not isElement(vehicle) then
        outputChatBox("[DEBUG] Vehículo inválido", 255, 0, 0)
        return
    end
    
    -- Obtener estado actual del bloqueo
    local isLocked = getVehicleLocked(vehicle)
    local newState = not isLocked
    
    local plate = getElementData(vehicle, "vehicle:plate") or "Sin matrícula"
    outputChatBox("[DEBUG] Enviando evento - Vehículo: " .. plate .. " | Estado actual: " .. tostring(isLocked) .. " | Nuevo estado: " .. tostring(newState), 0, 255, 255)
    
    -- Enviar al servidor para verificar llaves y cambiar estado
    triggerServerEvent("vehicle:toggleLock", localPlayer, vehicle, newState)
    outputChatBox("[DEBUG] Evento enviado al servidor", 0, 255, 0)
end)

-- Control L: Prender/Apagar luces
bindKey("l", "down", function()
    if not vehicleControlsEnabled then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
        return
    end
    
    -- Verificar llaves en el servidor
    local lightsState = getVehicleOverrideLights(vehicle)
    local newState = (lightsState == 2) and 0 or 2
    triggerServerEvent("vehicle:toggleLights", localPlayer, vehicle, newState)
end)

-- Prevenir que el jugador entre a vehículos bloqueados sin llaves
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then -- Solo conductor
        local isLocked = getVehicleLocked(vehicle)
        if isLocked then
            -- Verificar si tiene las llaves en el servidor
            triggerServerEvent("vehicle:checkKeyForEnter", localPlayer, vehicle)
        end
    end
end)

-- Evento para recibir resultado de verificación al entrar
addEvent("vehicle:enterCheckResult", true)
addEventHandler("vehicle:enterCheckResult", root, function(canEnter)
    if not canEnter then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if vehicle then
            removePedFromVehicle(localPlayer)
            outputChatBox("Este vehículo está bloqueado y no tienes las llaves.", 255, 0, 0)
        end
    end
end)

-- Evento para reproducir sonido de bloqueo/desbloqueo
addEvent("vehicle:playLockSound", true)
addEventHandler("vehicle:playLockSound", root, function(x, y, z)
    -- Siempre reproducir sonido del juego primero (más confiable)
    playSoundFrontEnd(40)
    
    -- Intentar reproducir el sonido personalizado también
    local sound = nil
    -- La ruta debe ser relativa al recurso (sin "client/")
    local soundPath = "assents/sound/block-desblock.mp3"
    
    if x and y and z then
        -- Reproducir sonido 3D en la posición del vehículo
        sound = playSound3D(soundPath, x, y, z, false)
        if sound and isElement(sound) then
            setSoundVolume(sound, 0.7)
            setSoundMaxDistance(sound, 30)
            setSoundMinDistance(sound, 5)
        else
            -- Si falla el sonido 3D, intentar sonido local
            sound = playSound(soundPath, false)
            if sound and isElement(sound) then
                setSoundVolume(sound, 0.7)
            end
        end
    else
        -- Si no hay posición, reproducir sonido local
        sound = playSound(soundPath, false)
        if sound and isElement(sound) then
            setSoundVolume(sound, 0.7)
        end
    end
end)
