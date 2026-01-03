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
    if not vehicleControlsEnabled then 
        return 
    end
    
    -- Primero verificar si está dentro de un vehículo
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    -- Si no está en un vehículo, buscar el más cercano
    if not vehicle then
        local px, py, pz = getElementPosition(localPlayer)
        local nearbyVehicle = nil
        local minDistance = 10.0 -- Aumentado a 10 metros para mejor detección
        
        -- Buscar todos los vehículos cercanos
        for _, veh in ipairs(getElementsByType("vehicle")) do
            -- Verificar que sea un vehículo válido
            if isElement(veh) then
                -- Verificar que sea un vehículo del sistema (tiene matrícula o dueño)
                local plate = getElementData(veh, "vehicle:plate")
                local ownerId = getElementData(veh, "vehicle:owner_id")
                
                -- También aceptar vehículos que tengan matrícula visible (getVehiclePlateText)
                -- Esto ayuda con vehículos creados antes del sistema o sin elementData
                if not plate then
                    plate = getVehiclePlateText(veh)
                    -- Si tiene matrícula visible, considerarlo como vehículo del sistema
                    if plate and plate ~= "" and plate ~= " " then
                        -- Usar este vehículo aunque no tenga elementData
                    end
                end
                
                -- Si tiene matrícula (de elementData o visible) o dueño, considerarlo
                if (plate and plate ~= "" and plate ~= " ") or ownerId then
                    local vx, vy, vz = getElementPosition(veh)
                    local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
                    if distance < minDistance then
                        nearbyVehicle = veh
                        minDistance = distance
                    end
                end
            end
        end
        
        if nearbyVehicle then
            vehicle = nearbyVehicle
        else
            -- No hay vehículo cerca, mostrar mensaje de ayuda
            outputChatBox("No hay ningún vehículo cerca (máximo 10 metros).", 255, 255, 0)
            return
        end
    end
    
    if not vehicle or not isElement(vehicle) then
        return
    end
    
    -- Obtener estado actual del bloqueo
    local isLocked = getVehicleLocked(vehicle)
    local newState = not isLocked
    
    -- Enviar al servidor para verificar llaves y cambiar estado
    triggerServerEvent("vehicle:toggleLock", localPlayer, vehicle, newState)
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
    -- Probar diferentes formatos y rutas (WAV primero porque es más compatible)
    local sound = nil
    local soundPaths = {
        "client/assents/sound/block-desblock.wav",  -- WAV con ruta completa (más compatible)
        "assents/sound/block-desblock.wav",         -- WAV sin client/
        "client/assents/sound/block-desblock.mp3",  -- MP3 con ruta completa
        "assents/sound/block-desblock.mp3"          -- MP3 sin client/
    }
    
    local soundPlayed = false
    
    if x and y and z then
        -- Intentar reproducir sonido 3D en la posición del vehículo
        for _, soundPath in ipairs(soundPaths) do
            sound = playSound3D(soundPath, x, y, z, false)
            if sound and isElement(sound) then
                setSoundVolume(sound, 0.7)
                setSoundMaxDistance(sound, 30)
                setSoundMinDistance(sound, 5)
                soundPlayed = true
                break
            end
        end
        
        -- Si falla el sonido 3D, intentar sonido local
        if not soundPlayed then
            for _, soundPath in ipairs(soundPaths) do
                sound = playSound(soundPath, false)
                if sound and isElement(sound) then
                    setSoundVolume(sound, 0.7)
                    soundPlayed = true
                    break
                end
            end
        end
    else
        -- Si no hay posición, reproducir sonido local
        for _, soundPath in ipairs(soundPaths) do
            sound = playSound(soundPath, false)
            if sound and isElement(sound) then
                setSoundVolume(sound, 0.7)
                soundPlayed = true
                break
            end
        end
    end
    
    -- Si ningún formato funcionó, solo usar el sonido del juego (ya reproducido arriba)
end)
