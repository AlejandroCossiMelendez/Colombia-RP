function giveMoney(player, command, otherP, cantidad)
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		if otherP and cantidad then
			local other, name = exports.players:getFromName(player, otherP)
			if other then
				local set = exports.players:giveMoney(other, tonumber(cantidad))
				if set then
					outputChatBox('Le has giveado $'..cantidad..' a '..string.gsub(getPlayerName(other), '_', ' ')..'', player, 0, 255, 0)
					outputChatBox('El administrador '..string.gsub(getPlayerName(player), '_', ' ')..' te giveo $'..cantidad..'', other, 0, 170, 0)
					exports.logs:addLogMessage("comandosmoney", getPlayerName(player):gsub("_", " ").." ha giveado $"..cantidad.." a "..string.gsub(getPlayerName(other), '_', ' ')..".")
				else
				outputChatBox('Error, recuerda no usar simbolos en la cantidad!', player, 255, 0, 0)
				end
			else
			end
		else
			outputChatBox('SYNTAX: /'..command..' [Jugador] [Cantidad] ', player, 255, 255, 255)
		end
	end
end
addCommandHandler('$giv', giveMoney)

function setMoney(player, command, otherP, cantidad)
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		if otherP and cantidad then
			local other, name = exports.players:getFromName(player, otherP)
			if other then
				local set = exports.players:setMoney(other, tonumber(cantidad))
				if set then
					outputChatBox('Le has seteado $'..cantidad..' a '..string.gsub(getPlayerName(other), '_', ' ')..'', player, 0, 255, 0)
					outputChatBox('El administrador '..string.gsub(getPlayerName(player), '_', ' ')..' te seteo $'..cantidad..'', other, 0, 170, 0)
					exports.logs:addLogMessage("comandosmoney", getPlayerName(player):gsub("_", " ").." ha seteado $"..cantidad.." a "..string.gsub(getPlayerName(other), '_', ' ')..".")
				else
				outputChatBox('Error, recuerda no usar simbolos en la cantidad!', player, 255, 0, 0)
				end
			end
		else
			outputChatBox('SYNTAX: /'..command..' [Jugador] [Cantidad] ', player, 255, 255, 255)
		end
	end
end
addCommandHandler('$set', setMoney)