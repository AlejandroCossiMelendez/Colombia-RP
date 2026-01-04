-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'carro.txd' ) 
engineImportTXD( txd, 410 ) 
dff = engineLoadDFF('carro.dff', 410) 
engineReplaceModel( dff, 410 )
end)

-- ============================================
-- SISTEMA DE ASIENTOS PERSONALIZADOS PARA CHIVA RUMBERA
-- Usa attachElements en lugar de asientos nativos del vehículo
-- ============================================

local CHIVA_MODEL = 410  -- Modelo de la chiva

-- Configuración de asientos personalizados con offsets LOCALES del vehículo
-- offsetX: distancia hacia adelante/atrás desde el centro (positivo = adelante, negativo = atrás)
-- offsetY: distancia hacia izquierda/derecha desde el centro (negativo = izquierda, positivo = derecha)
-- offsetZ: altura desde el suelo del vehículo (para estar "arriba")
-- IMPORTANTE: Estos son offsets LOCALES, no coordenadas del mundo. attachElements los maneja automáticamente.
local CHIVA_SEATS_CONFIG = {
    -- Lado Izquierdo - Asientos 2, 3, 4, 5
    {seat = 2, name = "Izquierda - Asiento 1", side = "left", offsetX = 1.0, offsetY = -1.4, offsetZ = 0.6},
    {seat = 3, name = "Izquierda - Asiento 2", side = "left", offsetX = 1.9, offsetY = -1.4, offsetZ = 0.6},
    {seat = 4, name = "Izquierda - Asiento 3", side = "left", offsetX = 2.8, offsetY = -1.4, offsetZ = 0.6},
    {seat = 5, name = "Izquierda - Asiento 4", side = "left", offsetX = 3.7, offsetY = -1.4, offsetZ = 0.6},
    
    -- Lado Derecho - Asientos 6, 7, 8, 9
    {seat = 6, name = "Derecha - Asiento 1", side = "right", offsetX = -0.5, offsetY = 1.4, offsetZ = 0.6},
    {seat = 7, name = "Derecha - Asiento 2", side = "right", offsetX = -0.5, offsetY = 1.4, offsetZ = 0.6},  -- Movido hacia atrás
    {seat = 8, name = "Derecha - Asiento 3", side = "right", offsetX = 2.8, offsetY = 1.4, offsetZ = 0.6},
    {seat = 9, name = "Derecha - Asiento 4", side = "right", offsetX = 3.7, offsetY = 1.4, offsetZ = 0.6},
}


-- Tabla para rastrear qué jugadores están en qué asientos personalizados
local chivaPassengers = {}  -- [vehicle] = {[seat] = player}
-- Tabla para almacenar offsets de pasajeros montados (para actualización continua)
local chivaPassengerOffsets = {}  -- [player] = {vehicle = vehicle, seat = seat, offsetX = x, offsetY = y, offsetZ = z}

-- Función para verificar si un jugador está montado en una chiva
local function isPlayerMountedInChiva(player)
    for vehicle, seats in pairs(chivaPassengers) do
        if isElement(vehicle) then
            for seat, passenger in pairs(seats) do
                if passenger == player then
                    return true, vehicle, seat
                end
            end
        end
    end
    return false, nil, nil
end

-- Función para detectar la puerta más cercana y el asiento correspondiente
local function detectNearestDoorAndSeat(player, vehicle)
    if not player or not vehicle or not isElement(player) or not isElement(vehicle) then
        return nil, nil
    end
    
    local px, py, pz = getElementPosition(player)
    local vx, vy, vz = getElementPosition(vehicle)
    local vrx, vry, vrz = getElementRotation(vehicle)
    
    local minDistance = math.huge
    local nearestSeat = nil
    local nearestSide = nil
    
    local angle = math.rad(vrz)
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)
    
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local offsetX = seatConfig.offsetX
        local offsetY = seatConfig.offsetY
        
        local rotatedX = offsetX * cosAngle - offsetY * sinAngle
        local rotatedY = offsetX * sinAngle + offsetY * cosAngle
        
        local doorWorldX = vx + rotatedX
        local doorWorldY = vy + rotatedY
        
        local distance = math.sqrt((px - doorWorldX)^2 + (py - doorWorldY)^2)
        
        if distance < minDistance then
            minDistance = distance
            nearestSeat = seatConfig.seat
            nearestSide = seatConfig.side
        end
    end
    
    if minDistance > 5.0 then
        local dx = px - vx
        local dy = py - vy
        local playerAngle = math.rad(-vrz)
        local rotatedX = dx * math.cos(playerAngle) - dy * math.sin(playerAngle)
        
        if rotatedX > 0 then
            nearestSide = "right"
        else
            nearestSide = "left"
        end
        nearestSeat = nil
    end
    
    return nearestSide, nearestSeat
