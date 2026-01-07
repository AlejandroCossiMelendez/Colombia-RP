if isVoiceEnabled() then
	addEventHandler ( "onPlayerQuit", root,
		function()
			local previousChannel = playerChannels[source]
			--Remove them from any previous channels
			if tonumber(previousChannel) then
				channels[previousChannel][source] = nil
				--Delete the empty table if he was the last player
				if not next(channels[previousChannel]) then
					channels[previousChannel] = nil
				end
			end
			playerChannels[source] = nil
		end
	)

	function getPlayerChannel ( player )
		if not checkValidPlayer ( player ) then return false end
		return playerChannels[player]
	end

	function setPlayerChannel(player, id)
		if not checkValidPlayer(player) or not exports.players:isLoggedIn(player) then return false end -- Bloquea a jugadores no logueados
		
		id = tonumber(id)
		if not id then
			return setPlayerDefaultChannel(player)
		end
		
		local previousChannel = playerChannels[player]
		
		-- Remover del canal anterior
		if tonumber(previousChannel) then
			channels[previousChannel][player] = nil
			if not next(channels[previousChannel]) then
				channels[previousChannel] = nil
			end
		end
		
		-- Agregar al nuevo canal solo si está logueado
		playerChannels[player] = id
		channels[id] = channels[id] or {}
		channels[id][player] = true
		
		-- Actualizar la lista de transmisión de voz
		local playersInChannel = getPlayersInChannel(id)
		for _, v in ipairs(playersInChannel) do
			setPlayerVoiceBroadcastTo(v, playersInChannel)
		end
		
		return true
	end
	

	function getPlayersInChannel ( id )
		if not isElement(id) then
			id = tonumber(id)
			if not id then
				outputDebugString ( "getPlayersInChannel: Bad 'id' argument", 2 )
				return false
			end
		end
		return tableToArray(channels[id] or {})
	end

	function getNextEmptyChannel()
		local emptyChannel = 1
		while channels[emptyChannel] do
			emptyChannel = emptyChannel + 1
		end
		return emptyChannel
	end

else
	getPlayerChannel = outputVoiceNotLoaded
	setPlayerChannel = outputVoiceNotLoaded
	getPlayersInChannel = outputVoiceNotLoaded
	getNextEmptyChannel = outputVoiceNotLoaded
end
