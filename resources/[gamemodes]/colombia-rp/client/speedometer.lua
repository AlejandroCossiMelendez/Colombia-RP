-- Sistema de Velocímetro Personalizado Avanzado con DX
-- Mejoras: Optimización, animaciones, efectos visuales y más información

local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100
local speedometerVisible = false
local lastSpeed = 0
local needleSmooth = 0
local fuelWarningActive = false
local fuelWarningTime = 0
local vehicleHealth = 1000
local gear = 0
local odometer = 0
local tripMeter = 0
local lastPositionX, lastPositionY, lastPositionZ = 0, 0, 0

-- Configuración del velocímetro (fácil de personalizar)
local config = {
    position = {x = 0.85, y = 0.85}, -- Posición relativa a la pantalla
    size = {width = 300, height = 350},
    colors = {
        background = {20, 20, 30, 220},
        speedArc = {0, 255, 0, 255},
        rpmArc = {255, 165, 0, 255},
        fuelLow = {255, 50, 50, 255},
        fuelMedium = {255, 165, 0, 255},
        fuelHigh = {0, 200, 0, 255},
        text = {255, 255, 255, 255},
        textSecondary = {180, 180, 180, 220},
        needle = {255, 255, 255, 255},
        healthGood = {0, 255, 0, 255},
        healthMedium = {255, 165, 0, 255},
        healthBad = {255, 50, 50, 255}
    },
    animationSpeed = 0.15, -- Suavizado de aguja (0-1)
    enableShadows = true,
    enableAnimations = true
}

-- Deshabilitar el velocímetro nativo
addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("radar", false)
    
    -- Inicializar posición del jugador para el odómetro
    local x, y, z = getElementPosition(localPlayer)
    lastPositionX, lastPositionY, lastPositionZ = x, y, z
end)

-- Función optimizada para obtener velocidad
function getVehicleSpeedKMH(vehicle)
    if not isElement(vehicle) then return 0 end
    local vx, vy, vz = getElementVelocity(vehicle)
    return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 180)
end

-- Función mejorada para RPM (más realista)
function getVehicleRPM(vehicle)
    if not isElement(vehicle) then return 0 end
    
    local speed = getVehicleSpeedKMH(vehicle)
    local engineState = getVehicleEngineState(vehicle)
    
    if not engineState then return 0 end
    
    -- Simulación más realista de RPM
    local gearRatio = gear > 0 and (1 / gear) or 1
    local rpm = (speed * gearRatio * 50) + math.random(-50, 50)
    
    -- Límites de RPM
    rpm = math.max(800, math.min(8000, rpm))
    
    -- RPM en ralentí cuando está parado
    if speed < 5 then
        rpm = 800 + math.sin(getTickCount() * 0.001) * 50
    end
    
    return math.floor(rpm)
end

-- Función para estimar la marcha
function estimateGear(vehicle, speed)
    if speed < 20 then return 1
    elseif speed < 40 then return 2
    elseif speed < 60 then return 3
    elseif speed < 90 then return 4
    elseif speed < 130 then return 5
    else return 6 end
end

-- Función mejorada para dibujar círculo con relleno
function drawCircle(x, y, radius, color, thickness, segments, filled)
    segments = segments or 32
    thickness = thickness or 2
    
    if filled then
        dxDrawCircle(x, y, radius, color, 0, 360, segments)
    else
        local prevX, prevY = x + radius, y
        for i = 1, segments do
            local angle = (i / segments) * 2 * math.pi
            local newX = x + math.cos(angle) * radius
            local newY = y + math.sin(angle) * radius
            dxDrawLine(prevX, prevY, newX, newY, color, thickness)
            prevX, prevY = newX, newY
        end
    end
end

-- Función para dibujar texto con sombra
function dxDrawTextShadow(text, x, y, width, height, color, scale, font, alignX, alignY)
    if config.enableShadows then
        dxDrawText(text, x + 2, y + 2, width + 2, height + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
    end
    dxDrawText(text, x, y, width, height, color, scale, font, alignX, alignY)
end

-- Función para dibujar barra con gradiente
function drawProgressBar(x, y, width, height, percent, color1, color2)
    local fillWidth = (percent / 100) * width
    
    -- Fondo
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 180), false)
    
    -- Barra de progreso con gradiente
    if fillWidth > 0 then
        for i = 0, fillWidth - 1 do
            local ratio = i / width
            local r = color1[1] + (color2[1] - color1[1]) * ratio
            local g = color1[2] + (color2[2] - color1[2]) * ratio
            local b = color1[3] + (color2[3] - color1[3]) * ratio
            dxDrawRectangle(x + i, y, 1, height, tocolor(r, g, b, 255), false)
        end
    end
    
    -- Borde
    dxDrawRectangle(x, y, width, 1, tocolor(255, 255, 255, 50), false)
    dxDrawRectangle(x, y + height - 1, width, 1, tocolor(255, 255, 255, 50), false)
    dxDrawRectangle(x, y, 1, height, tocolor(255, 255, 255, 50), false)
    dxDrawRectangle(x + width - 1, y, 1, height, tocolor(255, 255, 255, 50), false)
