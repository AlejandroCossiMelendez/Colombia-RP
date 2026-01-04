-- Sistema de Chiva - Servidor
-- Asientos personalizados: attach real (server-side) + animación (client-side)

-- Tabla para rastrear ocupantes: [vehicle] = {[seat] = player}
local chivaPassengers = {}

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
    local existing = chivaPassengers[vehicle][seat]
    if existing and isElement(existing) then
        outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
        return false
    else
        chivaPassengers[vehicle][seat] = nil
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
    
    -- ⚠️ Detalles importantes para evitar bugs:
    -- 1) Desactivar colisiones (evita empujar el vehículo / glitches)
    setElementCollisionsEnabled(player, false)
    -- 2) Congelar jugador (evita deslizamientos)
    setElementFrozen(player, true)

    -- Asegurar que no esté adjuntado a nada previo
    detachElements(player)

    -- 🔥 Lo clave: attach real (server-side)
    local ok = attachElements(player, vehicle, offsetX, offsetY, offsetZ, 0, 0, 0)
    if not ok then
        setElementFrozen(player, false)
        setElementCollisionsEnabled(player, true)
        outputChatBox("Error al montarte en la chiva.", player, 255, 0, 0)
        triggerClientEvent(player, "chiva:mounted", resourceRoot, vehicle, seat, false)
        return false
    end

    -- Guardar ocupación
    chivaPassengers[vehicle][seat] = player

    -- Alinear el facing al vehículo una vez (el attach se encarga del resto)
    local _, _, vrz = getElementRotation(vehicle)
    setPedRotation(player, vrz)

    -- Animación sentada: mejor forzar client-side para que todos la vean
    triggerClientEvent(root, "chiva:playerMounted", resourceRoot, player, vehicle, seat)
    
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
    
    -- Desadjuntar del vehículo
    detachElements(player)

    -- Restaurar colisiones
    setElementCollisionsEnabled(player, true)

    -- Descongelar al jugador
    setElementFrozen(player, false)

    -- Detener animación (client-side también)
    setPedAnimation(player, nil)
    
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
    triggerClientEvent(root, "chiva:playerDismounted", resourceRoot, player, vehicle, seat)
    
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
    local player = client  -- triggerServerEvent
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
    if chivaPassengers[vehicle][seat] and isElement(chivaPassengers[vehicle][seat]) then
        triggerClientEvent(player, "chiva:mounted", resourceRoot, vehicle, seat, false)
        return
    end
    
    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " intenta montarse en chiva, asiento: " .. tostring(seat))
    mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
end)

-- Evento para recibir solicitud de bajarse desde el cliente
addEvent("chiva:requestDismount", true)
addEventHandler("chiva:requestDismount", root, function(vehicle, seat)
    local player = client  -- triggerServerEvent
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
                    detachElements(passenger)
                    setElementCollisionsEnabled(passenger, true)
                    setElementFrozen(passenger, false)
                    setPedAnimation(passenger, nil)
                    local vx, vy, vz = getElementPosition(source)
                    setElementPosition(passenger, vx, vy, vz + 1.0)
                    triggerClientEvent(root, "chiva:playerDismounted", resourceRoot, passenger, source, seat)
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
                    detachElements(source)
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
        local occupant = chivaPassengers[vehicle][seat]
        if not occupant or not isElement(occupant) then
            count = count + 1
        end
    end
    
    return count
end

-- Exportar funciones para uso desde otros recursos
-- Uso: exports.chiva:mountPlayerInChiva(player, vehicle, seat, offsetX, offsetY, offsetZ)
-- Uso: exports.chiva:getChivaSeatsInfo(vehicle)
-- Uso: exports.chiva:getAvailableSeatsCount(vehicle)
