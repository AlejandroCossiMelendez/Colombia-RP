-- =====================================================
-- VELOCÍMETRO BMW i8 / AUDI VIRTUAL COCKPIT - MTA:SA
-- Diseño Premium Digital con efectos y animaciones
-- Optimizado para rendimiento
-- =====================================================

local sw, sh = guiGetScreenSize()

-- ================= CONFIGURACIÓN PREMIUM =================
local MAX_SPEED = 300
local MAX_RPM = 8500

local UI = {
    radius = 115,
    spacing = 280,
    bottom = 50,
    width = 820,
    height = 280
}

-- Paleta de colores BMW i8 / Audi Virtual Cockpit
local colors = {
    bg_dark = tocolor(15, 18, 26, 240),
    bg_light = tocolor(30, 35, 45, 220),
    carbon = tocolor(40, 40, 40, 200),
    
    digital_blue = tocolor(0, 165, 255, 255),
    digital_cyan = tocolor(0, 255, 200, 255),
    digital_green = tocolor(80, 255, 80, 255),
    digital_orange = tocolor(255, 150, 0, 255),
    digital_red = tocolor(255, 50, 50, 255),
    digital_white = tocolor(245, 245, 255, 255),
    digital_yellow = tocolor(255, 220, 0, 255),
    
    glass = tocolor(255, 255, 255, 15),
    highlight = tocolor(255, 255, 255, 30),
    shadow = tocolor(0, 0, 0, 180)
}

local smoothSpeed = 0
local smoothRPM = 0
local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100
local pulseEffect = 0
local lastGear = "N"
local gearShiftEffect = 0

-- ================= FUNCIONES DE DISEÑO PREMIUM =================
function drawModernArc(cx, cy, radius, startAngle, endAngle, thickness, color, segments)
    local segmentAngle = (endAngle - startAngle) / segments
    for i = 0, segments do
        local angle1 = math.rad(startAngle + i * segmentAngle)
        local angle2 = math.rad(startAngle + (i + 1) * segmentAngle)
        
        local x1 = cx + math.cos(angle1) * radius
        local y1 = cy + math.sin(angle1) * radius
        local x2 = cx + math.cos(angle2) * radius
        local y2 = cy + math.sin(angle2) * radius
        
        dxDrawLine(x1, y1, x2, y2, color, thickness, false)
    end
end

function drawGlowingCircle(cx, cy, radius, color, glowSize)
    -- Círculo interior
    dxDrawCircle(cx, cy, radius, color, 0, 360, 64)
    
    -- Efecto glow exterior
    for i = 1, glowSize do
        local alpha = 50 - (i * (50 / glowSize))
        local glowColor = tocolor(
            bitExtract(color, 0, 8),
            bitExtract(color, 8, 8),
            bitExtract(color, 16, 8),
            alpha
        )
        dxDrawCircle(cx, cy, radius + i, glowColor, 0, 360, 48)
    end
end

function drawDigitalSegment(x, y, width, height, color, value, maxValue)
    local segmentCount = 10
    local segmentWidth = (width - 20) / segmentCount
    
    -- Fondo de segmentos
    for i = 1, segmentCount do
        local segmentX = x + 10 + (i-1) * segmentWidth
        local segmentColor
        
        if (i / segmentCount) <= (value / maxValue) then
            -- Segmento activo con gradiente
            local ratio = i / segmentCount
            local r = bitExtract(color, 0, 8) * ratio
            local g = bitExtract(color, 8, 8) * ratio
            local b = bitExtract(color, 16, 8) * ratio
            segmentColor = tocolor(r, g, b, 255)
        else
            -- Segmento inactivo
            segmentColor = tocolor(40, 40, 40, 150)
        end
        
        dxDrawRectangle(segmentX, y, segmentWidth - 2, height, segmentColor, false)
        
        -- Efecto 3D
        dxDrawRectangle(segmentX, y, segmentWidth - 2, 2, tocolor(255, 255, 255, 30), false)
        dxDrawRectangle(segmentX, y + height - 2, segmentWidth - 2, 2, tocolor(0, 0, 0, 50), false)
    end
