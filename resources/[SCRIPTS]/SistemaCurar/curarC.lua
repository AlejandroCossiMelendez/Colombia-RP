addEventHandler("onClientKey", root, 
	function (button, press)
        if getElementData(localPlayer, "ST:Curando") == true then
			if button == "F1" or button == "F2" or button == "F3" or button == "F4" or button == "F5" or button == "F6" or button == "F7" or button == "b" or button == "F9" or button == "F10" or button == "F11" or button == "lshift" then
				cancelEvent()
			end
		end
	end
)