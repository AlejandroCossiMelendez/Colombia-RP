-- Sistema de Chiva - Servidor
-- Sistema de asientos personalizados usando actualización continua de posición

-- Tabla para rastrear qué jugadores están en qué asientos personalizados
local chivaPassengers = {}  -- [vehicle] = {[seat] = {player = player, offsetX = x, offsetY = y, offsetZ = z, timer = timer}}

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
    if seatData and seatData.player and isElement(seatData.player) then
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
    
    -- Registrar al jugador en el asiento con sus offsets
    chivaPassengers[vehicle][seat] = {
        player = player,
        offsetX = offsetX,
        offsetY = offsetY,
        offsetZ = offsetZ
    }
    
    -- Congelar al jugador para que no se mueva manualmente
    setElementFrozen(player, true)
    
    -- Función para actualizar la posición del jugador continuamente
    local function updatePlayerPosition()
        if not isElement(player) or not isElement(vehicle) then
            return false
        end
        
        if not chivaPassengers[vehicle] or not chivaPassengers[vehicle][seat] or chivaPassengers[vehicle][seat].player ~= player then
            return false
        end
        
        -- Obtener posición y rotación del vehículo
        local vx, vy, vz = getElementPosition(vehicle)
        local vrx, vry, vrz = getElementRotation(vehicle)
        local angle = math.rad(vrz)
        local cosAngle = math.cos(angle)
        local sinAngle = math.sin(angle)
        
        -- Rotar los offsets según la rotación del vehículo
        local rotatedX = offsetX * cosAngle - offsetY * sinAngle
        local rotatedY = offsetX * sinAngle + offsetY * cosAngle
        
        -- Calcular posición mundial del asiento
        local seatX = vx + rotatedX
        local seatY = vy + rotatedY
        local seatZ = vz + offsetZ
        
        -- Actualizar posición del jugador
        setElementPosition(player, seatX, seatY, seatZ)
        
        -- Hacer que el jugador mire en la dirección del vehículo
        setPedRotation(player, vrz)
        
        return true
    end
    
    -- Crear timer para actualizar posición cada 50ms (20 veces por segundo)
    local updateTimer = setTimer(updatePlayerPosition, 50, 0)
    chivaPassengers[vehicle][seat].timer = updateTimer
    
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
    
    if not chivaPassengers[vehicle] or not chivaPassengers[vehicle][seat] or chivaPassengers[vehicle][seat].player ~= player then
        return false
    end
    
    -- Detener el timer de actualización de posición
    local seatData = chivaPassengers[vehicle][seat]
    if seatData.timer and isTimer(seatData.timer) then
        killTimer(seatData.timer)
    end
    
    -- Detener animación
    setPedAnimation(player, nil)
    
    -- Descongelar al jugador
    setElementFrozen(player, false)
    
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
    local player = source
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        outputServerLog("[CHIVA] Error: Jugador inválido en requestMount")
        return
    end
    
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        outputChatBox("Error: El vehículo no es válido.", player, 255, 0, 0)
        return
    end
    
    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " intenta montarse en chiva, asiento: " .. tostring(seat))
    mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
end)

-- Evento para recibir solicitud de bajarse desde el cliente
addEvent("chiva:requestDismount", true)
addEventHandler("chiva:requestDismount", root, function(vehicle, seat)
    local player = source
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
                if seatData and seatData.player and isElement(seatData.player) then
                    -- Detener timer
                    if seatData.timer and isTimer(seatData.timer) then
                        killTimer(seatData.timer)
                    end
                    -- Descongelar y colocar cerca
                    setElementFrozen(seatData.player, false)
                    setPedAnimation(seatData.player, nil)
                    local vx, vy, vz = getElementPosition(source)
                    setElementPosition(seatData.player, vx, vy, vz + 1.0)
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
                if seatData and seatData.player == source then
                    -- Detener timer
                    if seatData.timer and isTimer(seatData.timer) then
                        killTimer(seatData.timer)
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
        local occupant = seatData and seatData.player or nil
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
        if not seatData or not seatData.player then
            count = count + 1
        end
    end
    
    return count
end

-- Exportar funciones para uso desde otros recursos
-- Uso: exports.chiva:mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
-- Uso: exports.chiva:getChivaSeatsInfo(vehicle)
-- Uso: exports.chiva:getAvailableSeatsCount(vehicle)
