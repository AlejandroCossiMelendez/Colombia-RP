--if fileExists("sourceC.lua") then
	--fileDelete("sourceC.lua")
--end

local sx,sy = guiGetScreenSize()

local show = false
local textShowing = false
setElementData(localPlayer, "char:check", false)

local designation = 1
local status = "Kikapcsolva"
local soundElementsOutside = { }
local musicTable = {
 {"https://stream.zeno.fm/0ydsjpcxdhgtv", "Rap Melo"},
 {"https://stream.zeno.fm/u3xpc2fwuvmuv", "Vallenato FM"},
 {"https://stream.zeno.fm/qlhshvdoszqvv", "Salsa"},
 {"https://stream.zeno.fm/mucul6a3rypuv", "Verso Urbano"},
 {"https://stream.zeno.fm/mkebc9kjkyovv", "Flow Music"},
 {"https://stream.zeno.fm/svin0m855uavv", "Popular"},
 {"https://stream.zeno.fm/svin0m855uavv", "Cantina"},
}

addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(),

	function(theVehicle)
		setRadioChannel(0)

		radio = getElementData(theVehicle, "vehicle:radio") or 0

		setElementData(theVehicle, "vehicle:radio", radio)
		if radio > 0  then
			designation = radio
			setElementData(theVehicle, "vehicle:radio:status", 1)
			Image = 1
			triggerServerEvent("car:radio:sync", getLocalPlayer(), designation)
		else
			Image = "kikapcsolva"
			setElementData(theVehicle, "vehicle:radio:status", 0)
		end

		bindKey("r","down", createVehicleRadio)

	end

)

addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(),

	function(theVehicle)
		show = false

		unbindKey("r","down", createVehicleRadio)

	end

)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()) , function ()
	if isPedInVehicle(localPlayer) then
		local vehicle = getPedOccupiedVehicle(localPlayer)

		setRadioChannel(0)

		radio = getElementData(vehicle, "vehicle:radio") or 0
		setElementData(vehicle, "vehicle:radio:status", 0)
		Image = "kikapcsolva"

		setElementData(vehicle, "vehicle:radio", radio)

		bindKey("r","down", createVehicleRadio)
	end
end)
function createVehicleRadio ()
	--if  getPedOccupiedVehicleSeat(localPlayer) == 1  then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		local radio = getElementData(vehicle, "vehicle:radio") or 0
		if not show  then
			show = true
			removeEventHandler("onClientRender", root, createRadioPanel)
			addEventHandler("onClientRender", root, createRadioPanel)
		elseif show then
			show = false
			removeEventHandler("onClientRender", root, createRadioPanel)
		end
	--end
end

function createRadioPanel()
	if not show then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if isPedInVehicle(localPlayer) then
		local radio = getElementData(vehicle, "vehicle:radio") or 0
		local radioStatus = getElementData(vehicle, "vehicle:radio:status") or 0
		if radioStatus == 0 or radio == 0 then
			dxDrawImage(sx/2-256, sy/2-256, 512, 512, "files/background.png")
			dxDrawImage(sx/2-230,sy/2-240,31,31,"files/ledoff.png")
			dxDrawImage(sx/2-230,sy/2-200,45,28,"files/pout.png")

		else
			local newStation =  getElementData(vehicle, "vehicle:radio") or 0
			if newStation <= 1 then
				designation = 1
				setElementData(vehicle, "vehicle:radio", designation)
			end
			if newStation >= #musicTable then
				designation = 1
				setElementData(vehicle, "vehicle:radio", designation)
			end
			dxDrawImage(sx/2-256, sy/2-256, 512, 512, "files/background.png")
			dxDrawImage(sx/2-230,sy/2-240,31,31,"files/ledon.png")
			dxDrawImage(sx/2-230,sy/2-200,45,28,"files/pin.png")

			if isCursorOnBox(sx/2-55,sy/2-30,37,37) then
				dxDrawImage(sx/2-55,sy/2-30,37,37,"files/l2.png")
			else
				dxDrawImage(sx/2-55,sy/2-30,37,37,"files/l1.png")
			end
			if isCursorOnBox(sx/2+47,sy/2-30,37,37) then
				dxDrawImage(sx/2+47,sy/2-30,37,37,"files/r2.png")
			else
				dxDrawImage(sx/2+47,sy/2-30,37,37,"files/r1.png")
			end
			local hangero = getElementData(vehicle, "vehicle:radio:volume") or 40
			if hangero < 0 then
				hangero = 0
			end
			if hangero > 100 then
				hangero = 100
			end
			dxDrawText(musicTable[newStation][2], sx/2-160,sy/2-190,sx/2,sy/2, tocolor(255, 255, 255, 255), 2, "default", "left", "top", false, false, false, true )

			dxDrawImage(sx/2+100,sy/2+25,107,3,"files/sliderBG.png")
			dxDrawImage(sx/2+100+hangero,sy/2+25-2,23,6,"files/sliderBG.png",0,0,0,tocolor(41, 215, 191 ,255))
			dxDrawImage(sx/2+170,sy/2,12,11,"files/volume.png")
			dxDrawText(hangero.. "%", sx/2+220,sy/2-2,sx/2+220,sy/2-2, tocolor(41, 215, 191, 255), 1.0, "default", "right", "top", false, false, false, true )
			clientRenderFunc()
		end
	end
