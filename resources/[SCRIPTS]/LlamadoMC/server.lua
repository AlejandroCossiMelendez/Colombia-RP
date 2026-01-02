local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end

function entornoMeca(player, ...) 
	if getElementDimension(player) == 0 then
		local x, y, z = getElementPosition(player)
		exports.factions:createFactionBlip2(x, y, z, 3)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(player))
		exports.factions:createFactionBlip2(x, y, z, 3)
	end
	local message = table.concat( { ... }, " " )
	if #message > 0 and not getElementData(player, "nogui") == true then
		for k, v in ipairs(getElementsByType("player")) do
			local pletra = string.upper(string.sub(message, 1, 1))
			local resto = string.sub(message, 2)
			local mensaje = tostring(pletra..resto)
			if exports.factions:isPlayerInFaction(v, 3) then
			outputChatBox( "La persona "..getPlayerName(player).." Solicita Un Servicio De Mecanico -Acude Ahora-.", v, 255, 65, 50 )
			end
		end
		exports.chat:sendLocalOOC( player, "((MotoCar Colombia)) Ha recibido una solicitud de servicio por parte de\n".. "(( "..  getPlayerName( player ) .. ")) ", 255, 255, 255, false, 255, 255, 255 )
	else 
		outputChatBox( "Syntax: /meca1", player, 255, 255, 255 )
	end 
end
addCommandHandler("smeca", entornoMeca)

local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end

function entornoMeca2(player, ...) 
	if getElementDimension(player) == 0 then
		local x, y, z = getElementPosition(player)
		exports.factions:createFactionBlip2(x, y, z, 36)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(player))
		exports.factions:createFactionBlip2(x, y, z, 36)
	end
	local message = table.concat( { ... }, " " )
	if #message > 0 and not getElementData(player, "nogui") == true then
		for k, v in ipairs(getElementsByType("player")) do
			local pletra = string.upper(string.sub(message, 1, 1))
			local resto = string.sub(message, 2)
			local mensaje = tostring(pletra..resto)
			if exports.factions:isPlayerInFaction(v, 36) then
				outputChatBox( "La persona "..getPlayerName(player).." Solicita Un Servicio De Mecanico -Acude Ahora-.", v, 255, 65, 50 )
			end
		end
		exports.chat:sendLocalOOC( player, "((Taller el mocho)) Ha recibido una solicitud de servicio por parte de\n".. "(( "..  getPlayerName( player ) .. ")) ", 255, 255, 255, false, 255, 255, 255 )
	else 
		outputChatBox( "Syntax: /meca2", player, 255, 255, 255 )
	end 
end
addCommandHandler("smeca", entornoMeca2)
