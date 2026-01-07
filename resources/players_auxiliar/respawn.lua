--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local avisoExplosion = { }

function hayMedicos()
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 2) then
			return true
		end
	end
end

function avisarMedicos(herido) 
	if getElementDimension(herido) == 0 then
		local x, y, z = getElementPosition(herido)
		exports.factions:createFactionBlip2(x, y, z, 2)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(herido))
		exports.factions:createFactionBlip2(x, y, z, 2)
	end
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 2) then
		outputChatBox( "SMS de un ciudadano: Hospital: Emergencia - Situacion: Hay un hombre herido, corre riesgo de muerte.", v, 130, 255, 130 )
		triggerClientEvent( v, "gui:hint", v, "Hospital: Emergencia", "Situacion: Hay un hombre herido, corre riesgo de muerte." )
		end
	end
end

local sinMSJ =
    {
		[ 9 ] = true,
        [ 16 ] = true,
		[ 17 ] = true,
		[ 18 ] = true,
		[ 39 ] = true,
		[ 41 ] = true,
		[ 42 ] = true,
		[ 37 ] = true,
		[ 51 ] = true,
		[ 53 ] = true,
    }
	
local isMuertoQuemado = {}

function sufrirAtaque (atacante, arma, parte, muerto, staff)
	if getElementModel(source) == 279 and getWeaponNameFromID(arma) == "Drowned" then return end
	if isMuertoQuemado[source] then return end
	local duty = exports.players:getOption(source, "staffduty")
	
	-- SISTEMA DE HEADSHOT: Si es un disparo en la cabeza (parte 9) con un arma de fuego (armas 22-38)
	if atacante and parte == 9 and arma >= 22 and arma <= 38 and not getElementData(atacante, "tazerOn") and not getElementData(atacante, "gomaOn") then
		-- Hacer que el jugador quede sin cabeza
		setPedHeadless(source, true)
		
		-- Procesar el headshot como muerte directa
		if isPedInVehicle(source) then removePedFromVehicle(source) end
		if isPedDead(source) then
			local x, y, z = getElementPosition(source)
			spawnPlayer(source, x, y, z, 0, getElementModel(source), 0, 0)
			fadeCamera(source, true)
			setCameraTarget(source, source)
		end
		
		-- Mensajes y animación
		outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha dado un disparo en la cabeza con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
		outputChatBox("Has dado un disparo en la cabeza a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
		outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
		
		-- Animación y estado
		setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
		outputChatBox("Estás GRAVEMENTE herido o MUERTO por un disparo en la cabeza.", source, 255, 0, 0)
		setElementHealth(source, 1)
		setElementData(source, "muerto", true)
		
		-- Notificar a otros jugadores cercanos
		local x, y, z = getElementPosition(source)
		local jugadoresCercanos = getElementsWithinRange(x, y, z, 20, "player")
		for _, jugador in ipairs(jugadoresCercanos) do
			if jugador ~= source and jugador ~= atacante then
				outputChatBox("Escuchas un disparo certero y ves caer a alguien cerca de ti.", jugador, 255, 165, 0)
			end
		end
		
		-- Activar evento de animación de muerte
		triggerClientEvent(source, "onClientMuertoCapitalRP", source)
		
		-- Asegurar que los controles de chat estén permitidos explícitamente
		toggleControl(source, "chatbox", true)
		toggleControl(source, "chat", true)
		return
	end
	
	if atacante and (duty == false or not duty) then
		if getElementData(atacante, "tjail") and getElementData(atacante, "tjail") >= 1 and getElementData(atacante, "tjail") <= 80 then exports.jail:serverJail(atacante, tonumber(getElementData(atacante, "tjail")+5), "DM en Jail") return end
		local tipo = getElementType(atacante)
		if tipo == "player" then
			if not staff then
				setElementData(source, "herida"..tostring(parte), true)
			end
			if arma == 0 then
				if muerto == true then
					if not staff then
						outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado a puño.", source, 177, 177, 177)
						outputChatBox("Has matado a golpes a "..getPlayerName(source):gsub("_", " ")..".", atacante, 177, 177, 177)
						outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
					end
					if isPedInVehicle(source) then removePedFromVehicle(source) end
					if isPedDead(source) then
						local x, y, z = getElementPosition(source)
						spawnPlayer( source, x, y, z, 0, getElementModel( source ), 0, 0 )
						fadeCamera( source, true )
						setCameraTarget( source, source )
					end
					setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
					--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
					setElementHealth(source, 1)
					setElementData(source, "muerto", true)
					triggerClientEvent(source, "onClientMuertoCapitalRP", source)
				else
					if not staff then
						if getElementHealth(source) > 5 then
							setElementHealth(source, getElementHealth(source)-5)
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado a puño.", source, 177, 177, 177)
							outputChatBox("Has golpeado a "..getPlayerName(source):gsub("_", " ")..".", atacante, 177, 177, 177)
						else -- El jugador ha muerto
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado a puño.", source, 177, 177, 177)
							outputChatBox("Has matado a golpes a "..getPlayerName(source):gsub("_", " ")..".", atacante, 177, 177, 177)
							outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
							setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
							outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
							--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
							setElementHealth(source, 1)
							setElementData(source, "muerto", true)
							triggerClientEvent(source, "onClientMuertoCapitalRP", source)
						end
					end 
				end
			elseif arma >= 1 then
				if muerto == true then
					if not staff then
						outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
						outputChatBox("Has matado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
						outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
					end
					if isPedInVehicle(source) then removePedFromVehicle(source) end
					if isPedDead(source) then
						local x, y, z = getElementPosition(source)
						spawnPlayer( source, x, y, z, 0, getElementModel( source ), 0, 0 )
						fadeCamera( source, true )
						setCameraTarget( source, source )
					end
					setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
					--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
					setElementHealth(source, 1)
					setElementData(source, "muerto", true)
					triggerClientEvent(source, "onClientMuertoCapitalRP", source)
				else
					if not staff then
						if arma == 24 and getElementData(atacante, "tazerOn") then
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha tazeado con su Deagle.", source, 177, 177, 177)
							outputChatBox("Has tazeado a "..getPlayerName(source):gsub("_", " ").." con tu Deagle.", atacante, 177, 177, 177)
							triggerEvent("onPlayerTazed", source, atacante, 24, parte)
						elseif arma == 25 and getElementData(atacante, "gomaOn") then
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un cartucho de goma.", source, 177, 177, 177)
							outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un cartucho de goma.", atacante, 177, 177, 177)
							triggerEvent("onPlayerTazed", source, atacante, 25, parte)
						else
							hpq = 0
							if arma == 1 then
								hpq = 5								
							elseif arma == 4 or arma == 8 or arma == 30 or arma == 31 then
								hpq = 20
							elseif arma == 2 or arma == 3 or arma == 5 or arma == 6 or arma == 7 then
								hpq = 10
							elseif arma == 22 or arma == 26 then
								hpq = 25
							elseif arma == 23 or arma == 27 or arma == 33 then
								hpq = 30
							elseif arma == 24 then
								hpq = 45
							elseif arma == 25 then
								hpq = 55
							elseif arma == 28 or arma == 29 or arma == 32 then
								hpq = 10
							elseif arma == 16 then
								hpq = 60
							elseif arma == 34 then
								hpq = 70
							else
								hpq = 0
							end
							if getPedArmor(source) > 0 and tonumber(parte) == 3 then -- Tiene chaleco y va al torso.
								if getPedArmor(source) >= hpq then -- Con el chaleco tiene bastante.
									setPedArmor(source, tonumber(getPedArmor(source)-hpq))
									if not sinMSJ [arma] then
										outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
										outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
									end
								else -- Pues calculamos la diferencia, y lo que le falte se lo quitamos de vida.
									dif = hpq-getPedArmor(source)
									setPedArmor(source, 0)
									if dif < tonumber(getElementHealth(source)) then 
										setElementHealth(source, tonumber(getElementHealth(source)-dif))
										if not sinMSJ [arma] then
											outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
											outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
										end
									else -- Ha muerto
										outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
										outputChatBox("Has matado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
										outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
										setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
										outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
										--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
										setElementHealth(source, 1)
										setElementData(source, "muerto", true)
										triggerClientEvent(source, "onClientMuertoCapitalRP", source)
									end
								end
							elseif hpq < tonumber(getElementHealth(source)) then 
								setElementHealth(source, tonumber(getElementHealth(source)-hpq))
								if not sinMSJ [arma] then
									outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
									outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
								end
							else -- Ha muerto
								outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
								outputChatBox("Has matado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
								outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
								setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
								outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
								--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
								setElementHealth(source, 1)
								setElementData(source, "muerto", true)
								triggerClientEvent(source, "onClientMuertoCapitalRP", source)
							end
						end
					end
				end
			end
		elseif tipo == "vehicle" and atacante and getVehicleController(atacante) then
			outputChatBox("El jugador " ..getPlayerName(getVehicleController(atacante)):gsub("_", " ").." te ha atropellado.", source, 177, 177, 177)
			outputChatBox("Has atropellado al jugador "..getPlayerName(source):gsub("_", " ")..".", getVehicleController(atacante), 177, 177, 177)
		end
	else
		if not duty or duty == false then
			if muerto == true then
				if isPedDead(source) then
					local x, y, z = getElementPosition(source)
					spawnPlayer( source, x, y, z, 0, getElementModel( source ), 0, 0 )
					fadeCamera( source, true )
					setCameraTarget( source, source )
				end
				setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
				outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
				--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
				setElementHealth(source, 1)
				setElementData(source, "muerto", true)
				triggerClientEvent(source, "onClientMuertoCapitalRP", source)
			else
				outputChatBox("Te has hecho daño tú mismo.", source, 177, 177, 177)
				if muerto == true then
					setPedAnimation(source, "wuzi", "cs_dead_guy", -1, true, true, true)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO.", source, 255, 0, 0)
					--outputChatBox("Usa /avisarsura para solicitar un medico.", source, 255, 0, 0)
					setElementHealth(source, 1)
					setElementData(source, "muerto", true)
					triggerClientEvent(source, "onClientMuertoCapitalRP", source)
				end
			end
		end
	end
	if duty and atacante and not getElementData(atacante, "account:gmduty") == true and not sinMSJ [arma] then
		outputChatBox("Deja de atacar a un staff de servicio.", atacante, 255, 0, 0)
	end
	if arma and getWeaponNameFromID(arma) == "Explosion" and atacante then
		if not avisoExplosion[atacante] then
			avisoExplosion[atacante] = true
			outputChatBox("Por la zona del jugador "..getPlayerName(atacante):gsub("_", " ").. " ha habido una explosión.", getRootElement(), 255, 255, 0)
			setTimer(function() avisoExplosion[atacante] = nil end, 10000, 1)
		end
	end
end
addEvent("onSufrirDamageCapitalRP", true)
addEventHandler("onSufrirDamageCapitalRP", getRootElement(), sufrirAtaque)

-- Restaurar la cabeza cuando el jugador reaparece
addEventHandler("onPlayerSpawn", root,
	function()
		if isPedHeadless(source) then
			setPedHeadless(source, false)
		end
	end
)

function forzarRolHeridas()
	if tonumber(getElementHealth(source)) <= 1 then
		sufrirAtaque(source, 0, 60, true, true)
	end
end
addEventHandler("onCharacterLogin", getRootElement(), forzarRolHeridas)

function avisarMD (player)
	if player and getElementData(player, "muerto") == true then
		if hayMedicos() then
			if getElementData(player, "MDavisado") == true then
				outputChatBox("¡Ten paciencia! Sólo puedes dar el aviso a MD cada 20 segundos.", player, 255, 0, 0)
				setElementData(player, "reduccNOMD", 1)
				return
			end
			avisarMedicos(player)
			outputChatBox("Se ha avisado a los médicos por entorno. Ten paciencia.", player, 255, 255, 0)
			setElementData(player, "MDavisado", true)
			setTimer(setElementData, 20000, 1, player, "MDavisado", nil)
		else
			if not getElementData(player, "reduccNOMD") or getElementData(player, "reduccNOMD") ~= 2 then
				triggerClientEvent(player, "onClientMuertoCapitalRP", player)
				outputChatBox("Si el medico no viene, te puedes regenerar esperando el tiempo.", player, 255, 255, 0)
				setElementData(player, "reduccNOMD", 1)
			end
		end
	end
end
addCommandHandler("conteomd", avisarMD)

addEvent("onPlayerRespawn", true)
addEventHandler("onPlayerRespawn", root, function()
    local client = source
    
    -- Validación de seguridad
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, "onPlayerRespawn", {
        checkEventData = {
            {eventData = source, equalTo = client, debugData = "source"}
        }
    })
    
    if (not shouldProcessServerCode) then 
        return false 
    end
    
    -- Continuar con el código original
    if source == client then
        -- Verificamos que el jugador esté muerto y logueado
        if exports.players:isLoggedIn(source) then
            -- Ocultar la pantalla brevemente
            fadeCamera(source, false, 1)
            
            -- Limpiar datos de heridas y estado de muerte
            for i = 3, 9 do
                setElementData(source, "herida"..tostring(i), nil)
            end
            exports.medico:anularLlevarse(source)
            setElementData(source, "muerto", nil)
            triggerClientEvent(source, "onClientNoMuerto", source)
            setElementData(source, "accidente", nil)
            setElementData(source, "reduccNOMD", nil)
            exports.items:guardarArmas(source, true)
            
            -- Obtener la última posición del jugador antes de morir
            local x, y, z = getElementPosition(source)
            local dim = getElementDimension(source)
            local int = getElementInterior(source)
            
            -- Guardamos la posición para asegurar consistencia
            setElementData(source, "mPosX", x)
            setElementData(source, "mPosY", y)
            setElementData(source, "mPosZ", z)
            setElementData(source, "mDim", dim)
            setElementData(source, "mInt", int)
            
            -- Esperamos un corto tiempo y reaparecemos al jugador en la misma ubicación
            setTimer(
                function(source)
                    if isElement(source) and exports.players:isLoggedIn(source) then
                        spawnPlayer(source, x, y, z, 0, getElementModel(source), int, dim)
                        setElementHealth(source, 50)
                        fadeCamera(source, true)
                        setCameraTarget(source, source)
                        setCameraInterior(source, int)
                        outputChatBox("Has reaparecido en el mismo lugar donde moriste.", source, 255, 255, 255)
                    end
                end,
                1200,
                1,
                source
            )
            
            -- Limpiar datos de reaparición después de 10 segundos
            setTimer(function(source)
                setElementData(source, "mPosX", nil)
                setElementData(source, "mPosY", nil)
                setElementData(source, "mPosZ", nil)
                setElementData(source, "mDim", nil)
                setElementData(source, "mInt", nil)
            end, 10000, 1, source)
        end
    end
end)



function volverAnterior(player)
	if player and exports.players:isLoggedIn(player) and getElementData(player, "mPosX") then
		local x = getElementData(player, "mPosX")
		local y = getElementData(player, "mPosY")
		local z = getElementData(player, "mPosZ")
		local dim = getElementData(player, "mDim")
		local int = getElementData(player, "mInt")
		setElementPosition(player, x, y, z)
		setElementDimension(player, dim)
		setElementInterior(player, int)
		setElementHealth(player, 1)
		setElementData(player, "muerto", true)
		outputChatBox("Has vuelto a la zona donde estabas, por rol estás muerto o gravemente herido.", player, 255, 0, 0)
	end
end
addCommandHandler("volver", volverAnterior)

-- Eventos para diagnóstico y manejo de estado de muerte
addEvent("onServerReceiveDeadStatus", true)
addEventHandler("onServerReceiveDeadStatus", root, function(isDead)
    local client = source
    
    -- Validación de seguridad
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, "onServerReceiveDeadStatus", {
        checkEventData = {
            {eventData = source, equalTo = client, debugData = "source"},
            {eventData = isDead, allowedDataTypes = {["boolean"] = true}, debugData = "isDead"}
        }
    })
    
    if (not shouldProcessServerCode) then 
        return false 
    end
    
    -- Continuar con el código original
    if source and client == source then
        -- Actualizar datos del servidor según el estado de muerte del cliente
        if isDead ~= getElementData(source, "muerto") then
            -- Hay una discrepancia entre el cliente y el servidor
            outputDebugString("[SISTEMA] Discrepancia de estado muerto para " .. getPlayerName(source))
            
            -- Intentar sincronizar
            if isDead then
                -- El cliente piensa que está muerto pero el servidor no
                setElementData(source, "muerto", true)
            else
                -- El cliente piensa que está vivo pero el servidor lo ve muerto
                setElementData(source, "muerto", nil)
                setPedAnimation(source, false)
                toggleAllControls(source, true)
                -- Notificar al cliente para restaurar controles
                triggerClientEvent(source, "onClientRestoreControls", source)
            end
        end
    end
end)

-- Recibir diagnóstico del cliente
addEvent("onServerReceiveDiagnostic", true)
addEventHandler("onServerReceiveDiagnostic", root, function(playerState)
    local client = source
    
    -- Validación de seguridad
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, "onServerReceiveDiagnostic", {
        checkEventData = {
            {eventData = source, equalTo = client, debugData = "source"},
            {eventData = playerState, allowedDataTypes = {["table"] = true}, debugData = "playerState"}
        }
    })
    
    if (not shouldProcessServerCode) then 
        return false 
    end
    
    -- Continuar con el código original
    if source and client == source then
        local playerName = getPlayerName(source)
        outputDebugString("[DIAGNÓSTICO] " .. playerName .. ": " 
                         .. "Salud=" .. tostring(playerState.health) 
                         .. ", IsDead=" .. tostring(playerState.isDead)
                         .. ", IsMuerto=" .. tostring(playerState.isMuertoState)
                         .. ", HasCamera=" .. tostring(playerState.hasCamera))
        
        -- Si hay inconsistencias, intentar corregirlas
        if playerState.health > 20 and (playerState.isDead or playerState.isMuertoState) then
            -- Jugador tiene suficiente salud pero sigue marcado como muerto
            outputDebugString("[DIAGNÓSTICO] Corrigiendo estado de muerte para " .. playerName)
            setPedAnimation(source, false)
            removeElementData(source, "muerto")
            triggerClientEvent(source, "onClientRestoreControls", source)
        end
        
        if not playerState.hasCamera then
            -- La cámara no está dirigida al jugador
            outputDebugString("[DIAGNÓSTICO] Restaurando cámara para " .. playerName)
            triggerClientEvent(source, "onClientRestoreCamera", source)
        end
    end
end)

-- Comando para realizar diagnóstico
function diagnosticarJugador(admin, cmd, targetName)
    if admin and hasObjectPermissionTo(admin, "command.modchat", false) then
        local target
        if targetName then
            target, targetName = exports.players:getFromName(admin, targetName)
            if not target then
                outputChatBox("Jugador no encontrado.", admin, 255, 0, 0)
                return
            end
        else
            target = admin
            targetName = getPlayerName(admin):gsub("_", " ")
        end
        
        -- Iniciar diagnóstico
        outputChatBox("Realizando diagnóstico para " .. targetName .. "...", admin, 255, 165, 0)
        triggerClientEvent(target, "onClientPerformDiagnostic", target)
        
        -- Información del servidor
        local isServerMuerto = getElementData(target, "muerto") == true
        local isServerRecogido = getElementData(target, "recogido") == true
        outputChatBox("Estado servidor: Muerto=" .. tostring(isServerMuerto) .. ", Recogido=" .. tostring(isServerRecogido), admin, 255, 255, 255)
    else
        outputChatBox("No tienes permiso para usar este comando.", admin, 255, 0, 0)
    end
end
addCommandHandler("diagnosticar", diagnosticarJugador)

-- Controlador para desbloqueo de emergencia (tecla F8)
addEvent("onEmergencyUnlock", true)
addEventHandler("onEmergencyUnlock", root, function()
    local client = source
    
    -- Validación de seguridad
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, "onEmergencyUnlock", {
        checkEventData = {
            {eventData = source, equalTo = client, debugData = "source"}
        }
    })
    
    if (not shouldProcessServerCode) then 
        return false 
    end
    
    -- Continuar con el código original
    if source and client == source then
        local playerName = getPlayerName(source)
        outputDebugString("[SISTEMA] Desbloqueo de emergencia activado por " .. playerName)
        
        -- Limpiar todos los estados que podrían bloquear al jugador
        setElementData(source, "muerto", nil)
        setElementData(source, "recogido", nil)
        setElementData(source, "accidente", nil)
        setElementData(source, "MDavisado", nil)
        setElementData(source, "reduccNOMD", nil)
        
        -- Detener cualquier animación
        setPedAnimation(source, false)
        
        -- Asegurar que los controles estén habilitados
        toggleAllControls(source, true)
        
        -- Si tiene poca salud, darle un poco más
        if getElementHealth(source) < 20 then
            setElementHealth(source, 20)
        end
        
        -- Notificar a administradores
        for _, admin in ipairs(getElementsByType("player")) do
            if hasObjectPermissionTo(admin, "command.modchat", false) then
                outputChatBox("[SISTEMA] " .. playerName .. " ha usado desbloqueo de emergencia (F8)", admin, 255, 0, 0)
            end
        end
    end
end)	