-- =====================================================
-- VELOCÍMETRO PREMIUM - ESTILO DASHBOARD DE LUJO
-- Inspirado en BMW, Audi, Mercedes-Benz
-- Con efectos visuales avanzados y animaciones suaves
-- =====================================================

local sw, sh = guiGetScreenSize()
local font = dxCreateFont("fonts/Poppins-Bold.ttf", 14) or "default-bold"
local fontLight = dxCreateFont("fonts/Poppins-Light.ttf", 12) or "default"

-- ================= CONFIGURACIÓN =================
local CONFIG = {
    maxSpeed = 280,
    maxRPM = 8500,
    smoothFactor = 0.15,
    glowIntensity = 0.6,
    arcQuality = 2, -- Menor = más suave pero más pesado
}

local UI = {
    scale = 1,
    gaugeRadius = 110,
    gaugeSpacing = 280,
    bottomMargin = 50,
    glowRadius = 140,
}

-- ================= PALETA DE COLORES PREMIUM =================
local COLORS = {
    -- Backgrounds
    bgPrimary = tocolor(12, 15, 23, 245),
    bgGlass = tocolor(18, 22, 33, 200),
    bgDark = tocolor(8, 10, 15, 220),
    
    -- Principales
    primary = tocolor(0, 230, 255, 255),      -- Cyan brillante
    secondary = tocolor(138, 180, 248, 255),  -- Azul suave
    accent = tocolor(255, 107, 107, 255),     -- Rojo elegante
    
    -- Estados
    success = tocolor(46, 213, 115, 255),
    warning = tocolor(255, 184, 0, 255),
    danger = tocolor(255, 71, 87, 255),
    
    -- Neutros
    white = tocolor(255, 255, 255, 255),
    lightGray = tocolor(180, 188, 210, 255),
    gray = tocolor(120, 130, 155, 200),
    darkGray = tocolor(60, 68, 88, 255),
    
    -- Glow effects
    glowCyan = tocolor(0, 230, 255, 80),
    glowRed = tocolor(255, 71, 87, 80),
    glowGreen = tocolor(46, 213, 115, 80),
}

-- ================= VARIABLES DE ESTADO =================
local state = {
    speed = 0,
    rpm = 0,
    smoothSpeed = 0,
    smoothRPM = 0,
    gear = "P",
    fuel = 100,
    temp = 90,
    isInVehicle = false,
    currentVehicle = nil,
    engineOn = false,
    lightsOn = false,
    pulse = 0,
}

-- ================= FUNCIONES AUXILIARES =================

local function interpolate(current, target, factor)
    return current + (target - current) * factor
end

local function speedKMH(vehicle)
    if not vehicle or not isElement(vehicle) then return 0 end
    local vx, vy, vz = getElementVelocity(vehicle)
    return math.floor(((vx^2 + vy^2 + vz^2)^0.5) * 180)
end

local function calculateRPM(speed, gear)
    if speed < 3 then
        -- Motor en ralentí con vibración
        return 900 + math.sin(getTickCount() / 100) * 80
    end
    
    local baseRPM = (speed / CONFIG.maxSpeed) * CONFIG.maxRPM
    local gearRatio = {6500, 5500, 4800, 4200, 3800, 3400}
    local gearNum = tonumber(gear) or 1
    
    if gearNum >= 1 and gearNum <= 6 then
        baseRPM = math.min(baseRPM * (gearRatio[gearNum] / 3500), CONFIG.maxRPM)
    end
    
    return math.max(900, math.min(CONFIG.maxRPM, baseRPM))
end

local function getGearFromSpeed(speed)
    if speed < 2 then return "P"
    elseif speed < 5 then return "1"
    elseif speed < 30 then return "2"
    elseif speed < 55 then return "3"
    elseif speed < 85 then return "4"
    elseif speed < 120 then return "5"
    else return "6" end
end

local function getDynamicColor(value, max, reverse)
    local percent = value / max
    if reverse then percent = 1 - percent end
    
    if percent > 0.7 then
        return COLORS.success
    elseif percent > 0.4 then
        return COLORS.warning
    else
        return COLORS.danger
    end
end

-- ================= FUNCIONES DE DIBUJO =================

