-- ============================================
-- Sistema de Velocímetro Personalizado Avanzado
-- Diseño profesional y elaborado con DX
-- ============================================

-- ============================================
-- CONFIGURACIÓN Y VARIABLES GLOBALES
-- ============================================
local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100
local speedometerVisible = false
local lastSpeed = 0
local smoothSpeed = 0
local smoothRPM = 0

-- Configuración visual
local CONFIG = {
    position = {x = 0.85, y = 0.85}, -- Posición relativa (0-1)
    size = {width = 280, height = 400},
    colors = {
        background = {10, 10, 20, 240},
        backgroundSecondary = {20, 25, 35, 250},
        border = {0, 255, 100, 200},
        speedArc = {0, 255, 100, 255},
        speedArcSecondary = {0, 200, 80, 200},
        rpmArc = {255, 150, 0, 255},
        rpmArcSecondary = {255, 200, 0, 200},
        dangerZone = {255, 0, 0, 255},
        needle = {255, 255, 255, 255},
        text = {255, 255, 255, 255},
        textSecondary = {200, 200, 200, 200},
        fuelHigh = {0, 255, 100, 255},
        fuelMedium = {255, 150, 0, 255},
        fuelLow = {255, 0, 0, 255},
        engineOn = {0, 255, 100, 255},
        engineOff = {255, 50, 50, 255},
        lightsOn = {255, 255, 0, 255},
        lightsOff = {150, 150, 150, 200}
    },
    animationSpeed = 0.1, -- Suavizado (0-1)
    enableShadows = true,
    enableAnimations = true
}

-- ============================================
-- INICIALIZACIÓN
-- ============================================
addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("area_name", false)
end)

-- ============================================
-- FUNCIONES DE UTILIDAD
-- ============================================

-- Obtener velocidad en km/h
function getVehicleSpeedKMH(vehicle)
    if not vehicle or not isElement(vehicle) then return 0 end
    local vx, vy, vz = getElementVelocity(vehicle)
    return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 180)
end

-- Obtener RPM (simulado)
function getVehicleRPM(vehicle)
    if not vehicle or not isElement(vehicle) then return 0 end
    local speed = getVehicleSpeedKMH(vehicle)
    local engineState = getVehicleEngineState(vehicle)
    if not engineState then return 0 end
    
    local maxSpeed = 200
    local rpm = (speed / maxSpeed) * 8000
    rpm = math.max(800, math.min(8000, rpm))
    
    -- RPM en ralentí
    if speed < 5 then
        rpm = 800 + math.sin(getTickCount() * 0.001) * 50
    end
    
    return math.floor(rpm)
end

-- Obtener nombre del vehículo
function getVehicleDisplayName(vehicle)
    if not vehicle or not isElement(vehicle) then return "Vehículo" end
    local model = getElementModel(vehicle)
    return getVehicleNameFromModel(model) or "Vehículo"
end

-- Estimar marcha
function estimateGear(vehicle, speed)
    if speed < 15 then return 1
    elseif speed < 35 then return 2
    elseif speed < 55 then return 3
    elseif speed < 85 then return 4
    elseif speed < 130 then return 5
    else return 6 end
end

-- ============================================
-- FUNCIONES DE DIBUJO
-- ============================================

-- Dibujar círculo
function drawCircle(x, y, radius, color, thickness, segments)
    segments = segments or 64
    thickness = thickness or 1
    local prevX, prevY = x + radius, y
    for i = 1, segments do
        local angle = (i / segments) * 2 * math.pi
        local newX = x + math.cos(angle) * radius
        local newY = y + math.sin(angle) * radius
        dxDrawLine(prevX, prevY, newX, newY, color, thickness)
        prevX, prevY = newX, newY
    end
end

-- Dibujar arco
function drawArc(x, y, radius, startAngle, endAngle, color, thickness, segments)
    segments = segments or 64
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

-- Dibujar texto con sombra
function drawTextWithShadow(text, x, y, color, scale, font, alignX, alignY)
    if CONFIG.enableShadows then
        dxDrawText(text, x + 2, y + 2, x + 2, y + 2, tocolor(0, 0, 0, 200), scale, font, alignX, alignY, false, false, false, false, false)
    end
    dxDrawText(text, x, y, x, y, color, scale, font, alignX, alignY, false, false, false, false, false)
