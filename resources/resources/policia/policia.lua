-- 
local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end
local arrestado = { }


function avisarPolicia(player) 
	if getElementDimension(player) == 0 then
		local x, y, z = getElementPosition(player)
		exports.factions:createFactionBlip2(x, y, z, 1)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(player))
		exports.factions:createFactionBlip2(x, y, z, 1)
	end
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) then
		outputChatBox( "((/avisarpd "..getPlayerName(player)..")) Emergencia - Situacion: ¡Se requiere urgentemente a la policía en el lugar!", v, 130, 255, 130 )
		triggerClientEvent( v, "gui:hint", v, "Policía: Emergencia", "Situacion: ¡Se requiere urgentemente a la policía en el lugar!" )
		end
	end
	outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", player, 255, 0, 0)
end

addCommandHandler("avisarpd", avisarPolicia)
addCommandHandler("avisarsd", avisarPolicia)

function nivelDeAlcohol ( thePlayer, commandName, otherPlayer )
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then	        
		if exports.players:isLoggedIn( thePlayer ) then
			if otherPlayer then
				local other, name = exports.players:getFromName( player, otherPlayer )
				if other then
					local x, y, z = getElementPosition( thePlayer )
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( other ) ) < 5 then
						local alcohol = getElementData (other, "alcohol")
						if alcohol and tonumber(alcohol) > 0 then
							exports.chat:me( thePlayer, " comprueba el nivel de alcohol de " .. name .."." )            
							outputChatBox( name .. " tiene un " .. tostring(alcohol) .. "% de alcohol.", thePlayer, 255, 0, 0 )
						else
							exports.chat:me( thePlayer, " comprueba el nivel de alcohol de " .. name .."." )
							outputChatBox( name .. " no ha bebido alcohol.", thePlayer, 0, 255, 0 )
						end
					else 
						outputChatBox( "Estás demasiado lejos de " .. name .. ".", thePlayer, 255, 0, 0 )
					end
				end
			else
				outputChatBox("Sintaxis: /"..tostring(commandName).." [jugador]", thePlayer, 255, 255, 255)
			end
		end
	else
		outputChatBox("No eres policía.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("alc", nivelDeAlcohol)
addCommandHandler("alcoholimetro", nivelDeAlcohol)
addCommandHandler("alcohol", nivelDeAlcohol)

function refPolicia( player, cmd, aviso )
	if player then
		if isPedDead(player) or getElementData(player, "muerto") == true then outputChatBox("No puedes activar el botón de refuerzos una vez muerto.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 22) or exports.factions:isPlayerInFaction(player, 27) then
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if x and y and z then
				if not getElementData(player, "ref") then
					if not aviso then
						exports.factions:sendMessageToFaction(1, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." pide refuerzos, acuda a sus 10-20.",127, 127, 255,true )
						exports.factions:sendMessageToFaction(22, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." pide refuerzos, acuda a sus 10-20.",127, 127, 255,true )
						exports.factions:sendMessageToFaction(27, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." pide refuerzos, acuda a sus 10-20.",127, 127, 255,true )
                                             end
					for key, value in ipairs(getElementsByType("player")) do
					    if exports.factions:isPlayerInFaction(value, 1) or exports.factions:isPlayerInFaction(value, 22) or exports.factions:isPlayerInFaction(value, 27) then
					        b = createBlip(x, y, z, 41, 2, 255, 0, 0, 255, 0, 99999.0, value)
					        attachElements(b, player)
					        setElementData(b, "police", tostring(getPlayerName(player)))
					        setPlayerHudComponentVisible(value, "radar", true)
					    end
					end
					setElementData(player, "ref", true)
					else
					for key, value in ipairs(getElementsByType("blip")) do
						if getElementData(value, "police") == getPlayerName(player) then destroyElement(value) end
					end	
					if not aviso then
						exports.factions:sendMessageToFaction(1, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." ya no necesita refuerzos , Codigo 4.",127, 127, 255,true )
						exports.factions:sendMessageToFaction(22, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." ya no necesita refuerzos , Codigo 4.",127, 127, 255,true )
						exports.factions:sendMessageToFaction(27, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." ya no necesita refuerzos , Codigo 4.",127, 127, 255,true )
                                             end
					removeElementData(player, "ref")
				end
			end
		end
	end
end
addCommandHandler( "ref", refPolicia )

function ref2( player, cmd, aviso)
	if player then
		if exports.items:has(player, 35,2) then
		if isPedDead(player) or getElementData(player, "muerto") == true then outputChatBox("No puedes activar el botón de pánico una vez muerto.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(player, 1) or getElementData(player, "enc1") then
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if x and y and z then
				if not getElementData(player, "ref2") then
				for key, value in ipairs( getElementsByType("player") ) do
					if exports.factions:isPlayerInFaction(value, 1) or exports.factions:isPlayerInFaction(value, 22) or getElementData(value, "enc1") then
						if not aviso then
							outputChatBox("#7F7FFF(( #FF0000SD#7F7FFF )) "..getPlayerName( player ):gsub( "_", " " ).." HA ENVIADO UNA SEÑAL DE SOCORRO 10-32", value, 255, 0, 0,true)
							outputChatBox("#7F7FFF(( #FF0000SD#7F7FFF )) "..getPlayerName( player ):gsub( "_", " " ).." HA ENVIADO UNA SEÑAL DE SOCORRO 10-32", value, 255, 0, 0,true)
							outputChatBox("#7F7FFF(( #FF0000SD#7F7FFF )) "..getPlayerName( player ):gsub( "_", " " ).." HA ENVIADO UNA SEÑAL DE SOCORRO 10-32", value, 255, 0, 0,true)
						end
						b = createBlip ( x, y, z, 20, 2, 0, 0, 255, 255, 0, 99999.0, value )
						attachElements( b, player )
						setElementData(b, "police2", tostring(getPlayerName(player)))
						setPlayerHudComponentVisible ( value, "radar", true )
					end
				end
				setElementData(player, "ref2", true)
				else
				for key, value in ipairs(getElementsByType("blip")) do
					if getElementData(value, "police2") == getPlayerName(player) then destroyElement(value) end
				end
					for k2, v2 in ipairs (getElementsByType("player")) do
						if exports.factions:isPlayerInFaction(v2, 1) or exports.factions:isPlayerInFaction(v2, 22) or hasObjectPermissionTo(v2, "command.encubierto", false) then
							if not aviso then
								outputChatBox("#7F7FFF(( #FF0000PD#7F7FFF )) EL AGENTE "..getPlayerName( player ):gsub( "_", " " ).." #FF0000HA DESACTIVADO SU BOTÓN DE PANICO.", v2, 255, 255, 0,true)
							end
							removeElementData(v2, "ref2")
						end
					end
					if not aviso then
						outputChatBox("Has apagado tu botón de pánico.", player, 255, 0, 0)
					end
				end
			end
		end
	else
	outputChatBox("(( No tienes tu botón de panico en el bolsillo ))", player, 255, 0, 0)
	end
	end
end
addCommandHandler( "pan", ref2 )
addCommandHandler( "panico", ref2 )

function ref_departamento( player, cmd, aviso)
	if player then
		if isPedDead(player) or getElementData(player, "muerto") == true then outputChatBox("No puedes activar el botón de refuerzos una vez muerto.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 2) or exports.factions:isPlayerInFaction(player, 5) or exports.factions:isPlayerInFaction(player, 6) then
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if x and y and z then
				if not getElementData(player, "dref") then
					if not aviso then
						exports.factions:sendMessageToFaction(1, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(2, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(5, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(6, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
					end
					for key, value in ipairs( getElementsByType("player") ) do
						if exports.factions:isPlayerInFaction(value, 1) or exports.factions:isPlayerInFaction(value, 2) or exports.factions:isPlayerInFaction(value, 5) or exports.factions:isPlayerInFaction(value, 6) then
							b = createBlip ( x, y, z, 24, 2, 255, 0, 0, 255, 0, 99999.0, value )
							attachElements( b, player )
							setElementData(b, "dpolice", tostring(getPlayerName(player)))
							setPlayerHudComponentVisible ( value, "radar", true )
						end
					end
					setElementData(player, "dref", true)
					else
					for key, value in ipairs(getElementsByType("blip")) do
						if getElementData(value, "dpolice") == getPlayerName(player) then destroyElement(value) end
					end	
					if not aviso then
						exports.factions:sendMessageToFaction(1, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha retirado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(2, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha retirado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(5, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha retirado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(6, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha retirado su posición.", 0, 153, 0)
					end
					removeElementData(player, "dref")
				end
			end
		end
	end
end
addCommandHandler( "dref", ref_departamento )


function cachearJugador (p, cmd, o)
	if o and p then
		target, targetName = exports.players:getFromName( p, o )
		if not target then return end
		x1, y1, z1 = getElementPosition ( p )
		x2, y2, z2 = getElementPosition ( target )
		distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
		local vehicle = getPedOccupiedVehicle(p)
		local vehicle2 = getPedOccupiedVehicle(target)
		local tieneArmas = false
			if ( distance < 2.5) or (vehicle and vehicle2 and vehicle == vehicle2) then
				exports.chat:me(p, "empieza a cachear a ".. targetName)
				outputChatBox( "Dinero: "..(getPlayerMoney(target)) , p, 255, 150, 0 )
				for slot = 0, 6 do
					local weapon = getPedWeapon( target, slot )
					local balas = getPedTotalAmmo( target, slot )
					if weapon ~= 0 and (balas >= 1 and balas) then
						tieneArmas = true
					end
				end
				if tieneArmas == true then
					outputChatBox( "Armas: Tiene armas sacadas." , p, 255, 150, 0 )
				else
					outputChatBox( "Armas: No tiene armas sacadas." , p, 255, 150, 0 )
				end
				triggerClientEvent(p, "onRequestAnotherInventory", p, exports.items:get(target), target)
			else
				outputChatBox( "Estas demasiado lejos de ".. targetName, p, 255, 255, 255 )
			end
	else
		outputChatBox( "Sintaxis: /" .. cmd .. " [otro jugador]", p, 255, 255, 255 )
	end
end
addCommandHandler( "cachear" , cachearJugador)

function quitFreno (player)
	local oveh = getVehicleTowedByVehicle(getPedOccupiedVehicle(player))
	if oveh then
		setElementFrozen(oveh, false)
		outputChatBox("Has quitado el freno correctamente.", player, 0, 255, 0)
	else
		outputChatBox("¡Debes de estar subido en una grúa y tener el coche enganchado!", player, 255, 0, 0)
	end
end	 
addCommandHandler("quitarfreno", quitFreno)

local discordWebhookLOGS = "https://discord.com/api/webhooks/1249135235048669294/UGzAXw5D6EN1g-zvhNcnbWHybE9axc1SbqVN1UCRqlfJ8FSIlTHFWoraosxqB6xl2pwp"

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

function arrestar(player, commandName, otherPlayer, tiempo, ...)
    local razon = table.concat({...}, " ")
    local other, name = exports.players:getFromName(player, otherPlayer)
    if other and razon and tiempo and tonumber(tiempo) then
        if exports.factions:isPlayerInFaction(player, 1) then
            if (getElementDimension(player) ~= 2578) or (getElementDimension(other) ~= 2578) then 
                outputChatBox("(( No puedes arrestar a alguien estando fuera de Prision ))", player, 255, 0, 0) 
                return 
            end

            for k, v in ipairs(getElementsByType("player")) do
                if exports.factions:isPlayerInFaction(v, 1) then
                    outputChatBox(name .. " ha sido arrestado.", v, 255, 0, 0)
                    outputChatBox("Tiempo: ((" .. tostring(tiempo) .. " minutos)) Razón:" .. razon, v, 255, 0, 0)
                end
            end

             if getElementDimension(other) == 2578 then
                setElementPosition(other, 264.4736328125, 77.564453125, 1001.0390625)
                setElementInterior(other, 6)
                setElementDimension(other, 2578)

                local skinActual = getElementModel(other)
                setElementData(other, "originalSkin", skinActual)
                setElementModel(other, 17)
            else
                outputChatBox("¡Sólo puedes arrestar a alguien en Prision!.", player, 255, 0, 0)
                return
            end

            local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(other))
            if nivel == 3 and not exports.objetivos:isObjetivoCompletado(32, exports.players:getCharacterID(other)) then
                exports.objetivos:addObjetivo(32, exports.players:getCharacterID(other), other)
            end

            outputChatBox("Has sido arrestado durante " .. tostring(tiempo) .. " minutos.", other, 255, 0, 0)
            outputChatBox("Razón: " .. tostring(razon), other, 255, 0, 0)
            setElementData(other, "ajail", tonumber(tiempo))

            local agente = tostring(getPlayerName(player):gsub("_", " "))
            local sql, error = exports.sql:query_insertid("INSERT INTO `historiales` (`historialID`, `nombre`, `dni`, `residencia`, `profesion`, `delitos`, `agente`, `fecha`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP);", getPlayerName(other):gsub("_", " "), tostring(20000000 + exports.players:getCharacterID(other)), "No Procede", "No Procede", tostring(razon) .. " (( " .. tostring(tiempo) .. " minutos.))", agente)
            exports.sql:query_free("UPDATE characters SET ajail = " .. tiempo .. " WHERE characterID = " .. exports.players:getCharacterID(other))

            local message = string.format("**Fecha:** %s\n**Agente:** %s\n**Nombre:** %s\n**Razón:** %s\n**Tiempo:** %s mes(es).", os.date("%Y/%m/%d"), agente, getPlayerName(other), razon, tiempo)
            sendDiscordLogMessage(message, player)
        else
            outputChatBox("No eres policia.", player, 255, 0, 0)
        end
    else
        outputChatBox("Syntax: /arrestar [jugador] [tiempo] [razón]", player, 255, 255, 255)
    end
end
addCommandHandler("arrestar", arrestar)


function mostrarPlaca ( player, commandName, otherPlayer )
	if exports.factions:isPlayerInFaction(player, 1) then
		if exports.items:has(player, 35,3) then
			if otherPlayer then
				target, targetName = exports.players:getFromName( player, otherPlayer )
			else
				target = player
				targetName = getPlayerName( player ):gsub( "_", " " )
			end
			if player then
				x1, y1, z1 = getElementPosition ( player )
				x2, y2, z2 = getElementPosition ( target )
				if exports.factions:isPlayerInFaction ( player, 1 ) then
					distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
					if ( distance < 5) then
						exports.chat:me( player, "le enseña su placa a " .. targetName .. "." )
						outputChatBox( " -------- Policia Nacional Colombiana ---------- ", target, 255, 150, 0 )
						outputChatBox( "Placa a nombre de: " .. getPlayerName( player ):gsub( "_", " " ) .. ".", target, 255, 150, 0 )
						if getElementData(player, "enc1") then
							outputChatBox( "Alto Mando Policial", target, 255, 150, 0 )
						else
							outputChatBox( "Miembro Del Cuerpo Policial", target, 255, 150, 0 )
						end
						outputChatBox( "Tiene permiso de intervenir en procedimientos policiales.", target, 255, 150, 0 )
						outputChatBox( " ------------------------- ", target, 255, 150, 0 )
					else
					outputChatBox( "Estas muy lejos para enseñarle tu placa. ", player, 255, 50, 0 )
					end
				end
			end
		else
		outputChatBox("(( No tienes tu placa en el bolsillo ))", player, 255, 0, 0)
		end
    end
end	
addCommandHandler( "placa", mostrarPlaca ) 

siguimientos = {}

function dogFollow(theprisoner)
    if siguimientos[theprisoner] == nil then
        return
    else
        if not theprisoner then return end
        local policia = siguimientos[theprisoner]
        local copx, copy, copz = getElementPosition(policia)
        local prisonerx, prisonery, prisonerz = getElementPosition(theprisoner)
        local copangle = (360 - math.deg(math.atan2((copx - prisonerx), (copy - prisonery)))) % 360
        setPedRotation(theprisoner, copangle)
        local dist = getDistanceBetweenPoints2D(copx, copy, prisonerx, prisonery)
        
        if getElementInterior(policia) ~= getElementInterior(theprisoner) then
            setElementInterior(theprisoner, getElementInterior(policia))
        end
        if getElementDimension(policia) ~= getElementDimension(theprisoner) then
            setElementDimension(theprisoner, getElementDimension(policia))
        end
        
        if dist >= 200 then
            local x, y, z = getElementPosition(policia)
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
        
        if isPedInVehicle(policia) then
            local car = getPedOccupiedVehicle(policia)
            for i = 0, getVehicleMaxPassengers(car) do
                local p = getVehicleOccupant(car, i)
                if not p and not isVehicleLocked(car) then
                    warpPedIntoVehicle(theprisoner, car, i)
                end
            end
        else
            if isPedInVehicle(theprisoner) then
                removePedFromVehicle(theprisoner)
            end
        end

        setTimer(dogFollow, 750, 1, theprisoner)
    end
end

function stopFollowing(theprisoner)
    if siguimientos[theprisoner] then
        siguimientos[theprisoner] = nil
        setPedAnimation(theprisoner, false)
    end
end

addCommandHandler("esposar",
    function(p, cmd, otro)
        if otro then
            if not p or isPedDead(p) then return end
            if exports.items:has(p, 35, 4) then
                local other, name = exports.players:getFromName(p, otro)
                if isPedInVehicle(p) then outputChatBox("No puedes esposar a alguien si estás en un vehículo.", p, 255, 0, 0) return end
                if not other or isPedDead(other) then outputChatBox("No puedes esposar al jugador si está muerto.", p, 255, 0, 0, true) return end
                if getElementData(other, "muerto", true) then outputChatBox("No puedes esposar al jugador si está muerto.", p, 255, 0, 0, true) return end
                if isPedInVehicle(other) then outputChatBox("No puedes esposar a alguien que está en un vehículo.", p, 255, 0, 0) return end
                if other ~= p then
                    if not arrestado[p] then
                        if arrestado[other] then
                            local x, y, z = getElementPosition(p)
                            local int1, dim1 = getElementInterior(p), getElementDimension(p)
                            local int2, dim2 = getElementInterior(other), getElementDimension(other)
                            if getDistanceBetweenPoints3D(x, y, z, unpack({getElementPosition(other)})) < 3 and int1 == int2 and dim1 == dim2 then
                                local pl = arrestado[p]
                                local rx, ry, rz = getElementRotation(p)
                                setElementData(other, "esposado", false)
                                setElementData(other, "player.Cuffed", false)
                                toggleControl(other, "sprint", true)
                                toggleControl(other, "fire", true)
                                toggleControl(other, "jump", true)
                                toggleControl(other, "action", true)
                                toggleControl(other, "aim_weapon", true)
                                toggleControl(other, "next_weapon", true)
                                toggleControl(other, "previous_weapon", true)
                                toggleControl(other, "accelerate", true)
                                toggleControl(other, "brake_reverse", true)
                                toggleControl(other, "forwards", true)
                                toggleControl(other, "backwards", true)
                                toggleControl(other, "left", true)
                                toggleControl(other, "right", true)
                                setPedAnimation(p, "bd_fire", "wash_up", 3000, false, false, false, false)
                                setPedAnimation(other)
                                exports.chat:me(p, "le quita las esposas a " .. name:gsub("_", " ") .. " y las guarda en su CT.")
                                arrestado[other] = nil
                                stopFollowing(other)
                                for i, players in ipairs(getElementsByType("player")) do
                                    local x1, y1, z1 = getElementPosition(players)
                                    if getDistanceBetweenPoints3D(x, y, z, x1, y1, z1) < 20 then
                                        triggerClientEvent(players, "ejecutarSonidoPolicia", players, "esposas", x, y, z)
                                    end
                                end
                            end
                        else
                            local x, y, z = getElementPosition(p)
                            local int1, dim1 = getElementInterior(p), getElementDimension(p)
                            local int2, dim2 = getElementInterior(other), getElementDimension(other)
                            if getDistanceBetweenPoints3D(x, y, z, unpack({getElementPosition(other)})) < 3 and int1 == int2 and dim1 == dim2 then
                                if not arrestado[other] then
                                    local rx, ry, rz = getElementRotation(p)
                                    arrestado[other] = p
                                    setElementData(other, "esposado", true)
                                    setElementData(other, "player.Cuffed", true)
                                    exports.chat:me(p, "saca las esposas de su CT y se las coloca a " .. name:gsub("_", " ") .. ".")
                                    setPedWeaponSlot(other, 0)
                                    toggleControl(other, "fire", false)
                                    toggleControl(other, "action", false)
                                    toggleControl(other, "jump", false)
                                    toggleControl(other, "sprint", false)
                                    toggleControl(other, "aim_weapon", false)
                                    toggleControl(other, "next_weapon", false)
                                    toggleControl(other, "previous_weapon", false)
                                    toggleControl(other, "accelerate", false)
                                    toggleControl(other, "brake_reverse", false)
                                    toggleControl(other, "forwards", false)
                                    toggleControl(other, "backwards", false)
                                    toggleControl(other, "left", false)
                                    toggleControl(other, "right", false)
                                    setPedAnimation(p, "bd_fire", "wash_up", 3000, false, false, false, false)
                                    for i, players in ipairs(getElementsByType("player")) do
                                        local x1, y1, z1 = getElementPosition(players)
                                        if getDistanceBetweenPoints3D(x, y, z, x1, y1, z1) < 20 then
                                            triggerClientEvent(players, "ejecutarSonidoPolicia", players, "esposas", x, y, z)
                                        end
                                    end
                                    siguimientos[other] = p
                                    dogFollow(other)
                                end
                            else
                                outputChatBox("Estás demasiado lejos de " .. name .. ".", p, 255, 0, 0, true)
                            end
                        end
                    else
                        outputChatBox("Estás esposado, no puedes utilizar este comando.", p, 255, 0, 0, true)
                    end
                else
                    outputChatBox("No puedes hacer eso.", p, 255, 0, 0, true)
                end
            else
                outputChatBox("No tienes las esposas en tu mochila.", p, 255, 0, 0, true)
            end
        else
            outputChatBox("Syntax: /" .. cmd .. " [Jugador]", p, 255, 0, 0, true)
        end
    end
)


--[[function mejoraArmas () 
	outputDebugString("Mejora OK")
	-- MEJORA DE ARMA DEAGLE --
	setWeaponProperty(24, "std", "move_speed", getOriginalWeaponProperty(24, "std", "move_speed"))
	setWeaponProperty(24, "std", "anim_breakout_time", getOriginalWeaponProperty(24, "std", "anim_breakout_time"))
	setWeaponProperty(24, "std", "flags", "flag_move_and_shoot", getOriginalWeaponProperty(24, "std", "flags", "flag_move_and_shoot"))
	setWeaponProperty(24, "std", "flags", "flag_move_and_aim", getOriginalWeaponProperty(24, "std", "flags", "flag_move_and_aim"))
	setWeaponProperty(24, "std", "flags", "flag_anim_reload", getOriginalWeaponProperty(24, "std", "flags", "flag_anim_reload"))
	setWeaponProperty(24, "std", "anim_loop_start", getOriginalWeaponProperty(24, "std", "anim_loop_start"))
	setWeaponProperty(24, "std", "anim_loop_stop", getOriginalWeaponProperty(24, "std", "anim_loop_stop"))
	setWeaponProperty(24, "std", "maximum_clip_ammo", getOriginalWeaponProperty(24, "std", "maximum_clip_ammo"))
	-- FIN MEJORA DE ARMA DEAGLE --
end
addCommandHandler("mpol", mejoraArmas)]]

local IDs =
    {
		[ 3 ] = true,
		[ 24 ] = true,
		[ 25 ] = true,
		[ 29 ] = true,
		[ 31 ] = true,
    }
	
local balasCargador =
{
    [ 22 ] = 12,
    [ 23 ] = 12,
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
	if not exports.factions:isPlayerInFaction(player, 1) then outputChatBox("No eres policía.", player, 255, 0, 0) return end
	if not getElementDimension(player) == 70 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 1 AND characterID = " .. exports.players:getCharacterID(player))
	local rango = result.factionRank
	if not rango or not result or rango < 9 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
	if not wid then outputChatBox("Sintaxis: /armaspd [arma ID]", player, 255, 255, 255) return end
	if not IDs[tonumber(wid)] then outputChatBox("Solo puedes usar las siguientes IDs: 3, 24, 25, 29, 31", player, 255, 0, 0) return end
	exports.items:give(player, 29, tostring(wid), "Arma "..tostring(wid), 1)
	outputChatBox("Has adquirido un arma "..tostring(wid).." sin munición.", player, 0, 255, 0)
	outputChatBox("Utiliza /cargadorespd para obtener cargadores de cada arma.", player, 255, 0, 0)
	exports.logs:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha obtenido un arma "..tostring(wid)..".\n")
end
--addCommandHandler("armaspd", getArmamento)

function getCargadores (player, cmd, wid)
	if not exports.factions:isPlayerInFaction(player, 1) then outputChatBox("No eres policía.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 70 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 1 AND characterID = " .. exports.players:getCharacterID(player))
	local rango = result.factionRank
	if not rango or not result or rango < 9 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
	if not wid then outputChatBox("Sintaxis: /cargadorespd [arma ID]", player, 255, 255, 255) return end
	if not IDs[tonumber(wid)] then outputChatBox("Solo puedes usar las siguientes IDs: 3, 24, 25, 29, 31", player, 255, 0, 0) return end
	exports.items:give(player, 43, tostring(wid), "Cargador Arma PD["..getPlayerName(player):gsub("_", " ").."]", balasCargador[tonumber(wid)])
	outputChatBox("Has adquirido un cargador para un arma "..tostring(wid)..".", player, 0, 255, 0)
	exports.logs:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha obtenido cargador de un arma "..tostring(wid)..".\n")
end
--addCommandHandler("cargadorespd", getCargadores)

function giveUtiles (player, cmd, otherPlayer)
	if not exports.factions:isPlayerInFaction(player, 1) then outputChatBox("No eres policía.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 6 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	if otherPlayer then
	local other, name = exports.players:getFromName(player, otherPlayer)
	if other then
		local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 1 AND characterID = " .. exports.players:getCharacterID(player))
		local rango = result.factionRank
		if not rango or not result or rango < 9 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(other, 1) and getElementDimension(other) == 6 then
			exports.items:give(other, 35, 1)
			exports.items:give(other, 35, 2)
			exports.items:give(other, 35, 3)
			exports.items:give(other, 35, 4)
			outputChatBox("Has dado los útiles de PD a "..name..".", player, 0, 255, 0)
			outputChatBox(getPlayerName(player):gsub("_", " ").. " te ha dado los útiles de PD.", other, 0, 255, 0)
			exports.logs:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha dado utiles de PD a "..name..".")
		else
			outputChatBox("Error grave, asegúrate de que "..name.." está en la facción y en comisaria.", player, 255, 0, 0)
		end
	end
	else 
		outputChatBox("Sintaxis: /utilespd [agente]", player, 255, 255, 255)
	end
end
--addCommandHandler("utilespd", giveUtiles)

function getMunicionPD (player)
	if not exports.factions:isPlayerInFaction(player, 1) then outputChatBox("No eres policía.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 104 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	local wid = 24
	exports.items:give(player, 43, tostring(wid), "Cargador Arma PD["..getPlayerName(player):gsub("_", " ").."]", 7)
	outputChatBox("Has adquirido un cargador para un arma "..tostring(wid)..".", player, 0, 255, 0)
	exports.logs:addLogMessage("armaspd", getPlayerName(player):gsub("_", " ").." ha obtenido cargador de un arma "..tostring(wid)..".\n")
end
--addCommandHandler("municionpd", getMunicionPD)

function liberarJugador ( player, commandName, otherPlayer )
	if not otherPlayer then outputChatBox("Sintaxis: /liberar [jugador]", player, 255, 255, 255) return end
	local otro = exports.players:getFromName(player, otherPlayer)
	local charID = exports.players:getCharacterID(otro)
	if hasObjectPermissionTo(player, 'command.modchat', false) or exports.factions:isPlayerInFaction(player, 1) then
		if getElementData( otro, "ajail") and tonumber(getElementData( otro, "ajail")) > 0 then
			if getElementDimension(otro) == 0 then
				setElementPosition(otro, 633.6318359375, -572.3896484375, 16.3359375)
				setElementDimension(otro, 0)
				setElementInterior(otro, 0)
			end
			if getElementData(player, "enc") then
				outputChatBox('Alguien te ha sacado de la celda.', otro, 0, 255, 0)
			else
				outputChatBox('El agente/staff '..getPlayerName(player):gsub("_", " ").. ' te ha sacado de la celda.', otro, 0, 255, 0)
			end
			outputChatBox('Has sacado de la celda a '..getPlayerName(otro):gsub("_", " ").. '.', player, 0, 255, 0)
			removeElementData(otro, "ajail")
			exports.sql:query_free( "UPDATE characters SET ajail = 0 WHERE characterID = " .. charID )
		else
			outputChatBox("El jugador seleccionado no está arrestado a la espera de juicio.", player, 0, 255, 0)
		end
	else
		outputChatBox("Acceso denegado.", player, 0, 255, 0)
	end
end 
addCommandHandler("liberar", liberarJugador)

function getChaleco (player)
	if not exports.factions:isPlayerInFaction(player, 1) then outputChatBox("No eres policía.", player, 255, 0, 0) return end
	if getElementDimension(player) ~= 61 then outputChatBox("No estás en comisaria.", player, 255, 0, 0) return end
	if getPedArmor(player) < 100 then
		setPedArmor(player, 100)
		outputChatBox("Se ha renovado tu chaleco. Usa /chaleco de nuevo para quitártelo.", player, 0, 255, 0)
	else
		setPedArmor(player, 0)
		outputChatBox("Se te ha retirado tu chaleco. Usa /chaleco de nuevo para ponértelo.", player, 255, 0, 0)
	end
end
addCommandHandler("chaleco", getChaleco)

function elementClicked( theButton, theState, thePlayer )
	if getPedOccupiedVehicle(thePlayer) and source then
		if theButton == "left" and theState == "down" and getPedOccupiedVehicle(thePlayer) and getElementModel(getPedOccupiedVehicle(thePlayer)) == 525 and getVehicleType(source) == "Bike" and getVehicleController(source) == false then
			local vehicle = getPedOccupiedVehicle(thePlayer)
			attachElements(source, vehicle, 0, -3, 0.6, 0, 0, 90)
			outputChatBox("Se soltará al bajar de la grúa.", thePlayer, 0, 255, 0)
		end
	end
end
addEventHandler( "onElementClicked", getRootElement(), elementClicked )

function soltarMoto (player)
	if source and getElementModel(source) == 525 then 
		local attachedElements = getAttachedElements ( source )
		for i,v in ipairs ( attachedElements ) do
			if isElement(v) and getElementType(v) == "vehicle" then
				detachElements ( v, vehicle )
			end
		end
	end
end
addEventHandler("onVehicleExit", getRootElement(), soltarMoto)
markerParkPDC = createMarker( 1825.29, 337.04, 21, "cylinder", 60, 255, 0, 0, 0)

function marcarVehiculo (element, dimension)
	if element and getElementType(element) == "vehicle" and dimension == true and exports.vehicles:getOwner(element) == -1 then
		for k, v in ipairs(getElementsByType("player")) do
			if v and (exports.factions:isPlayerInFaction(v, 1) or getElementData(v, "enc1")) then
				createBlipAttachedTo(element, 55, 2, 0, 0, 0, 255, 0, 65535, v)
			end
		end
	end
end
addEventHandler("onMarkerLeave", markerParkPDC, marcarVehiculo)

function desmarcarVehiculo (element, dimension)
	if element and getElementType(element) == "vehicle" and dimension == true and exports.vehicles:getOwner(element) == -1 then
		for k, v in ipairs(getAttachedElements(element)) do
			if getElementType(v) == "blip" then
				destroyElement(v)
			end
		end
	end
end
addEventHandler("onMarkerHit", markerParkPDC, desmarcarVehiculo)

function crearBlipsAlStartResource2()
	for k, v in ipairs(getElementsByType("vehicle")) do
		if exports.vehicles:getOwner(v) == -1 and markerParkPDC and not isElementWithinMarker(v, markerParkPDC) and getElementDimension(v) ~= 415 then 
			for k2, v2 in ipairs(getElementsByType("player")) do
				local x, y, z = getElementPosition(v)
				if v2 and exports.factions:isPlayerInFaction(v2, 1) then
					createBlipAttachedTo(v, 55, 2, 0, 0, 0, 255, 0, 65535, v2)
				end
			end
		end
	end
end

function crearBlipsAlStartResource()
	setTimer(crearBlipsAlStartResource2, 5000, 1)
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), crearBlipsAlStartResource)

function crearBlipsAlStartPJ()
	if source and exports.factions:isPlayerInFaction(source, 1) or getElementData(source, "enc1") then
		for k, v in ipairs(getElementsByType("vehicle")) do
			local x, y, z = getElementPosition(v)
			if exports.vehicles:getOwner(v) == -1 and not isElementWithinMarker(v, markerParkPDC) and getElementDimension(v) ~= 415 then 
				createBlipAttachedTo(v, 55, 2, 0, 0, 0, 255, 0, 65535, source)
			end
		end 
	end
end
addEventHandler ( "onCharacterLogin", getRootElement(), crearBlipsAlStartPJ)

function destroyBlipsAlCambioPJ()
	if source then
		outputDebugString(getPlayerName(source).." onCharacterLogout detectado.")
		for k, v in ipairs(getElementsByType("vehicle")) do
			if exports.vehicles:getOwner(v) == -1 then
				for k2, v2 in ipairs(getAttachedElements(v)) do
					if getElementType(v2) == "blip" and isElementVisibleTo(v2, source) then
						destroyElement(v2)
					end
				end
			end
		end
	end
end
addEventHandler ( "onCharacterLogout", getRootElement(), destroyBlipsAlCambioPJ)

-- function solicitarDIC (player, cmd, nuevoName)
	-- if player and exports.players:isLoggedIn(player) and exports.factions:isPlayerInFaction(player, 1) then
		-- if nuevoName then
			-- if not string.find(nuevoName, "_") then outputChatBox("Formato incorrecto. Usa /dic Nombre_Apellido", player, 255, 0, 0) return end
			-- if getElementData(player, "dic") then outputChatBox("Usa /nodic para quitarte el nombre DIC.", player, 255, 0, 0) return end
			-- if exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s'", nuevoName ) then
				-- outputChatBox( "Otro jugador ya está utilizando ese nombre.", player, 255, 0, 0 )
			-- else
				-- setElementData(player, "dic", true)
				-- outputChatBox("Está usted ahora en Servicio DIC.", player, 0, 255, 0)
				-- outputChatBox("Para dejar de estar en Servicio DIC use /nodic", player, 255, 255, 0)
				-- outputChatBox("((Recuerda por ejemplo cambiar tu /yo para evitar ser detectado.))", player, 255, 0, 0)
				-- setPlayerName(player, tostring(nuevoName))
				-- exports.logs:addLogMessage("dic", "[ON] Agente: "..getPlayerName(player).. " Nueva Identidad: "..tostring(nuevoName))
			-- end
		-- else
			-- outputChatBox("Sintaxis: /dic Nombre_Apellido.", player, 255, 255, 255)
		-- end
	-- end
-- end
-- addCommandHandler("dic", solicitarDIC)

-- function solicitarNODIC (player)
	-- if player and exports.players:isLoggedIn(player) and exports.factions:isPlayerInFaction(player, 1) then
		-- if getElementData(player, "dic") then
			-- removeElementData(player, "dic")
			-- local sql = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
			-- outputChatBox("Está usted ahora fuera de Servicio DIC.", player, 0, 255, 0)
			-- exports.logs:addLogMessage("dic", "[OFF] Agente: "..tostring(sql.characterName).. " Antigua Identidad: "..tostring(getPlayerName(player)))
			-- setPlayerName(player, tostring(sql.characterName))
		-- end
	-- end
-- end
-- addCommandHandler("nodic", solicitarNODIC)

function regularizarMultasFacciones(player)

	if not exports.factions:isPlayerInFaction(player, 1) then outputChatBox("No eres policía.", player, 255, 0, 0) return end
	local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 1 AND characterID = " .. exports.players:getCharacterID(player))
	local rango = result.factionRank
	if not rango or not result or rango < 9 then outputChatBox("No tienes suficiente rango como para acceder a este comando.", player, 255, 0, 0) return end

	local sql = exports.sql:query_assoc("SELECT * FROM multas WHERE estado = 1 AND characterID < 0")
	for k, v in ipairs(sql) do
		if exports.factions:takeFactionPresupuesto(math.abs(v.characterID), v.cantidad) then
			exports.sql:query_free("UPDATE multas SET pagado = cantidad WHERE ind = "..v.ind)
			exports.sql:query_free("UPDATE multas SET estado = 0 WHERE ind = "..v.ind)
		else
			outputChatBox("Facción ID "..tostring(v.characterID).." no ha podido saldar sus deudas.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("pagofac", regularizarMultasFacciones)

-- function myTestBug()
	-- local player = getPlayerFromName("Test")
	-- local x,y,z = getElementPosition(player)
	-- local marker = createMarker( x,y,z, "cylinder", 20.0, 255, 0, 0, 255)
	-- if isElementWithinMarker(player, marker) then
		-- outputChatBox("Works fine!", player, 0, 255, 0)
	-- else
		-- outputChatBox("Fail detected!", player, 255, 0, 0)
	-- end
-- end
-- addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), myTestBug)