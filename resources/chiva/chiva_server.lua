-- Sistema de Chiva - Servidor
-- Sistema de asientos personalizados usando actualización continua de posición

-- Tabla para rastrear qué jugadores están en qué asientos personalizados
local chivaPassengers = {}  -- [vehicle] = {[seat] = player}

-- Función para montar un jugador en la chiva usando attachElements
function mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return false
    end
    
    local model = getElementModel(vehicle)
    if model ~= 410 then
        outputServerLog("[CHIVA] Error: Vehículo no es modelo 410, es modelo " .. tostring(model))
        return false
    end
    
    -- Verificar que el asiento esté en el rango válido (2-9)
    if seat < 2 or seat > 9 then
        outputChatBox("Asiento inválido. Usa asientos del 2 al 9.", player, 255, 0, 0)
        return false
    end
    
    -- Inicializar tabla de pasajeros si no existe
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    -- Verificar que el asiento esté disponible
    if chivaPassengers[vehicle][seat] then
        outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
        return false
    end
    
    -- Verificar que el jugador no esté ya en un vehículo
    local currentVehicle = getPedOccupiedVehicle(player)
    if currentVehicle then
        outputChatBox("Ya estás en un vehículo. Bájate primero.", player, 255, 255, 0)
        return false
    end
    
    -- Verificar que el vehículo esté detenido o moviéndose muy lentamente
    local vx, vy, vz = getElementVelocity(vehicle)
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180
    
    if speed > 5.0 then
        outputChatBox("El vehículo está en movimiento. Debe estar detenido para montarte.", player, 255, 255, 0)
        return false
    end
    
    -- Verificar distancia
    local px, py, pz = getElementPosition(player)
    local vpx, vpy, vpz = getElementPosition(vehicle)
    local distance = getDistanceBetweenPoints3D(px, py, pz, vpx, vpy, vpz)
    
    if distance > 8.0 then
        outputChatBox("Estás muy lejos de la chiva. Acércate más.", player, 255, 255, 0)
        return false
    end
    
    -- 🔥 USAR attachElements - MTA maneja todo automáticamente
    local success = attachElements(player, vehicle, offsetX, offsetY, offsetZ, 0, 0, 0)
    
    if not success then
        outputChatBox("Error al montarte en la chiva.", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: attachElements falló para " .. getPlayerName(player))
        triggerClientEvent(player, "chiva:mounted", resourceRoot, vehicle, seat, false)
        return false
    end
    
    -- ⚠️ DETALLES IMPORTANTES para evitar bugs:
    -- 1. Desactivar colisiones para evitar que empuje el vehículo o salga disparado
    setElementCollisionsEnabled(player, false)
    
    -- 2. Congelar al jugador para evitar deslizamientos, desync y caídas
    setElementFrozen(player, true)
    
    -- Registrar al jugador en el asiento
    chivaPassengers[vehicle][seat] = player
    
    -- Reproducir animación de sentado arriba (sincronizada para todos)
    setPedAnimation(player, "ped", "CAR_sit", -1, true, false, false, false)
    
    -- Notificar a todos los clientes sobre el montaje
    triggerClientEvent("chiva:playerMounted", resourceRoot, player, vehicle, seat)
    
    outputChatBox("Te has montado en la chiva (Asiento " .. seat .. "). Presiona F para bajarte.", player, 0, 255, 0)
    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " montado en asiento personalizado " .. seat)
    
    triggerClientEvent(player, "chiva:mounted", resourceRoot, vehicle, seat, true)
    return true
end

-- Función para bajar a un jugador de la chiva
function dismountPlayerFromChiva(player, vehicle, seat)
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    if not vehicle or not isElement(vehicle) then
        return false
    end
    
    if not chivaPassengers[vehicle] or not chivaPassengers[vehicle][seat] or chivaPassengers[vehicle][seat] ~= player then
        return false
    end
    
    -- Desconectar del vehículo
    detachElements(player, vehicle)
    
    -- Restaurar colisiones
    setElementCollisionsEnabled(player, true)
    
    -- Descongelar al jugador
    setElementFrozen(player, false)
    
    -- Detener animación
    setPedAnimation(player, nil)
    
    -- Colocar al jugador cerca del vehículo al bajarse
    local x, y, z = getElementPosition(vehicle)
    setElementPosition(player, x + 1.5, y, z)
    
    -- Notificar a todos los clientes sobre el desmontaje
    triggerClientEvent("chiva:playerDismounted", resourceRoot, player, vehicle, seat)
    
    -- Remover de la tabla
    chivaPassengers[vehicle][seat] = nil
    
    outputChatBox("Te has bajado de la chiva.", player, 0, 255, 0)
    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " se bajó del asiento " .. seat)
    
    triggerClientEvent(player, "chiva:dismounted", resourceRoot, vehicle, seat)
    return true