end

-- Dibujar rectángulo con borde
function drawBorderedRectangle(x, y, width, height, bgColor, borderColor, borderWidth)
    borderWidth = borderWidth or 2
    dxDrawRectangle(x, y, width, height, bgColor, false)
    if borderColor then
        dxDrawRectangle(x, y, width, borderWidth, borderColor, false) -- Top
        dxDrawRectangle(x, y + height - borderWidth, width, borderWidth, borderColor, false) -- Bottom
        dxDrawRectangle(x, y, borderWidth, height, borderColor, false) -- Left
        dxDrawRectangle(x + width - borderWidth, y, borderWidth, height, borderColor, false) -- Right
    end
end

-- ============================================
-- COMPONENTES DEL VELOCÍMETRO
-- ============================================

-- Velocímetro principal (círculo)
function drawSpeedometerGauge(centerX, centerY, radius, speed, rpm)
    -- Fondo exterior (sombra)
    if CONFIG.enableShadows then
        drawCircle(centerX + 2, centerY + 2, radius + 2, tocolor(0, 0, 0, 150), 1, 64)
    end
    
    -- Fondo principal (múltiples capas para profundidad)
    drawCircle(centerX, centerY, radius, tocolor(15, 15, 25, 240), 3, 64)
    drawCircle(centerX, centerY, radius - 3, tocolor(25, 25, 35, 250), 2, 64)
    drawCircle(centerX, centerY, radius - 8, tocolor(10, 10, 20, 200), 1, 64)
    
    -- Marcas del velocímetro (0-200 km/h)
    for i = 0, 200, 10 do
        local angle = math.rad(-90 + (i / 200) * 180)
        local markLength = (i % 20 == 0) and ((i % 40 == 0) and 14 or 10) or 6
        local markRadius = radius - 8
        local x1 = centerX + math.cos(angle) * markRadius
        local y1 = centerY + math.sin(angle) * markRadius
        local x2 = centerX + math.cos(angle) * (markRadius - markLength)
        local y2 = centerY + math.sin(angle) * (markRadius - markLength)
        local markColor = (i % 40 == 0) and tocolor(200, 200, 200, 255) or tocolor(150, 150, 150, 180)
        dxDrawLine(x1, y1, x2, y2, markColor, (i % 40 == 0) and 2 or 1)
        
        -- Números cada 40 km/h
        if i % 40 == 0 and i > 0 then
            local textX = centerX + math.cos(angle) * (markRadius - 28)
            local textY = centerY + math.sin(angle) * (markRadius - 28)
            drawTextWithShadow(tostring(i), textX, textY, tocolor(220, 220, 220, 255), 0.65, "default-bold", "center", "center")
        end
    end
    
    -- Arco de velocidad (verde)
    local speedPercent = math.min(speed / 200, 1.0)
    local speedAngle = speedPercent * 180
    if speedAngle > 0 then
        drawArc(centerX, centerY, radius - 5, -90, -90 + speedAngle, tocolor(unpack(CONFIG.colors.speedArc)), 8, 64)
        drawArc(centerX, centerY, radius - 3, -90, -90 + speedAngle, tocolor(unpack(CONFIG.colors.speedArcSecondary)), 4, 64)
    end
    
    -- Zona de peligro (rojo) cuando velocidad > 85%
    if speedPercent > 0.85 then
        local dangerAngle = (speedPercent - 0.85) * 180 / 0.15
        drawArc(centerX, centerY, radius - 5, -90 + (0.85 * 180), -90 + speedAngle, tocolor(unpack(CONFIG.colors.dangerZone)), 8, 32)
    end
    
    -- Arco de RPM (naranja/amarillo)
    local rpmPercent = math.min(rpm / 8000, 1.0)
    local rpmAngle = rpmPercent * 180
    if rpmAngle > 0 then
        -- Color dinámico según RPM
        local r = 255
        local g = math.max(0, 255 - (rpmPercent * 200))
        local b = 0
        drawArc(centerX, centerY, radius - 12, -90, -90 + rpmAngle, tocolor(r, g, b, 255), 5, 64)
        drawArc(centerX, centerY, radius - 10, -90, -90 + rpmAngle, tocolor(255, 200, 0, 200), 3, 64)
    end
    
    -- Aguja de velocidad (suavizada)
    local needleAngle = math.rad(-90 + smoothSpeed)
    local needleLength = radius - 25
    local needleEndX = centerX + math.cos(needleAngle) * needleLength
    local needleEndY = centerY + math.sin(needleAngle) * needleLength
    
    -- Aguja principal
    dxDrawLine(centerX, centerY, needleEndX, needleEndY, tocolor(unpack(CONFIG.colors.needle)), 4)
    -- Aguja secundaria (efecto 3D)
    local needleEndX2 = centerX + math.cos(needleAngle) * (needleLength - 6)
    local needleEndY2 = centerY + math.sin(needleAngle) * (needleLength - 6)
    dxDrawLine(centerX, centerY, needleEndX2, needleEndY2, tocolor(200, 200, 200, 200), 2)
    
    -- Centro del velocímetro
    drawCircle(centerX, centerY, 12, tocolor(255, 255, 255, 255), 2, 16)
    dxDrawRectangle(centerX - 10, centerY - 10, 20, 20, tocolor(20, 20, 30, 255), false)
    drawCircle(centerX, centerY, 7, tocolor(50, 50, 60, 255), 1, 16)
    
    -- Velocidad en texto (grande)
    local speedText = string.format("%03d", speed)
    drawTextWithShadow(speedText, centerX, centerY - 25, tocolor(unpack(CONFIG.colors.text)), 2.8, "default-bold", "center", "center")
    drawTextWithShadow("KM/H", centerX, centerY + 18, tocolor(unpack(CONFIG.colors.textSecondary)), 0.95, "default", "center", "center")
    
    -- RPM en texto (debajo del velocímetro)
    local rpmText = "RPM: " .. tostring(rpm):gsub("(%d)(%d%d%d)$", "%1,%2")
    drawTextWithShadow(rpmText, centerX, centerY + 45, tocolor(255, 150, 0, 255), 1.0, "default-bold", "center", "center")