end

function drawRoundedRectangle(x, y, width, height, color, radius)
    radius = radius or 5
    
    -- Rectángulo principal
    dxDrawRectangle(x + radius, y, width - 2 * radius, height, color, false)
    dxDrawRectangle(x, y + radius, width, height - 2 * radius, color, false)
    
    -- Esquinas redondeadas
    dxDrawCircle(x + radius, y + radius, radius, color, 0, 360, 32)
    dxDrawCircle(x + width - radius, y + radius, radius, color, 0, 360, 32)
    dxDrawCircle(x + radius, y + height - radius, radius, color, 0, 360, 32)
    dxDrawCircle(x + width - radius, y + height - radius, radius, color, 0, 360, 32)
end

function drawTextWithEffects(text, x, y, color, scale, font, alignX, alignY, effects)
    effects = effects or {}
    
    -- Sombra suave (múltiples capas para efecto blur)
    if effects.shadow then
        for i = 1, 3 do
            local offset = i * 0.5
            dxDrawText(text, x + offset, y + offset, x + offset, y + offset, 
                tocolor(0, 0, 0, 100 - i * 20), scale, font, alignX, alignY, false, false, false, false, false)
        end
    end
    
    -- Efecto glow
    if effects.glow then
        local glowColor = effects.glowColor or color
        for i = 1, 2 do
            dxDrawText(text, x, y, x, y, 
                tocolor(bitExtract(glowColor, 0, 8), bitExtract(glowColor, 8, 8), 
                       bitExtract(glowColor, 16, 8), 100 - i * 30), 
                scale + (i * 0.1), font, alignX, alignY, false, false, false, false, false)
        end
    end
    
    -- Texto principal
    dxDrawText(text, x, y, x, y, color, scale, font, alignX, alignY, false, false, false, false, false)
end

function drawGauge(cx, cy, radius, value, maxValue, color, label, unit)
    local angle = (value / maxValue) * 270
    local startAngle = -225
    
    -- Fondo del gauge
    drawModernArc(cx, cy, radius, startAngle, startAngle + 270, 12, tocolor(40, 40, 40, 180), 72)
    
    -- Arco de valor
    if angle > 0 then
        drawModernArc(cx, cy, radius, startAngle, startAngle + angle, 12, color, 72)
        
        -- Efecto de brillo en el extremo
        local endRad = math.rad(startAngle + angle)
        local endX = cx + math.cos(endRad) * radius
        local endY = cy + math.sin(endRad) * radius
        drawGlowingCircle(endX, endY, 6, color, 3)
    end
    
    -- Marcas principales
    for i = 0, 270, 27 do
        local markRad = math.rad(startAngle + i)
        local innerX = cx + math.cos(markRad) * (radius - 6)
        local innerY = cy + math.sin(markRad) * (radius - 6)
        local outerX = cx + math.cos(markRad) * (radius + 6)
        local outerY = cy + math.sin(markRad) * (radius + 6)
        
        dxDrawLine(innerX, innerY, outerX, outerY, tocolor(255, 255, 255, 120), 2, false)
    end
    
    -- Valor numérico grande
    local valueText = string.format("%03d", math.floor(value))
    drawTextWithEffects(valueText, cx, cy - 30, colors.digital_white, 2.2, "default-bold", "center", "center", 
        {shadow = true, glow = true, glowColor = color})
    
    -- Etiqueta y unidad
    drawTextWithEffects(label, cx, cy + 15, colors.digital_white, 1.0, "default", "center", "center", {shadow = true})
    drawTextWithEffects(unit, cx, cy + 35, colors.digital_cyan, 0.8, "default", "center", "center", {shadow = true})
    
    -- Fondo circular decorativo
    dxDrawCircle(cx, cy, radius - 20, tocolor(20, 25, 35, 200), 0, 360, 48)
    
    -- Efecto glass overlay
    for i = 0, 180, 30 do
        local glassRad = math.rad(startAngle + i)
        local glassX1 = cx + math.cos(glassRad) * (radius - 15)
        local glassY1 = cy + math.sin(glassRad) * (radius - 15)
        local glassX2 = cx + math.cos(glassRad) * (radius + 15)
        local glassY2 = cy + math.sin(glassRad) * (radius + 15)
        
        dxDrawLine(glassX1, glassY1, glassX2, glassY2, tocolor(255, 255, 255, 20), 1, false)
    end
