-- Sistema de Chiva - Servidor
-- Funciones para controlar los pasajeros desde el servidor

-- Función para montar un jugador en la chiva desde el servidor
function mountPlayerInChiva(player, vehicle, seat)
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return false
    end
    
    local model = getElementModel(vehicle)
    if model ~= 410 then  -- Modelo de chiva
        outputServerLog("[CHIVA] Error: Vehículo no es modelo 410, es modelo " .. tostring(model))
        return false
    end
    
    -- Verificar número máximo de pasajeros del vehículo
    local maxPassengers = getVehicleMaxPassengers(vehicle)
    outputServerLog("[CHIVA] Vehículo modelo 410 tiene " .. tostring(maxPassengers) .. " asientos de pasajeros")
    
    -- Si no se especifica asiento, encontrar el siguiente disponible
    if not seat then
        -- Usar solo los asientos que realmente existen en el vehículo
        local availableSeats = {}
        for s = 2, math.min(9, maxPassengers) do
            table.insert(availableSeats, s)
        end
        
        for _, s in ipairs(availableSeats) do
            local occupant = getVehicleOccupant(vehicle, s)
            if not occupant then
                seat = s
                break
            end
        end
        
        if not seat then
            outputChatBox("La chiva está llena. No hay asientos disponibles.", player, 255, 255, 0)
            outputServerLog("[CHIVA] No hay asientos disponibles para " .. getPlayerName(player))
            return false
        end
    end
    
    -- Verificar que el asiento solicitado no exceda el máximo
    if seat > maxPassengers then
        outputChatBox("Este asiento no existe en este vehículo. Máximo: " .. maxPassengers, player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Asiento " .. seat .. " excede el máximo (" .. maxPassengers .. ")")
        return false
    end
    
    -- Verificar que el asiento esté disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    if occupant then
        outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
        return false
    end
    
    -- Verificar que el jugador no esté ya en un vehículo
    local currentVehicle = getPedOccupiedVehicle(player)
    if currentVehicle then
        outputChatBox("Ya estás en un vehículo. Bájate primero.", player, 255, 255, 0)
        return false
    end
    
    -- Verificar que el asiento sea válido para este vehículo
    local maxPassengers = getVehicleMaxPassengers(vehicle)
    outputServerLog("[CHIVA] Intentando montar a " .. getPlayerName(player) .. " en asiento " .. seat .. " (max pasajeros: " .. maxPassengers .. ")")
    
    if seat > maxPassengers then
        outputChatBox("Este asiento no existe en este vehículo. Máximo: " .. maxPassengers, player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Asiento " .. seat .. " excede el máximo (" .. maxPassengers .. ")")
        return false
    end
    
    -- Verificar que el asiento esté realmente disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    if occupant then
        outputChatBox("Este asiento está ocupado por " .. (isElement(occupant) and getPlayerName(occupant) or "alguien") .. ".", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Asiento " .. seat .. " ocupado")
        return false
    end
    
    -- Montar al jugador directamente desde el servidor
    local success = warpPedIntoVehicle(player, vehicle, seat)
    
    if success then
        -- Verificar que realmente se montó
        setTimer(function()
            if isElement(player) and isElement(vehicle) then
                local actualVehicle = getPedOccupiedVehicle(player)
                local actualSeat = getPedOccupiedVehicleSeat(player)
                
                if actualVehicle == vehicle and actualSeat == seat then
                    outputChatBox("Te has montado en la chiva (Asiento " .. seat .. ").", player, 0, 255, 0)
                    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " montado exitosamente en asiento " .. seat)
                else
                    -- Intentar de nuevo
                    if warpPedIntoVehicle(player, vehicle, seat) then
                        outputChatBox("Te has montado en la chiva (Asiento " .. seat .. ").", player, 0, 255, 0)
                    else
                        outputChatBox("Error al montarte en la chiva. Intenta de nuevo.", player, 255, 0, 0)
                        outputServerLog("[CHIVA] Error: No se pudo montar a " .. getPlayerName(player) .. " en asiento " .. seat)
                    end
                end
            end
        end, 100, 1)
        
        triggerClientEvent(player, "chiva:mounted", resourceRoot, true, "Te has montado en la chiva.")
        return true
    else
        outputChatBox("Error al montarte en la chiva. Verifica que el asiento esté disponible.", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: warpPedIntoVehicle falló para " .. getPlayerName(player) .. " en asiento " .. seat)
        triggerClientEvent(player, "chiva:mounted", resourceRoot, false, "Error al montarte en la chiva.")
        return false
    end
end

-- Evento para recibir solicitud de montar desde el cliente
addEvent("chiva:requestMount", true)
addEventHandler("chiva:requestMount", root, function(vehicle, seat)
    local player = source
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        outputServerLog("[CHIVA] Error: Jugador inválido en requestMount")
        return
    end
    
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        outputChatBox("Error: El vehículo no es válido.", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Vehículo inválido en requestMount para " .. getPlayerName(player))
        return
    end
    
    -- Verificar que el jugador no esté ya en un vehículo
    local currentVehicle = getPedOccupiedVehicle(player)
    if currentVehicle then
        outputChatBox("Ya estás en un vehículo. Bájate primero.", player, 255, 255, 0)
        return
    end
    
    -- Verificar distancia
    local px, py, pz = getElementPosition(player)
    local vx, vy, vz = getElementPosition(vehicle)
    local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
    
    if distance > 5.0 then
        outputChatBox("Estás muy lejos de la chiva. Acércate más.", player, 255, 255, 0)
        return
    end
    
    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " intenta montarse en chiva, asiento: " .. tostring(seat))
    mountPlayerInChiva(player, vehicle, seat)
end)

-- Función para obtener información de los asientos desde el servidor
function getChivaSeatsInfo(vehicle)
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return nil
    end
    
    local model = getElementModel(vehicle)
    if model ~= 410 then
        return nil
    end
    
    local seatsInfo = {}
    local seats = {2, 3, 4, 5, 6, 7, 8, 9}  -- Asientos de pasajeros (excluyendo conductor y copiloto)
    
    for _, seat in ipairs(seats) do
        local occupant = getVehicleOccupant(vehicle, seat)
        table.insert(seatsInfo, {
            seat = seat,
            occupied = occupant ~= false,
            occupant = occupant
        })
    end
    
    return seatsInfo
end

-- Función para obtener el número de asientos disponibles
function getAvailableSeatsCount(vehicle)
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return 0
    end
    
    local model = getElementModel(vehicle)
    if model ~= 410 then
        return 0
    end
    
    local count = 0
    local seats = {2, 3, 4, 5, 6, 7, 8, 9}
    
    for _, seat in ipairs(seats) do
        local occupant = getVehicleOccupant(vehicle, seat)
        if not occupant then
            count = count + 1
        end
    end
    
    return count
end

-- Exportar funciones para uso desde otros recursos
-- Uso: exports.chiva:mountPlayerInChiva(player, vehicle, seat)
-- Uso: exports.chiva:getChivaSeatsInfo(vehicle)
-- Uso: exports.chiva:getAvailableSeatsCount(vehicle)