end

-- Panel de información del vehículo
function drawVehicleInfo(x, y, width, height, vehicleName, rpm, engineState, lightsState, health, gear)
    -- Fondo con borde
    drawBorderedRectangle(x, y, width, height, tocolor(unpack(CONFIG.colors.background)), tocolor(unpack(CONFIG.colors.border)), 3)
    dxDrawRectangle(x + 2, y + 2, width - 4, height - 4, tocolor(unpack(CONFIG.colors.backgroundSecondary)), false)
    
    -- Nombre del vehículo (centrado, destacado)
    drawTextWithShadow(vehicleName, x + width / 2, y + 10, tocolor(unpack(CONFIG.colors.border)), 1.3, "default-bold", "center", "top")
    
    -- Separador
    dxDrawLine(x + 15, y + 35, x + width - 15, y + 35, tocolor(100, 100, 100, 100), 1)
    
    -- Información en dos columnas
    local col1X = x + 20
    local col2X = x + width / 2 + 10
    
    -- Columna 1: Motor y Luces
    local engineColor = engineState and tocolor(unpack(CONFIG.colors.engineOn)) or tocolor(unpack(CONFIG.colors.engineOff))
    local engineText = engineState and "ENCENDIDO" or "APAGADO"
    drawTextWithShadow("⚡ Motor: " .. engineText, col1X, y + 45, engineColor, 0.95, "default", "left", "top")
    
    local lightsColor = (lightsState == 2) and tocolor(unpack(CONFIG.colors.lightsOn)) or tocolor(unpack(CONFIG.colors.lightsOff))
    local lightsText = (lightsState == 2) and "ENCENDIDAS" or "APAGADAS"
    drawTextWithShadow("💡 Luces: " .. lightsText, col1X, y + 65, lightsColor, 0.95, "default", "left", "top")
    
    -- Columna 2: Marcha y Salud
    local gearText = (speed > 5) and tostring(gear) or "N"
    drawTextWithShadow("🎛️  Marcha: " .. gearText, col2X, y + 45, tocolor(unpack(CONFIG.colors.text)), 0.95, "default", "left", "top")
    
    local healthPercent = (health / 1000) * 100
    local healthColor
    if healthPercent > 70 then
        healthColor = tocolor(unpack(CONFIG.colors.fuelHigh))
    elseif healthPercent > 30 then
        healthColor = tocolor(unpack(CONFIG.colors.fuelMedium))
    else
        healthColor = tocolor(unpack(CONFIG.colors.fuelLow))
    end
    drawTextWithShadow("🔧 Salud: " .. math.floor(healthPercent) .. "%", col2X, y + 65, healthColor, 0.95, "default", "left", "top")