local function drawTextShadow(text, x, y, color, scale, font, alignX, alignY, blur)
    blur = blur or 2
    local shadowAlpha = 180
    
    for i = 1, blur do
        dxDrawText(text, x + i, y + i, x + i, y + i, 
            tocolor(0, 0, 0, shadowAlpha / blur), 
            scale, font, alignX, alignY, false, false, false, true, false)
    end
    
    dxDrawText(text, x, y, x, y, color, scale, font, alignX, alignY, false, false, false, true, false)
end

local function drawGlow(x, y, radius, color, intensity)
    intensity = intensity or 1
    for i = 1, 4 do
        local r = radius + (i * 8)
        local alpha = (120 / i) * intensity
        local glowColor = tocolor(
            math.floor(color[1] or 0),
            math.floor(color[2] or 0),
            math.floor(color[3] or 0),
            math.floor(alpha)
        )
        
        for angle = 0, 360, 8 do
            local rad = math.rad(angle)
            local x1 = x + math.cos(rad) * r
            local y1 = y + math.sin(rad) * r
            dxDrawRectangle(x1 - 2, y1 - 2, 4, 4, glowColor, false, false)
        end
    end
end

local function drawCircularGauge(cx, cy, radius, value, maxValue, color, glowColor, showMarks)
    local startAngle = -225
    local endAngle = 45
    local totalAngle = endAngle - startAngle
    local valueAngle = (value / maxValue) * totalAngle
    
    -- Fondo del gauge (arco completo)
    for angle = startAngle, endAngle, CONFIG.arcQuality do
        local rad = math.rad(angle)
        local x1 = cx + math.cos(rad) * radius
        local y1 = cy + math.sin(rad) * radius
        local x2 = cx + math.cos(rad) * (radius - 8)
        local y2 = cy + math.sin(rad) * (radius - 8)
        dxDrawLine(x1, y1, x2, y2, COLORS.darkGray, 3, false)
    end
    
    -- Marcas del gauge
    if showMarks then
        for i = 0, 10 do
            local angle = startAngle + (totalAngle / 10) * i
            local rad = math.rad(angle)
            local markSize = (i % 2 == 0) and 12 or 6
            local x1 = cx + math.cos(rad) * radius
            local y1 = cy + math.sin(rad) * radius
            local x2 = cx + math.cos(rad) * (radius - markSize)
            local y2 = cy + math.sin(rad) * (radius - markSize)
            dxDrawLine(x1, y1, x2, y2, COLORS.gray, 2, false)
        end
    end
    
    -- Arco de valor (animado)
    if valueAngle > 0 then
        for angle = startAngle, startAngle + valueAngle, CONFIG.arcQuality do
            local rad = math.rad(angle)
            local x1 = cx + math.cos(rad) * radius
            local y1 = cy + math.sin(rad) * radius
            local x2 = cx + math.cos(rad) * (radius - 8)
            local y2 = cy + math.sin(rad) * (radius - 8)
            
            -- Gradiente de color
            local progress = (angle - startAngle) / valueAngle
            local alpha = 200 + (55 * progress)
            local gradientColor = tocolor(
                color[1] or 255,
                color[2] or 255,
                color[3] or 255,
                math.floor(alpha)
            )
            
            dxDrawLine(x1, y1, x2, y2, gradientColor, 4, false)
        end
        
        -- Punto final brillante
        local finalAngle = math.rad(startAngle + valueAngle)
        local dotX = cx + math.cos(finalAngle) * (radius - 4)
        local dotY = cy + math.sin(finalAngle) * (radius - 4)
        
        dxDrawRectangle(dotX - 5, dotY - 5, 10, 10, color, false, false)
        dxDrawRectangle(dotX - 3, dotY - 3, 6, 6, COLORS.white, false, false)
    end
end

local function drawPanel(x, y, w, h, title)
    -- Panel con efecto glass
    dxDrawRectangle(x, y, w, h, COLORS.bgGlass, false, false)
    dxDrawRectangle(x, y, w, 2, COLORS.primary, false, false)
    
    if title then
        drawTextShadow(title, x + w/2, y + 8, COLORS.lightGray, 0.7, fontLight, "center", "top")
    end
end

-- ================= RENDERIZADO PRINCIPAL =================

