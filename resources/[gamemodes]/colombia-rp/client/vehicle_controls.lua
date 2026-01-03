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

-- Variable para almacenar las llaves del jugador
local playerVehicleKeys = {}
local keysRequested = false

-- Evento para recibir las llaves del servidor
addEvent("vehicle:receiveKeys", true)
addEventHandler("vehicle:receiveKeys", root, function(keys)
    playerVehicleKeys = keys or {}
    keysRequested = true
end)

-- Función para buscar vehículo cercano con llaves
local function findNearbyVehicleWithKeys()
    local px, py, pz = getElementPosition(localPlayer)
    local nearbyVehicle = nil
    local minDistance = 10.0 -- Distancia máxima de 10 metros
    
    -- Buscar vehículos cercanos que coincidan con las llaves
    for _, veh in ipairs(getElementsByType("vehicle")) do
        if isElement(veh) then
            -- Obtener matrícula del vehículo
            local plate = getElementData(veh, "vehicle:plate")
            if not plate then
                plate = getVehiclePlateText(veh)
            end
            
            -- Verificar si tiene matrícula válida
            if plate and plate ~= "" and plate ~= " " then
                -- Normalizar la matrícula (quitar espacios y convertir a string)
                plate = tostring(plate):gsub("%s+", "")
                
                -- Verificar si tenemos la llave de este vehículo
                local hasKey = false
                for _, keyPlate in ipairs(playerVehicleKeys) do
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
    
    return nearbyVehicle
end

-- Control K: Bloquear/Desbloquear puertas
bindKey("k", "down", function()
    if not vehicleControlsEnabled then 
        return 
    end
    
    -- Primero verificar si está dentro de un vehículo
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle then
        -- Si está dentro de un vehículo, usar ese directamente
        local isLocked = getVehicleLocked(vehicle)
        local newState = not isLocked
        triggerServerEvent("vehicle:toggleLock", localPlayer, vehicle, newState)
    else
        -- Si no está en un vehículo, pedirle al servidor que busque uno cercano con llaves
        -- El servidor hará toda la validación y búsqueda
        triggerServerEvent("vehicle:toggleLockNearby", localPlayer)
    end
end)

-- Cargar llaves cuando el jugador entra al juego o cuando se actualiza el inventario
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Solicitar llaves al iniciar
    setTimer(function()
        triggerServerEvent("vehicle:requestKeys", localPlayer)
    end, 2000, 1) -- Esperar 2 segundos para que el personaje esté cargado
end)

-- Actualizar llaves cuando se actualiza el inventario
addEventHandler("syncItems", root, function()
    -- Solicitar llaves actualizadas cuando se sincronizan los items
    setTimer(function()
        triggerServerEvent("vehicle:requestKeys", localPlayer)
    end, 500, 1)
end)

-- Control L: Prender/Apagar luces
bindKey("l", "down", function()
    if not vehicleControlsEnabled then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
        return
    end
    
    -- Obtener estado actual de las luces
    local lightsState = getVehicleOverrideLights(vehicle)
    local newState = (lightsState == 2) and 0 or 2
    
    -- Cambiar las luces inmediatamente en el cliente
    setVehicleOverrideLights(vehicle, newState)
    
    -- Enviar al servidor para verificar llaves y actualizar en BD
    triggerServerEvent("vehicle:toggleLights", localPlayer, vehicle, newState)
end)

-- Control N: Freno de mano (Handbrake)
bindKey("n", "down", function()
    if not vehicleControlsEnabled then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
        return
    end
    
    -- Obtener estado actual del freno de mano
    local handbrakeOn = getElementData(vehicle, "vehicle:handbrake") or false
    local newState = not handbrakeOn
    
    -- Aplicar freno de mano inmediatamente
    setElementData(vehicle, "vehicle:handbrake", newState)
    
    if newState then
        -- Activar freno de mano: congelar el vehículo
        setElementFrozen(vehicle, true)
        outputChatBox("Freno de mano activado", 0, 255, 0)
    else
        -- Desactivar freno de mano
        setElementFrozen(vehicle, false)
        outputChatBox("Freno de mano desactivado", 0, 255, 0)
    end
    
    -- Enviar al servidor para actualizar en BD
    triggerServerEvent("vehicle:toggleHandbrake", localPlayer, vehicle, newState)
end)

-- Evento para sincronizar el estado de bloqueo desde el servidor
addEvent("vehicle:syncLockState", true)
addEventHandler("vehicle:syncLockState", root, function(vehicle, locked)
    if vehicle and isElement(vehicle) then
        setVehicleLocked(vehicle, locked)
    end
end)

-- Prevenir que los jugadores salgan del vehículo si está bloqueado
addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
    if vehicle and isElement(vehicle) then
        -- Verificar tanto getVehicleLocked como elementData para mayor confiabilidad
        local isLocked = getVehicleLocked(vehicle) or (getElementData(vehicle, "vehicle:locked") == true)
        if isLocked then
            -- Cancelar la salida
            cancelEvent()
            outputChatBox("El vehículo está bloqueado. Desbloquéalo con K para salir.", 255, 0, 0)
            -- Forzar al jugador a quedarse en el vehículo
            setTimer(function()
                if vehicle and isElement(vehicle) and getPedOccupiedVehicle(localPlayer) ~= vehicle then
                    warpPedIntoVehicle(localPlayer, vehicle, seat)
                end
            end, 50, 1)
        end
    end
end)

-- Evento para revertir luces si el servidor rechaza el cambio
addEvent("vehicle:revertLights", true)
addEventHandler("vehicle:revertLights", root, function(vehicle, state)
    if vehicle and isElement(vehicle) then
        setVehicleOverrideLights(vehicle, state)
    end
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
