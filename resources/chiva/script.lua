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
local CHIVA_SEATS_CONFIG = {
    -- Fila 1 (atrás - lado izquierdo del vehículo)
    {seat = 2, name = "Fila 1 - Asiento 1"},
    {seat = 3, name = "Fila 1 - Asiento 2"},
    {seat = 4, name = "Fila 1 - Asiento 3"},
    {seat = 5, name = "Fila 1 - Asiento 4"},
    
    -- Fila 2 (delante de atrás - lado derecho del vehículo)
    {seat = 6, name = "Fila 2 - Asiento 1"},
    {seat = 7, name = "Fila 2 - Asiento 2"},
    {seat = 8, name = "Fila 2 - Asiento 3"},
    {seat = 9, name = "Fila 2 - Asiento 4"},
}

-- Función para obtener el siguiente asiento disponible
local function getNextAvailableSeat(vehicle)
    if not vehicle or not isElement(vehicle) or getElementModel(vehicle) ~= CHIVA_MODEL then
        return nil
    end
    
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local seat = seatConfig.seat
        local occupant = getVehicleOccupant(vehicle, seat)
        if not occupant then
            return seat
        end
    end
    
    return nil  -- No hay asientos disponibles
end

-- Función para verificar si el jugador está cerca de una chiva (especialmente de atrás)
local function getNearbyChiva(player, maxDistance)
    maxDistance = maxDistance or 3.0
    local px, py, pz = getElementPosition(player)
    
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementModel(vehicle) == CHIVA_MODEL then
            local vx, vy, vz = getElementPosition(vehicle)
            local vrx, vry, vrz = getElementRotation(vehicle)
            
            -- Calcular posición trasera del vehículo
            local matrix = getElementMatrix(vehicle)
            if matrix then
                -- Posición trasera (offset negativo en Y)
                local rearX = vx - math.sin(math.rad(vrz)) * 2.5
                local rearY = vy + math.cos(math.rad(vrz)) * 2.5
                local rearZ = vz
                
                local distance = getDistanceBetweenPoints3D(px, py, pz, rearX, rearY, rearZ)
                
                if distance <= maxDistance then
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
    
    if not seat then
        seat = getNextAvailableSeat(vehicle)
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
    
    -- Si no se especifica asiento, usar el siguiente disponible
    if not seat then
        seat = getNextAvailableSeat(vehicle)
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
