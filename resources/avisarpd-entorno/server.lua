local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end



function entornoMeca(player, ...) 
	if getElementDimension(player) == 0 then
		local x, y, z = getElementPosition(player)
		exports.factions:createFactionBlip2(x, y, z, 1)
		exports.factions:createFactionBlip2(x, y, z, 4)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(player))
		exports.factions:createFactionBlip2(x, y, z, 1)
		exports.factions:createFactionBlip2(x, y, z, 4)
	end
	local message = table.concat( { ... }, " " )
	if #message > 0 and not getElementData(player, "nogui") == true then
		for k, v in ipairs(getElementsByType("player")) do
			local pletra = string.upper(string.sub(message, 1, 1))
			local resto = string.sub(message, 2)
			local mensaje = tostring(pletra..resto)
			if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
			outputChatBox( "((/avisarpd "..getPlayerName(player)..")) Central: Tenemos una posible situacion de emergencia. Por favor acudir al sitio las unidades mas cercanas lo antes posible.", v, 130, 255, 130 )
			triggerClientEvent( v, "gui:hint", v, "Policía Nacional: Emergencia", "Situacion: ".. mensaje .." " )
			--triggerClientEvent(player, "callNotification", player, "info", "Mecanicos: Situacion: ", true)
			end
		end
		outputChatBox("Se ha dado el aviso a las unidades policiales mas cercanas, por favor aguarde con cuidado en este lugar.", player, 255, 0, 0)
		exports.chat:sendLocalOOC( player, "((/avisarpd)) Una persona en tu zona a llamado a la Policia Nacional\n".. "(( "..  getPlayerName( player ) .. ")) ", 255, 255, 255, false, 255, 255, 255 )
	else 
		outputChatBox( "Syntax: /avisarpd [avisarpd policial en 3era persona]", player, 255, 255, 255 )
	end 
end
addCommandHandler("entorno", entornoMeca)


