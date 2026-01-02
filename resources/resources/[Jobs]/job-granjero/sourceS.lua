local containerModels = {}
local attachedContainers = {}

addEvent("attachContainerToVehicle2", true)
addEventHandler("attachContainerToVehicle2", root, function()
	local vehicle = getPedOccupiedVehicle(source)

	if isElement(vehicle) then
		if isElement(attachedContainers[vehicle]) then
			outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFDebes entregar la mercancia antes de recoger más.", source, 255, 255, 255, true)
		else
			attachedContainers[vehicle] = createObject(1224, 0, 0, 0)
			setObjectScale(attachedContainers[vehicle], 0.925)
			attachElements(attachedContainers[vehicle], vehicle, 0, -1.9, 1)

			outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFRecogiste la mercancía. Ve hasta el #32a852punto de venta#FFFFFF.", source, 255, 255, 255, true)

			triggerClientEvent(source, "generateDropPoint2", source)
		end
	end
end)

function getPlayerVIP(source)
	if isElement(source) then
		local accName = getAccountName(getPlayerAccount(source))
		if isObjectInACLGroup("user."..accName, aclGetGroup("VIP")) then
			return "VIP"
		else
			return false
		end
	end
	return false
end

addEvent("detachContainerFromVehicle", true)
addEventHandler("detachContainerFromVehicle", root, function()
	local vehicle = getPedOccupiedVehicle(source)

	if isElement(vehicle) then
		if attachedContainers[vehicle] and isElement(attachedContainers[vehicle]) then
			detachElements(attachedContainers[vehicle])
			destroyElement(attachedContainers[vehicle])

			local d = math.random(1200000,2800000)
			outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFEntregaste la mercancia y ganaste #32a852$".. d .." #FFFFFFpesos.", source, 255, 255, 255, true)
			exports.players:giveMoney(source, d)
			if (getPlayerVIP(source) == "VIP") then
				local extra = math.random(150,300)
				outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFBeneficio por ser #FFCD00VIP #FFFFFFrecibiste #00FF00$"..extra.." #FFFFFFpesos extras.", source, 255, 255, 255, true)
				exports.players:giveMoney(source, extra)
			end
		end
	end
end)

addCommandHandler("descargmaskd", function(source)
	local vehicle = getPedOccupiedVehicle(source)

	if isElement(vehicle) then
		if attachedContainers[vehicle] and isElement(attachedContainers[vehicle]) then
			detachElements(attachedContainers[vehicle])
			destroyElement(attachedContainers[vehicle])
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
    local vehicle = getPedOccupiedVehicle(source)

    if isElement(vehicle) then
        if attachedContainers[vehicle] and isElement(attachedContainers[vehicle]) then
            detachElements(attachedContainers[vehicle])
            destroyElement(attachedContainers[vehicle])
        end
    end
end)
------
local camionX, camionY, camionZ = -1381.2666015625, 2111.701171875, 42.199996948242
local radioDeCamion = 5 
local tiempoEntreCamiones = 120 

local ultimaVezCamion = {}
local vehiculosJugador = {}

addCommandHandler("granja", function(player)
    local x, y, z = getElementPosition(player)
    local distancia = getDistanceBetweenPoints3D(x, y, z, camionX, camionY, camionZ)
    if distancia <= radioDeCamion then
        local currentTime = getTickCount()
        if not ultimaVezCamion[player] or currentTime - ultimaVezCamion[player] >= tiempoEntreCamiones * 1000 then
            ultimaVezCamion[player] = currentTime

            local truck = createVehicle(478, camionX, camionY, camionZ)
            if truck then
                warpPedIntoVehicle(player, truck)
                vehiculosJugador[player] = truck
				outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFPuedes iniciar a trabajar.", player, 255, 255, 255, true)
            else
			   outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFNo se pudo crear el walton.", player, 255, 255, 255, true)
            end
        else
            outputChatBox("¡Debes esperar " .. math.ceil((currentTime - ultimaVezCamion[player]) / 1000) .. " segundos antes de usar este comando nuevamente!", player, 255, 0, 0)
        end
    else
		outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFDebes estar en la zona de trabajo.", source, 255, 255, 255, true)
    end
end)

addCommandHandler("irme", function(player)
    if vehiculosJugador[player] and isElement(vehiculosJugador[player]) then
        destroyElement(vehiculosJugador[player])
		outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFRenunciaste y tu vehiculo fue guardado.", source, 255, 255, 255, true)
        vehiculosJugador[player] = nil
    else
		outputChatBox("#FFAA00[Ayuda Verso] #FFFFFFNo tienes un auto asignado como para renunciar.", source, 255, 255, 255, true)
    end
end)