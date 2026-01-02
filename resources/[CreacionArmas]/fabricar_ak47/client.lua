----------------------------------------------------------------------------------------------------------------------------------------
local screenW, screenH = guiGetScreenSize()
local isPanelVisible = false
function onStart()
    font1 = dxCreateFont("Roboto.ttf", 10)
    font2 = dxCreateFont("RobotoBold.ttf", 10)
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)
----------------------------------------------------------------------------------------------------------------------------------------
function render()
	dxDrawRectangle(screenW * 0.3946, screenH * 0.3164, screenW * 0.2116, screenH * 0.3672, tocolor(25, 25, 25, 254), false)--background
	dxDrawRectangle(screenW * 0.5717, screenH * 0.3164, screenW * 0.0344, screenH * 0.0456, tocolor(190, 0, 0, 255), false)--close
	dxDrawRectangle(screenW * 0.4510, screenH * 0.3737, screenW * 0.0988, screenH * 0.1497, tocolor(45, 45, 45, 255), false)--slotitemselected
	dxDrawRectangle(screenW * 0.4580, screenH * 0.6270, screenW * 0.0871, screenH * 0.0391, tocolor(45, 45, 45, 255), false)--fabricar
	dxDrawText("X", screenW * 0.5717, screenH * 0.3164, screenW * 0.6061, screenH * 0.3620, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, false, false)
	dxDrawText("1 -   Culata de Ak-47\n2 -   Cuerpo de Ak-47\n3 -   Cargador de Ak-47\n4 -   Cañon de Ak-47", screenW * 0.4050, screenH * 0.4900, screenW * 0.5988, screenH * 0.6706, tocolor(255, 255, 255, 255), 0.80, font2, "left", "center", false, false, false, false, false)
	dxDrawText("FABRICAR", screenW * 0.4050, screenH * 0.6270, screenW * 0.5988, screenH * 0.6706, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, false, false)
	dxDrawText("    FABRICAR AK-47", screenW * 0.3946, screenH * 0.3164, screenW * 0.5717, screenH * 0.3620, tocolor(255, 255, 255, 255), 1.00, font2, "left", "center", false, false, false, false, false)
	dxDrawImage(screenW * 0.4729, screenH * 0.3919, screenW * 0.0549, screenH * 0.0977, "sementedemaconha.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
end
----------------------------------------------------------------------------------------------------------------------------------------
function toggle()
	if not (isPanelVisible) then
		isPanelVisible = true
		showCursor(true)
		addEventHandler("onClientRender", root, render)
	end
end
addEvent("Toggle", true)
addEventHandler("Toggle", resourceRoot, toggle)
-------------------------------------------------------------------------------------------------------------------------------------------------
function onClick(button, state)
	if (button == "left" and state == "down") then
    	if (isPanelVisible) then
    		if isCursorOnElement(screenW * 0.5717, screenH * 0.3164, screenW * 0.0344, screenH * 0.0456) then
				isPanelVisible = false
				showCursor(false)
				removeEventHandler("onClientRender", root, render)
			elseif isCursorOnElement(screenW * 0.4580, screenH * 0.6270, screenW * 0.1969, screenH * 0.0469) then
				triggerServerEvent("Start", resourceRoot, localPlayer, 1)
				isPanelVisible = false
				showCursor(false)
				removeEventHandler("onClientRender", root, render)
			end
		end
    end
end
addEventHandler("onClientClick", root, onClick)
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
function isCursorOnElement(x, y, w, h)
	if isCursorShowing() then
		local mx, my = getCursorPosition()
		local fullx, fully = guiGetScreenSize()
		local cursorx, cursory = mx*fullx, my*fully
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		else
			return false
		end
	else
		return false
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------