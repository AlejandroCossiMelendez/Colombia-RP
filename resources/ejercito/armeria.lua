local IDs =
    {
		[ 3 ] = true,
		[ 23 ] = true,
		[ 24 ] = true,
		[ 29 ] = true,
		[ 31 ] = true,
    }
	
local balasCargador =
{
	[ 24 ] = 7,
	[ 25 ] = 1,
	[ 26 ] = 2,
	[ 27 ] = 4,
	[ 28 ] = 50,
	[ 29 ] = 45,
	[ 32 ] = 50,
	[ 30 ] = 30,
	[ 31 ] = 30,
	[ 33 ] = 1,
	[ 34 ] = 1,
}

function getArmamento (player, cmd, wid)
	if not exports.factions:isPlayerInFaction(player, 4) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if not getElementDimension(player) == 560 then outputChatBox("No estás en la armeria.", player, 255, 0, 0) return end
	local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 10 AND characterID = " .. exports.players:getCharacterID(player))
	local rango = result.factionRank
	if not rango or not result or rango < 8 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
	if not wid then outputChatBox("Sintaxis: /armasejc [arma ID]", player, 255, 255, 255) return end
	if not IDs[tonumber(wid)] then outputChatBox("Solo puedes usar las siguientes IDs: 3, 24, 25, 29, 31", player, 255, 0, 0) return end
	exports.items:give(player, 29, tostring(wid), "Arma "..tostring(wid), 1)
	outputChatBox("Has adquirido un arma "..tostring(wid).." sin munición.", player, 0, 255, 0)
	outputChatBox("Utiliza /cargadoresejc para obtener cargadores de cada arma.", player, 255, 0, 0)
	exports.logsic:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha obtenido un arma "..tostring(wid)..".\n")
end
addCommandHandler("armasejc", getArmamento)

function getCargadores (player, cmd, wid)
	if not exports.factions:isPlayerInFaction(player, 4) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 560 then outputChatBox("No estás en la armeria.", player, 255, 0, 0) return end
	local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 10 AND characterID = " .. exports.players:getCharacterID(player))
	local rango = result.factionRank
	if not rango or not result or rango < 8 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
	if not wid then outputChatBox("Sintaxis: /cargadoresejc [arma ID]", player, 255, 255, 255) return end
	if not IDs[tonumber(wid)] then outputChatBox("Solo puedes usar las siguientes IDs: 3, 24, 25, 29, 31", player, 255, 0, 0) return end
	exports.items:give(player, 43, tostring(wid), "Cargador Arma EJC["..getPlayerName(player):gsub("_", " ").."]", balasCargador[tonumber(wid)])
	outputChatBox("Has adquirido un cargador para un arma "..tostring(wid)..".", player, 0, 255, 0)
	exports.logsic:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha obtenido cargador de un arma "..tostring(wid)..".\n")
end
addCommandHandler("cargadoresejc", getCargadores)

function giveUtiles (player, cmd, otherPlayer)
	if not exports.factions:isPlayerInFaction(player, 4) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 560 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	if otherPlayer then
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other then
		local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 10 AND characterID = " .. exports.players:getCharacterID(player))
		local rango = result.factionRank
		if not rango or not result or rango < 7 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(other, 10) and getElementDimension(other) == 560 then
			exports.items:give(other, 35, 4)
			outputChatBox("Has dado las esposas a "..name..".", player, 0, 255, 0)
			outputChatBox(getPlayerName(player):gsub("_", " ").. " te ha dado las esposas.", other, 0, 255, 0)
			exports.logsic:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha dado esposas a "..name..".")
		else
			outputChatBox("Error grave, asegúrate de que "..name.." está en la facción y en comisaria.", player, 255, 0, 0)
		end
	end
	else 
		outputChatBox("Sintaxis: /esposasejc [agente]", player, 255, 255, 255)
	end
end
addCommandHandler("esposasejc", giveUtiles)

function giveUtiles (player, cmd, otherPlayer)
	if not exports.factions:isPlayerInFaction(player, 4) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 560 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	if otherPlayer then
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other then
		local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 10 AND characterID = " .. exports.players:getCharacterID(player))
		local rango = result.factionRank
		if not rango or not result or rango < 7 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(other, 10) and getElementDimension(other) == 560 then
			exports.items:give(other, 46, 100)
			outputChatBox("Has entregado un chaleco a "..name..".", player, 0, 255, 0)
			outputChatBox(getPlayerName(player):gsub("_", " ").. " te ha dado tu chaleco tactico.", other, 0, 255, 0)
			exports.logsic:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha dado chaleco a "..name..".")
		else
			outputChatBox("Error grave, asegúrate de que "..name.." está en la facción y en comisaria.", player, 255, 0, 0)
		end
	end
	else 
		outputChatBox("Sintaxis: /chalecosejn [agente]", player, 255, 255, 255)
	end
end
addCommandHandler("chalecosejn", giveUtiles)