end

-- Función para obtener el siguiente asiento disponible en un lado específico
local function getNextAvailableSeat(vehicle, preferredSide, preferredSeat)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return nil
    end
    
    -- Inicializar tabla de pasajeros si no existe
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    -- Si hay un asiento preferido específico, intentar usarlo primero
    if preferredSeat and preferredSeat >= 2 and preferredSeat <= 9 then
        if not chivaPassengers[vehicle][preferredSeat] then
            return preferredSeat
        end
    end
    
    -- Primero buscar en el lado preferido
    if preferredSide then
        for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
            local seat = seatConfig.seat
            if seatConfig.side == preferredSide and not chivaPassengers[vehicle][seat] then
                return seat
            end
        end
    end
    
    -- Si no hay disponibles en el lado preferido, buscar en cualquier lado
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local seat = seatConfig.seat
        if not chivaPassengers[vehicle][seat] then
            return seat
        end
    end
    
    return nil
end

-- Función para verificar si el jugador está cerca de una chiva
local function getNearbyChiva(player, maxDistance)
    maxDistance = maxDistance or 3.5
    local px, py, pz = getElementPosition(player)
    
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementModel(vehicle) == CHIVA_MODEL then
            local vx, vy, vz = getElementPosition(vehicle)
            local vrx, vry, vrz = getElementRotation(vehicle)
            
            local angle = math.rad(vrz)
            local cosAngle = math.cos(angle)
            local sinAngle = math.sin(angle)
            
            for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
                local offsetX = seatConfig.offsetX
                local offsetY = seatConfig.offsetY
                
                local rotatedX = offsetX * cosAngle - offsetY * sinAngle
                local rotatedY = offsetX * sinAngle + offsetY * cosAngle
                
                local doorWorldX = vx + rotatedX
                local doorWorldY = vy + rotatedY
                
                local distance = math.sqrt((px - doorWorldX)^2 + (py - doorWorldY)^2)
                
                if distance <= maxDistance then
                    return vehicle
                end
            end
            
            local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
            if distance <= maxDistance + 2.0 then
                return vehicle
            end
        end
    end
    
    return nil
end

-- Función para montar al jugador en la chiva usando asientos personalizados
local function mountPlayerInChiva(player, vehicle, seat)
    if not vehicle or not isElement(vehicle) then
        return false
    end
    
    -- Verificar que el jugador no esté ya en un vehículo
    if getPedOccupiedVehicle(player) then
        outputChatBox("Ya estás en un vehículo. Bájate primero.", 255, 255, 0)
        return false
    end
    
    -- Inicializar tabla de pasajeros si no existe
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    -- Si no se especifica asiento, detectar la puerta más cercana
    if not seat then
        local playerSide, preferredSeat = detectNearestDoorAndSeat(player, vehicle)
        seat = getNextAvailableSeat(vehicle, playerSide, preferredSeat)
        
        if not seat then
            outputChatBox("La chiva está llena. No hay asientos disponibles.", 255, 255, 0)
            return false
        end
    end
    
    -- Verificar que el asiento esté disponible
    if chivaPassengers[vehicle][seat] then
        outputChatBox("Este asiento está ocupado.", 255, 0, 0)
        return false
    end
    
    -- Obtener la configuración del asiento
    local seatConfig = nil
    local seatSide = nil
    for _, config in ipairs(CHIVA_SEATS_CONFIG) do
        if config.seat == seat then
            seatConfig = config
            seatSide = config.side
            break
        end
    end
    
    if not seatConfig then
        outputChatBox("Error: Configuración de asiento no encontrada.", 255, 0, 0)
        return false
    end
    
    -- Determinar qué animación usar según el lado
    local openAnim = "CAR_open_LHS"
    local sitAnim = "CAR_pullout_LHS"
    
    if seatSide == "right" then
        openAnim = "CAR_open_RHS"
        sitAnim = "CAR_pullout_RHS"
    end
    
    -- Congelar controles durante la animación
    toggleControl(player, "forwards", false)
    toggleControl(player, "backwards", false)
    toggleControl(player, "left", false)
    toggleControl(player, "right", false)
    toggleControl(player, "sprint", false)
    toggleControl(player, "jump", false)
    
    -- Función para restaurar controles
    local function restoreControls()
        if isElement(player) then
            toggleControl(player, "forwards", true)
            toggleControl(player, "backwards", true)
            toggleControl(player, "left", true)
            toggleControl(player, "right", true)
            toggleControl(player, "sprint", true)
            toggleControl(player, "jump", true)
        end
    end
    
    -- Reproducir animación de abrir puerta
    setPedAnimation(player, "ped", openAnim, 1000, false, false, false, false)
    
    -- Después de abrir la puerta, animación de sentarse
    setTimer(function()
        if not isElement(player) or not isElement(vehicle) then
            restoreControls()
            return
        end
        
        -- Verificar distancia
        local px, py, pz = getElementPosition(player)
        local vx, vy, vz = getElementPosition(vehicle)
        local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
        
        if distance > 8.0 then
            outputChatBox("Te alejaste demasiado de la chiva.", 255, 255, 0)
            restoreControls()
            setPedAnimation(player, nil)
            return
        end
        
        -- Animación de sentarse
        setPedAnimation(player, "ped", sitAnim, 1500, false, false, false, false)
        
        -- Después de la animación, montar al jugador
        setTimer(function()
            if not isElement(player) or not isElement(vehicle) then
                restoreControls()
                return
            end
            
            -- Verificar distancia nuevamente
            local px2, py2, pz2 = getElementPosition(player)
            local vx2, vy2, vz2 = getElementPosition(vehicle)
            local distance2 = getDistanceBetweenPoints3D(px2, py2, pz2, vx2, vy2, vz2)
            
            if distance2 > 8.0 then
                outputChatBox("Te alejaste demasiado de la chiva.", 255, 255, 0)
                restoreControls()
                setPedAnimation(player, nil)
                return
            end
            
            -- Detener animación
            setPedAnimation(player, nil)
            
            -- Restaurar controles
            restoreControls()
            
            -- Enviar al servidor para montar usando attachElements
            triggerServerEvent("chiva:requestMount", player, vehicle, seat, seatConfig.offsetX, seatConfig.offsetY, seatConfig.offsetZ)
        end, 1500, 1)
    end, 1000, 1)
    
    return true
