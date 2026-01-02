-- Sistema de Velocímetro Personalizado y Gasolina con DX
-- Deshabilita el velocímetro nativo y crea uno personalizado con dibujo directo

local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100 -- Nivel de gasolina (0-100)
local speedometerVisible = false

-- Deshabilitar el velocímetro nativo del juego
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Deshabilitar el componente de nombre de vehículo (velocímetro nativo)
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("area_name", false)
end)

-- Función para obtener la velocidad del vehículo en km/h
function getVehicleSpeedKMH(vehicle)
    if not vehicle or not isElement(vehicle) then
        return 0
    end
    
    local vx, vy, vz = getElementVelocity(vehicle)
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180 -- Convertir a km/h
    return math.floor(speed)
end

-- Función para obtener las RPM del vehículo (simulado)
function getVehicleRPM(vehicle)
    if not vehicle or not isElement(vehicle) then
        return 0
    end
    
    local speed = getVehicleSpeedKMH(vehicle)
    local model = getElementModel(vehicle)
    local maxSpeed = 150 -- Velocidad máxima por defecto
    
    local rpm = (speed / maxSpeed) * 8000 -- RPM máximo simulado: 8000
    return math.floor(math.max(0, math.min(8000, rpm)))
end

-- Función para obtener el nombre del vehículo
function getVehicleDisplayName(vehicle)
    if not vehicle or not isElement(vehicle) then
        return ""
    end
    
    local model = getElementModel(vehicle)
    local name = getVehicleNameFromModel(model)
    return name or "Vehículo"
end

-- Función auxiliar para dibujar un círculo usando líneas
function drawCircle(x, y, radius, color, segments)
    segments = segments or 32
    local prevX, prevY = x + radius, y
    for i = 1, segments do
        local angle = (i / segments) * 2 * math.pi
        local newX = x + math.cos(angle) * radius
        local newY = y + math.sin(angle) * radius
        dxDrawLine(prevX, prevY, newX, newY, color, 2)
        prevX, prevY = newX, newY
    end
end

-- Función auxiliar para dibujar un arco
function drawArc(x, y, radius, startAngle, endAngle, color, thickness, segments)
    segments = segments or 32
    thickness = thickness or 2
    local angleStep = (endAngle - startAngle) / segments
    for i = 0, segments do
        local angle = math.rad(startAngle + (i * angleStep))
        local x1 = x + math.cos(angle) * radius
        local y1 = y + math.sin(angle) * radius
        local x2 = x + math.cos(angle) * (radius - thickness)
        local y2 = y + math.sin(angle) * (radius - thickness)
        dxDrawLine(x1, y1, x2, y2, color, thickness)
    end
end

