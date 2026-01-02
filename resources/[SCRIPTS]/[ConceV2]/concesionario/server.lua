local isPlayerBuy = {}

addEvent("RealizarCompra", true)
addEvent("RealizarCompraBank", true)

for _, v in ipairs(posMaker) do
    NPConce = createPed(121, v.posx, v.posy, v.posz)
end

function clickAbrirConce( button, state, player )
    if button == "left" and state == "down" then
        local x, y, z = getElementPosition( player )
        local x1, y1, z1 = getElementPosition( source ) 
        local distance = getDistanceBetweenPoints3D( x, y, z, x1, y1, z1 )
        if distance < 2 then
            if source == NPConce then
                if not isPlayerBuy[player] then
                    triggerClientEvent(player, "panelVehicleConce", player)
                    isPlayerBuy[player] = true
                end
            end
        end
    end
end
addEventHandler( "onElementClicked", root, clickAbrirConce ) 



addEventHandler("RealizarCompra", getRootElement(), function(carro, price, vip)
	local shouldProcessServerCode = exports["AzkeAC"]:processServerEventData(client, source, eventName, {
		checkEventData = {
			{eventData = source, equalTo = client, debugData = "source"},
			{eventData = carro, allowedDataTypes  = {["number"] = true}, debugData = "vehicleId"},
			{eventData = price, allowedDataTypes  = {["number"] = true}, debugData = "vehicleCost"},
			{eventData = vip, allowedDataTypes  = {["boolean"] = true}, debugData = "isVip"}
		}
	})

	if (not shouldProcessServerCode) then 
		return false
	end

    local codigoCompra = tostring(math.random(0,9))..tostring(math.random(0,9))
    if vip and not hasObjectPermissionTo(client, 'command.vip', false) then 
        triggerClientEvent(client ,"comprao", client) 
        return 
    end

    if exports.players:takeMoney(client, price) then
        triggerEvent("generarVehiculo", client, client, tonumber(carro))
        exports.items:give( client, 1, tonumber(getElementData(client, "vehicleIDa")) )
        outputChatBox("Has comprado el vehículo correctamente.", client, 0, 255, 0)
        removeElementData(client, "codigoCompra")
		isPlayerBuy[client] = false
        triggerClientEvent(client ,"compra", client)
        setCameraTarget(client, client)
    else
        outputChatBox( "Se ha producido un error. Comprueba que tienes dinero suficiente.", client, 255, 127, 0 )
		isPlayerBuy[client] = false
        triggerClientEvent(client ,"comprano", client)
    end
end)

addEventHandler("RealizarCompraBank", getRootElement(), function(carro, price, vip)
    local shouldProcessServerCode = exports["AzkeAC"]:processServerEventData(client, source, eventName, {
		checkEventData = {
			{eventData = source, equalTo = client, debugData = "source"},
			{eventData = carro, allowedDataTypes  = {["number"] = true}, debugData = "vehicleId"},
			{eventData = price, allowedDataTypes  = {["number"] = true}, debugData = "vehicleCost"},
			{eventData = vip, allowedDataTypes  = {["boolean"] = true}, debugData = "isVip"}
		}
	})

	if (not shouldProcessServerCode) then 
		return false
	end

    local codigoCompra = tostring(math.random(0,9))..tostring(math.random(0,9))
    if vip and not hasObjectPermissionTo(client, 'command.vip', flse) then 
        triggerClientEvent(client ,"comprao", client) 
        return 
    end

    if exports.bank:getDinero(client) > tonumber(price) then
		if exports.sql:query_free("UPDATE characters SET banco = " .. (exports.bank:getDinero( client ) - price) .. " WHERE characterID = " .. exports.players:getCharacterID ( client )) then
            triggerEvent("generarVehiculo", client, client, tonumber(carro))
            exports.items:give( client, 1, tonumber(getElementData(client, "vehicleIDa")) )
            outputChatBox("Has comprado el vehículo correctamente.", client, 0, 255, 0)
            removeElementData(client, "codigoCompra")
            isPlayerBuy[client] = false
            triggerClientEvent(client ,"compra", client)
            setCameraTarget(client, client)

        else
            outputChatBox( "algo ah fallado contacta con un staff.", player, 255, 127, 0 )
        end
    else
        outputChatBox( "Se ha producido un error. Comprueba que tienes dinero suficiente.", player, 255, 127, 0 )
        triggerClientEvent(player ,"comprano", player)
		isPlayerBuy[player] = false
    end
end)


addEvent("cerrar", true)
addEventHandler("cerrar", root, function(player)
	isPlayerBuy[player] = false
end)

