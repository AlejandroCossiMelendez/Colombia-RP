-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'carro.txd' ) 
engineImportTXD( txd, 410 ) 
dff = engineLoadDFF('carro.dff', 410) 
engineReplaceModel( dff, 410 )
end)

-- ============================================
-- SISTEMA DE ASIENTOS PARA CHIVA RUMBERA
-- ============================================

local CHIVA_MODEL = 410  -- Modelo de la chiva

-- Configuración de asientos basada en offsets relativos al vehículo
-- Seat 0 = Conductor, Seat 1 = Copiloto
-- Seats 2-9 = Pasajeros
-- LADO IZQUIERDO: Asientos 2, 3, 4, 5 (fila izquierda)
-- LADO DERECHO: Asientos 6, 7, 8, 9 (fila derecha)

-- Separación promedio entre puertas: ~0.95 unidades GTA
-- Offsets calculados desde el centro del vehículo (basados en coordenadas de referencia)
-- Vehículo de referencia estaba en: X: 1230.75, Y: -1709.25

-- Posiciones relativas de las puertas desde el centro del vehículo
-- offsetX: distancia hacia adelante/atrás (negativo = atrás del centro)
-- offsetY: distancia hacia izquierda/derecha (negativo = izquierda, positivo = derecha)
local CHIVA_SEATS_CONFIG = {
    -- Lado Izquierdo - Asientos 2, 3, 4, 5
    -- Separación: ~0.95 unidades entre cada puerta
    {seat = 2, name = "Izquierda - Asiento 1", side = "left", offsetX = -9.85, offsetY = -6.40},  -- Más atrás
    {seat = 3, name = "Izquierda - Asiento 2", side = "left", offsetX = -8.49, offsetY = -6.20},
    {seat = 4, name = "Izquierda - Asiento 3", side = "left", offsetX = -7.55, offsetY = -6.20},
    {seat = 5, name = "Izquierda - Asiento 4", side = "left", offsetX = -6.74, offsetY = -6.30},  -- Más adelante
    
    -- Lado Derecho - Asientos 6, 7, 8, 9
    -- Separación: ~0.95 unidades entre cada puerta
    -- Copiloto referencia: offsetX = -9.36, offsetY = -2.99 (calculado desde coordenadas)
    -- Nota: offsetY positivo = derecha, negativo = izquierda (desde el centro del vehículo)
    {seat = 6, name = "Derecha - Asiento 1", side = "right", offsetX = -9.36, offsetY = -2.99},  -- Copiloto referencia
    {seat = 7, name = "Derecha - Asiento 2", side = "right", offsetX = -8.41, offsetY = -2.99},  -- +0.95 en X (más adelante)
    {seat = 8, name = "Derecha - Asiento 3", side = "right", offsetX = -7.46, offsetY = -2.99},  -- +0.95 en X
    {seat = 9, name = "Derecha - Asiento 4", side = "right", offsetX = -6.51, offsetY = -2.99},  -- +0.95 en X
}

-- Función para detectar la puerta más cercana y el asiento correspondiente
local function detectNearestDoorAndSeat(player, vehicle)
    if not player or not vehicle or not isElement(player) or not isElement(vehicle) then
        return nil, nil
    end
    
    local px, py, pz = getElementPosition(player)
    local vx, vy, vz = getElementPosition(vehicle)
    local vrx, vry, vrz = getElementRotation(vehicle)
    
    -- Calcular las posiciones de las puertas transformadas según la posición y rotación del vehículo
    local minDistance = math.huge
    local nearestSeat = nil
    local nearestSide = nil
    
    -- Ángulo de rotación en radianes
    local angle = math.rad(vrz)
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)
    
    -- Buscar la puerta más cercana
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        -- Transformar offset relativo a coordenadas del mundo según la rotación del vehículo
        local offsetX = seatConfig.offsetX
        local offsetY = seatConfig.offsetY
        
        -- Rotar el offset según la rotación del vehículo
        local rotatedX = offsetX * cosAngle - offsetY * sinAngle
        local rotatedY = offsetX * sinAngle + offsetY * cosAngle
        
        -- Calcular posición mundial de la puerta
        local doorWorldX = vx + rotatedX
        local doorWorldY = vy + rotatedY
        
        -- Calcular distancia desde el jugador a la puerta (solo X e Y, Z es similar)
        local distance = math.sqrt((px - doorWorldX)^2 + (py - doorWorldY)^2)
        
        if distance < minDistance then
            minDistance = distance
            nearestSeat = seatConfig.seat
            nearestSide = seatConfig.side
        end
    end
    
    -- Si la distancia es muy grande, usar método alternativo basado en posición relativa
    if minDistance > 5.0 then
        -- Método alternativo: usar posición relativa al vehículo
        local dx = px - vx
        local dy = py - vy
        
        -- Rotar el vector para que esté en el sistema de coordenadas del vehículo
        local playerAngle = math.rad(-vrz)
        local rotatedX = dx * math.cos(playerAngle) - dy * math.sin(playerAngle)
        
        -- Si rotatedX es positivo, está a la derecha del vehículo
        if rotatedX > 0 then
            nearestSide = "right"
        else
            nearestSide = "left"
        end
        nearestSeat = nil  -- Se asignará automáticamente
    end
    
    return nearestSide, nearestSeat
end

