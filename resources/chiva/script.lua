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
        outputChatBox("[CHIVA DEBUG] Vehículo inválido en getNextAvailableSeat", 255, 0, 0)
        return nil
    end
    
    -- Para la chiva personalizada, usamos asientos 2-9 sin validar maxPassengers
    -- porque el modelo personalizado tiene más asientos de los que MTA reconoce
    
    -- Si hay un asiento preferido específico, intentar usarlo primero
    if preferredSeat and preferredSeat >= 2 and preferredSeat <= 9 then
        outputChatBox("[CHIVA DEBUG] Intentando asiento preferido: " .. tostring(preferredSeat), 255, 255, 0)
        local occupant = getVehicleOccupant(vehicle, preferredSeat)
        if not occupant or occupant == false then
            outputChatBox("[CHIVA DEBUG] Asiento preferido disponible: " .. tostring(preferredSeat), 0, 255, 0)
            return preferredSeat
        else
            outputChatBox("[CHIVA DEBUG] Asiento preferido ocupado: " .. tostring(preferredSeat), 255, 255, 0)
        end
    end
    
    -- Primero buscar en el lado preferido
    if preferredSide then
        outputChatBox("[CHIVA DEBUG] Buscando en lado: " .. tostring(preferredSide), 255, 255, 0)
        for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
            local seat = seatConfig.seat
            if seatConfig.side == preferredSide then
                local occupant = getVehicleOccupant(vehicle, seat)
                outputChatBox("[CHIVA DEBUG] Asiento " .. seat .. " ocupado: " .. tostring(occupant ~= false and occupant ~= nil), 255, 255, 0)
                if not occupant or occupant == false then
                    outputChatBox("[CHIVA DEBUG] Asiento disponible encontrado: " .. seat, 0, 255, 0)
                    return seat
                end
            end
        end
    end
    
    -- Si no hay disponibles en el lado preferido, buscar en cualquier lado
    outputChatBox("[CHIVA DEBUG] Buscando en cualquier lado...", 255, 255, 0)
    for _, seatConfig in ipairs(CHIVA_SEATS_CONFIG) do
        local seat = seatConfig.seat
        local occupant = getVehicleOccupant(vehicle, seat)
        if not occupant or occupant == false then
            outputChatBox("[CHIVA DEBUG] Asiento disponible encontrado: " .. seat, 0, 255, 0)
            return seat
        end
    end
    
    outputChatBox("[CHIVA DEBUG] No se encontraron asientos disponibles", 255, 0, 0)
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
        outputChatBox("[CHIVA DEBUG] Vehículo inválido", 255, 0, 0)
        return false
    end
    
    outputChatBox("[CHIVA DEBUG] Intentando montar en chiva...", 255, 255, 0)
    
    -- Si no se especifica asiento, detectar la puerta más cercana y asignar asiento correspondiente
    if not seat then
        local playerSide, preferredSeat = detectNearestDoorAndSeat(player, vehicle)
        outputChatBox("[CHIVA DEBUG] Lado detectado: " .. tostring(playerSide) .. ", Asiento preferido: " .. tostring(preferredSeat), 255, 255, 0)
        
        seat = getNextAvailableSeat(vehicle, playerSide, preferredSeat)
        
        if not seat then
            outputChatBox("[CHIVA DEBUG] getNextAvailableSeat retornó nil", 255, 0, 0)
            outputChatBox("La chiva está llena. No hay asientos disponibles.", player, 255, 255, 0)
            return false
        end
        
        outputChatBox("[CHIVA DEBUG] Asiento asignado: " .. tostring(seat), 0, 255, 0)
    else
        outputChatBox("[CHIVA DEBUG] Usando asiento proporcionado: " .. tostring(seat), 0, 255, 0)
    end
    
    -- Verificar que el asiento esté disponible
    local occupant = getVehicleOccupant(vehicle, seat)
    outputChatBox("[CHIVA DEBUG] Verificando asiento " .. seat .. ", ocupante: " .. tostring(occupant), 255, 255, 0)
    if occupant and occupant ~= false then
        outputChatBox("Este asiento está ocupado.", player, 255, 0, 0)
        return false
    end
    
    outputChatBox("[CHIVA DEBUG] Verificando configuración del asiento " .. tostring(seat), 255, 255, 0)
    
    -- Obtener la configuración del asiento para ajustar la posición
    local seatConfig = nil
    local seatSide = nil
    for _, config in ipairs(CHIVA_SEATS_CONFIG) do
        if config.seat == seat then
            seatConfig = config
            seatSide = config.side
            outputChatBox("[CHIVA DEBUG] Configuración encontrada para asiento " .. seat .. ", lado: " .. tostring(seatSide), 0, 255, 0)
            break
        end
    end
    
    -- Si no encontramos la configuración, detectar el lado
    if not seatSide then
        outputChatBox("[CHIVA DEBUG] No se encontró configuración, detectando lado...", 255, 255, 0)
        seatSide, _ = detectNearestDoorAndSeat(player, vehicle)
        outputChatBox("[CHIVA DEBUG] Lado detectado: " .. tostring(seatSide), 255, 255, 0)
    end
    
    outputChatBox("[CHIVA DEBUG] Calculando posición ajustada...", 255, 255, 0)
    
    -- Calcular posición ajustada (más hacia adentro)
    local vx, vy, vz = getElementPosition(vehicle)
    local vrx, vry, vrz = getElementRotation(vehicle)
    local angle = math.rad(vrz)
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)
    
    -- Ajustar offset para que sea más hacia adentro (reducir offsetY en 0.5-1.0 unidades)
    local offsetX = seatConfig and seatConfig.offsetX or 0
    local offsetY = seatConfig and (seatConfig.offsetY * 0.7) or 0  -- Reducir 30% para acercar más
    
    outputChatBox("[CHIVA DEBUG] Offset X: " .. tostring(offsetX) .. ", Y: " .. tostring(offsetY), 255, 255, 0)
    
    -- Rotar el offset según la rotación del vehículo
    local rotatedX = offsetX * cosAngle - offsetY * sinAngle
    local rotatedY = offsetX * sinAngle + offsetY * cosAngle
    
    -- Calcular posición mundial ajustada
    local targetX = vx + rotatedX
    local targetY = vy + rotatedY
    local targetZ = vz + 0.5  -- Un poco más arriba
    
    -- Verificar distancia antes de proceder
    local px, py, pz = getElementPosition(player)
    local distance = getDistanceBetweenPoints3D(px, py, pz, targetX, targetY, targetZ)
    
    -- Solo ajustar posición si está muy lejos (más de 1.5 unidades)
    -- Asegurarse de que el jugador no esté dentro de un vehículo antes de moverlo
    if distance > 1.5 and not getPedOccupiedVehicle(player) then
        -- Mover al jugador hacia la posición
        setElementPosition(player, targetX, targetY, targetZ)
        outputChatBox("[CHIVA DEBUG] Posición ajustada, distancia: " .. string.format("%.2f", distance), 255, 255, 0)
    else
        outputChatBox("[CHIVA DEBUG] Jugador ya está cerca o en vehículo, distancia: " .. string.format("%.2f", distance), 255, 255, 0)
    end
    
    -- Hacer que el jugador mire hacia el vehículo (solo si no está en un vehículo)
    if not getPedOccupiedVehicle(player) then
        local lookAtX = vx
        local lookAtY = vy
        local lookAngle = math.deg(math.atan2(lookAtY - targetY, lookAtX - targetX))
        setPedRotation(player, lookAngle)
    end
    
    -- Congelar al jugador durante la animación
    toggleControl(player, "forwards", false)
    toggleControl(player, "backwards", false)
    toggleControl(player, "left", false)
    toggleControl(player, "right", false)
    toggleControl(player, "sprint", false)
    toggleControl(player, "jump", false)
    
    -- Determinar qué animación usar según el lado
    local openAnim = "CAR_open_LHS"  -- Por defecto izquierda
    local sitAnim = "CAR_pullout_LHS"
    
    if seatSide == "right" then
        openAnim = "CAR_open_RHS"
        sitAnim = "CAR_pullout_RHS"
    end
    
    outputChatBox("[CHIVA DEBUG] Animación seleccionada: " .. openAnim, 255, 255, 0)
    
    -- Función para restaurar controles
    local function restoreControls()
        if isElement(player) then
            toggleControl(player, "forwards", true)
            toggleControl(player, "backwards", true)
            toggleControl(player, "left", true)
            toggleControl(player, "right", true)
            toggleControl(player, "sprint", true)
            toggleControl(player, "jump", true)
        end
    end
    
    outputChatBox("[CHIVA DEBUG] Iniciando animación...", 0, 255, 0)
    
    -- Reproducir animación de abrir puerta y sentarse
    -- Animación de abrir puerta de vehículo
    setPedAnimation(player, "ped", openAnim, 1000, false, false, false, false)
    
    -- Después de abrir la puerta, animación de sentarse
    setTimer(function()
        if not isElement(player) or not isElement(vehicle) then
            restoreControls()
            return
        end
        
        -- Verificar que aún esté cerca del vehículo
        local px, py, pz = getElementPosition(player)
        local vx, vy, vz = getElementPosition(vehicle)
        local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
        
        if distance > 8.0 then
            outputChatBox("Te alejaste demasiado de la chiva.", player, 255, 255, 0)
            restoreControls()
            setPedAnimation(player, nil)
            return
        end
        
        -- Animación de sentarse arriba
        setPedAnimation(player, "ped", sitAnim, 1500, false, false, false, false)
        
        -- Después de la animación, montar al jugador
        setTimer(function()
            if not isElement(player) or not isElement(vehicle) then
                restoreControls()
                return
            end
        
            -- Verificar distancia nuevamente
            local px2, py2, pz2 = getElementPosition(player)
            local vx2, vy2, vz2 = getElementPosition(vehicle)
            local distance2 = getDistanceBetweenPoints3D(px2, py2, pz2, vx2, vy2, vz2)
            
            if distance2 > 8.0 then
                outputChatBox("Te alejaste demasiado de la chiva.", player, 255, 255, 0)
                restoreControls()
                setPedAnimation(player, nil)
                return
            end
            
            -- Detener animación
            setPedAnimation(player, nil)
            
            -- Restaurar controles
            restoreControls()
            
            -- Enviar al servidor para montar al jugador (warpPedIntoVehicle es función del servidor)
            outputChatBox("[CHIVA DEBUG] Enviando evento al servidor...", 255, 255, 0)
            triggerServerEvent("chiva:requestMount", player, vehicle, seat)
        end, 1500, 1)
    end, 1000, 1)
    
    return true
end

-- BindKey para presionar G y montarse
bindKey("g", "down", function()
    local player = localPlayer
    
    -- Debug
    outputChatBox("[DEBUG] Tecla G presionada", 255, 255, 0)
    
    -- Verificar si ya está en un vehículo
    if getPedOccupiedVehicle(player) then
        outputChatBox("[DEBUG] Ya estás en un vehículo", 255, 255, 0)
        return
    end
    
    -- Buscar chiva cercana
    local chiva = getNearbyChiva(player, 3.5)
    if chiva then
        outputChatBox("[DEBUG] Chiva encontrada, intentando montar...", 0, 255, 0)
        -- Montar al jugador en el siguiente asiento disponible
        mountPlayerInChiva(player, chiva)
    else
        -- Mostrar mensaje si no hay chiva cerca
        outputChatBox("Acércate a una chiva y presiona G para montarte.", 255, 255, 0)
        outputChatBox("[DEBUG] No se encontró chiva cercana", 255, 0, 0)
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