end

-- BindKey para presionar G y montarse
bindKey("g", "down", function()
    local player = localPlayer
    
    -- Verificar si ya está en un vehículo
    if getPedOccupiedVehicle(player) then
        return
    end
    
    -- Verificar si ya está en una chiva (asiento personalizado)
    local isMounted, mountedVehicle, mountedSeat = isPlayerMountedInChiva(player)
    if isMounted then
        -- Ya está montado, no hacer nada
        return
    end
    
    -- Buscar chiva cercana
    local chiva = getNearbyChiva(player, 3.5)
    if chiva then
        mountPlayerInChiva(player, chiva)
    else
        outputChatBox("Acércate a una chiva y presiona G para montarte.", 255, 255, 0)
    end
end)

-- BindKey para bajarse (F por ejemplo)
bindKey("f", "down", function()
    local player = localPlayer
    
    -- Buscar si el jugador está en alguna chiva
    local isMounted, mountedVehicle, mountedSeat = isPlayerMountedInChiva(player)
    if isMounted then
        triggerServerEvent("chiva:requestDismount", player, mountedVehicle, mountedSeat)
    end
end)

-- Evento para recibir confirmación del servidor después de montar
addEvent("chiva:mounted", true)
addEventHandler("chiva:mounted", root, function(vehicle, seat, success)
    if success then
        local player = localPlayer
        if not chivaPassengers[vehicle] then
            chivaPassengers[vehicle] = {}
        end
        chivaPassengers[vehicle][seat] = player
        outputChatBox("Te has montado en la chiva (Asiento " .. seat .. "). Presiona F para bajarte.", 0, 255, 0)
    else
        outputChatBox("Error al montarte en la chiva.", 255, 0, 0)
    end
end)

-- Evento para recibir confirmación del servidor después de bajarse
addEvent("chiva:dismounted", true)
addEventHandler("chiva:dismounted", root, function(vehicle, seat)
    local player = localPlayer
    if chivaPassengers[vehicle] and chivaPassengers[vehicle][seat] == player then
        chivaPassengers[vehicle][seat] = nil
        outputChatBox("Te has bajado de la chiva.", 0, 255, 0)
    end
end)