-- Función para obtener el siguiente asiento disponible en un lado específico
local function getNextAvailableSeat(vehicle, preferredSide, preferredSeat)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return nil
    end
    
    -- Obtener número máximo de pasajeros del vehículo
    local maxPassengers = getVehicleMaxPassengers(vehicle)
    
    -- Si hay un asiento preferido específico, intentar usarlo primero
    if preferredSeat then
        if preferredSeat <= maxPassengers then
            local occupant = getVehicleOccupant(vehicle, preferredSeat)
            if not occupant then
                return preferredSeat
            end
        end
    end
    
    -- Primero buscar en el lado preferido
    if preferredSide then
        for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
            local seat = seatConfig.seat
            -- Verificar que el asiento no exceda el máximo del vehículo
            if seat <= maxPassengers and seatConfig.side == preferredSide then
                local occupant = getVehicleOccupant(vehicle, seat)
                if not occupant then
                    return seat
                end
            end
        end
    end
    
    -- Si no hay disponibles en el lado preferido, buscar en cualquier lado
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local seat = seatConfig.seat
        -- Verificar que el asiento no exceda el máximo del vehículo
        if seat <= maxPassengers then
            local occupant = getVehicleOccupant(vehicle, seat)
            if not occupant then
                return seat
            end
        end
    end
    
    return nil  -- No hay asientos disponibles
end

-- Función para verificar si el jugador está cerca de una chiva (usando coordenadas de puertas transformadas)
local function getNearbyChiva(player, maxDistance)
    maxDistance = maxDistance or 3.5
    local px, py, pz = getElementPosition(player)
    
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementModel(vehicle) == CHIVA_MODEL then
            local vx, vy, vz = getElementPosition(vehicle)
            local vrx, vry, vrz = getElementRotation(vehicle)
            
            -- Ángulo de rotación en radianes
            local angle = math.rad(vrz)
            local cosAngle = math.cos(angle)
            local sinAngle = math.sin(angle)
            
            -- Verificar distancia a las puertas transformadas
            for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
                -- Transformar offset relativo a coordenadas del mundo
                local offsetX = seatConfig.offsetX
                local offsetY = seatConfig.offsetY
                
                -- Rotar el offset según la rotación del vehículo
                local rotatedX = offsetX * cosAngle - offsetY * sinAngle
                local rotatedY = offsetX * sinAngle + offsetY * cosAngle
                
                -- Calcular posición mundial de la puerta
                local doorWorldX = vx + rotatedX
                local doorWorldY = vy + rotatedY
                
                -- Calcular distancia desde el jugador a la puerta (solo X e Y)
                local distance = math.sqrt((px - doorWorldX)^2 + (py - doorWorldY)^2)
                
                if distance <= maxDistance then
                    return vehicle
                end
            end
            
            -- Fallback: verificar distancia general al vehículo
            local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
            if distance <= maxDistance + 2.0 then
                return vehicle
            end
        end
    end
    
    return nil
end

-- Función para montar al jugador en la chiva
local function mountPlayerInChiva(player, vehicle, seat)
    if not vehicle or not isElement(vehicle) then
        return false
    end
    
    -- Si no se especifica asiento, detectar la puerta más cercana y asignar asiento correspondiente
    if not seat then
        local playerSide, preferredSeat = detectNearestDoorAndSeat(player, vehicle)
        seat = getNextAvailableSeat(vehicle, playerSide, preferredSeat)
        
        if not seat then
            outputChatBox("La chiva está llena. No hay asientos disponibles.", player, 255, 255, 0)
            return false
        end
    end
    
    -- Verificar que el asiento esté disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    if occupant then
        outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
        return false
    end
    
    -- Enviar al servidor para montar al jugador (warpPedIntoVehicle es función del servidor)
    triggerServerEvent("chiva:requestMount", player, vehicle, seat)
    return true
end

-- BindKey para presionar G y montarse
bindKey("g", "down", function()
    local player = localPlayer
    
    -- Verificar si ya está en un vehículo
    if getPedOccupiedVehicle(player) then
        return
    end
    
    -- Buscar chiva cercana (especialmente de atrás)
    local chiva = getNearbyChiva(player, 3.5)
    if chiva then
        -- Montar al jugador en el siguiente asiento disponible
        mountPlayerInChiva(player, chiva)
    else
        -- Mostrar mensaje si no hay chiva cerca
        outputChatBox("Acércate a la parte trasera de una chiva y presiona G para montarte.", player, 255, 255, 0)
    end
end)

-- Función exportable para montar pasajeros mediante código (solo para uso interno)
function mountPassenger(player, vehicle, seat)
    if not player or not isElement(player) then
        return false
    end
    
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return false
    end
    
    -- Si no se especifica asiento, detectar la puerta más cercana y asignar asiento correspondiente
    if not seat then
        local playerSide, preferredSeat = detectNearestDoorAndSeat(player, vehicle)
        seat = getNextAvailableSeat(vehicle, playerSide, preferredSeat)
        if not seat then
            return false
        end
    end
    
    -- Verificar que el asiento esté disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    if occupant then
        return false
    end
    
    -- Enviar al servidor para montar (warpPedIntoVehicle es función del servidor)
    triggerServerEvent("chiva:requestMount", player, vehicle, seat)
    return true
end

-- Evento para recibir confirmación del servidor después de montar
addEvent("chiva:mounted", true)
addEventHandler("chiva:mounted", root, function(success, message)
    if message then
        if success then
            outputChatBox(message, 0, 255, 0)
        else
            outputChatBox(message, 255, 0, 0)
        end
    end
end)

-- Función para obtener información de los asientos
function getChivaSeatsInfo(vehicle)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return nil
    end
    
    local seatsInfo = {}
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local occupant = getVehicleOccupant(vehicle, seatConfig.seat)
        table.insert(seatsInfo, {
            seat = seatConfig.seat,
            name = seatConfig.name,
            occupied = occupant ~= false,
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
    
    local count = 0
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local occupant = getVehicleOccupant(vehicle, seatConfig.seat)
        if not occupant then
            count = count + 1
        end
    end
    
    return count
end
