-- =====================================================
-- VELOCÍMETRO BMW / AUDI DIGITAL - MTA:SA
-- Integrado con sistema de combustible
-- Optimizado para rendimiento
-- =====================================================

local sw, sh = guiGetScreenSize()

-- ================= CONFIG =================
local MAX_SPEED = 260
local MAX_RPM   = 8000

local UI = {
    radius = 95,
    spacing = 240,
    bottom = 40
}

local colors = {
    bg      = tocolor(10,12,18,230),
    white   = tocolor(255,255,255,255),
    gray    = tocolor(160,160,160,200),
    green   = tocolor(0,255,140,255),
    yellow  = tocolor(255,180,0,255),
    red     = tocolor(255,60,60,255),
    blue    = tocolor(0,140,255,255)
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

local function shadow(text,x,y,c,s,f,aX,aY)
    dxDrawText(text,x+1,y+1,x,y,tocolor(0,0,0,200),s,f,aX,aY,false,false,false,false,false)
    dxDrawText(text,x,y,x,y,c,s,f,aX,aY,false,false,false,false,false)
end

local function drawCircle(cx,cy,r,color,w)
    -- Optimizado: menos iteraciones
    for i=0,360,3 do
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

local function drawArc(cx,cy,r,startA,endA,color,w)
    -- Optimizado: menos iteraciones
    for a=startA,endA,2 do
        local rad = math.rad(a)
        dxDrawLine(
            cx+math.cos(rad)*r,
            cy+math.sin(rad)*r,
            cx+math.cos(rad)*(r-w),
            cy+math.sin(rad)*(r-w),
            color,w
        )
    end
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

    -- Suavizado optimizado
    smoothSpeed = smoothSpeed + (speed - smoothSpeed)*0.12
    smoothRPM   = smoothRPM   + (rpm   - smoothRPM)  *0.12

    local cx = sw/2
    local cy = sh - UI.radius - UI.bottom

    local leftX  = cx - UI.spacing/2
    local rightX = cx + UI.spacing/2

    -- FONDO
    dxDrawRectangle(cx-380,cy-140,760,280,colors.bg)

    -- ========= RPM (IZQUIERDA) =========
    drawCircle(leftX,cy,UI.radius,colors.gray,2)
    local rpmAngle = (smoothRPM/MAX_RPM)*270
    if rpmAngle > 0 then
        drawArc(leftX,cy,UI.radius,-225,-225+rpmAngle,colors.yellow,6)
    end

    shadow(math.floor(smoothRPM/1000).." x1000",
        leftX,cy+40,colors.gray,0.9,"default","center","top")

    -- ========= SPEED (DERECHA) =========
    drawCircle(rightX,cy,UI.radius,colors.gray,2)
    local spdAngle = (smoothSpeed/MAX_SPEED)*270
    if spdAngle > 0 then
        drawArc(rightX,cy,UI.radius,-225,-225+spdAngle,colors.blue,6)
    end

    shadow(string.format("%03d",math.floor(smoothSpeed)),
        rightX,cy-25,colors.white,2.8,"default-bold","center","center")
    shadow("KM/H",rightX,cy+20,colors.gray,1,"default","center","top")

    -- ========= CENTER (MARCHA) =========
    shadow("GEAR",cx,cy-40,colors.gray,0.9,"default","center","top")
    shadow(gear,cx,cy-15,colors.white,2.5,"default-bold","center","top")

    -- ========= COMBUSTIBLE =========
    local barW = 180
    dxDrawRectangle(cx-barW/2,cy+60,barW,10,tocolor(0,0,0,160))
    
    local fuelColor
    if fuel > 50 then
        fuelColor = colors.green
    elseif fuel > 20 then
        fuelColor = colors.yellow
    else
        fuelColor = colors.red
    end
    
    dxDrawRectangle(cx-barW/2,cy+60,(fuel/100)*barW,10,fuelColor)

    shadow("FUEL "..math.floor(fuel).."%",cx,cy+75,colors.white,0.9,"default","center","top")

    -- ========= STATUS (IZQUIERDA) =========
    local hpColor = hp>60 and colors.green or hp>30 and colors.yellow or colors.red
    shadow("HP "..hp.."%",cx-200,cy-80,hpColor,0.9,"default","left","top")

    -- ========= STATUS (DERECHA) =========
    local engineColor = engineState and colors.green or colors.red
    local engineText = engineState and "ON" or "OFF"
    shadow("ENGINE "..engineText,cx+120,cy-80,engineColor,0.9,"default","left","top")

    -- Luces
    local lightsColor = (lightsState == 2) and colors.yellow or colors.gray
    local lightsText = (lightsState == 2) and "ON" or "OFF"
    shadow("LIGHTS "..lightsText,cx+120,cy-60,lightsColor,0.9,"default","left","top")

    -- Advertencia de combustible bajo
    if fuel <= 15 then
        local blinkAlpha = (getTickCount() % 1000 < 500) and 255 or 150
        shadow("⚠ LOW FUEL ⚠",cx,cy-100,tocolor(255,60,60,blinkAlpha),1.2,"default-bold","center","top")
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