end

function drawGearIndicator(cx, cy, gear, effectIntensity)
    local gearColor = colors.digital_cyan
    
    if gear == "R" then
        gearColor = colors.digital_red
    elseif gear == "N" then
        gearColor = colors.digital_orange
    elseif tonumber(gear) then
        local gearNum = tonumber(gear)
        if gearNum >= 5 then
            gearColor = colors.digital_green
        end
    end
    
    -- Efecto de cambio de marcha
    local pulseScale = 1 + (effectIntensity * 0.3)
    local pulseAlpha = 255 - (effectIntensity * 200)
    
    -- Fondo con efecto de pulso
    if effectIntensity > 0 then
        dxDrawCircle(cx, cy, 35, tocolor(bitExtract(gearColor, 0, 8), 
                                          bitExtract(gearColor, 8, 8), 
                                          bitExtract(gearColor, 16, 8), pulseAlpha), 
                    0, 360, 48)
    end
    
    -- Círculo exterior
    dxDrawCircle(cx, cy, 35, tocolor(40, 40, 40, 180), 0, 360, 48)
    dxDrawCircle(cx, cy, 33, tocolor(25, 30, 40, 220), 0, 360, 48)
    
    -- Texto de marcha
    drawTextWithEffects(gear, cx, cy, gearColor, 2.0 * pulseScale, "default-bold", "center", "center", 
        {shadow = true, glow = true})
    
    -- Etiqueta "GEAR"
    drawTextWithEffects("GEAR", cx, cy - 55, colors.digital_white, 0.9, "default", "center", "center", {shadow = true})
end

function drawFuelGauge(cx, cy, width, height, fuelLevel)
    local fuelColor
    local warningEffect = 0
    
    if fuelLevel > 60 then
        fuelColor = colors.digital_green
    elseif fuelLevel > 30 then
        fuelColor = colors.digital_yellow
    else
        fuelColor = colors.digital_red
        warningEffect = (getTickCount() % 1000 < 500) and 1 or 0.5
    end
    
    -- Fondo
    drawRoundedRectangle(cx, cy, width, height, tocolor(30, 35, 45, 220), 5)
    
    -- Barra de combustible con gradiente
    local barWidth = (fuelLevel / 100) * (width - 20)
    
    for i = 0, barWidth - 1 do
        local ratio = i / (width - 20)
        local r = bitExtract(fuelColor, 0, 8)
        local g = bitExtract(fuelColor, 8, 8) * (1 - ratio * 0.3)
        local b = bitExtract(fuelColor, 16, 8) * (1 - ratio * 0.3)
        
        dxDrawRectangle(cx + 10 + i, cy + 10, 1, height - 20, 
            tocolor(r, g, b, 255 - (warningEffect * 100)), false)
    end
    
    -- Icono de combustible
    local iconColor = fuelColor
    if warningEffect > 0 then
        iconColor = tocolor(255, 100, 100, 255 * warningEffect)
    end
    
    drawTextWithEffects("⛽", cx + 25, cy + height/2 - 12, iconColor, 1.2, "default", "left", "center", {shadow = true})
    
    -- Porcentaje
    drawTextWithEffects(string.format("%02d%%", math.floor(fuelLevel)), 
        cx + width - 25, cy + height/2, colors.digital_white, 1.0, "default-bold", "right", "center", {shadow = true})
    
    -- Efecto de advertencia
    if warningEffect > 0 then
        drawTextWithEffects("LOW FUEL", cx + width/2, cy - 25, 
            tocolor(255, 50, 50, 255 * warningEffect), 0.9, "default-bold", "center", "center", {shadow = true})
    end
