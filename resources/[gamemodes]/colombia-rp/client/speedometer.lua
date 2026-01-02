-- =====================================================
-- VELOCÍMETRO MODERNO - MTA:SA
-- Diseño futurista con efectos visuales avanzados
-- =====================================================

local sw, sh = guiGetScreenSize()

-- ================= CONFIG =================
local MAX_SPEED = 260
local MAX_RPM   = 8000

local UI = {
    radius = 100,
    spacing = 260,
    bottom = 50
}

local colors = {
    bg      = tocolor(5,5,10,240),
    bgLight = tocolor(15,15,25,200),
    white   = tocolor(255,255,255,255),
    gray    = tocolor(180,180,180,220),
    green   = tocolor(0,255,150,255),
    cyan    = tocolor(0,255,255,255),
    blue    = tocolor(100,200,255,255),
    yellow  = tocolor(255,220,0,255),
    orange  = tocolor(255,150,0,255),
    red     = tocolor(255,80,80,255),
    purple  = tocolor(200,100,255,255)
}

local smoothSpeed = 0
local smoothRPM   = 0
local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100

-- ================= UTILS =================
local function speedKMH(v)
    if not v or not isElement(v) then return 0 end
    local x,y,z = getElementVelocity(v)
    return ((x*x+y*y+z*z)^0.5)*180
end

local function calcRPM(speed)
    local r = (speed / MAX_SPEED) * MAX_RPM
    r = math.max(800, math.min(MAX_RPM, r))
    if speed < 5 then
        r = 800 + math.sin(getTickCount()/120)*50
    end
    return r
end

local function gearFromSpeed(speed)
    if speed < 5 then return "N"
    elseif speed < 25 then return 1
    elseif speed < 45 then return 2
    elseif speed < 70 then return 3
    elseif speed < 100 then return 4
    elseif speed < 140 then return 5
    else return 6 end
end

-- Texto con sombra mejorada
local function shadowText(text,x,y,c,s,f,aX,aY,glow)
    local glowColor = glow or tocolor(0,0,0,150)
    -- Sombra múltiple para efecto de profundidad
    dxDrawText(text,x+2,y+2,x,y,glowColor,s*1.1,f,aX,aY,false,false,false,false,false)
    dxDrawText(text,x+1,y+1,x,y,glowColor,s,f,aX,aY,false,false,false,false,false)
    -- Texto principal
    dxDrawText(text,x,y,x,y,c,s,f,aX,aY,false,false,false,false,false)
end

-- Círculo con efecto de brillo
local function drawGlowCircle(cx,cy,r,color,w,glow)
    glow = glow or false
    -- Brillo exterior
    if glow then
        for i=0,360,4 do
            local a = math.rad(i)
            local glowR = r + 3
            dxDrawLine(
                cx+math.cos(a)*glowR,
                cy+math.sin(a)*glowR,
                cx+math.cos(a)*(glowR-2),
                cy+math.sin(a)*(glowR-2),
                tocolor(color[1],color[2],color[3],50),1
            )
        end
    end
    -- Círculo principal
    for i=0,360,2 do
        local a = math.rad(i)
        dxDrawLine(
            cx+math.cos(a)*r,
            cy+math.sin(a)*r,
            cx+math.cos(a)*(r-w),
            cy+math.sin(a)*(r-w),
            color,w
        )
    end
end

-- Arco con gradiente y brillo
local function drawGlowArc(cx,cy,r,startA,endA,color1,color2,w)
    local steps = math.floor((endA - startA) / 1.5)
    for i=0,steps do
        local a = startA + (i/steps) * (endA - startA)
        local rad = math.rad(a)
        local ratio = i / steps
        
        -- Gradiente de color
        local r = color1[1] + (color2[1] - color1[1]) * ratio
        local g = color1[2] + (color2[2] - color1[2]) * ratio
        local b = color1[3] + (color2[3] - color1[3]) * ratio
        
        -- Línea principal
        dxDrawLine(
            cx+math.cos(rad)*r,
            cy+math.sin(rad)*r,
            cx+math.cos(rad)*(r-w),
            cy+math.sin(rad)*(r-w),
            tocolor(r,g,b,255),w
        )
        
        -- Brillo superior
        if i % 3 == 0 then
            dxDrawLine(
                cx+math.cos(rad)*(r-w+1),
                cy+math.sin(rad)*(r-w+1),
                cx+math.cos(rad)*(r-w),
                cy+math.sin(rad)*(r-w),
                tocolor(255,255,255,100),1
            )
        end
    end