end

-- Función principal para dibujar el velocímetro
function drawSpeedometer()
    if not speedometerVisible or not isInVehicle or not currentVehicle then return end
    
    local screenW, screenH = guiGetScreenSize()
    local speed = getVehicleSpeedKMH(currentVehicle)
    local rpm = getVehicleRPM(currentVehicle)
    local vehicleName = getVehicleName(currentVehicle) or "Vehículo"
    local engineState = getVehicleEngineState(currentVehicle)
    local lightsState = getVehicleOverrideLights(currentVehicle)
    local vehicleFuel = getElementData(currentVehicle, "vehicle:fuel") or fuelLevel
    local health = getElementHealth(currentVehicle)
    
    -- Suavizar la aguja
    local targetAngle = (speed / 200) * 180
    needleSmooth = needleSmooth + (targetAngle - needleSmooth) * config.animationSpeed
    
    -- Calcular posición
    local posX = screenW * config.position.x - config.size.width
    local posY = screenH * config.position.y - config.size.height
    
    -- Dibujar velocímetro
    drawMainSpeedometer(posX, posY, speed, rpm, needleSmooth)
    drawVehicleInfo(posX + 10, posY + 220, vehicleName, speed, rpm, engineState, lightsState, health, vehicleFuel)
    drawFuelGauge(posX + 10, posY + 320, vehicleFuel)
    
    -- Advertencia de gasolina baja
    if vehicleFuel <= 15 then
        drawFuelWarning(posX, posY, screenW, screenH, vehicleFuel)
    end
    
    -- Actualizar odómetro
    updateOdometer()
end

function drawMainSpeedometer(x, y, speed, rpm, needleAngle)
    local centerX = x + 150
    local centerY = y + 100
    local radius = 85
    
    -- Fondo del velocímetro con sombra
    if config.enableShadows then
        drawCircle(centerX + 3, centerY + 3, radius, tocolor(0, 0, 0, 100), 2, 64, true)
    end
    
    -- Fondo principal
    drawCircle(centerX, centerY, radius, tocolor(unpack(config.colors.background)), 2, 64, true)
    
    -- Marcas de velocidad
    for i = 0, 180, 20 do
        local angle = math.rad(-90 + i)
        local length = (i % 40 == 0) and 15 or 8
        local startX = centerX + math.cos(angle) * (radius - 5)
        local startY = centerY + math.sin(angle) * (radius - 5)
        local endX = centerX + math.cos(angle) * (radius - 5 - length)
        local endY = centerY + math.sin(angle) * (radius - 5 - length)
        
        dxDrawLine(startX, startY, endX, endY, tocolor(255, 255, 255, 100), 2)
        
        -- Números cada 40 km/h
        if i % 40 == 0 then
            local textX = centerX + math.cos(angle) * (radius - 25)
            local textY = centerY + math.sin(angle) * (radius - 25)
            dxDrawTextShadow(tostring(i), textX, textY, textX, textY, 
                tocolor(255, 255, 255, 200), 0.7, "default", "center", "center")
        end
    end
    
    -- Arco de RPM
    local rpmPercent = math.min(rpm / 8000, 1.0)
    local rpmAngle = rpmPercent * 180
    drawRPMArc(centerX, centerY, radius - 10, rpmAngle)
    
    -- Aguja principal
    local needleRad = math.rad(-90 + needleAngle)
    local needleEndX = centerX + math.cos(needleRad) * (radius - 20)
    local needleEndY = centerY + math.sin(needleRad) * (radius - 20)
    
    dxDrawLine(centerX, centerY, needleEndX, needleEndY, 
        tocolor(unpack(config.colors.needle)), 4)
    
    -- Centro de la aguja
    drawCircle(centerX, centerY, 8, tocolor(0, 0, 0, 200), 2, 16, true)
    drawCircle(centerX, centerY, 6, tocolor(255, 255, 255, 255), 2, 16, true)
    
    -- Velocidad actual
    dxDrawTextShadow(string.format("%03d", speed), centerX, centerY - 20, centerX, centerY - 20,
        tocolor(255, 255, 255, 255), 2.5, "default-bold", "center", "center")
    dxDrawTextShadow("KM/H", centerX, centerY + 15, centerX, centerY + 15,
        tocolor(180, 180, 180, 200), 0.8, "default", "center", "center")
    
    -- RPM actual
    dxDrawTextShadow("RPM: " .. tostring(rpm), centerX, centerY + 40, centerX, centerY + 40,
        tocolor(255, 165, 0, 255), 0.9, "default-bold", "center", "center")