function giveUtiles (player, cmd, otherPlayer)
	if not exports.factions:isPlayerInFaction(player, 4) then outputChatBox("No eres militar.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 0 then outputChatBox("No estás en la base militar.", player, 255, 0, 0) return end
	if otherPlayer then
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other then
		local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 10 AND characterID = " .. exports.players:getCharacterID(player))
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

siguimientos = {}

function dogFollow( theprisoner)
	if siguimientos[theprisoner] == nil then
	else
		if not theprisoner then return end
		policia = siguimientos[theprisoner]
		local copx, copy, copz = getElementPosition ( siguimientos[theprisoner] )
		local prisonerx, prisonery, prisonerz = getElementPosition ( theprisoner )
		copangle = ( 360 - math.deg ( math.atan2 ( ( copx - prisonerx ), ( copy - prisonery ) ) ) ) % 360
		setPedRotation ( theprisoner, copangle )
		local dist = getDistanceBetweenPoints2D ( copx, copy, prisonerx, prisonery )	
		if getElementInterior(siguimientos[theprisoner]) ~= getElementInterior(theprisoner) then setElementInterior(theprisoner, getElementInterior(siguimientos[theprisoner])) end
		if getElementDimension(siguimientos[theprisoner]) ~= getElementDimension(theprisoner) then setElementDimension(theprisoner, getElementDimension(siguimientos[theprisoner])) end
		if dist >= 200 then
			local x,y,z = getElementPosition(siguimientos[theprisoner])
			setElementPosition(theprisoner, x, y, z)
		elseif dist >= 9 then
			setPedAnimation(theprisoner, "ped", "sprint_civi")
		elseif dist >= 6 then
			setPedAnimation(theprisoner, "ped", "run_player")
		elseif dist >= 3 then
			setPedAnimation(theprisoner, "ped", "WALK_player")
		else
			setPedAnimation(theprisoner, false)
		end
		if isPedInVehicle ( policia ) then
			car = getPedOccupiedVehicle ( policia )
			for i = 0, getVehicleMaxPassengers( car ) do
			local p = getVehicleOccupant( car, i )
				if not p and not isVehicleLocked(car) then
					warpPedIntoVehicle ( theprisoner, car, i )
				end
			end
		else
			if isPedInVehicle ( theprisoner ) then
				removePedFromVehicle ( theprisoner )
			end
		end

		local zombify = setTimer ( dogFollow, 750, 1, theprisoner )
	end
end

addCommandHandler("esposar",
function(player, cmd, other)
	if not player or isPedDead(player) then return end -- tiene cierre
	if exports.factions:isPlayerInFaction(player, 4) then -- no tiene cierre
		if exports.items:has(player, 35,4) then	
			if other then
				target, targetName = exports.players:getFromName( player, other )
				if not target or isPedDead(target) then return end
				x1, y1, z1 = getElementPosition ( player )
				x2, y2, z2 = getElementPosition ( target )
				distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
				if ( distance < 2) then
					if siguimientos[target] == nil then
						siguimientos[target] = player
						dogFollow(target)
						exports.chat:me(player, "pone las esposas a ".. targetName)
						showCursor(target, true)
						toggleControl ( target, "chatbox ", true )
						setElementData(target, "esposado", true)
					else
						siguimientos[target] = nil
						exports.chat:me (player, "quita las esposas a ".. targetName)
						showCursor(target, false)
						toggleAllControls ( target, true )  
						setElementData(target, "esposado", false)
					end
				else
					outputChatBox("Estas demasiado lejos del fugetivo para esposarlo", player, 255, 0,0)
				end
			end	
		else
		outputChatBox("(( No llevas las esposas en tu cinturón tactico ))", player, 255, 0, 0)
	    end
	end
end
)

--[[function arrestar (player, commandName, otherPlayer, tiempo, ...)
	local razon = table.concat({...}, " ")
	local other, name = exports.players:getFromName(player, otherPlayer)

	if other and razon and tiempo and tonumber(tiempo) then
		tiempo = math.min(tonumber(tiempo), 60) -- Limita el tiempo a un máximo de 60 minutos

		if exports.factions:isPlayerInFaction(player, 4) then
			if (getElementDimension(player) ~= 0) or (getElementDimension(other) ~= 0) then 
				outputChatBox("(( No puedes arrestar a alguien estando fuera de prisión ))", player, 255, 0, 0) 
				return 
			end

			for k, v in ipairs(getElementsByType("player")) do
				if exports.factions:isPlayerInFaction(v, 10) then
					outputChatBox(name.." ha sido arrestado.", v, 255, 0, 0)
					outputChatBox("Tiempo: (("..tostring(tiempo).." minutos)) Razón: "..razon, v, 255, 0, 0)
				end
			end

			if getElementDimension(other) == 0 then
				setElementPosition(other, 148.640625, 1410.171875, 12.40625)
				setElementInterior(other, 0)
				setElementDimension(other, 0)
			else
				outputChatBox("¡Sólo puedes arrestar a alguien en prisión!.", player, 255, 0, 0)
				return
			end

			local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(other))
			if nivel == 3 and not exports.objetivos:isObjetivoCompletado(32, exports.players:getCharacterID(other)) then
				exports.objetivos:addObjetivo(32, exports.players:getCharacterID(other), other)
			end

			outputChatBox("Has sido arrestado durante "..tostring(tiempo).." minutos.", other, 255, 0, 0)
			outputChatBox("Razón: "..tostring(razon), other, 255, 0, 0)
			setElementData(other, "ajail", tiempo)

			local agente = tostring(getPlayerName(player):gsub("_", " "))
			local sql, error = exports.sql:query_insertid("INSERT INTO `historiales` (`historialID`, `nombre`, `dni`, `residencia`, `profesion`, `delitos`, `agente`, `fecha`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP);", 
				getPlayerName(other):gsub("_", " "), 
				tostring(20000000+exports.players:getCharacterID(other)), 
				"No Procede", 
				"No Procede", 
				tostring(razon).." (( "..tostring(tiempo).." minutos.))", 
				agente
			)
			exports.sql:query_free("UPDATE characters SET ajail = "..tiempo.." WHERE characterID = "..exports.players:getCharacterID(other))
		else
			outputChatBox("No eres militar.", player, 255, 0, 0)
		end
	else
		outputChatBox("Syntax: /encarcelar [jugador] [tiempo] [razón]", player, 255, 255, 255)
	end
end
addCommandHandler("encarcelar", arrestar)]]--