end

-- Barra de progreso moderna
local function drawModernBar(x,y,w,h,percent,color1,color2)
    -- Fondo
    dxDrawRectangle(x,y,w,h,tocolor(0,0,0,180),false)
    dxDrawRectangle(x+1,y+1,w-2,h-2,tocolor(20,20,30,255),false)
    
    if percent > 0 then
        local fillW = (percent/100)*w
        
        -- Gradiente
        for i=0,fillW-1 do
            local ratio = i/w
            local r = color1[1] + (color2[1] - color1[1]) * ratio
            local g = color1[2] + (color2[2] - color1[2]) * ratio
            local b = color1[3] + (color2[3] - color1[3]) * ratio
            dxDrawRectangle(x+i,y,1,h,tocolor(r,g,b,255),false)
        end
        
        -- Brillo superior
        dxDrawRectangle(x,y,fillW,2,tocolor(255,255,255,120),false)
        
        -- Borde brillante
        dxDrawRectangle(x,y,fillW,1,tocolor(255,255,255,80),false)
    end
    
    -- Borde exterior
    dxDrawRectangle(x,y,w,1,tocolor(255,255,255,50),false)
    dxDrawRectangle(x,y+h-1,w,1,tocolor(255,255,255,50),false)
end

-- ================= DRAW =================
addEventHandler("onClientRender",root,function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

    local speed = speedKMH(veh)
    local rpm   = calcRPM(speed)
    local gear  = gearFromSpeed(speed)
    local fuel  = getElementData(veh,"vehicle:fuel") or fuelLevel
    local hp    = math.floor(getElementHealth(veh)/10)
    local engineState = getVehicleEngineState(veh)
    local lightsState = getVehicleOverrideLights(veh)

    -- Suavizado mejorado
    smoothSpeed = smoothSpeed + (speed - smoothSpeed)*0.15
    smoothRPM   = smoothRPM   + (rpm   - smoothRPM)  *0.15

    local cx = sw/2
    local cy = sh - UI.radius - UI.bottom

    local leftX  = cx - UI.spacing/2
    local rightX = cx + UI.spacing/2

    -- FONDO MODERNO CON GRADIENTE
    dxDrawRectangle(cx-400,cy-150,800,300,colors.bg)
    -- Efecto de borde superior
    dxDrawRectangle(cx-400,cy-150,800,2,tocolor(0,255,255,100),false)
    -- Efecto de borde inferior
    dxDrawRectangle(cx-400,cy+148,800,2,tocolor(0,255,255,100),false)

    -- ========= RPM (IZQUIERDA) - ESTILO MODERNO =========
    -- Círculo con brillo
    drawGlowCircle(leftX,cy,UI.radius,tocolor(40,40,50,200),2,true)
    
    -- Arco RPM con gradiente (amarillo a naranja)
    local rpmAngle = (smoothRPM/MAX_RPM)*270
    if rpmAngle > 0 then
        drawGlowArc(leftX,cy,UI.radius,-225,-225+rpmAngle,
            {255,220,0},{255,150,0},7)
    end
    
    -- Texto RPM moderno
    shadowText(math.floor(smoothRPM/1000).."K",
        leftX,cy+45,colors.yellow,1.1,"default-bold","center","top",tocolor(255,220,0,100))
    shadowText("RPM",leftX,cy+65,colors.gray,0.75,"default","center","top")

    -- ========= SPEED (DERECHA) - ESTILO MODERNO =========
    -- Círculo con brillo
    drawGlowCircle(rightX,cy,UI.radius,tocolor(40,40,50,200),2,true)
    
    -- Arco velocidad con gradiente (cyan a azul)
    local spdAngle = (smoothSpeed/MAX_SPEED)*270
    if spdAngle > 0 then
        drawGlowArc(rightX,cy,UI.radius,-225,-225+spdAngle,
            {0,255,255},{100,200,255},7)
    end
    
    -- Velocidad grande y moderna
    shadowText(string.format("%03d",math.floor(smoothSpeed)),
        rightX,cy-30,colors.cyan,3.2,"default-bold","center","center",tocolor(0,255,255,80))
    shadowText("KM/H",rightX,cy+25,colors.gray,0.9,"default","center","top")

    -- ========= CENTER (MARCHA) - ESTILO MODERNO =========
    -- Fondo para la marcha
    dxDrawRectangle(cx-35,cy-50,70,70,tocolor(0,0,0,180),false)
    dxDrawRectangle(cx-33,cy-48,66,66,tocolor(20,20,30,255),false)
    dxDrawRectangle(cx-33,cy-48,66,2,tocolor(0,255,255,150),false) -- Borde superior
    
    shadowText("GEAR",cx,cy-40,colors.gray,0.85,"default","center","top")
    shadowText(gear,cx,cy-10,colors.cyan,3.0,"default-bold","center","center",tocolor(0,255,255,100))

    -- ========= COMBUSTIBLE MODERNO =========
    local barW = 200
    local barX = cx - barW/2
    local barY = cy + 70
    
    -- Título
    shadowText("FUEL",cx,barY,colors.gray,0.8,"default","center","top")
    
    -- Barra moderna con gradiente
    local fuelColor1, fuelColor2
    if fuel > 50 then
        fuelColor1 = {0,255,150}
        fuelColor2 = {0,200,255}
    elseif fuel > 20 then
        fuelColor1 = {255,220,0}
        fuelColor2 = {255,150,0}
    else
        fuelColor1 = {255,80,80}
        fuelColor2 = {255,0,0}
    end
    
    drawModernBar(barX,barY+15,barW,12,fuel,fuelColor1,fuelColor2)
    
    -- Porcentaje
    shadowText(math.floor(fuel).."%",cx,barY+32,colors.white,0.95,"default-bold","center","top")

    -- ========= STATUS MODERNO =========
    -- HP (Izquierda)
    local hpColor = hp>60 and colors.green or hp>30 and colors.orange or colors.red
    shadowText("HP "..hp.."%",cx-220,cy-90,hpColor,1.0,"default-bold","left","top")
    
    -- Motor (Derecha superior)
    local engineColor = engineState and colors.green or colors.red
    local engineText = engineState and "ON" or "OFF"
    shadowText("ENG "..engineText,cx+200,cy-90,engineColor,1.0,"default-bold","left","top")
    
    -- Luces (Derecha inferior)
    local lightsColor = (lightsState == 2) and colors.yellow or colors.gray
    local lightsText = (lightsState == 2) and "ON" or "OFF"
    shadowText("LGT "..lightsText,cx+200,cy-70,lightsColor,1.0,"default-bold","left","top")

    -- Advertencia de combustible bajo (moderna)
    if fuel <= 15 then
        local blinkAlpha = (getTickCount() % 1000 < 500) and 255 or 120
        -- Fondo de advertencia
        dxDrawRectangle(cx-150,cy-120,300,40,tocolor(255,0,0,blinkAlpha*0.3),false)
        dxDrawRectangle(cx-150,cy-120,300,2,tocolor(255,80,80,blinkAlpha),false)
        dxDrawRectangle(cx-150,cy-78,300,2,tocolor(255,80,80,blinkAlpha),false)
        
        shadowText("⚠ LOW FUEL ⚠",cx,cy-105,tocolor(255,80,80,blinkAlpha),1.4,"default-bold","center","center")
    end
end)

-- ================= ACTUALIZACIÓN DE ESTADO =================
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

-- ================= EVENTOS DE VEHÍCULO =================
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

-- ================= HUD =================
addEventHandler("onClientResourceStart",resourceRoot,function()
    setPlayerHudComponentVisible("vehicle_name",false)
    setPlayerHudComponentVisible("area_name",false)
end)

addEventHandler("onClientResourceStop",resourceRoot,function()
    setPlayerHudComponentVisible("vehicle_name",true)
    setPlayerHudComponentVisible("area_name",true)
end)
