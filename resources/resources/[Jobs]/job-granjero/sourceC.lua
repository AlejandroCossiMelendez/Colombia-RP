local screenX, screenY = guiGetScreenSize()

local pickupPos = {-1377.8037109375, 2106.9765625, 42.199996948242}
local pickupBlip = nil
local pickupMarker = nil

local dropBlip = nil
local dropMarker = nil

local jobPed = nil
local jobActive = false

local Roboto = nil

local dropPositions = {
	{-1300.056640625, 2512.583984375, 87.027320861816}
}

local _destroyElement = destroyElement

local trabajo = {
	camiones = "478",
	acceptMsg = false
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	jobPed = createPed(71, -1376.3720703125, 2102.517578125, 42.250980377197, 57)
	setElementFrozen(jobPed, true)
	setPedAnimation(jobPed, "cop_ambient", "coplook_think", -1, true, false, false, false)
end)

function startJob()
	outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFAceptaste tu trabajo de #FFFF00Granjero #FFFFFFnecesitarás un Vehiculo #00CC00Walton #FFFFFFpara comenzar a trabajar.", 255, 255, 255, true)

	destroyElement(pickupMarker)
	pickupMarker = createMarker(pickupPos[1], pickupPos[2], pickupPos[3] - 3.7, "cylinder", 4, 255, 162, 0, 200)

	destroyElement(pickupBlip)
	pickupBlip = createBlip(pickupPos[1], pickupPos[2], pickupPos[3] - 3.7, 0, 2, 255, 162, 0)

	Roboto = dxCreateFont("Roboto.ttf", 12)

	addEventHandler("onClientRender", root, renderMarkerInfo)
	addEventHandler("onClientMarkerHit", root, markerHandler)

	
end

function stopJob()
	outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFRechazaste el trabajo de #FFFF00Granjero#FFFFFF.", 255, 255, 255, true)

	removeEventHandler("onClientRender", root, renderMarkerInfo)
	removeEventHandler("onClientMarkerHit", root, markerHandler)

	destroyElement(pickupMarker)
	destroyElement(pickupBlip)
	destroyElement(dropMarker)
	destroyElement(dropBlip)
	destroyElement(Roboto)
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "down" then
		if clickedElement == jobPed then
			local x, y, z = getElementPosition(clickedElement)
			local distance = getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer))

			if distance < 5 then
				if jobActive then
					stopJob()
					jobActive = false
				else	
					startJob()
					jobActive = true
				end
			end
		end
	end
end)

local startAnim = false

function markerHandler(player, matchDim)
	if player == localPlayer and matchDim then
		if source == pickupMarker then
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if (vehicle and string.find(trabajo.camiones,tostring(getElementModel(vehicle)))) then
				if isElement(vehicle) then
					tempContainer = createObject(1224, 0, 0, 0)
					setObjectScale(tempContainer, 0.925)
					attachElements(tempContainer, vehicle, 0, -1.9, 1)
					setElementAlpha(tempContainer, 0)
					toggleAllControls(false)
					setElementFrozen(vehicle, true)

					startAnim = true
					initAnimation("bgAlpha", true, {0, 0, 0}, {1, 0, 0}, 1000, "Linear", function()
						triggerServerEvent("attachContainerToVehicle2", localPlayer)
						initAnimation("bgAlpha", true, {1, 0, 0}, {0, 0, 0}, 1000, "Linear", function()
							toggleAllControls(true)
							startAnim = false
							setElementFrozen(vehicle, false)
						end)
					end)
				end
			else
				outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFNecesitas un vehículo de trabajo. #00FFFF(Walton)", 255, 255, 255, true)
			end
		elseif source == dropMarker then
			local vehicle = getPedOccupiedVehicle(localPlayer)

			if isElement(vehicle) then
				setElementFrozen(vehicle, true)

				startAnim = true
				initAnimation("bgAlpha", true, {0, 0, 0}, {1, 0, 0}, 1000, "Linear", function()
					triggerServerEvent("detachContainerFromVehicle", localPlayer)

					initAnimation("bgAlpha", true, {1, 0, 0}, {0, 0, 0}, 1000, "Linear", function()
						toggleAllControls(true)
						startAnim = false
						setElementFrozen(vehicle, false)
					end)
				end)
				destroyElement(dropMarker)
				destroyElement(dropBlip)
			end
		end
	end
end