end

function clientRenderFunc()
	if isElement(newSoundElement) then
    local bt = getSoundFFTData(newSoundElement,2048,257)
    if(not bt) then return end
        for i=1,250 do
            bt[i] = math.sqrt(bt[i])*250 --scale it (sqrt to make low values more visible)
            dxDrawRectangle(sx/2+i-108,sy/2-90-bt[i]/2,1,bt[i], tocolor(41, 215, 191, 255))
        end
    end
end

function menuClick(gomb,stat,x,y)
	if not show then return end
	if isPedInVehicle(localPlayer) then
		if gomb == "left" and stat == "down" then
			--if  getPedOccupiedVehicleSeat(localPlayer) == 1  then
				local vehicle = getPedOccupiedVehicle(localPlayer)
				if (dobozbaVan(sx/2-55,sy/2-30,37,37, x, y)) then
					if designation >= 1 and (getElementData(vehicle, "vehicle:radio:status") or 0) == 1 then
						designation = designation - 1
						setElementData(vehicle, "vehicle:radio", designation )
						local selectSound = playSound ( "files/stationswitch.mp3", false )
						setSoundVolume(selectSound, 0.2)
					end
				elseif (dobozbaVan(sx/2+47,sy/2-30,37,37, x, y)) then
					if designation >= 1 and designation <= #musicTable  and (getElementData(vehicle, "vehicle:radio:status") or 0) == 1 then
						designation = designation + 1
						local selectSound = playSound ( "files/stationswitch.mp3", false )
						setSoundVolume(selectSound, 0.2)
						setElementData(vehicle, "vehicle:radio", designation )
					end
				elseif (dobozbaVan(sx/2-230,sy/2-200,45,28, x, y)) then
					if (getElementData(vehicle, "vehicle:radio:status") or 0) == 0 then
						setElementData(vehicle, "vehicle:radio:status", 1)
						designation = 1
						setElementData(vehicle, "vehicle:radio", designation)
						local powerSound = playSound ( "files/poweronoff.mp3", false )
						setSoundVolume(powerSound, 0.2)
					else
						setElementData(vehicle, "vehicle:radio:status", 0)
						setElementData(vehicle, "vehicle:radio", 0)
						designation = 0
						local powerSound = playSound ( "files/poweronoff.mp3", false )
						setSoundVolume(powerSound, 0.2)
					end
				end
				triggerServerEvent("car:radio:sync", getLocalPlayer(), designation)
			--end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),menuClick)

--<[ Görgetés ]>--
bindKey("mouse_wheel_down", "down",
	function()
		if show and isPedInVehicle(localPlayer) then
			local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
			local hangero = getElementData(theVehicle, "vehicle:radio:volume") or 25
			if hangero > 0 and hangero <= 105 then
				hangero = hangero - 10
				setElementData(theVehicle, "vehicle:radio:volume", hangero)
				triggerServerEvent("car:radio:vol", getLocalPlayer(), tonumber(hangero))
			end
		end
	end
)


bindKey("mouse_wheel_up", "down",
	function()
		if show and isPedInVehicle(localPlayer) then
			local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
			local hangero = getElementData(theVehicle, "vehicle:radio:volume") or 25
			if hangero < 100 then
				hangero = hangero + 10
				setElementData(theVehicle, "vehicle:radio:volume", hangero)
				triggerServerEvent("car:radio:vol", getLocalPlayer(), tonumber(hangero))
			end
		end
	end
)
--<[ Görgetés vége ]>--

function dobozbaVan(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function isCursorOnBox(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end
end

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	local radio = getElementData(source, "vehicle:radio") or 0

	if getElementType(source) == "vehicle" and radio ~= 0 then
		if isElement(newSoundElement) then
			stopSound(newSoundElement)
		end
		setElementData(source, "vehicle:radio", 0)
	end
end)

addEventHandler ( "onClientElementDataChange", getRootElement(),

	function ( dataName )
		if getElementType ( source ) == "vehicle" and dataName == "vehicle:radio" then
				local newStation =  getElementData(source, "vehicle:radio") or 0

				if (isElementStreamedIn (source)) then
					if newStation ~= 0 then
						if (soundElementsOutside[source]) then
							stopSound(soundElementsOutside[source])
						end

						local x, y, z = getElementPosition(source)

						local song = nil

						song = musicTable[newStation][1]
						newSoundElement = playSound3D(song, x, y, z, true)
						soundElementsOutside[source] = newSoundElement
						updateLoudness(source)
						setElementDimension(newSoundElement, getElementDimension(source))
						setElementDimension(newSoundElement, getElementDimension(source))
					else
						if (soundElementsOutside[source]) then
							stopSound(soundElementsOutside[source])
							soundElementsOutside[source] = nil
						end
					end
				end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:windowstat" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:radio:volume" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		end
	end
)

addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), function()

	cancelEvent()