end

function drawVehicleStatus(cx, cy, width, height, vehicle)
    local engineState = getVehicleEngineState(vehicle)
    local lightsState = getVehicleOverrideLights(vehicle)
    local health = math.floor(getElementHealth(vehicle) / 10)
    local locked = getVehicleLocked(vehicle)
    
    -- Fondo
    drawRoundedRectangle(cx, cy, width, height, tocolor(30, 35, 45, 220), 5)
    
    -- Iconos y estados
    local iconSize = 30
    local spacing = 70
    local startX = cx + 20
    
    -- Motor
    local engineColor = engineState and colors.digital_green or colors.digital_red
    drawTextWithEffects(engineState and "⚡" or "🔋", startX, cy + height/2, engineColor, 1.0, "default", "left", "center")
    drawTextWithEffects(engineState and "ON" or "OFF", startX + 20, cy + height/2, 
        colors.digital_white, 0.8, "default", "left", "center", {shadow = true})
    
    -- Luces
    local lightsColor = (lightsState == 2) and colors.digital_yellow or colors.digital_gray
    drawTextWithEffects("💡", startX + spacing, cy + height/2, lightsColor, 1.0, "default", "left", "center")
    drawTextWithEffects((lightsState == 2) and "ON" or "OFF", startX + spacing + 20, cy + height/2, 
        colors.digital_white, 0.8, "default", "left", "center", {shadow = true})
    
    -- Salud
    local healthColor = health > 70 and colors.digital_green or health > 30 and colors.digital_yellow or colors.digital_red
    drawTextWithEffects("🔧", startX + spacing * 2, cy + height/2, healthColor, 1.0, "default", "left", "center")
    drawTextWithEffects(string.format("%d%%", health), startX + spacing * 2 + 20, cy + height/2, 
        healthColor, 0.8, "default-bold", "left", "center", {shadow = true})
    
    -- Bloqueo
    local lockColor = locked and colors.digital_red or colors.digital_green
    drawTextWithEffects(locked and "🔒" or "🔓", startX + spacing * 3, cy + height/2, lockColor, 1.0, "default", "left", "center")
end