end

function drawRPMArc(x, y, radius, angle)
    local segments = 32
    local thickness = 6
    
    for i = 0, angle, angle/segments do
        local currentAngle = math.rad(-90 + i)
        local startX = x + math.cos(currentAngle) * radius
        local startY = y + math.sin(currentAngle) * radius
        local endX = x + math.cos(currentAngle) * (radius - thickness)
        local endY = y + math.sin(currentAngle) * (radius - thickness)
        
        -- Color que cambia con las RPM
        local r = 255
        local g = math.max(0, 255 - (i/180)*200)
        local b = 0
        
        dxDrawLine(startX, startY, endX, endY, tocolor(r, g, b, 200), 2)
    end
end

function drawVehicleInfo(x, y, vehicleName, speed, rpm, engineState, lightsState, health, fuel)
    local width = 280
    local height = 90
    
    -- Fondo
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150), false)
    dxDrawRectangle(x + 2, y + 2, width - 4, height - 4, tocolor(20, 20, 30, 200), false)
    
    -- Nombre del vehículo
    dxDrawTextShadow(vehicleName, x + width/2, y + 10, x + width/2, y + 10,
        tocolor(0, 255, 255, 255), 1.2, "default-bold", "center", "top")
    
    -- Información en dos columnas
    local column1X = x + 20
    local column2X = x + width/2 + 10
    
    -- Columna 1
    dxDrawTextShadow("⚡ " .. (engineState and "ENCENDIDO" or "APAGADO"), 
        column1X, y + 35, column1X, y + 35,
        engineState and tocolor(0, 255, 0, 255) or tocolor(255, 50, 50, 255),
        0.9, "default", "left", "top")
    
    dxDrawTextShadow("💡 " .. (lightsState == 2 and "ENCENDIDAS" or "APAGADAS"), 
        column1X, y + 55, column1X, y + 55,
        lightsState == 2 and tocolor(255, 255, 0, 255) or tocolor(180, 180, 180, 200),
        0.9, "default", "left", "top")
    
    -- Columna 2
    gear = estimateGear(currentVehicle, speed)
    dxDrawTextShadow("🎛️  Marcha: " .. (speed > 5 and gear or "N"), 
        column2X, y + 35, column2X, y + 35,
        tocolor(255, 255, 255, 255), 0.9, "default", "left", "top")
    
    local healthPercent = (health/1000)*100
    local healthColor = healthPercent > 70 and config.colors.healthGood or 
                       healthPercent > 30 and config.colors.healthMedium or 
                       config.colors.healthBad
    
    dxDrawTextShadow("🔧 Salud: " .. math.floor(healthPercent) .. "%", 
        column2X, y + 55, column2X, y + 55,
        healthColor, 0.9, "default", "left", "top")
end

function drawFuelGauge(x, y, fuel)
    local width = 280
    local height = 40
    
    -- Fondo
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150), false)
    dxDrawRectangle(x + 2, y + 2, width - 4, height - 4, tocolor(20, 20, 30, 200), false)
    
    -- Icono de gasolina
    dxDrawTextShadow("⛽", x + 10, y + 10, x + 10, y + 10,
        fuel <= 15 and tocolor(255, 50, 50, 255) or tocolor(255, 200, 0, 255),
        1.5, "default", "left", "top")
    
    -- Barra de combustible
    local barX = x + 40
    local barY = y + 15
    local barWidth = 230
    local barHeight = 12
    
    local fuelColor1, fuelColor2
    if fuel <= 15 then
        fuelColor1 = config.colors.fuelLow
        fuelColor2 = {255, 100, 100, 255}
    elseif fuel <= 50 then
        fuelColor1 = config.colors.fuelMedium
        fuelColor2 = {255, 200, 0, 255}
    else
        fuelColor1 = config.colors.fuelHigh
        fuelColor2 = {100, 255, 100, 255}
    end
    
    drawProgressBar(barX, barY, barWidth, barHeight, fuel, fuelColor1, fuelColor2)
    
    -- Porcentaje
    dxDrawTextShadow(math.floor(fuel) .. "%", barX + barWidth/2, barY + barHeight + 5,
        barX + barWidth/2, barY + barHeight + 5, tocolor(255, 255, 255, 255),
        0.8, "default", "center", "top")
    
    -- Odómetro
    dxDrawTextShadow(string.format("ODO: %.1f km", odometer/1000), 
        x + width - 10, y + 5, x + width - 10, y + 5,
        tocolor(180, 180, 180, 200), 0.8, "default", "right", "top")