function generateDropPoint()
	destroyElement(dropMarker)
	destroyElement(dropBlip)

	local rand = math.random(1, #dropPositions)
	local x, y, z = unpack(dropPositions[rand])

	dropBlip = createBlip(x, y, z - 3.7, 0, 2, 50, 168, 82)
	dropMarker = createMarker(x, y, z - 3.7, "cylinder", 4, 50, 168, 82, 200)
end
addEvent("generateDropPoint2", true)
addEventHandler("generateDropPoint2", root, generateDropPoint)

function renderMarkerInfo()
	if isElement(pickupMarker) then
		local mX, mY, mZ = getElementPosition(pickupMarker)
		local distance = getDistanceBetweenPoints3D(mX, mY, mZ, getElementPosition(localPlayer))
		local maxDistance = 30

		if distance < maxDistance then
			local scale = 1 - distance / maxDistance
			local w, h = 210, 50
			local x, y = getScreenFromWorldPosition(mX, mY, mZ + 4)

			if x and y then
				w, h = w * scale, h * scale
				x, y = x - w / 2, y - h / 2 

				dxDrawText("PUNTO DE CARGA", x, y, x + w, y + h, tocolor(35, 255, 0), 2 * scale, "default-bold", "center", "center")
			end
		end
	end

	if isElement(dropMarker) then
		local mX, mY, mZ = getElementPosition(dropMarker)
		local distance = getDistanceBetweenPoints3D(mX, mY, mZ, getElementPosition(localPlayer))
		local maxDistance = 30

		if distance < maxDistance then
			local scale = 1 - distance / maxDistance
			local w, h = 210, 50
			local x, y = getScreenFromWorldPosition(mX, mY, mZ + 4)

			if x and y then
				w, h = w * scale, h * scale
				x, y = x - w / 2, y - h / 2 

				dxDrawText("PUNTO DE VENTA", x, y, x + w, y + h, tocolor(35, 255, 0), 2 * scale, "default-bold", "center", "center")
			end
		end
	end
end

function destroyElement(element)
	if isElement(element) then
		return _destroyElement(element)	
	end
end

function dxDrawBorderedRectangle( x, y, width, height, color1, color2, _width, postGUI )
    local _width = _width or 1
    dxDrawRectangle ( x+1, y+1, width-1, height-1, color1, postGUI )
    dxDrawLine ( x, y, x+width, y, color2, _width, postGUI ) -- Top
    dxDrawLine ( x, y, x, y+height, color2, _width, postGUI ) -- Left
    dxDrawLine ( x, y+height, x+width, y+height, color2, _width, postGUI ) -- Bottom
    dxDrawLine ( x+width, y, x+width, y+height, color2, _width, postGUI ) -- Right
end

---------------------------------------------------------------------------------------------------------------------------------------------------

local animations = {}

addEventHandler("onClientRender", root, function()
	for k, v in pairs(animations) do
        if not v.completed then
            local currentTick = getTickCount()
            local elapsedTick = currentTick - v.startTick
            local duration = v.endTick - v.startTick
            local progress = elapsedTick / duration

            v.currentValue[1], v.currentValue[2], v.currentValue[3] = interpolateBetween(
                v.startValue[1], v.startValue[2], v.startValue[3], 
                v.endValue[1], v.endValue[2], v.endValue[3], 
                progress, 
                v.easingType or "Linear"
            )

            if progress >= 1 then
                v.completed = true

                if v.completeFunction then
                    v.completeFunction(unpack(v.functionArgs))
                end
            end
        end
	end
	
	if startAnim then
	dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255 * getAnimationValue("bgAlpha")[1]))
	end
end)

function initAnimation(id, storeVal, startVal, endVal, time, easing, compFunction, args)
    if not storeVal then
        animations[id] = {}
    end

    if not animations[id] then
        animations[id] = {}
    end

    animations[id].startValue = startVal
    animations[id].endValue = endVal
    animations[id].startTick = getTickCount()
    animations[id].endTick = animations[id].startTick + (time or 3000)
    animations[id].easingType = easing
    animations[id].completeFunction = compFunction
    animations[id].functionArgs = args or {}

    animations[id].currentValue = storeVal and animations[id].currentValue or {0, 0, 0}
    animations[id].completed = false
end

function getAnimationValue(id)
	if animations[id] then
		return animations[id].currentValue
	end

	return {0, 0, 0}
end

function setAnimationValue(id, val)
    animations[id].currentValue = val 
end