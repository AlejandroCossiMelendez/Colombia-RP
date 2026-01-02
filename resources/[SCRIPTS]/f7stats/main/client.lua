-- // Trululu | Dashbaord
local sx, sy = guiGetScreenSize( )
local x, y = sx / 1280, sy / 720
local isVisible = false

addEventHandler("onClientRender", root,
    function()
        if not isVisible then
        	return
        end
		
		local ping = getPlayerPing( localPlayer );		
		
	dxDrawRoundedRectangle(x*1080, y*262, x*180, y*230, tocolor(0, 0, 0, 110), 12)
        dxDrawImage(x*1140, y*235, x*64, x*64, "assets/images/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawLine(x*1108, y*352, x*1224, y*352, tocolor(255, 255, 255, 255), 2, false)
        dxDrawText("#FFFFFFMi ID: #00FF1F" ..getElementData( localPlayer, "playerid" ), x*1378, y*285, x*1069, x*294, tocolor(255, 255, 255, 255), 1.05, "default-bold", "center", "center", false, false, false, true, false)
        dxDrawText("Personaje:", x*1160, y*245, x*1079, y*332, tocolor(255, 255, 255, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("FPS:", x*1130, y*305, x*1079, y*360, tocolor(255, 255, 255, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("PING:", x*1340, y*278, x*1079, y*388, tocolor(255, 255, 255, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Funcionarios Publicos", x*1260, y*250, x*1079, y*492, tocolor(255, 255, 255, 255), 1.10, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Militares:", x*1178, y*418, x*1079, y*436, tocolor(255, 251, 0, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Policias:", x*1172, y*468, x*1079, y*436, tocolor(35, 255, 0, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Medicos:", x*1175, y*486, x*1079, y*464, tocolor(0, 255, 209, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Mecanicos:", x*1190, y*306, x*1079, y*492, tocolor(255, 93, 0, 255), 1.15, "default-bold", "center", "center", false, false, false, false, false)

        dxDrawText(getPlayerName( localPlayer ):gsub( "_", " " ), x*1095 + 1, y*275 + 1, x*1197 + 1, y*332 + 1, tocolor(0, 255, 0, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
        
        dxDrawText(getCurrentFPS( ), x*1124 + 1, y*305, x*1197 + 1, y*360 + 1, tocolor(0, 255, 0, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
                
        dxDrawText(ping, x*1234 + 1, y*280 + 1, x*1197 + 1, y*385 + 1, tocolor(0, 255, 0, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
                
        dxDrawText(tostring( policeON ), x*1162 + 1, y*466 + 1, x*1197 + 1, y*436 + 1, tocolor(255, 255, 255, 255), 1.05, "default-bold", "left", "center", false, false, false, false, false)
                
        dxDrawText(tostring( medicON ), x*1167 + 1, y*485 + 1, x*1197 + 1, y*464 + 1, tocolor(255, 255, 255, 255), 1.05, "default-bold", "left", "center", false, false, false, false, false)
                
        dxDrawText(tostring( mechanicON ), x*1181 + 1, y*307 + 1, x*1207 + 1, y*492 + 1, tocolor(255, 255, 255, 255), 1.05, "default-bold", "left", "center", false, false, false, false, false)
        
        dxDrawText(tostring( gobiernoON ), x*1165 + 1, y*364 + 1, x*1207 + 1, y*492 + 1, tocolor(255, 255, 255, 255), 1.05, "default-bold", "left", "center", false, false, false, false, false)
        
    end
)

bindKey( "F7", "down",
	function ( )
		if not isVisible then
			isVisible = true
		else
			isVisible = false
		end
		triggerServerEvent( "onServer > getOnlineMembers", localPlayer )
	end
)

addEvent( "onClient > sendOnlineMembers", true )
addEventHandler( "onClient > sendOnlineMembers", root,
	function ( police, medic, mechanic, gob )
		if police and medic and mechanic then
			policeON = tonumber( police )
			medicON = tonumber( medic )
			mechanicON = tonumber( mechanic )
                        gobiernoON = tonumber( gob )
		end
	end
)

-- utiles
function dxDrawBorderedText (outline, text, left, top, right, bottom, color, color1, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText (text, left + oX, top + oY, right + oX, bottom + oY, color1, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

local fps = 0
local nextTick = 0
function getCurrentFPS() -- Setup the useful function
    return math.floor(fps)
end

local function updateFPS(msSinceLastFrame)
    -- FPS are the frames per second, so count the frames rendered per milisecond using frame delta time and then convert that to frames per second.
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)