function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "vehicle:radio", station)
end
addEvent("car:radio:sync", true)
addEventHandler("car:radio:sync", getRootElement(), syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "vehicle:radio:volume", vol)
end
addEvent("car:radio:vol", true)
addEventHandler("car:radio:vol", getRootElement(), syncRadio)