end

-- Indicador de gasolina
function drawFuelIndicator(x, y, width, height, fuel)
    local fuelPercent = math.max(0, math.min(100, fuel))
    
    -- Fondo con borde
    drawBorderedRectangle(x, y, width, height, tocolor(unpack(CONFIG.colors.background)), tocolor(255, 200, 0, 200), 3)
    dxDrawRectangle(x + 2, y + 2, width - 4, height - 4, tocolor(unpack(CONFIG.colors.backgroundSecondary)), false)
    
    -- Icono de gasolina
    local fuelIconColor = fuelPercent <= 20 and tocolor(unpack(CONFIG.colors.fuelLow)) or tocolor(255, 200, 0, 255)
    drawTextWithShadow("⛽", x + 25, y + 15, fuelIconColor, 2.2, "default", "left", "top")
    
    -- Barra de gasolina
    local fuelBarX = x + 60
    local fuelBarY = y + 20
    local fuelBarWidth = width - 75
    local fuelBarHeight = 28
    local fuelBarFillWidth = (fuelPercent / 100) * fuelBarWidth
    
    -- Fondo de la barra
    dxDrawRectangle(fuelBarX - 2, fuelBarY - 2, fuelBarWidth + 4, fuelBarHeight + 4, tocolor(0, 0, 0, 200), false)
    dxDrawRectangle(fuelBarX, fuelBarY, fuelBarWidth, fuelBarHeight, tocolor(30, 30, 40, 255), false)
    
    -- Barra de gasolina con gradiente
    if fuelBarFillWidth > 0 then
        local fuelColor
        if fuelPercent <= 20 then
            fuelColor = tocolor(unpack(CONFIG.colors.fuelLow))
        elseif fuelPercent <= 50 then
            fuelColor = tocolor(unpack(CONFIG.colors.fuelMedium))
        else
            fuelColor = tocolor(unpack(CONFIG.colors.fuelHigh))
        end
        
        -- Barra principal
        dxDrawRectangle(fuelBarX, fuelBarY, fuelBarFillWidth, fuelBarHeight, fuelColor, false)
        
        -- Efecto de brillo (superior)
        if fuelBarFillWidth > 5 then
            dxDrawRectangle(fuelBarX, fuelBarY, fuelBarFillWidth, 4, tocolor(255, 255, 255, 120), false)
        end
        
        -- Efecto de parpadeo si está bajo
        if fuelPercent <= 20 then
            local blinkAlpha = math.sin(getTickCount() / 200) * 100 + 155
            dxDrawRectangle(fuelBarX, fuelBarY, fuelBarFillWidth, fuelBarHeight, tocolor(255, 0, 0, blinkAlpha), false)
        end
    end
    
    -- Porcentaje de gasolina
    local fuelText = math.floor(fuelPercent) .. "%"
    local fuelTextColor = fuelPercent <= 20 and tocolor(255, 100, 100, 255) or tocolor(unpack(CONFIG.colors.text))
    drawTextWithShadow(fuelText, fuelBarX + fuelBarWidth / 2, fuelBarY + fuelBarHeight + 10, fuelTextColor, 1.1, "default-bold", "center", "top")
end

