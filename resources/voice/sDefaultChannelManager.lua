if isVoiceEnabled() then
	addEventHandler ( "onPlayerJoin", root,
		function()
			setPlayerInternalChannel ( source, root )
		end
		)

	addEventHandler ( "onResourceStart", getResourceRootElement(),
		function()
			refreshPlayers()
		end
		)

	function refreshPlayers()
		for i,player in ipairs(getElementsByType"player") do
			if not tonumber(getPlayerChannel ( player )) then --If he's not in a scripted channel
				setPlayerDefaultChannel ( player )
			end
		end
	end

	setTimer ( refreshPlayers, TEAM_REFRESH, 0 )

	function setPlayerDefaultChannel ( player )
		setPlayerInternalChannel ( player, root )
	end


	function setPlayerInternalChannel ( player, element )
		if playerChannels[player] == element then
			return false
		end
		playerChannels[player] = element
		channels[element] = player
		setPlayerVoiceBroadcastTo ( player, element )
		return true
	end
end
