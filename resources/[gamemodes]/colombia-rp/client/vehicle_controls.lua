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
    
    -- Verificar llaves en el servidor
    triggerServerEvent("vehicle:toggleEngine", localPlayer, vehicle, nil)
end)

-- Control K: Bloquear/Desbloquear puertas
bindKey("k", "down", function()
    if not vehicleControlsEnabled then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then
        -- Verificar si hay un vehículo cerca
        local px, py, pz = getElementPosition(localPlayer)
        local nearbyVehicle = nil
        local minDistance = 5.0
        
        for _, veh in ipairs(getElementsByType("vehicle")) do
            local vx, vy, vz = getElementPosition(veh)
            local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
            if distance < minDistance then
                nearbyVehicle = veh
                minDistance = distance
            end
        end
        
        if nearbyVehicle then
            vehicle = nearbyVehicle
        else
            return
        end
    end
    
    -- Verificar llaves en el servidor
    local isLocked = getVehicleLocked(vehicle)
    triggerServerEvent("vehicle:toggleLock", localPlayer, vehicle, not isLocked)
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