-- Función para dibujar el velocímetro
function drawSpeedometer()
    if not speedometerVisible or not isInVehicle or not currentVehicle then
        return
    end
    
    local screenW, screenH = guiGetScreenSize()
    local speed = getVehicleSpeedKMH(currentVehicle)
    local rpm = getVehicleRPM(currentVehicle)
    local vehicleName = getVehicleDisplayName(currentVehicle)
    local engineState = getVehicleEngineState(currentVehicle)
    local lightsState = getVehicleOverrideLights(currentVehicle)
    local vehicleFuel = getElementData(currentVehicle, "vehicle:fuel") or fuelLevel
    
    -- Posición del velocímetro (esquina inferior derecha)
    local posX = screenW - 250
    local posY = screenH - 280
    
    -- Fondo del velocímetro principal (círculo)
    local centerX = posX + 100
    local centerY = posY + 100
    local radius = 90
    
    -- Fondo del círculo (semitransparente)
    drawCircle(centerX, centerY, radius, tocolor(20, 20, 30, 200), 64)
    drawCircle(centerX, centerY, radius - 2, tocolor(0, 0, 0, 180), 64)
    
    -- Arco de velocidad (verde) - semicírculo superior
    local speedPercent = math.min(speed / 200, 1.0)
    local speedAngle = speedPercent * 180 -- 0 a 180 grados
    if speedAngle > 0 then
        drawArc(centerX, centerY, radius - 5, -90, -90 + speedAngle, tocolor(0, 255, 0, 255), 6, 32)
    end
    
    -- Arco de RPM (amarillo/naranja) - interior
    local rpmPercent = math.min(rpm / 8000, 1.0)
    local rpmAngle = rpmPercent * 180
    if rpmAngle > 0 then
        drawArc(centerX, centerY, radius - 8, -90, -90 + rpmAngle, tocolor(255, 170, 0, 255), 4, 32)
    end
    
    -- Aguja de velocidad
    local needleAngle = math.rad(-90 + speedAngle)
    local needleLength = radius - 20
    local needleEndX = centerX + math.cos(needleAngle) * needleLength
    local needleEndY = centerY + math.sin(needleAngle) * needleLength
    dxDrawLine(centerX, centerY, needleEndX, needleEndY, tocolor(255, 255, 255, 255), 3)
    
    -- Centro del velocímetro (círculo pequeño)
    drawCircle(centerX, centerY, 8, tocolor(255, 255, 255, 255), 16)
    dxDrawRectangle(centerX - 6, centerY - 6, 12, 12, tocolor(26, 26, 26, 255), false)
    
    -- Velocidad en texto (grande)
    local speedText = tostring(speed)
    dxDrawText(speedText, centerX, centerY - 15, centerX, centerY - 15, tocolor(255, 255, 255, 255), 2.0, "default-bold", "center", "center", false, false, false, false, false)
    dxDrawText("KM/H", centerX, centerY + 10, centerX, centerY + 10, tocolor(200, 200, 200, 200), 0.8, "default", "center", "center", false, false, false, false, false)
    
    -- Información del vehículo (debajo del velocímetro)
    local infoY = posY + 200
    local infoWidth = 200
    local infoHeight = 80
    
    -- Fondo de la información
    dxDrawRectangle(posX, infoY, infoWidth, infoHeight, tocolor(0, 0, 0, 180), false)
    dxDrawRectangle(posX + 2, infoY + 2, infoWidth - 4, infoHeight - 4, tocolor(20, 20, 30, 220), false)
    
    -- Nombre del vehículo
    dxDrawText(vehicleName, posX + infoWidth / 2, infoY + 5, posX + infoWidth / 2, infoY + 5, tocolor(0, 255, 0, 255), 1.0, "default-bold", "center", "top", false, false, false, false, false)
    
    -- RPM
    dxDrawText("RPM: " .. tostring(rpm), posX + 10, infoY + 25, posX + 10, infoY + 25, tocolor(255, 255, 255, 255), 0.9, "default", "left", "top", false, false, false, false, false)
    
    -- Estado del motor
    local engineColor = engineState and tocolor(0, 255, 0, 255) or tocolor(255, 0, 0, 255)
    local engineText = engineState and "ON" or "OFF"
    dxDrawText("⚡ " .. engineText, posX + 10, infoY + 45, posX + 10, infoY + 45, engineColor, 0.9, "default", "left", "top", false, false, false, false, false)
    
    -- Estado de las luces
    local lightsColor = (lightsState == 2) and tocolor(255, 255, 0, 255) or tocolor(200, 200, 200, 200)
    local lightsText = (lightsState == 2) and "ON" or "OFF"
    dxDrawText("💡 " .. lightsText, posX + 100, infoY + 45, posX + 100, infoY + 45, lightsColor, 0.9, "default", "left", "top", false, false, false, false, false)
    
    -- Indicador de Gasolina (debajo de la información)
    local fuelY = infoY + infoHeight + 10
    local fuelWidth = 200
    local fuelHeight = 50
    
    -- Fondo del indicador de gasolina
    dxDrawRectangle(posX, fuelY, fuelWidth, fuelHeight, tocolor(0, 0, 0, 180), false)
    dxDrawRectangle(posX + 2, fuelY + 2, fuelWidth - 4, fuelHeight - 4, tocolor(20, 20, 30, 220), false)
    
    -- Icono de gasolina
    dxDrawText("⛽", posX + 15, fuelY + 10, posX + 15, fuelY + 10, tocolor(255, 200, 0, 255), 1.5, "default", "left", "top", false, false, false, false, false)
    
    -- Barra de gasolina
    local fuelBarX = posX + 45
    local fuelBarY = fuelY + 15
    local fuelBarWidth = 140
    local fuelBarHeight = 20
    local fuelPercent = math.max(0, math.min(100, vehicleFuel))
    
    -- Fondo de la barra
    dxDrawRectangle(fuelBarX, fuelBarY, fuelBarWidth, fuelBarHeight, tocolor(0, 0, 0, 200), false)
    
    -- Barra de gasolina (con gradiente de color)
    local fuelBarFillWidth = (fuelPercent / 100) * fuelBarWidth
    local fuelColor
    if fuelPercent <= 20 then
        fuelColor = tocolor(255, 0, 0, 255) -- Rojo
    elseif fuelPercent <= 50 then
        fuelColor = tocolor(255, 170, 0, 255) -- Naranja
    else
        fuelColor = tocolor(0, 255, 0, 255) -- Verde
    end
    
    dxDrawRectangle(fuelBarX, fuelBarY, fuelBarFillWidth, fuelBarHeight, fuelColor, false)
    
    -- Borde de la barra
    dxDrawRectangle(fuelBarX, fuelBarY, fuelBarWidth, fuelBarHeight, tocolor(255, 255, 255, 50), false)
    
    -- Porcentaje de gasolina
    dxDrawText(math.floor(fuelPercent) .. "%", fuelBarX + fuelBarWidth / 2, fuelBarY + fuelBarHeight + 5, fuelBarX + fuelBarWidth / 2, fuelBarY + fuelBarHeight + 5, tocolor(255, 255, 255, 255), 0.8, "default", "center", "top", false, false, false, false, false)
end

-- Actualizar estado del velocímetro
function updateSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle and vehicle ~= currentVehicle then
        -- Jugador entró a un vehículo
        isInVehicle = true
        currentVehicle = vehicle
        speedometerVisible = true
        
        -- Cargar gasolina del vehículo desde el servidor
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    elseif not vehicle and isInVehicle then
        -- Jugador salió del vehículo
        isInVehicle = false
        currentVehicle = nil
        speedometerVisible = false
    end
end

-- Timer para actualizar el estado
setTimer(updateSpeedometer, 100, 0)

-- Renderizar el velocímetro
addEventHandler("onClientRender", root, drawSpeedometer)

-- Evento cuando el jugador entra/sale de un vehículo
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then -- Solo si es el conductor
        isInVehicle = true
        currentVehicle = vehicle
        speedometerVisible = true
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = false
        currentVehicle = nil
        speedometerVisible = false
    end
end)

-- Evento para recibir el nivel de gasolina del servidor
addEvent("speedometer:receiveFuel", true)
addEventHandler("speedometer:receiveFuel", root, function(fuel)
    fuelLevel = fuel or 100
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

-- Evento para actualizar la gasolina cuando cambia
addEvent("speedometer:updateFuel", true)
addEventHandler("speedometer:updateFuel", root, function(fuel)
    fuelLevel = fuel or fuelLevel
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

-- Limpiar al detener el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    -- Restaurar el velocímetro nativo
    setPlayerHudComponentVisible("vehicle_name", true)
    setPlayerHudComponentVisible("area_name", true)
end)
