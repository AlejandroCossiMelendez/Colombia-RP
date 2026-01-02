function giveUtiles (player, cmd, otherPlayer)
	if not exports.factions:isPlayerInFaction(player, 22) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 795 then outputChatBox("No estás en la zona de equipamiento.", player, 255, 0, 0) return end
	if otherPlayer then
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other then
		local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 22 AND characterID = " .. exports.players:getCharacterID(player))
		local rango = result.factionRank
		if not rango or not result or rango < 1 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(other, 22) and getElementDimension(other) == 795 then
			exports.items:give(other, 46, 100)
			outputChatBox("Has entregado un chaleco a "..name..".", player, 0, 255, 0)
			outputChatBox(getPlayerName(player):gsub("_", " ").. " te ha dado tu chaleco tactico.", other, 0, 255, 0)
			exports.logs:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha dado chaleco a "..name..".")
		else
			outputChatBox("Error grave, asegúrate de que "..name.." está en la facción y en la zona correcta.", player, 255, 0, 0)
		end
	end
	else 
		outputChatBox("Sintaxis: /chalecosejn [soldado]", player, 255, 255, 255)
	end
end
addCommandHandler("chalecosejn", giveUtiles)

function giveUtiles (player, cmd, otherPlayer)
	if not exports.factions:isPlayerInFaction(player, 22) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 0 then outputChatBox("No estás en la base militar.", player, 255, 0, 0) return end
	if otherPlayer then
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other then
		local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 22 AND characterID = " .. exports.players:getCharacterID(player))
		local rango = result.factionRank
		if not rango or not result or rango < 7 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
			exports.items:give(other, 45, 1)
			outputChatBox("Has entregado una libreta militar a "..name..".", player, 0, 255, 0)
			outputChatBox(getPlayerName(player):gsub("_", " ").. " te ha entregado tu libreta militar.", other, 0, 255, 0)
		end
	else 
		outputChatBox("Sintaxis: /darlibreta [agente]", player, 255, 255, 255)
	end
end
addCommandHandler("darlibreta", giveUtiles)

local discordWebhookLOGS = "https://discord.com/api/webhooks/1250242757289705563/mYyvrnUrg5bAv3cOeufrm7jqAmCFNUrWhqI_in3X1Xf_tqX-mC6Ufi3nHK964EQPeRQ5"

local function callback() end

local function sendDiscordLogMessage(message, thePlayer)
    if thePlayer and exports.players:isLoggedIn(thePlayer) then
        if message and #message > 0 then
            local sendOptions = {
                queueName = "dcq",
                connectionAttempts = 3,
                connectTimeout = 5000,
                formFields = {
                    content = string.format(
                        ">>> %s",
                        message
                    )
                }
            }
            fetchRemote(discordWebhookLOGS, sendOptions, callback)
        end
    end
end

function arrestar (player, commandName, otherPlayer, tiempo, ...)
	local razon = table.concat({...}, " ")
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other and razon and tiempo and tonumber(tiempo) then
		if exports.factions:isPlayerInFaction(player, 22) then
			if (getElementDimension(player) ~= 2578) or (getElementDimension(other) ~= 2578) then outputChatBox("(( No puedes arrestar a alguien estando fuera de prision ))", player, 255, 0, 0) return end
			for k, v in ipairs(getElementsByType("player")) do
				if exports.factions:isPlayerInFaction(v, 22) then
					outputChatBox(name.." ha sido arrestado.", v, 255, 0, 0)
					outputChatBox("Tiempo: (("..tostring(tiempo).." minutos)) Razón:"..razon, v, 255, 0, 0)
				end
			end
			if getElementDimension(other) == 2578 then
				setElementPosition(other, 264.142578125, 77.6396484375, 1001.0390625)
				setElementInterior(other, 6)
				setElementDimension(other, 2578)
			else
				outputChatBox("¡Sólo puedes arrestar a alguien en prision!.", player, 255, 0, 0)
				return
			end
			local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(other))
			if nivel == 3 and not exports.objetivos:isObjetivoCompletado(32, exports.players:getCharacterID(other)) then
				exports.objetivos:addObjetivo(32, exports.players:getCharacterID(other), other)
			end
			outputChatBox("Has sido arrestado durante "..tostring(tiempo).." minutos.", other, 255, 0, 0)
			outputChatBox("Razón: "..tostring(razon), other, 255, 0, 0)
			setElementData(other, "ajail", tonumber(tiempo))
			local agente = tostring(getPlayerName(player):gsub("_", " "))
			local sql, error = exports.sql:query_insertid("INSERT INTO `historiales` (`historialID`, `nombre`, `dni`, `residencia`, `profesion`, `delitos`, `agente`, `fecha`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP);", getPlayerName(other):gsub("_", " "), tostring(20000000+exports.players:getCharacterID(other)), "No Procede", "No Procede", tostring(razon).." (( "..tostring(tiempo).." minutos.))", agente)
			exports.sql:query_free("UPDATE characters SET ajail = "..tiempo.." WHERE characterID = "..exports.players:getCharacterID(other))
		    
		    local message = string.format("**Fecha:** %s\n**Agente:** %s\n**Nombre:** %s\n**Razón:** %s\n**Tiempo:** %s mes(es).", os.date("%Y/%m/%d"), agente, getPlayerName(other), razon, tiempo)
            sendDiscordLogMessage(message, player)
		
		else
			outputChatBox("No eres militar.", player, 255, 0, 0)
		end
	else
		outputChatBox("Syntax: /encarcelar [jugador] [tiempo] [razón]", player, 255, 255, 255)
	end
end
addCommandHandler("encarcelar", arrestar)