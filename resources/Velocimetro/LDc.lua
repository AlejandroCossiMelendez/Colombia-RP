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

function draw_hud()
    alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 1000), 'Linear')
    if (isPedInVehicle(localPlayer)) then 

        local vehicle = getPedOccupiedVehicle(localPlayer) 
        if (isElement(vehicle)) then 
            local kmh = getElementSpeed(vehicle, 1) 
            kmh = math.floor(kmh)
            if (kmh == 0) then 
                kmh = '#42424200'..kmh
            elseif (kmh < 10) then 
                kmh = '#42424200#FFFFFF'..kmh
            elseif (kmh < 100) then 
                kmh = '#4242420#FFFFFF'..kmh
            end 
            dxDrawText(""..kmh.."", x - 725, y - 45, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[1], 'left', 'top', false, false, false, true)
            dxDrawText('KMH', x - 660, y - 30, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[2])

            dxDrawImage(x - 623, y - 30, 15, 15, 'assets/belt.png', 0, 0, 0, (getElementData(localPlayer, config.cinto) and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
            dxDrawImage(x - 600, y - 29, 9, 13, 'assets/lights.png', 0, 0, 0, (getVehicleOverrideLights(vehicle) == 2 and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
            dxDrawImage(x - 580, y - 28, 10, 11, 'assets/engine.png', 0, 0, 0, (getVehicleEngineState(vehicle) and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))

            dxDrawImage(x - 745, y - 29, 10, 11, 'assets/fuel.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawText(math.floor((getElementData(vehicle, config.gasolina) or 100))..'%', (x - 750) - (dxGetTextWidth(math.floor((getElementData(vehicle, config.gasolina) or 100))..'%', 1, fonts[3])), y - 32, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[3])
		end
	end 
end
addEventHandler('onClientRender', root, draw_hud)

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