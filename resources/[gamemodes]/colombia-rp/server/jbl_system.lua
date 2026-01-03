-- Sistema JBL - Servidor
-- Maneja la activación del JBL y la reproducción de música

local activeJBLs = {} -- {player = {object = element, x, y, z, music = url, volume = 0.5}}
local vehicleMusic = {} -- {vehicle = {music = url, volume = 0.5, owner = player}} - Música por vehículo
local jblModel = 2226 -- ID del modelo JBL

-- Función para obtener el modelo JBL
function getJBLModel()
    return jblModel
end

-- Activar JBL
addEvent("jbl:activate", true)
addEventHandler("jbl:activate", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    -- Verificar si ya tiene un JBL activo
    if activeJBLs[player] then
        outputChatBox("Ya tienes un JBL activo.", player, 255, 0, 0)
        return
    end
    
    -- Crear objeto JBL y adjuntarlo a la mano del jugador
    local x, y, z = getElementPosition(player)
    local jblObject = createObject(jblModel, x, y, z)
    
    if not jblObject then
        outputChatBox("Error al crear el JBL.", player, 255, 0, 0)
        return
    end
    
    -- Hacer el parlante más pequeño (70% del tamaño original)
    setObjectScale(jblObject, 0.7)
    
    -- Adjuntar a la mano derecha (bone 12 - right hand según functions.txt)
    -- Verificar si bone_attach está disponible
    local boneAttachResource = getResourceFromName("bone_attach")
    if boneAttachResource and getResourceState(boneAttachResource) == "running" then
        if exports.bone_attach then
            -- Ajustar posición para que se vea bien en la mano
            -- Bone 12 = mano derecha (right hand)
            -- Offset: x (lateral derecho - más a la derecha), y (adelante), z (arriba)
            -- Rotación: rx (pitch), ry (yaw), rz (roll)
            -- Valores ajustados: más pequeño, girado y más a la derecha
            exports.bone_attach:attachElementToBone(jblObject, player, 12, 0.25, 0.08, 0.0, 0, 45, 0)
        end
    else
        -- Si bone_attach no está disponible, adjuntar usando attachElements
        -- Ajustar posición relativa para la mano (lado derecho del jugador)
        -- Más a la derecha, girado 45 grados en Y
        attachElements(jblObject, player, 0.25, 0.08, 0.0, 0, 45, 0)
    end
    
    activeJBLs[player] = {
        object = jblObject,
        x = x,
        y = y,
        z = z,
        music = nil,
        volume = 0.5
    }
    
    triggerClientEvent(player, "jbl:activated", resourceRoot)
    outputChatBox("JBL activado. Usa F6 para controlar la música.", player, 0, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " activó su JBL")
end)

-- Desactivar JBL
addEvent("jbl:deactivate", true)
addEventHandler("jbl:deactivate", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    -- Detener música si está reproduciendo
    if jblData.music then
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
    end
    
    -- Destruir objeto
    if isElement(jblData.object) then
        -- Desadjuntar
        local boneAttachResource = getResourceFromName("bone_attach")
        if boneAttachResource and getResourceState(boneAttachResource) == "running" then
            if exports.bone_attach then
                exports.bone_attach:detachElementFromBone(jblData.object)
            end
        end
        -- Siempre intentar detachElements también por si acaso
        if isElement(jblData.object) then
            detachElements(jblData.object, player)
        end
        destroyElement(jblData.object)
    end
    
    activeJBLs[player] = nil
    triggerClientEvent(player, "jbl:deactivated", resourceRoot)
    outputChatBox("JBL desactivado.", player, 255, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " desactivó su JBL")
end)