-- ================= RENDERIZADO PRINCIPAL =================
addEventHandler("onClientRender", root, function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

    local speed = speedKMH(veh)
    local rpm = calcRPM(speed)
    local gear = gearFromSpeed(speed)
    local fuel = getElementData(veh, "vehicle:fuel") or fuelLevel
    
    -- Suavizado con curva de aceleración
    smoothSpeed = smoothSpeed + (speed - smoothSpeed) * 0.15
    smoothRPM = smoothRPM + (rpm - smoothRPM) * 0.18
    
    -- Efecto de pulso en cambios de marcha
    if gear ~= lastGear then
        gearShiftEffect = 1.0
        lastGear = gear
    end
    
    if gearShiftEffect > 0 then
        gearShiftEffect = gearShiftEffect - 0.05
    end
    
    local cx = sw / 2
    local cy = sh - UI.radius - UI.bottom
    
    local leftX = cx - UI.spacing / 2
    local rightX = cx + UI.spacing / 2
    
    -- ========= FONDO PRINCIPAL =========
    local bgWidth = UI.width
    local bgHeight = UI.height
    local bgX = cx - bgWidth / 2
    local bgY = cy - bgHeight / 2
    
    -- Fondo con efecto de profundidad
    drawRoundedRectangle(bgX, bgY, bgWidth, bgHeight, colors.bg_dark, 10)
    
    -- Efecto de borde con gradiente
    dxDrawRectangle(bgX + 2, bgY + 2, bgWidth - 4, 2, colors.glass, false)
    dxDrawRectangle(bgX + 2, bgY + bgHeight - 2, bgWidth - 4, 2, tocolor(0, 0, 0, 150), false)
    
    -- Patrón carbon fiber
    for i = 0, bgWidth, 20 do
        for j = 0, bgHeight, 20 do
            dxDrawRectangle(bgX + i, bgY + j, 10, 10, colors.carbon, false)
        end
    end
    
    -- ========= TACÓMETRO (RPM) =========
    drawGauge(leftX, cy, UI.radius, smoothRPM, MAX_RPM, colors.digital_orange, "RPM", "x1000")
    
    -- ========= VELOCÍMETRO =========
    drawGauge(rightX, cy, UI.radius, smoothSpeed, MAX_SPEED, colors.digital_blue, "SPEED", "KM/H")
    
    -- ========= INDICADOR DE MARCHA =========
    drawGearIndicator(cx, cy, gear, gearShiftEffect)
    
    -- ========= INDICADOR DE COMBUSTIBLE =========
    drawFuelGauge(cx - 180, cy + 100, 200, 40, fuel)
    
    -- ========= ESTADO DEL VEHÍCULO =========
    drawVehicleStatus(cx + 40, cy + 100, 200, 40, veh)
    
    -- ========= NOMBRE DEL VEHÍCULO =========
    local vehicleName = getVehicleName(veh) or "VEHICLE"
    drawTextWithEffects(vehicleName, cx, cy - 120, colors.digital_cyan, 1.2, "default-bold", "center", "center", 
        {shadow = true, glow = true})
end)

-- ================= FUNCIONES UTILITARIAS =================
function speedKMH(v)
    if not v or not isElement(v) then return 0 end
    local x, y, z = getElementVelocity(v)
    return ((x*x + y*y + z*z)^0.5) * 180
end

function calcRPM(speed)
    local r = (speed / MAX_SPEED) * MAX_RPM
    r = math.max(800, math.min(MAX_RPM, r))
    
    if speed < 5 then
        -- Simulación de ralentí
        r = 800 + math.sin(getTickCount() / 120) * 50
    elseif speed > 200 then
        -- Efecto de límite de RPM
        r = MAX_RPM - 200 + math.sin(getTickCount() / 50) * 100
    end
    
    return r
end

function gearFromSpeed(speed)
    if speed < 5 then 
        return "N"
    elseif speed < 10 then
        return "R"
    elseif speed < 25 then 
        return 1
    elseif speed < 45 then 
        return 2
    elseif speed < 70 then 
        return 3
    elseif speed < 100 then 
        return 4
    elseif speed < 140 then 
        return 5
    elseif speed < 180 then 
        return 6
    else 
        return 7
    end
end

-- ================= SISTEMA DE EVENTOS =================
function updateSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle and vehicle ~= currentVehicle then
        isInVehicle = true
        currentVehicle = vehicle
        smoothSpeed = 0
        smoothRPM = 0
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    elseif not vehicle and isInVehicle then
        isInVehicle = false
        currentVehicle = nil
    end
end

setTimer(updateSpeedometer, 100, 0)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = true
        currentVehicle = vehicle
        smoothSpeed = 0
        smoothRPM = 0
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = false
        currentVehicle = nil
    end
end)

-- ================= EVENTOS DE COMBUSTIBLE =================
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

-- ================= CONFIGURACIÓN HUD =================
addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("area_name", false)
    
    -- Cargar fuentes premium si están disponibles
    local digitalFont = dxCreateFont("fonts/digital-7.ttf", 12, false) or "default-bold"
    local sleekFont = dxCreateFont("fonts/sleek.ttf", 10, false) or "default"
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", true)
    setPlayerHudComponentVisible("area_name", true)
end)

-- ================= EFECTOS DE SONIDO (OPCIONAL) =================
function playGearShiftSound()
    if getSoundVolume() > 0 then
        playSound("sounds/gear_shift.wav")
    end
end