end

function drawFuelWarning(x, y, screenW, screenH, fuel)
    local currentTime = getTickCount()
    
    -- Efecto de parpadeo cada 500ms cuando está muy bajo
    if fuel <= 5 and currentTime % 1000 < 500 then
        dxDrawRectangle(0, 0, screenW, screenH, tocolor(255, 0, 0, 50), false)
        
        dxDrawText("⚠ GASOLINA MUY BAJA ⚠", 
            screenW/2, screenH/2 - 50, screenW/2, screenH/2 - 50,
            tocolor(255, 50, 50, 255), 2.0, "default-bold", "center", "center", true)
        
        dxDrawText("Busca una gasolinera pronto!", 
            screenW/2, screenH/2 + 20, screenW/2, screenH/2 + 20,
            tocolor(255, 255, 255, 200), 1.2, "default", "center", "center", true)
    elseif fuel <= 15 then
        dxDrawText("Gasolina baja", 
            screenW/2, 100, screenW/2, 100,
            tocolor(255, 165, 0, 200), 1.5, "default-bold", "center", "center", true)
    end
end

function updateOdometer()
    if not isInVehicle or not currentVehicle then return end
    
    local x, y, z = getElementPosition(currentVehicle)
    local distance = getDistanceBetweenPoints3D(lastPositionX, lastPositionY, lastPositionZ, x, y, z)
    
    odometer = odometer + distance
    tripMeter = tripMeter + distance
    
    lastPositionX, lastPositionY, lastPositionZ = x, y, z
end

-- Sistema de actualización optimizado
local lastUpdate = 0
function updateSpeedometer()
    local currentTime = getTickCount()
    if currentTime - lastUpdate < 50 then return end -- Actualizar cada 50ms
    lastUpdate = currentTime
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle then
        local seat = getPedOccupiedVehicleSeat(localPlayer)
        if seat == 0 then
            if not isInVehicle or vehicle ~= currentVehicle then
                isInVehicle = true
                currentVehicle = vehicle
                speedometerVisible = true
                triggerServerEvent("speedometer:getVehicleData", localPlayer, vehicle)
            end
            
            -- Actualizar salud del vehículo
            vehicleHealth = getElementHealth(vehicle)
        end
    elseif isInVehicle then
        isInVehicle = false
        currentVehicle = nil
        speedometerVisible = false
    end
end

-- Eventos optimizados
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = true
        currentVehicle = vehicle
        speedometerVisible = true
        needleSmooth = 0
        triggerServerEvent("speedometer:getVehicleData", localPlayer, vehicle)
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = false
        currentVehicle = nil
        speedometerVisible = false
    end
end)

-- Receptor de datos del servidor
addEvent("speedometer:receiveVehicleData", true)
addEventHandler("speedometer:receiveVehicleData", root, function(fuel, odometerValue)
    fuelLevel = fuel or 100
    odometer = odometerValue or odometer
    
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
        setElementData(currentVehicle, "vehicle:odometer", odometer)
    end
end)

-- Actualización en tiempo real
addEvent("speedometer:updateFuel", true)
addEventHandler("speedometer:updateFuel", root, function(fuel)
    fuelLevel = fuel or fuelLevel
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

-- Comandos de depuración (opcional)
addCommandHandler("resetodo", function()
    odometer = 0
    tripMeter = 0
    outputChatBox("Odómetro reiniciado", 0, 255, 0)
end)

addCommandHandler("trip", function()
    outputChatBox("Viaje actual: " .. string.format("%.2f", tripMeter/1000) .. " km", 0, 255, 255)
    tripMeter = 0
end)

-- Limpieza
addEventHandler("onClientResourceStop", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", true)
    setPlayerHudComponentVisible("area_name", true)
    setPlayerHudComponentVisible("radar", true)
end)

-- Iniciar el sistema
setTimer(updateSpeedometer, 50, 0)
addEventHandler("onClientRender", root, drawSpeedometer)