-- ============================================
-- FUNCIÓN PRINCIPAL DE RENDERIZADO
-- ============================================
function drawSpeedometer()
    if not speedometerVisible or not isInVehicle or not currentVehicle then return end
    
    local screenW, screenH = guiGetScreenSize()
    local speed = getVehicleSpeedKMH(currentVehicle)
    local rpm = getVehicleRPM(currentVehicle)
    local vehicleName = getVehicleDisplayName(currentVehicle)
    local engineState = getVehicleEngineState(currentVehicle)
    local lightsState = getVehicleOverrideLights(currentVehicle)
    local vehicleFuel = getElementData(currentVehicle, "vehicle:fuel") or fuelLevel
    local health = getElementHealth(currentVehicle)
    local gear = estimateGear(currentVehicle, speed)
    
    -- Suavizar valores para animaciones
    if CONFIG.enableAnimations then
        smoothSpeed = smoothSpeed + ((speed / 200) * 180 - smoothSpeed) * CONFIG.animationSpeed
        smoothRPM = smoothRPM + (rpm - smoothRPM) * 0.2
    else
        smoothSpeed = (speed / 200) * 180
        smoothRPM = rpm
    end
    
    -- Calcular posición
    local posX = screenW * CONFIG.position.x - CONFIG.size.width
    local posY = screenH * CONFIG.position.y - CONFIG.size.height
    
    -- Velocímetro principal
    local centerX = posX + 140
    local centerY = posY + 130
    local radius = 115
    drawSpeedometerGauge(centerX, centerY, radius, speed, rpm)
    
    -- Panel de información
    local infoY = posY + 260
    local infoWidth = 260
    local infoHeight = 110
    drawVehicleInfo(posX + 10, infoY, infoWidth, infoHeight, vehicleName, rpm, engineState, lightsState, health, gear)
    
    -- Indicador de gasolina
    local fuelY = infoY + infoHeight + 15
    local fuelWidth = 260
    local fuelHeight = 65
    drawFuelIndicator(posX + 10, fuelY, fuelWidth, fuelHeight, vehicleFuel)
    
    -- Advertencia de gasolina baja (pantalla completa)
    if vehicleFuel <= 15 then
        local currentTime = getTickCount()
        if vehicleFuel <= 5 and currentTime % 1000 < 500 then
            dxDrawRectangle(0, 0, screenW, screenH, tocolor(255, 0, 0, 50), false)
            drawTextWithShadow("⚠ GASOLINA MUY BAJA ⚠", screenW / 2, screenH / 2 - 50, tocolor(255, 50, 50, 255), 2.2, "default-bold", "center", "center")
            drawTextWithShadow("Busca una gasolinera pronto!", screenW / 2, screenH / 2 + 20, tocolor(255, 255, 255, 200), 1.3, "default", "center", "center")
        elseif vehicleFuel <= 15 then
            drawTextWithShadow("Gasolina baja", screenW / 2, 100, tocolor(255, 165, 0, 200), 1.6, "default-bold", "center", "center")
        end
    end
end

-- ============================================
-- SISTEMA DE ACTUALIZACIÓN
-- ============================================
function updateSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle and vehicle ~= currentVehicle then
        isInVehicle = true
        currentVehicle = vehicle
        speedometerVisible = true
        smoothSpeed = 0
        smoothRPM = 0
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    elseif not vehicle and isInVehicle then
        isInVehicle = false
        currentVehicle = nil
        speedometerVisible = false
    end
end

-- ============================================
-- EVENTOS
-- ============================================
setTimer(updateSpeedometer, 50, 0)
addEventHandler("onClientRender", root, drawSpeedometer)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = true
        currentVehicle = vehicle
        speedometerVisible = true
        smoothSpeed = 0
        smoothRPM = 0
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

addEvent("speedometer:receiveFuel", true)
addEventHandler("speedometer:receiveFuel", root, function(fuel)
    fuelLevel = fuel or 100
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

addEvent("speedometer:updateFuel", true)
addEventHandler("speedometer:updateFuel", root, function(fuel)
    fuelLevel = fuel or fuelLevel
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", true)
    setPlayerHudComponentVisible("area_name", true)
end)
