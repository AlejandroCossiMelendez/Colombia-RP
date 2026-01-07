local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end



function entornoMeca(player, ...) 
	-- Crear blip solo si el export de factions está disponible
	if exports.factions then
		if getElementDimension(player) == 0 then
			local x, y, z = getElementPosition(player)
			exports.factions:createFactionBlip2(x, y, z, 3)
		else
			if exports.interiors then
				local x, y, z = exports.interiors:getPos(getElementDimension(player))
				exports.factions:createFactionBlip2(x, y, z, 3)
			end
		end
	end
	local message = table.concat( { ... }, " " )
	if #message > 0 and getElementData(player, "nogui") ~= true then
		for k, v in ipairs(getElementsByType("player")) do
			local pletra = string.upper(string.sub(message, 1, 1))
			local resto = string.sub(message, 2)
			local mensaje = tostring(pletra..resto)
			if exports.factions and exports.factions:isPlayerInFaction(v, 3) then
			outputChatBox( "((/avisarmeca "..getPlayerName(player)..")) Mecanicos - Situacion: ".. mensaje, v, 130, 255, 130 )
			--triggerClientEvent( v, "gui:hint", v, "Policía: Emergencia", "Situacion: ".. mensaje .." " )
			end
		end
		outputChatBox("Se ha dado el aviso a los mecanicos, por favor espere en este lugar.", player, 255, 0, 0)
		if exports.chat then
			exports.chat:sendLocalOOC( player, "((/avisarmeca)) Una persona en tu zona ha llamado a un mecanico\n".. "(( "..  getPlayerName( player ) .. ")) ", 255, 255, 255, false, 255, 255, 255 )
		end
	else 
		outputChatBox( "Syntax: /avisarmeca [Descripcion de la situacion]", player, 255, 255, 255 )
	end 
end
addCommandHandler("avisarmeca", entornoMeca)


