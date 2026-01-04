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
        return false
    end
    
    -- Si no se especifica asiento, encontrar el siguiente disponible
    if not seat then
        local seats = {2, 3, 4, 5, 6, 7, 8, 9}
        for _, s in ipairs(seats) do
            local occupant = getVehicleOccupant(vehicle, s)
            if not occupant then
                seat = s
                break
            end
        end
        
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
    
    -- Montar al jugador directamente desde el servidor
    if warpPedIntoVehicle(player, vehicle, seat) then
        outputChatBox("Te has montado en la chiva (Asiento " .. seat .. ").", player, 0, 255, 0)
        triggerClientEvent(player, "chiva:mounted", resourceRoot, true, "Te has montado en la chiva.")
        return true
    else
        outputChatBox("Error al montarte en la chiva.", player, 255, 0, 0)
        triggerClientEvent(player, "chiva:mounted", resourceRoot, false, "Error al montarte en la chiva.")
        return false
    end
end

-- Evento para recibir solicitud de montar desde el cliente
addEvent("chiva:requestMount", true)
addEventHandler("chiva:requestMount", root, function(vehicle, seat)
    local player = source
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return
    end
    
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