end

-- Evento para recibir solicitud de montar desde el cliente
addEvent("chiva:requestMount", true)
addEventHandler("chiva:requestMount", root, function(vehicle, seat, offsetX, offsetY, offsetZ)
    local player = client  -- Usar client en lugar de source para eventos remotos
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        outputServerLog("[CHIVA] Error: Jugador inválido en requestMount")
        return
    end
    
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        outputChatBox("Error: El vehículo no es válido.", player, 255, 0, 0)
        return
    end
    
    if getElementModel(vehicle) ~= 410 then
        outputChatBox("Error: Este vehículo no es una chiva.", player, 255, 0, 0)
        return
    end
    
    -- Inicializar tabla si no existe
    chivaPassengers[vehicle] = chivaPassengers[vehicle] or {}
    
    -- Verificar si el asiento ya está ocupado
    if chivaPassengers[vehicle][seat] then
        triggerClientEvent(player, "chiva:mounted", resourceRoot, vehicle, seat, false)
        return
    end
    
    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " intenta montarse en chiva, asiento: " .. tostring(seat))
    mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
end)

-- Evento para recibir solicitud de bajarse desde el cliente
addEvent("chiva:requestDismount", true)
addEventHandler("chiva:requestDismount", root, function(vehicle, seat)
    local player = client  -- Usar client en lugar de source para eventos remotos
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    if not vehicle or not isElement(vehicle) then
        return
    end
    
    dismountPlayerFromChiva(player, vehicle, seat)
end)

-- Limpiar cuando el vehículo se destruye
addEventHandler("onElementDestroy", root, function()
    if getElementType(source) == "vehicle" and getElementModel(source) == 410 then
        if chivaPassengers[source] then
            -- Bajar a todos los pasajeros
            for seat, passenger in pairs(chivaPassengers[source]) do
                if passenger and isElement(passenger) then
                    -- Desconectar del vehículo
                    detachElements(passenger, source)
                    -- Restaurar colisiones
                    setElementCollisionsEnabled(passenger, true)
                    -- Descongelar y colocar cerca
                    setElementFrozen(passenger, false)
                    setPedAnimation(passenger, nil)
                    local vx, vy, vz = getElementPosition(source)
                    setElementPosition(passenger, vx, vy, vz + 1.0)
                    -- Notificar al cliente
                    triggerClientEvent("chiva:playerDismounted", resourceRoot, passenger, source, seat)
                end
            end
            chivaPassengers[source] = nil
        end
    end
end)

-- Limpiar cuando un jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    for vehicle, seats in pairs(chivaPassengers) do
        if isElement(vehicle) then
            for seat, passenger in pairs(seats) do
                if passenger == source then
                    -- Desconectar del vehículo
                    if isElement(vehicle) then
                        detachElements(source, vehicle)
                        setElementCollisionsEnabled(source, true)
                        setElementFrozen(source, false)
                        triggerClientEvent("chiva:playerDismounted", resourceRoot, source, vehicle, seat)
                    end
                    chivaPassengers[vehicle][seat] = nil
                    break
                end
            end
        end
    end
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
    
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    local seatsInfo = {}
    local seats = {2, 3, 4, 5, 6, 7, 8, 9}
    
    for _, seat in ipairs(seats) do
        local occupant = chivaPassengers[vehicle][seat]
        table.insert(seatsInfo, {
            seat = seat,
            occupied = occupant ~= nil,
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
    
    if not chivaPassengers[vehicle] then
        chivaPassengers[vehicle] = {}
    end
    
    local count = 0
    local seats = {2, 3, 4, 5, 6, 7, 8, 9}
    
    for _, seat in ipairs(seats) do
        if not chivaPassengers[vehicle][seat] then
            count = count + 1
        end
    end
    
    return count
end

-- Exportar funciones para uso desde otros recursos
-- Uso: exports.chiva:mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
-- Uso: exports.chiva:getChivaSeatsInfo(vehicle)
-- Uso: exports.chiva:getAvailableSeatsCount(vehicle)