local function renderSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then 
        state.isInVehicle = false
        return 
    end
    
    state.isInVehicle = true
    state.currentVehicle = vehicle
    
    -- Actualizar valores
    state.speed = speedKMH(vehicle)
    state.gear = getGearFromSpeed(state.speed)
    state.rpm = calculateRPM(state.speed, state.gear)
    state.fuel = getElementData(vehicle, "vehicle:fuel") or 100
    state.engineOn = getVehicleEngineState(vehicle)
    state.lightsOn = getVehicleOverrideLights(vehicle) == 2
    state.pulse = (math.sin(getTickCount() / 500) + 1) / 2
    
    -- Interpolación suave
    state.smoothSpeed = interpolate(state.smoothSpeed, state.speed, CONFIG.smoothFactor)
    state.smoothRPM = interpolate(state.smoothRPM, state.rpm, CONFIG.smoothFactor)
    
    -- Posiciones
    local centerX = sw / 2
    local centerY = sh - UI.gaugeRadius - UI.bottomMargin
    local leftX = centerX - UI.gaugeSpacing / 2
    local rightX = centerX + UI.gaugeSpacing / 2
    
    -- Panel principal
    local panelW = 900
    local panelH = 280
    dxDrawRectangle(centerX - panelW/2, centerY - 150, panelW, panelH, COLORS.bgPrimary, false, false)
    dxDrawRectangle(centerX - panelW/2, centerY - 150, panelW, 3, COLORS.primary, false, false)
    
    -- ========= GAUGE RPM (IZQUIERDA) =========
    local rpmColor = state.smoothRPM > 7000 and 
        {255, 71, 87} or {138, 180, 248}
    
    drawCircularGauge(leftX, centerY, UI.gaugeRadius, 
        state.smoothRPM, CONFIG.maxRPM, 
        tocolor(rpmColor[1], rpmColor[2], rpmColor[3], 255),
        COLORS.glowCyan, true)
    
    -- Texto RPM
    local rpmDisplay = string.format("%.1f", state.smoothRPM / 1000)
    drawTextShadow(rpmDisplay, leftX, centerY - 10, COLORS.white, 2.2, font, "center", "center")
    drawTextShadow("x1000 RPM", leftX, centerY + 30, COLORS.lightGray, 0.8, fontLight, "center", "top")
    
    -- ========= GAUGE VELOCIDAD (DERECHA) =========
    local speedColor = {0, 230, 255}
    
    drawCircularGauge(rightX, centerY, UI.gaugeRadius, 
        state.smoothSpeed, CONFIG.maxSpeed, 
        tocolor(speedColor[1], speedColor[2], speedColor[3], 255),
        COLORS.glowCyan, true)
    
    -- Texto velocidad
    local speedDisplay = string.format("%03d", math.floor(state.smoothSpeed))
    drawTextShadow(speedDisplay, rightX, centerY - 10, COLORS.white, 3, font, "center", "center")
    drawTextShadow("KM/H", rightX, centerY + 35, COLORS.lightGray, 0.9, fontLight, "center", "top")
    
    -- ========= PANEL CENTRAL (MARCHA) =========
    local gearPanelW = 120
    local gearPanelH = 140
    drawPanel(centerX - gearPanelW/2, centerY - 70, gearPanelW, gearPanelH, "GEAR")
    
    -- Marcha actual con glow
    local gearColor = state.gear == "P" and COLORS.lightGray or COLORS.primary
    drawTextShadow(state.gear, centerX, centerY + 10, gearColor, 4.5, font, "center", "center")
    
    -- ========= PANEL DE COMBUSTIBLE =========
    local fuelPanelW = 280
    local fuelPanelH = 50
    drawPanel(centerX - fuelPanelW/2, centerY + 80, fuelPanelW, fuelPanelH, nil)
    
    -- Barra de combustible con gradiente
    local fuelBarW = fuelPanelW - 20
    local fuelBarH = 12
    local fuelBarX = centerX - fuelBarW/2
    local fuelBarY = centerY + 95
    
    dxDrawRectangle(fuelBarX, fuelBarY, fuelBarW, fuelBarH, COLORS.bgDark, false, false)
    
    local fuelColor = getDynamicColor(state.fuel, 100, true)
    local fuelWidth = (state.fuel / 100) * fuelBarW
    dxDrawRectangle(fuelBarX, fuelBarY, fuelWidth, fuelBarH, fuelColor, false, false)
    
    -- Texto combustible
    drawTextShadow("FUEL " .. math.floor(state.fuel) .. "%", 
        centerX, fuelBarY + fuelBarH + 5, COLORS.white, 0.8, fontLight, "center", "top")
    
    -- ========= INDICADORES LATERALES =========
    -- Panel izquierdo
    local leftPanelX = centerX - panelW/2 + 20
    local leftPanelY = centerY - 120
    
    drawTextShadow("VEHICLE STATUS", leftPanelX, leftPanelY, COLORS.lightGray, 0.7, fontLight, "left", "top")
    
    local health = math.floor(getElementHealth(vehicle) / 10)
    local healthColor = getDynamicColor(health, 100, true)
    drawTextShadow("HP: " .. health .. "%", leftPanelX, leftPanelY + 20, healthColor, 0.9, font, "left", "top")
    
    local engineColor = state.engineOn and COLORS.success or COLORS.danger
    local enginePulse = state.engineOn and 255 or (100 + state.pulse * 155)
    drawTextShadow("ENGINE: " .. (state.engineOn and "ON" or "OFF"), 
        leftPanelX, leftPanelY + 42, 
        tocolor(engineColor[1], engineColor[2], engineColor[3], enginePulse), 
        0.9, font, "left", "top")
    
    -- Panel derecho
    local rightPanelX = centerX + panelW/2 - 20
    local rightPanelY = centerY - 120
    
    drawTextShadow("SYSTEMS", rightPanelX, rightPanelY, COLORS.lightGray, 0.7, fontLight, "right", "top")
    
    local lightsColor = state.lightsOn and COLORS.warning or COLORS.gray
    drawTextShadow("LIGHTS: " .. (state.lightsOn and "ON" or "OFF"), 
        rightPanelX, rightPanelY + 20, lightsColor, 0.9, font, "right", "top")
    
    local tempColor = COLORS.success
    drawTextShadow("TEMP: " .. state.temp .. "°C", 
        rightPanelX, rightPanelY + 42, tempColor, 0.9, font, "right", "top")
    
    -- ========= ADVERTENCIAS =========
    if state.fuel <= 15 then
        local warningAlpha = 100 + (state.pulse * 155)
        drawTextShadow("⚠ LOW FUEL WARNING ⚠", 
            centerX, centerY - 130, 
            tocolor(255, 71, 87, warningAlpha), 
            1.3, font, "center", "top", 3)
    end
    
    if state.smoothRPM > 7500 then
        local redlineAlpha = 150 + (state.pulse * 105)
        drawTextShadow("⚠ REDLINE ⚠", 
            leftX, centerY - 90, 
            tocolor(255, 71, 87, redlineAlpha), 
            1.1, font, "center", "top", 2)
    end
end

-- ================= EVENTOS =================

addEventHandler("onClientRender", root, renderSpeedometer)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then
        state.smoothSpeed = 0
        state.smoothRPM = 0
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
    if seat == 0 then
        state.isInVehicle = false
        state.currentVehicle = nil
    end
end)

-- Eventos de combustible
addEvent("speedometer:receiveFuel", true)
addEventHandler("speedometer:receiveFuel", root, function(fuel)
    state.fuel = fuel or 100
end)

addEvent("speedometer:updateFuel", true)
addEventHandler("speedometer:updateFuel", root, function(fuel)
    state.fuel = fuel or state.fuel
end)

-- ================= INICIALIZACIÓN =================

addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("area_name", false)
    outputChatBox("✓ Velocímetro Premium cargado correctamente", 46, 213, 115)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    setPlayerHudComponentVisible("vehicle_name", true)
    setPlayerHudComponentVisible("area_name", true)
end)

-- ================= OPTIMIZACIÓN =================
-- Timer para actualizar combustible cada 5 segundos
setTimer(function()
    if state.currentVehicle and isElement(state.currentVehicle) then
        local fuel = getElementData(state.currentVehicle, "vehicle:fuel")
        if fuel then state.fuel = fuel end
    end
end, 5000, 0)
