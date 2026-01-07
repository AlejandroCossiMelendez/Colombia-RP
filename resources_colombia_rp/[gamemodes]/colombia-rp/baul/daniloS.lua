local function getNearestVehicle(player, distance)
    local lastMinDis = distance-0.0001
    local nearestVeh = false
    local px,py,pz = getElementPosition(player)
    local pint = getElementInterior(player)
    local pdim = getElementDimension(player)

    for _,v in pairs(getElementsByType("vehicle")) do
        local vint,vdim = getElementInterior(v),getElementDimension(v)
        if vint == pint and vdim == pdim then
            local vx,vy,vz = getElementPosition(v)
            local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
            if dis < distance then
                if dis < lastMinDis then 
                    lastMinDis = dis
                    nearestVeh = v
                end
            end
        end
    end
    return nearestVeh
end


local function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix (element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end


local entrou = {}


local function portamala(thePlayer)
	local vehicle = getNearestVehicle(thePlayer, config["Gerais"]["Dist"])
	if vehicle and not isPedInVehicle (thePlayer) then
		for i, v in pairs(config.VehiclesID) do
			if v == getElementModel(vehicle) then
				if not entrou[thePlayer] then
					setVehicleDoorOpenRatio(vehicle, 1, 1, 0)
					attachElements(thePlayer, vehicle, 0.2, -1.5, 0, 0,0,90)
					setElementAlpha(thePlayer, 0)
					setPedAnimation(thePlayer, "ped", "CAR_dead_LHS", false, false)
					entrou[thePlayer] = true
					setVehicleDoorOpenRatio(vehicle, 1, 0, 300)
				else
					setVehicleDoorOpenRatio(vehicle, 1, 1, 0)
					setElementAlpha(thePlayer, 255)
					detachElements (thePlayer, vehicle)
					setPedAnimation(thePlayer, nil)
					local x, y, z = getPositionFromElementOffset(vehicle, 0, -4, 1)
					setElementPosition(thePlayer, x, y, z)
					entrou[thePlayer] = nil  
					setVehicleDoorOpenRatio(vehicle, 1, 0, 300)
					end
				end
			end
		end
	end
addCommandHandler(config["Gerais"]["Cmd"], portamala)


addEventHandler("onPlayerQuit", root, function()
	setElementAlpha(source, 255)
	setPedAnimation(source, nil)
	entrou[source] = nil  
end)


addEventHandler("onPlayerWasted", root, function()
	setElementAlpha(source, 255)
	setPedAnimation(source, nil)
	entrou[source] = nil  
end)


addEventHandler("onElementDestroy", getRootElement(), function ()
	local attachedElements = getAttachedElements (source)
	if (attachedElements) then
		for ElementKey, ElementValue in ipairs (attachedElements) do
			if (getElementType(ElementValue) == "player" ) then
				setElementAlpha(ElementValue, 255)
				detachElements(ElementValue, source)
				setPedAnimation(ElementValue, nil)
				entrou[ElementValue] = nil  
			end
		end
	end
end)