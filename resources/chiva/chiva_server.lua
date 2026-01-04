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
    
    -- Verificar número máximo de pasajeros del vehículo (solo para logging)
    local maxPassengers = getVehicleMaxPassengers(vehicle)
    outputServerLog("[CHIVA] Vehículo modelo 410 tiene " .. tostring(maxPassengers) .. " asientos reconocidos por MTA, pero el modelo personalizado tiene más")
    
    -- Si no se especifica asiento, encontrar el siguiente disponible
    -- Para la chiva personalizada, usamos asientos 2-9 sin importar maxPassengers
    if not seat then
        -- Usar los asientos 2-9 de la chiva personalizada
        local availableSeats = {2, 3, 4, 5, 6, 7, 8, 9}
        
        for _, s in ipairs(availableSeats) do
            local occupant = getVehicleOccupant(vehicle, s)
            if not occupant or occupant == false then
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
    
    -- NO validar contra maxPassengers porque el modelo personalizado tiene más asientos
    -- Solo validar que el asiento esté en el rango válido (2-9)
    if seat < 2 or seat > 9 then
        outputChatBox("Asiento inválido. Usa asientos del 2 al 9.", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Asiento " .. seat .. " fuera del rango válido (2-9)")
        return false
    end
    
    -- Verificar que el asiento esté disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    if occupant and occupant ~= false then
        outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
        return false
    end
    
    -- Verificar que el jugador no esté ya en un vehículo
    local currentVehicle = getPedOccupiedVehicle(player)
    if currentVehicle then
        outputChatBox("Ya estás en un vehículo. Bájate primero.", player, 255, 255, 0)
        return false
    end
    
    -- Verificar que el asiento esté en el rango válido (2-9 para pasajeros de la chiva)
    outputServerLog("[CHIVA] Intentando montar a " .. getPlayerName(player) .. " en asiento " .. seat)
    
    if seat < 2 or seat > 9 then
        outputChatBox("Asiento inválido. Usa asientos del 2 al 9.", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Asiento " .. seat .. " fuera del rango válido (2-9)")
        return false
    end
    
    -- Verificar que el asiento esté realmente disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    if occupant and occupant ~= false then
        outputChatBox("Este asiento está ocupado por " .. (isElement(occupant) and getPlayerName(occupant) or "alguien") .. ".", player, 255, 0, 0)
        outputServerLog("[CHIVA] Error: Asiento " .. seat .. " ocupado")
        return false
    end
    
    -- Verificar que el vehículo esté detenido o moviéndose muy lentamente
    local vx, vy, vz = getElementVelocity(vehicle)
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180  -- Convertir a km/h aproximado
    
    if speed > 5.0 then
        outputChatBox("El vehículo está en movimiento. Debe estar detenido para montarte.", player, 255, 255, 0)
        outputServerLog("[CHIVA] Vehículo en movimiento a " .. string.format("%.2f", speed) .. " km/h")
        return false
    end
    
    -- Asegurarse de que el jugador no esté en otro vehículo
    local currentVehicle = getPedOccupiedVehicle(player)
    if currentVehicle and currentVehicle ~= vehicle then
        removePedFromVehicle(player)
    end
    
    -- Obtener posición del vehículo para colocar al jugador cerca primero
    local vpx, vpy, vpz = getElementPosition(vehicle)
    local px, py, pz = getElementPosition(player)
    
    -- Colocar al jugador muy cerca del vehículo antes de intentar montarlo
    if getDistanceBetweenPoints3D(px, py, pz, vpx, vpy, vpz) > 3.0 then
        setElementPosition(player, vpx + 1.0, vpy, vpz + 0.5)
        outputServerLog("[CHIVA] Jugador movido cerca del vehículo antes de montar")
    end
    
    -- Intentar montar directamente
    local success = warpPedIntoVehicle(player, vehicle, seat)
    
    if success then
        outputServerLog("[CHIVA] warpPedIntoVehicle exitoso en primer intento")
        -- Verificar después de un pequeño delay
        setTimer(function()
            if isElement(player) and isElement(vehicle) then
                local actualVehicle = getPedOccupiedVehicle(player)
                local actualSeat = getPedOccupiedVehicleSeat(player)
                
                if actualVehicle == vehicle and actualSeat == seat then
                    outputChatBox("Te has montado en la chiva (Asiento " .. seat .. ").", player, 0, 255, 0)
                    outputServerLog("[CHIVA] " .. getPlayerName(player) .. " montado exitosamente en asiento " .. seat)
                    triggerClientEvent(player, "chiva:mounted", resourceRoot, true, "Te has montado en la chiva.")
                else
                    outputChatBox("Te has montado en la chiva (Asiento " .. (actualSeat or "desconocido") .. ").", player, 0, 255, 0)
                    triggerClientEvent(player, "chiva:mounted", resourceRoot, true, "Te has montado en la chiva.")
                end
            end
        end, 100, 1)
        return true
    else
        -- Si falla, intentar método alternativo: montar en asiento 1 primero, luego cambiar
        outputServerLog("[CHIVA] Primer intento falló, intentando método alternativo...")
        
        -- Intentar montar en asiento 1 (copiloto) primero
        if warpPedIntoVehicle(player, vehicle, 1) then
            outputServerLog("[CHIVA] Jugador montado en asiento 1, intentando cambiar a asiento " .. seat)
            -- Esperar un momento y cambiar al asiento correcto
            setTimer(function()
                if isElement(player) and isElement(vehicle) then
                    removePedFromVehicle(player)
                    setTimer(function()
                        if isElement(player) and isElement(vehicle) then
                            if warpPedIntoVehicle(player, vehicle, seat) then
                                outputChatBox("Te has montado en la chiva (Asiento " .. seat .. ").", player, 0, 255, 0)
                                outputServerLog("[CHIVA] Método alternativo exitoso, jugador en asiento " .. seat)
                                triggerClientEvent(player, "chiva:mounted", resourceRoot, true, "Te has montado en la chiva.")
                            else
                                -- Si aún falla, intentar con asiento 0
                                if warpPedIntoVehicle(player, vehicle, 0) then
                                    outputChatBox("Te has montado en la chiva como conductor.", player, 0, 255, 0)
                                    triggerClientEvent(player, "chiva:mounted", resourceRoot, true, "Te has montado en la chiva.")
                                else
                                    outputChatBox("Error: No se pudo montar en ningún asiento. El modelo puede no tener estos asientos configurados.", player, 255, 0, 0)
                                    outputServerLog("[CHIVA] Error: Todos los métodos fallaron para asiento " .. seat)
                                    triggerClientEvent(player, "chiva:mounted", resourceRoot, false, "Error al montarte en la chiva.")
                                end
                            end
                        end
                    end, 150, 1)
                end
            end, 150, 1)
            return true
        else
            outputChatBox("Error al montarte en la chiva. Verifica que el vehículo esté detenido y cerca.", player, 255, 0, 0)
            outputServerLog("[CHIVA] Error: warpPedIntoVehicle falló completamente para " .. getPlayerName(player) .. " en asiento " .. seat)
            triggerClientEvent(player, "chiva:mounted", resourceRoot, false, "Error al montarte en la chiva.")
            return false
        end
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
    
    -- Verificar distancia (aumentada para permitir movimiento durante animación)
    local px, py, pz = getElementPosition(player)
    local vx, vy, vz = getElementPosition(vehicle)
    local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
    
    if distance > 8.0 then
        outputChatBox("Estás muy lejos de la chiva. Acércate más.", player, 255, 255, 0)
        outputServerLog("[CHIVA] Distancia demasiado grande: " .. tostring(distance))
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

