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

-- Configuración de asientos (8 pasajeros en 2 filas de 4)
-- Seat 0 = Conductor, Seat 1 = Copiloto
-- Seats 2-9 = Pasajeros (configurables)
-- LADO IZQUIERDO: Asientos 2, 3, 6, 7 (2 filas, lado izquierdo)
-- LADO DERECHO: Asientos 4, 5, 8, 9 (2 filas, lado derecho)
local CHIVA_SEATS_CONFIG = {
    -- Lado Izquierdo - Fila 1 (atrás)
    {seat = 2, name = "Izquierda - Fila 1 - Asiento 1", side = "left"},
    {seat = 3, name = "Izquierda - Fila 1 - Asiento 2", side = "left"},
    
    -- Lado Derecho - Fila 1 (atrás)
    {seat = 4, name = "Derecha - Fila 1 - Asiento 1", side = "right"},
    {seat = 5, name = "Derecha - Fila 1 - Asiento 2", side = "right"},
    
    -- Lado Izquierdo - Fila 2 (delante de atrás)
    {seat = 6, name = "Izquierda - Fila 2 - Asiento 1", side = "left"},
    {seat = 7, name = "Izquierda - Fila 2 - Asiento 2", side = "left"},
    
    -- Lado Derecho - Fila 2 (delante de atrás)
    {seat = 8, name = "Derecha - Fila 2 - Asiento 1", side = "right"},
    {seat = 9, name = "Derecha - Fila 2 - Asiento 2", side = "right"},
}

-- Función para detectar en qué lado de la chiva está el jugador
local function detectPlayerSide(player, vehicle)
    if not player or not vehicle or not isElement(player) or not isElement(vehicle) then
        return nil
    end
    
    local px, py, pz = getElementPosition(player)
    local vx, vy, vz = getElementPosition(vehicle)
    local vrx, vry, vrz = getElementRotation(vehicle)
    
    -- Calcular vector desde el vehículo al jugador
    local dx = px - vx
    local dy = py - vy
    
    -- Rotar el vector para que esté en el sistema de coordenadas del vehículo
    local angle = math.rad(-vrz)
    local rotatedX = dx * math.cos(angle) - dy * math.sin(angle)
    local rotatedY = dx * math.sin(angle) + dy * math.cos(angle)
    
    -- Si rotatedX es positivo, está a la derecha del vehículo (visto desde atrás)
    -- Si rotatedX es negativo, está a la izquierda del vehículo
    if rotatedX > 0 then
        return "right"  -- Lado derecho
    else
        return "left"   -- Lado izquierdo
    end
end

-- Función para obtener el siguiente asiento disponible en un lado específico
local function getNextAvailableSeat(vehicle, preferredSide)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return nil
    end
    
    -- Primero buscar en el lado preferido
    if preferredSide then
        for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
            if seatConfig.side == preferredSide then
                local seat = seatConfig.seat
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
        local occupant = getVehicleOccupant(vehicle, seat)
        if not occupant then
            return seat
        end
    end
    
    return nil  -- No hay asientos disponibles
end

-- Función para verificar si el jugador está cerca de una chiva (lados o atrás)
local function getNearbyChiva(player, maxDistance)
    maxDistance = maxDistance or 3.5
    local px, py, pz = getElementPosition(player)
    
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementModel(vehicle) == CHIVA_MODEL then
            local vx, vy, vz = getElementPosition(vehicle)
            local vrx, vry, vrz = getElementRotation(vehicle)
            
            -- Calcular posición de los lados y atrás del vehículo
            local matrix = getElementMatrix(vehicle)
            if matrix then
                -- Verificar distancia a los lados (izquierda y derecha)
                -- Lado izquierdo (offset negativo en X)
                local leftX = vx - math.cos(math.rad(vrz)) * 1.5
                local leftY = vy - math.sin(math.rad(vrz)) * 1.5
                local leftZ = vz
                local leftDist = getDistanceBetweenPoints3D(px, py, pz, leftX, leftY, leftZ)
                
                -- Lado derecho (offset positivo en X)
                local rightX = vx + math.cos(math.rad(vrz)) * 1.5
                local rightY = vy + math.sin(math.rad(vrz)) * 1.5
                local rightZ = vz
                local rightDist = getDistanceBetweenPoints3D(px, py, pz, rightX, rightY, rightZ)
                
                -- Parte trasera
                local rearX = vx - math.sin(math.rad(vrz)) * 2.5
                local rearY = vy + math.cos(math.rad(vrz)) * 2.5
                local rearZ = vz
                local rearDist = getDistanceBetweenPoints3D(px, py, pz, rearX, rearY, rearZ)
                
                -- Si está cerca de cualquier lado o atrás
                if leftDist <= maxDistance or rightDist <= maxDistance or rearDist <= maxDistance then
                    return vehicle
                end
            else
                -- Fallback: verificar distancia general
                local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
                if distance <= maxDistance then
                    return vehicle
                end
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
    
    -- Si no se especifica asiento, detectar el lado del jugador y asignar asiento del mismo lado
    if not seat then
        local playerSide = detectPlayerSide(player, vehicle)
        seat = getNextAvailableSeat(vehicle, playerSide)
        
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
    
    -- Si no se especifica asiento, detectar el lado del jugador y asignar asiento del mismo lado
    if not seat then
        local playerSide = detectPlayerSide(player, vehicle)
        seat = getNextAvailableSeat(vehicle, playerSide)
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