end)

function updateLoudness(theVehicle)
	if (soundElementsOutside[theVehicle]) then

		local windowState = getElementData(theVehicle, "vehicle:windowstat") or 1

		local carVolume = getElementData(theVehicle, "vehicle:radio:volume") or 25

		carVolume = carVolume / 100
		--  ped is inside
		if (getPedOccupiedVehicle( getLocalPlayer() ) == theVehicle) then
			setSoundMinDistance(soundElementsOutside[theVehicle], 8)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 70)
			setSoundVolume(soundElementsOutside[theVehicle], 0.6775*carVolume)
		elseif (getVehicleType(theVehicle) == "Boat") then
			setSoundMinDistance(soundElementsOutside[theVehicle], 25)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 50)
			setSoundVolume(soundElementsOutside[theVehicle], 0.6725*carVolume)
		elseif (windowState == 1) then --letekerve az ablak
			setSoundMinDistance(soundElementsOutside[theVehicle], 5)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 15.5)
			setSoundVolume(soundElementsOutside[theVehicle], 0.6725*carVolume)
		elseif (windowState == 0 ) then --feltekerve az ablak
			setSoundMinDistance(soundElementsOutside[theVehicle], 3)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 7.5)
			setSoundVolume(soundElementsOutside[theVehicle], 0.6725*carVolume)
		else
			setSoundMinDistance(soundElementsOutside[theVehicle], 3)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 10)
			setSoundVolume(soundElementsOutside[theVehicle], 0.6725*carVolume)
		end
	end
end

addEventHandler( "onClientPreRender", getRootElement(),
	function()
		if soundElementsOutside ~= nil then
			for element, sound in pairs(soundElementsOutside) do
				if (isElement(sound) and isElement(element)) then
					local x, y, z = getElementPosition(element)
					setElementPosition(sound, x, y, z)
					setElementInterior(sound, getElementInterior(element))
					getElementDimension(sound, getElementDimension(element))
				end
			end
		end
	end
)

function spawnSound(theVehicle)
		local newSoundElement = nil
    if getElementType( theVehicle ) == "vehicle" then

			local radioStation = getElementData(theVehicle, "vehicle:radio") or 0
			if radioStation ~= 0 then
				if (soundElementsOutside[theVehicle]) then
					stopSound(soundElementsOutside[theVehicle])
				end

				local x, y, z = getElementPosition(theVehicle)

				song = musicTable[radioStation][1]
				newSoundElement = playSound3D(song, x, y, z, true)
				soundElementsOutside[theVehicle] = newSoundElement
				setElementDimension(newSoundElement, getElementDimension(theVehicle))
				setElementDimension(newSoundElement, getElementDimension(theVehicle))
				updateLoudness(theVehicle)
			end
    end
end


function removeTheEvent()
	removeEventHandler("onClientPreRender", getRootElement(), showStation)
	textShowing = false
end



function saveRadio(station)

	cancelEvent()
	local radios = 0
	if (station == 0) then
		return
	end
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())

	if (vehicle) then

		if getVehicleOccupant(vehicle) == getLocalPlayer() or getVehicleOccupant(vehicle, 1) == getLocalPlayer() then
			if (station == 12) then
				if (radio == 0) then
					radio = totalStreams + 1
				end

				if (streams[radio - 1]) then
					radio = radio - 1
				else
					radio = 0
				end
			elseif (station == 0) then
				if (streams[radio+1]) then
					radio = radio+1
				else
					radio = 0
				end
			end
			if not textShowing then
				addEventHandler("onClientPreRender", getRootElement(), showStation)
				if (isTimer(theTimer)) then
					resetTimer(theTimer)
				else
					theTimer = setTimer(removeTheEvent, 6000, 1)
				end
				textShowing = true
			else
				removeEventHandler("onClientPreRender", getRootElement(), showStation)
				addEventHandler("onClientPreRender", getRootElement(), showStation)
				if (isTimer(theTimer)) then
					resetTimer(theTimer)
				else
					theTimer = setTimer(removeTheEvent, 6000, 1)
				end
			end
			triggerServerEvent("car:radio:sync", getLocalPlayer(), radio)
		end
	end
end



addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
			spawnSound(source)
    end
)


addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
		local newSoundElement = nil
      if getElementType( source ) == "vehicle" then
				if (soundElementsOutside[source]) then
					stopSound(soundElementsOutside[source])
					soundElementsOutside[source] = nil
				end
      end
    end
)
