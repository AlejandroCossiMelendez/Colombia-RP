--------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy

--------------------------------------------------------

local x, y = guiGetScreenSize()

local fonts = {
    dxCreateFont('assets/fonts/black.ttf', 20);
    dxCreateFont('assets/fonts/medium.ttf', 9);
    dxCreateFont('assets/fonts/black.ttf', 10);
}

local tick = getTickCount()
local circleScale, sizeStroke = 35, 3
local circleLeft, circleTop = circleScale + 30, x - circleScale - 20
local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted" }

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
    for _, component in ipairs( components ) do
        setPlayerHudComponentVisible( component, false )
    end

    createCircleStroke('bgFuel', circleScale, circleScale, sizeStroke)
    createCircleStroke('fuel', circleScale, circleScale, sizeStroke)
end)

function draw_hud()
    alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 1000), 'Linear')
    if (isPedInVehicle(localPlayer)) then 
        local vehicle = getPedOccupiedVehicle(localPlayer) 
        if (isElement(vehicle)) then 
            local fuelValue = getElementData(vehicle, "fuel") or 100
            
            drawItem('bgFuel', x - 54, y - 150, tocolor(101, 101, 101, alpha * 86))
            drawItem('fuel', x - 54, y - 150, tocolor(237, 187, 4, alpha))
    
            local kmh = getElementSpeed(vehicle, 1) 
            dxDrawImage(x - 200, y - 95, 170, 115, 'assets/speedBar.png', 0, 0, 0, tocolor(255, 255, 255, alpha * 0.4))
            dxDrawImage(x - 210, y - 105, 130, 125, 'assets/speedBar.png', 0, 0, 0, tocolor(255, 255, 255, 255))

            if (kmh <= 400) then 
                dxDrawImageSection(x - 200, y - 95, 170 * (kmh / 400), 115, 0, 0, 110 * (kmh / 400), 76, 'assets/speedBar.png', 0, 0, 0, tocolor(255, 0, 0, 255))
            else
                dxDrawImage(x - 200, y - 95, 170, 115, 'assets/speedBar.png', 0, 0, 0, tocolor(255, 0, 0, alpha))
            end
            
            dxDrawText('KMH', x - 150, y - 47, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[2])

            dxDrawImage(x - 105, y - 47, 16, 17, 'assets/belt.png', 0, 0, 0, (getElementData(localPlayer, config.cinto) and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
            dxDrawImage(x - 74, y - 45.5, 12, 15, 'assets/lights.png', 0, 0, 0, (getVehicleOverrideLights(vehicle) == 2 and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
            dxDrawImage(x - 47, y - 47, 15, 15, 'assets/engine.png', 0, 0, 0, (getVehicleEngineState(vehicle) and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
            dxDrawImage(x - 74, y - 123, 25, 21, 'assets/car.png', 0, 0, 0, (getVehicleEngineState(vehicle) and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))

            dxDrawImage(x - 43.5, y - 140, 13, 13, 'assets/fuel.png', 0, 0, 0, tocolor(255, 255, 255, alpha))

            dxDrawRoundedRectangle(x - 90, y - 78, 35, 25,4, tocolor(255, 0, 0, 255))

            kmh = math.floor(kmh)
            if (kmh == 0) then 
                kmh = '#4242420'..kmh
                dxDrawText("N", x - 80, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            elseif (kmh < 30) then 
                kmh = '#4242420#FFFFFF'..kmh
                dxDrawText("1", x - 78, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            elseif (kmh < 70) then 
                kmh = '#4242420#FFFFFF'..kmh
                dxDrawText("2", x - 78, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            elseif (kmh < 100) then 
                kmh = '#4242420#FFFFFF'..kmh
                dxDrawText("3", x - 78, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            elseif (kmh < 140) then 
                dxDrawText("4", x - 78, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            elseif (kmh < 170) then 
                dxDrawText("5", x - 78, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            elseif (kmh < 240) then 
                dxDrawText("6", x - 78, y - 77, 0, 0, tocolor(255, 255, 255, alpha), 0.70, fonts[1], 'left', 'top', false, false, false, true)
            end 
            dxDrawText(kmh, x - 171, y - 82, 0, 0, tocolor(255, 255, 255, alpha), 1.15, fonts[1], 'left', 'top', false, false, false, true)

            setSVGOffset('fuel', fuelValue)
        end
    end
end

addEventHandler('onClientRender', root, draw_hud)

addEventHandler("onClientElementDataChange", root,
    function(dataName)
        if dataName == "fuel" and source == getPedOccupiedVehicle(localPlayer) then
            tick = getTickCount()
        end
    end
)

addEventHandler('onClientPlayerVoiceStart', localPlayer,
    function ()
        voice = true 
    end
)

addEventHandler('onClientPlayerVoiceStop', localPlayer,
    function ()
        voice = false 
    end
)

addEventHandler("onPlayerJoin", getResourceRootElement(getThisResource()),
function ()
    for _, component in ipairs( components ) do
        setPlayerHudComponentVisible( component, false )
    end
end)

addEventHandler('onClientPlayerVehicleEnter', localPlayer, 
    function()
        tick = getTickCount()
    end
)

addEventHandler('onClientPlayerVehicleExit', localPlayer, 
    function()
        tick = getTickCount()
    end
)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

--------------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy

--------------------------------------------------------