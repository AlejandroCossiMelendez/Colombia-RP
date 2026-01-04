-- Sistema de Chiva - Servidor
-- Sistema de asientos personalizados usando actualización continua de posición

-- Tabla para rastrear qué jugadores están en qué asientos personalizados
local chivaPassengers = {}  -- [vehicle] = {[seat] = {player = player, offsetX = x, offsetY = y, offsetZ = z}}

-- Timer para actualizar posición y rotación de pasajeros desde el servidor
local function updatePassengersPositions()
    for vehicle, seats in pairs(chivaPassengers) do
        if isElement(vehicle) then
            local vx, vy, vz = getElementPosition(vehicle)
            local vrx, vry, vrz = getElementRotation(vehicle)
            local angle = math.rad(vrz)
            local cosAngle = math.cos(angle)
            local sinAngle = math.sin(angle)
            
            for seat, seatData in pairs(seats) do
                if seatData and seatData.player and isElement(seatData.player) then
                    local player = seatData.player
                    
                    -- Rotar los offsets según la rotación del vehículo
                    local rotatedX = seatData.offsetX * cosAngle - seatData.offsetY * sinAngle
                    local rotatedY = seatData.offsetX * sinAngle + seatData.offsetY * cosAngle
                    
                    -- Calcular posición mundial del asiento
                    local seatX = vx + rotatedX
                    local seatY = vy + rotatedY
                    local seatZ = vz + seatData.offsetZ
                    
                    -- Actualizar posición y rotación desde el servidor
                    setElementPosition(player, seatX, seatY, seatZ)
                    setPedRotation(player, vrz)
                end
            end
        end
    end
end

-- Iniciar timer de actualización en el servidor (cada 50ms = 20 veces por segundo)
setTimer(updatePassengersPositions, 50, 0)

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
    local seatData = chivaPassengers[vehicle][seat]
    if seatData then
        local existingPlayer = seatData.player or seatData
        if existingPlayer and isElement(existingPlayer) then
            outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
            return false
        end
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
    
    -- ⚠️ DETALLES IMPORTANTES para evitar bugs:
    -- 1. Desactivar colisiones para evitar que empuje el vehículo o salga disparado
    setElementCollisionsEnabled(player, false)
    
    -- 2. Congelar al jugador para evitar deslizamientos, desync y caídas
    setElementFrozen(player, true)
    
    -- Registrar al jugador en el asiento con offsets
    chivaPassengers[vehicle][seat] = {
        player = player,
        offsetX = offsetX,
        offsetY = offsetY,
        offsetZ = offsetZ
    }
    
    -- Reproducir animación de sentado arriba (sincronizada para todos)
    setPedAnimation(player, "ped", "CAR_sit", -1, true, false, false, false)
    
    -- Notificar a todos los clientes sobre el montaje (con offsets para actualización continua)
    triggerClientEvent("chiva:playerMounted", resourceRoot, player, vehicle, seat, offsetX, offsetY, offsetZ)
    
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
    
    local seatData = chivaPassengers[vehicle] and chivaPassengers[vehicle][seat]
    if not seatData then
        return false
    end
    local attachedPlayer = seatData.player or seatData
    if attachedPlayer ~= player then
        return false
    end
    
    -- Restaurar colisiones
    setElementCollisionsEnabled(player, true)
    
    -- Descongelar al jugador
    setElementFrozen(player, false)
    
    -- Detener animación
    setPedAnimation(player, nil)
    
    -- Notificar al cliente para que deje de actualizar la posición
    triggerClientEvent("chiva:playerDismounted", resourceRoot, player, vehicle, seat)
    
    -- Colocar al jugador cerca del vehículo al bajarse
    local vx, vy, vz = getElementPosition(vehicle)
    local vrx, vry, vrz = getElementRotation(vehicle)
    local angle = math.rad(vrz)
    
    -- Calcular posición de bajada (al lado del vehículo)
    local offsetX = 2.0
    local offsetY = 0.0
    local rotatedX = offsetX * math.cos(angle) - offsetY * math.sin(angle)
    local rotatedY = offsetX * math.sin(angle) + offsetY * math.cos(angle)
    
    setElementPosition(player, vx + rotatedX, vy + rotatedY, vz + 0.5)
    
    -- Reproducir animación de bajarse
    setPedAnimation(player, "ped", "CAR_getout_LHS", 2000, false, false, false, false)
    setTimer(function()
        if isElement(player) then
            setPedAnimation(player, nil)
        end
    end, 2000, 1)
    
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
            for seat, seatData in pairs(chivaPassengers[source]) do
                local passenger = seatData and seatData.player or seatData
                if passenger and isElement(passenger) then
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
            for seat, seatData in pairs(seats) do
                local passenger = seatData and seatData.player or seatData
                if passenger == source then
                    -- Restaurar estado
                    if isElement(vehicle) then
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
        local seatData = chivaPassengers[vehicle][seat]
        local occupant = seatData and (seatData.player or seatData) or nil
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
        local seatData = chivaPassengers[vehicle][seat]
        if not seatData or not (seatData.player or seatData) then
            count = count + 1
        end
    end
    
    return count
end

-- Exportar funciones para uso desde otros recursos
-- Uso: exports.chiva:mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
-- Uso: exports.chiva:getChivaSeatsInfo(vehicle)
-- Uso: exports.chiva:getAvailableSeatsCount(vehicle)