-- Evento para sincronizar animación cuando otro jugador se monta
addEvent("chiva:playerMounted", true)
addEventHandler("chiva:playerMounted", root, function(player, vehicle, seat, offsetX, offsetY, offsetZ)
    if isElement(player) and isElement(vehicle) then
        -- Reproducir animación de sentado para todos los clientes
        setPedAnimation(player, "ped", "CAR_sit", -1, true, false, false, false)
        
        -- Registrar offsets para actualización continua
        chivaPassengerOffsets[player] = {
            vehicle = vehicle,
            seat = seat,
            offsetX = offsetX,
            offsetY = offsetY,
            offsetZ = offsetZ
        }
    end
end)

-- Evento para sincronizar animación cuando otro jugador se baja
addEvent("chiva:playerDismounted", true)
addEventHandler("chiva:playerDismounted", root, function(player, vehicle, seat)
    if isElement(player) then
        -- Detener animación de sentado
        setPedAnimation(player, nil)
        
        -- Remover de la tabla de offsets
        chivaPassengerOffsets[player] = nil
    end
end)

-- 🔥 SISTEMA DE ACTUALIZACIÓN CONTINUA (similar a bone_attach)
-- Actualiza la posición de los jugadores montados en cada frame
function updateChivaPassengersPosition()
    for player, data in pairs(chivaPassengerOffsets) do
        if isElement(player) and isElement(data.vehicle) then
            -- Obtener posición y rotación del vehículo
            local vx, vy, vz = getElementPosition(data.vehicle)
            local vrx, vry, vrz = getElementRotation(data.vehicle)
            
            -- Convertir rotación a radianes
            local angle = math.rad(vrz)
            local cosAngle = math.cos(angle)
            local sinAngle = math.sin(angle)
            
            -- Rotar los offsets según la rotación del vehículo
            -- offsetX es hacia adelante/atrás, offsetY es hacia izquierda/derecha
            local rotatedX = data.offsetX * cosAngle - data.offsetY * sinAngle
            local rotatedY = data.offsetX * sinAngle + data.offsetY * cosAngle
            
            -- Calcular posición mundial del asiento
            local seatX = vx + rotatedX
            local seatY = vy + rotatedY
            local seatZ = vz + data.offsetZ
            
            -- Actualizar posición del jugador
            setElementPosition(player, seatX, seatY, seatZ)
            
            -- Hacer que el jugador mire en la dirección del vehículo
            setPedRotation(player, vrz)
            
            -- Sincronizar interior y dimensión
            local vehicleInt = getElementInterior(data.vehicle)
            if vehicleInt ~= getElementInterior(player) then
                setElementInterior(player, vehicleInt)
            end
            
            local vehicleDim = getElementDimension(data.vehicle)
            if vehicleDim ~= getElementDimension(player) then
                setElementDimension(player, vehicleDim)
            end
        else
            -- Limpiar si el elemento ya no existe
            chivaPassengerOffsets[player] = nil
        end
    end
end

-- Iniciar el sistema de actualización continua
addEventHandler("onClientResourceStart", resourceRoot, function()
    addEventHandler("onClientPreRender", root, updateChivaPassengersPosition)
end)

-- Limpiar cuando el recurso se detiene
addEventHandler("onClientResourceStop", resourceRoot, function()
    removeEventHandler("onClientPreRender", root, updateChivaPassengersPosition)
end)

-- Limpiar tabla cuando el vehículo se destruye
addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "vehicle" and getElementModel(source) == CHIVA_MODEL then
        chivaPassengers[source] = nil
    end
end)

-- Función exportable para montar pasajeros mediante código
function mountPassenger(player, vehicle, seat)
    if not player or not isElement(player) then
        return false
    end
    
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return false
    end
    
    local seatConfig = nil
    for _, config in ipairs(CHIVA_SEATS_CONFIG) do
        if config.seat == seat then
            seatConfig = config
            break
        end
    end
    
    if not seatConfig then
        return false
    end
    
    triggerServerEvent("chiva:requestMount", player, vehicle, seat, seatConfig.offsetX, seatConfig.offsetY, seatConfig.offsetZ)
    return true
end

-- Función para obtener información de los asientos
function getChivaSeatsInfo(vehicle)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return nil
    end
    
    local seatsInfo = {}
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local occupant = chivaPassengers[vehicle][seatConfig.seat]
        table.insert(seatsInfo, {
            seat = seatConfig.seat,
            name = seatConfig.name,
            occupied = occupant ~= nil,
            occupant = occupant
        })
    end
    
    return seatsInfo
end

-- Función para obtener el número de asientos disponibles
function getAvailableSeatsCount(vehicle)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return 0
    end
    
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    local count = 0
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        if not chivaPassengers[vehicle][seatConfig.seat] then
            count = count + 1
        end
    end
    
    return count
end
