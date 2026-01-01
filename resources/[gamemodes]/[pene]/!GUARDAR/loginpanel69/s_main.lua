




addEvent('tengo:caca', true)
addEventHandler('tengo:caca', resourceRoot, function(player, x, y, z, int_dim)

	if player then
		triggerClientEvent(player, 'loadingScreen', resourceRoot)

		fadeCamera(player, false)
		setElementFrozen(player, true)
		setTimer(function()
			interior = 0
			dimension = 0

			fadeCamera(player, true)

			setTimer(function()
				setElementFrozen(player, false)
			end, 1000, 1)

			spawnPlayer(player, x, y, z, 90, interior, dimension)
		end, 1000, 1)

		--setElementData(player,'wPaneluLogowania',nil)
		showChat(player, true)
		showCursor(player, false)
		--setElementData(player, 'pokaz:hud', true)
		setElementData(player, 'grey_shader', 0)
		setCameraTarget(player,player)
		setElementFrozen(player, false)
		triggerClientEvent(player, 'stopMusic', resourceRoot)
	end
end)















addEvent('logowanie:zatwierdzPoradnik', true)
addEventHandler('logowanie:zatwierdzPoradnik', resourceRoot, function(player, type)
	type = tonumber(type)

	if type == 1 then
		exports["polaczenie"]:query("UPDATE users SET tutorial=? WHERE login=? limit 1", "TAK", getPlayerName(player))
	elseif type == 2 then
		exports["polaczenie"]:query("UPDATE users SET cut=? WHERE login=? limit 1", "TAK", getPlayerName(player))
	end
end)




function escapeString(text)
	local str = string.gsub(tostring(text), "'", '')
	str = string.gsub(str, '"', '')
	str = string.gsub(str, ';', '')
	str = string.gsub(str, '\\', '')
	str = string.gsub(str, '/*', '')
	str = string.gsub(str, '*/', '')
	str = string.gsub(str, "'", '')
	str = string.gsub(str, '`', '')
	str = string.gsub(str, ' ', '')
	return str
end
