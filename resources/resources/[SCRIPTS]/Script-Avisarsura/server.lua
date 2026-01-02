local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end



function entornoMeca(player, ...) 
	if getElementDimension(player) == 0 then
		local x, y, z = getElementPosition(player)
		exports.factions:createFactionBlip2(x, y, z, 2)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(player))
		exports.factions:createFactionBlip2(x, y, z, 2)
	end
	local message = table.concat( { ... }, " " )
	if #message > 0 and not getElementData(player, "nogui") == true then
		for k, v in ipairs(getElementsByType("player")) do
			local pletra = string.upper(string.sub(message, 1, 1))
			local resto = string.sub(message, 2)
			local mensaje = tostring(pletra..resto)
			if exports.factions:isPlayerInFaction(v, 2) then
			outputChatBox( "((/avisarsura "..getPlayerName(player)..")) Sura - Situacion: Se solicita medico en esta zona.", v, 130, 255, 130 )
			--triggerClientEvent( v, "gui:hint", v, "Policía: Emergencia", "Situacion: ".. mensaje .." " )
			triggerClientEvent(player, "callNotification", player, "info", "Sura: Situacion: ", true)
			end
		end
		outputChatBox("Se ha dado el aviso a los medicos, por favor espere en este lugar.", player, 255, 0, 0)
		exports.chat:sendLocalOOC( player, "((/avisarsura)) Una persona en tu zona ha llamado a un medico\n".. "(( "..  getPlayerName( player ) .. ")) ", 255, 255, 255, false, 255, 255, 255 )
	else 
		outputChatBox( "Syntax: /avisarsura [Entorno medico en 3era persona]", player, 255, 255, 255 )
	end 
end
addCommandHandler("avisarsura", entornoMeca)