-- Reproducir música desde link (sistema mejorado - URLs directas)
addEvent("jbl:playFromLink", true)
addEventHandler("jbl:playFromLink", root, function(url)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    if not url or url == "" then
        outputChatBox("Por favor ingresa un link válido.", player, 255, 0, 0)
        return
    end
    
    -- Verificar si el jugador está en un vehículo
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        -- Sistema de música en vehículo (cualquier pasajero puede controlar)
        -- Detener música anterior si existe
        if vehicleMusic[vehicle] and vehicleMusic[vehicle].music then
            triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot, vehicle)
        end
        
        -- Almacenar música en el vehículo
        vehicleMusic[vehicle] = {
            music = url,
            volume = 0.5,
            owner = player
        }
        
        -- Reproducir música en el vehículo
        triggerClientEvent(getRootElement(), "jbl:ReproducirCliente", root, url, vehicle)
        
        outputChatBox("Reproduciendo música en el vehículo...", player, 0, 255, 0)
        outputServerLog("[JBL] " .. getPlayerName(player) .. " está reproduciendo música en vehículo desde link: " .. url)
        return
    end
    
    -- Sistema normal de JBL portátil (solo si tiene JBL activo)
    local jblData = activeJBLs[player]
    if not jblData then
        outputChatBox("Primero debes activar el JBL o subirte a un vehículo.", player, 255, 0, 0)
        return
    end
    
    -- Detener música anterior si existe
    if jblData.music then
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
    end
    
    -- Obtener objeto JBL
    local jblObject = jblData.object
    
    -- Reproducir directamente desde la URL (debe ser una URL de audio válida: .mp3, .ogg, etc.)
    jblData.music = url
    triggerClientEvent(getRootElement(), "jbl:ReproducirCliente", root, url, jblObject)
    
    outputChatBox("Reproduciendo música desde link...", player, 0, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " está reproduciendo música desde link: " .. url)
end)

-- Evento para parar música (compatibilidad con sistema mejorado)
addEvent("jbl:PararServer", true)
addEventHandler("jbl:PararServer", root, function(ent)
    local player = source
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if jblData and jblData.music then
        jblData.music = nil
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
        outputChatBox("Música detenida.", player, 255, 255, 0)
    end
end)

-- Reproducir música desde Spotify
addEvent("jbl:playFromSpotify", true)
addEventHandler("jbl:playFromSpotify", root, function(trackUrl, trackName)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        outputChatBox("Primero debes activar el JBL.", player, 255, 0, 0)
        return
    end
    
    -- Detener música anterior si existe
    if jblData.music then
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
    end
    
    -- Obtener posición del JBL
    local x, y, z = getElementPosition(jblData.object)
    
    -- Reproducir nueva música
    jblData.music = trackUrl
    triggerClientEvent(getRootElement(), "jbl:musicStarted", resourceRoot, trackUrl, x, y, z, jblData.object)
    
    outputChatBox("Reproduciendo: " .. (trackName or "Música"), player, 0, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " está reproduciendo música desde Spotify")
end)

-- Cambiar volumen
addEvent("jbl:setVolume", true)
addEventHandler("jbl:setVolume", root, function(volume)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    volume = math.max(0, math.min(1, tonumber(volume) or 0.5))
    jblData.volume = volume
    
    triggerClientEvent(getRootElement(), "jbl:volumeChanged", resourceRoot, volume)
end)

-- Detener música
addEvent("jbl:stopMusic", true)
addEventHandler("jbl:stopMusic", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    -- Verificar si el jugador está en un vehículo
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        -- Detener música del vehículo (cualquier pasajero puede detener)
        if vehicleMusic[vehicle] and vehicleMusic[vehicle].music then
            vehicleMusic[vehicle].music = nil
            triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot, vehicle)
            outputChatBox("Música del vehículo detenida.", player, 255, 255, 0)
        end
        return
    end
    
    -- Sistema normal de JBL portátil
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    if jblData.music then
        jblData.music = nil
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
        outputChatBox("Música detenida.", player, 255, 255, 0)
    end
end)

-- Limpiar cuando el jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    local player = source
    if activeJBLs[player] then
        local jblData = activeJBLs[player]
        if jblData.music then
            triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
        end
        if isElement(jblData.object) then
            if exports.bone_attach then
                exports.bone_attach:detachElementFromBone(jblData.object)
            end
            destroyElement(jblData.object)
        end
        activeJBLs[player] = nil
    end
end)

-- Limpiar música del vehículo cuando se destruye
addEventHandler("onVehicleDestroy", root, function()
    if vehicleMusic[source] then
        if vehicleMusic[source].music then
            triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot, source)
        end
        vehicleMusic[source] = nil
    end
end)

-- Limpiar música del vehículo cuando todos los pasajeros se bajan
addEventHandler("onVehicleExit", root, function(player, seat)
    local vehicle = source
    if vehicleMusic[vehicle] then
        -- Verificar si hay otros pasajeros
        local hasPassengers = false
        for seatNum = 0, getVehicleMaxPassengers(vehicle) do
            if getVehicleOccupant(vehicle, seatNum) then
                hasPassengers = true
                break
            end
        end
        -- Si no hay pasajeros, detener música
        if not hasPassengers then
            if vehicleMusic[vehicle].music then
                triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot, vehicle)
            end
            vehicleMusic[vehicle] = nil
        end
    end
end)

