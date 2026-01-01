--[[local clothmarker1 = createMarker(215.064453125, -156.3017578125, 1000.5234375,"cylinder",2,0,200,0,50) -- Binco, Ganton LS
setElementInterior(clothmarker1, 14)
setElementDimension(clothmarker1, 5)
]]
local clothmarker2 = createMarker(217.447265625, -98.6455078125, 1004.2578125,"cylinder",2,0,200,0,50) -- Binco, Ganton LS
setElementInterior(clothmarker2, 15)
setElementDimension(clothmarker2, 175)

-- local clothmarker2 = createMarker(197.755859375, -131.837890625, 1002.5078125, "cylinder",2,0,200,0,50) -- Las Barrancas
-- setElementInterior(clothmarker2, 3)
-- setElementDimension(clothmarker2, 216)



							
addEvent("displayclothes",true)
addEventHandler("displayclothes",getRootElement(),
function(style)
	if client and source and client == source then
		local sql, err = exports.sql:query_assoc_single("SELECT color, genero FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(source)))
		local color = tonumber(sql.color)
		local genero = tonumber(sql.genero)
		triggerClientEvent(client,"displayClothOn",client,clothes[style], style, tonumber(genero), tonumber(color))
	end
end)



local VendedorPed = createPed(2, 207.0205078125, -127.806640625, 1003.5078125, 178.34655761719)
setElementInterior( VendedorPed, 3)
setElementDimension( VendedorPed, 1034)
setElementID(VendedorPed, 'custom:npc')

addEventHandler("onPlayerClick",getRootElement(),
function(button,state, hit)
	if not (button == 'left' and state == 'down') then
		return
	end
	local hitElement = source
	local source = hit
	if (source == VendedorPed) or (source == clothmarker2) then
		if getElementType(hitElement) == "player" and not isPedInVehicle(hitElement) then
			if getElementDimension(hitElement) == getElementDimension(source) then
				local sql, err = exports.sql:query_assoc_single("SELECT color, genero FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(hitElement)))
				--local color = tonumber(sql.color)
				local genero = tonumber(sql.genero)
				triggerClientEvent(hitElement,"showDemClothGui", hitElement, genero)
				exports.objetivos:addObjetivo(10, exports.players:getCharacterID(hitElement), hitElement)
			end
		end
	end
end) 

addEvent("aplicarRopaServidor",true)
addEventHandler("aplicarRopaServidor",getRootElement(),
function(idUnico)
	if idUnico then
		local sql = exports.sql:query_assoc_single("SELECT color FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(source)))
		local color = tonumber(sql.color)
		local cost = getPrecioRopa(idUnico)
		if idUnico <= 0 then
			if getElementModel(source) > 0 then
				setElementModel(source, 0)
			end
			removePedClothes(source, -idUnico)
			if color == 1 then -- Blanco
				triggerClientEvent("onSolicitarRopaBlanco", source)
			end
		else
			if idUnico >= 341 then -- Skin de las antiguas.
				if idUnico == 99999 then
					setElementModel(source, 0)
					if color == 1 then -- Blanco
						triggerClientEvent("onSolicitarRopaBlanco", source)
					end
				else
					local _, skin = getInfoRopa(tonumber(idUnico))
					--outputDebugString("IDUnico: "..tonumber(idUnico))
					--outputDebugString("IDSkin: "..tonumber(skin))
					setElementModel(source, tonumber(skin))
				end
			else
				if getElementModel(source) > 0 then
					setElementModel(source, 0)
				end
				local textura, modelo, tipo = getInfoRopa(tonumber(idUnico))
				addPedClothes(source,textura,modelo,tipo)
				if color == 1 then -- Blanco
					triggerClientEvent("onSolicitarRopaBlanco", source)
				end
			end
		end
		if tonumber(cost) then
			exports.players:takeMoney(source, cost)
		end
		exports.ropas:saveClothes(source)
	end 
end)