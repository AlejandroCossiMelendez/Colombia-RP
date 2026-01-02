bindKey ("m", "down",
function()
    showCursor( not isCursorShowing() )
end)

function showAdminHelpPanel()
	if showAH then
			dxDrawRectangle(sxF-300, syF-300, 600, 610, tocolor(0,0,0,140))
			dxDrawRectangle(sxF-300, syF-300, 600, 30, tocolor(0,0,0,170))
			dxDrawRectangle(sxF-300+10, syF-300+40, 580, 30, tocolor(0,0,0,170)) -- magyarázat
			if isInSlot(sxF-300+10, syF-300+530+20+10, 580, 40) then
				dxDrawRectangle(sxF-300+10, syF-300+530+20+10, 580, 40, tocolor(217, 83, 79,255)) -- kilépés
			else
				dxDrawRectangle(sxF-300+10, syF-300+530+20+10, 580, 40, tocolor(217, 83, 79,200))
			end
			dxDrawText("#7cc576Parancs", sxF-300+15, syF-300+40, 0, syF-300+40+30, tocolor(255,255,255,255), 0.8, ahFont, "left", "center", false,false,false,true)
			dxDrawText("#7cc576Leírás", sxF-300+15+140, syF-300+40, 0, syF-300+40+30, tocolor(255,255,255,255), 0.8, ahFont, "left", "center", false,false,false,true)
			dxDrawText("See#7cc576MTA v3 - Admin Commands", sxF-300+5,syF-300, 0,syF-300+30, tocolor(255,255,255,255), 1, ahFont, "left", "center", false,false,false,true)
			dxDrawText("Kilépés", sxF-300+10, syF-300+530+20+10, sxF-300+10+580, syF-300+530+20+10+40, tocolor(0,0,0,255), 1, ahFont, "center", "center", false,false,false,true)
			--exports['sas_system']:formComboRajzolas(sxF,syF, 80, 25, letrehozasInputok)
			local elem = 0
			for level, levelcmds in pairs( commands ) do
				if (level > scrollNum and elem < maxShowed) then
						elem = elem + 1
						if elem < 9 then
							dxDrawRectangle(sxF-300+10, syF-300+40+(elem*60), 580, 30, tocolor(0,0,0,170))
						end
						dxDrawRectangle(sxF-300+10, syF-300+40+(elem*30), 580, 30, tocolor(0,0,0,100))
						dxDrawText(commands[level][1], sxF-300+15, syF-300+40+(elem*30), 0, syF-300+40+30+(elem*30), tocolor(255,255,255,255), 0.8, ahFont, "left", "center", false,false,false,true)
						dxDrawText(commands[level][3], sxF-300+15+140, syF-300+40+(elem*30), 0, syF-300+40+30+(elem*30), tocolor(255,255,255,255), 0.8, ahFont, "left", "center", false,false,false,true)
				end
			end
			exports['sas_system']:gorgetesRajzolas(sxF-300+600, syF-300, 5, 610, #commands, maxShowed, scrollNum, tocolor(0, 0, 0, 255))
	end
end
addEventHandler("onClientRender", getRootElement(), showAdminHelpPanel)

function ahPanelOpen()
	if not showAH then
		showAH = true
	elseif showAH then
		showAH = false
	end
end
addCommandHandler("izjtinhzitozno", ahPanelOpen)

function exitClick(button, state)
	if button == "left" and state == "down" then
		if showAH then
			if isInSlot(sxF-300+10, syF-300+530+20+10, 580, 40) then
				showAH = false
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), exitClick)


bindKey("mouse_wheel_down", "down",
	function()
		if showAH then
			if scrollNum < #commands - maxShowed then
				scrollNum = scrollNum + 1
			end
		end
	end
)

bindKey("mouse_wheel_up", "down",
	function()
		if showAH then
			if scrollNum > 0 then
				scrollNum = scrollNum - 1
			end
		end
	end
)

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function fadeOff ()
	fadeCamera(true)
end
addCommandHandler("bazdmeeeeg", fadeOff)
