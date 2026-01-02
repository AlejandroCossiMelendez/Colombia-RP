markerSell = createMarker(-67.1201171875, -1119.966796875, 1.078125 - 1, "cylinder", 3, 150, 150, 0, 100)

addCommandHandler("vendervehiculo", function(source)
	if isElementWithinMarker(source, markerSell) then
		local pVehicle = getPedOccupiedVehicle(source)
		if isPedInVehicle(source) and pVehicle then
			local sourceId = exports.players:getCharacterID(source)

			local vehicleModel = getVehicleNameFromModel(getElementModel(pVehicle))
			local vehicleCost = exports.vehicles_auxiliar:getPrecioFromModel(vehicleModel)

			local vehicleId = exports.vehicles:getIDFromVehicle(pVehicle)
			local vehicleOwner = exports.vehicles:getOwner(pVehicle)

			if sourceId and vehicleId then
				if exports.items:has(source, 1, vehicleId) then
					if sourceId == vehicleOwner then
						if vehicleCost then
							-- ! LE DAMOS EL 50% DEL COSTO ORIGINAL
							local finalCost = vehicleCost * 0.4

							if exports.sql:query_assoc("DELETE FROM vehicles WHERE vehicleID="..vehicleId) then
								if exports.items:take2(source, 1, vehicleId) then
									destroyElement(pVehicle)
									exports.players:giveMoney(source, tonumber(finalCost))

									-- ! ELIMINAMOS LOS ITEMS DEL MALETERO POR SI SALE UN VEHICULO CON LA MISMA ID
									exports.sql:query_assoc("DELETE FROM maleteros WHERE vehicleID="..vehicleId)

									outputChatBox("(( ¡Vendiste tu "..vehicleModel.." por $"..formatNumber(finalCost, ",").." un 50% menos de su valor original ($"..formatNumber(vehicleCost, ",")..")! ))", source, 0, 200, 0)
								else
									outputChatBox("(( Ocurrio un error. Contacta con un administrador ))", source, 200, 0, 0)
								end
							else
								outputChatBox("(( Ocurrio un error. Contacta con un administrador ))", source, 200, 0, 0)
							end
						else
							outputChatBox("(( ¡Este vehiculo no tiene un costo registrado!, Contacta con un administrador ))", source, 200, 0, 0)
						end
					else
						outputChatBox("(( Eh chaval que estos papeles no estan a tu nombre ))", source, 200, 0, 0)
					end
				else
					outputChatBox("(( Si no tienes las llaves del vehiculo no lo puedes vender ))", source, 200, 0, 0)
				end
			end
		end
	end
end)

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end