local screenW, screenH = guiGetScreenSize()
local isProgressBarRendered = false
local font = dxCreateFont("fontes/RobotoBold.ttf", 10)
local rotation = 0

function progress()
	local timeInSeconds = (string.format("%4d", tostring(getTimerDetails(Timer) / 1000)).." segundos restantes...")
	local barra = interpolateBetween (0, 0, 0, 0.2782, 0, 0, (getTickCount()-tick)/time, "Linear")
	dxDrawRectangle(screenW * 0.3594, screenH * 0.8581, screenW * 0.2811, screenH * 0.0508, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(screenW * 0.3609, screenH * 0.8607, screenW * barra, screenH * 0.0456, tocolor(37, 198, 21, 255), false)
	dxDrawText(timeInSeconds, screenW * 0.4495 + 2, screenH * 0.8607 + 2, screenW * 0.5512, screenH * 0.9063, tocolor(0, 0, 0, 255), 1.00, font, "center", "center", false, false, false, false, false)
	dxDrawText(timeInSeconds, screenW * 0.4495, screenH * 0.8607, screenW * 0.5512, screenH * 0.9063, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
 	 dxDrawImage(screenW * 0.6457, screenH * 0.8581, screenW * 0.0278, screenH * 0.0495, "gfx/loading.png", rotation, 0, 0, tocolor(255, 255, 255, 255), false)
 	rotation = rotation + 3
end

function toggleProgress(tempo)
	if not isProgressBarRendered then
		tick = getTickCount()
		time = tempo
		rotation = 0
		isProgressBarRendered = true
		addEventHandler("onClientRender", root, progress)
		Timer = setTimer(function()
			removeEventHandler("onClientRender", root, progress)
			isProgressBarRendered = false
		end, time, 1)
	else
		removeEventHandler("onClientRender", root, progress)
		killTimer(Timer)
		tick = getTickCount()
		time = tempo
		addEventHandler("onClientRender", root, progress)
		Timer = setTimer(function()
			removeEventHandler("onClientRender", root, progress)
			isProgressBarRendered = false
		end, time, 1)
	end
end
addEvent("progressBar", true)
addEventHandler("progressBar", root, toggleProgress)