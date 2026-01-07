local function getStaff( )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.modchat", false ) then
			--if not duty or exports.players:getOption( value, "staffduty" ) or exports.players:getOption( value, "helpduty" ) or getElementData(value, "pm") == true then
				t[ #t + 1 ] = value
			--end
		end
	end
	return t
end

local function staffMessage( message )
	for key, value in ipairs( getStaff() ) do
		outputChatBox( message, value, 255, 255, 0 )
	end
end

function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false  
end

function curarJugador ( player, commandName, otherPlayer )
    local otro, nombre = exports.players:getFromName ( player, otherPlayer )
	local x, y, z = getElementPosition( player )
	if exports.factions:isPlayerInFaction ( player, 2 ) then
		if player ~= otro then
			if otro then
				if getElementHealth(otro) == 100 then outputChatBox("No puedes curar a un jugador sano.", player, 255, 0, 0) return end
				if getDistanceBetweenPoints3D( x, y, z, getElementPosition( otro ) ) < 5 then
					setElementHealth ( otro, getElementHealth(otro) + 100 )
					exports.factions:giveFactionPresupuesto(2, 50) 					
					exports.chat:me( player, "le administra el tratamiento médico a " .. nombre .. "." )
					exports.logsic:addLogMessage("md_curar", getPlayerName(player).. " ha curado a "..getPlayerName(otro)..".")
					for i = 3, 9 do
						removeElementData(otro, "herida"..tostring(i))
						i = i+1
					end
					outputChatBox("La facción ha ganado 50 dólares con el tratamiento médico.", player, 0, 255, 0)
					local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(otro))
					if nivel == 2 and not exports.objetivos:isObjetivoCompletado(20, exports.players:getCharacterID(otro)) then
						exports.objetivos:addObjetivo(20, exports.players:getCharacterID(otro), otro)
					end
				end
			else
				outputChatBox ( "Jugador no encontrado.", player, 255, 255, 150 )
			end
		else
			outputChatBox ( "No puedes curarte a tí mismo.", player, 255, 255, 150 )
		end
    end
end
addCommandHandler ( "curar", curarJugador )

function reanimarJugador ( player, commandName, otherPlayer )
    local otro, nombre = exports.players:getFromName ( player, otherPlayer )
	local x, y, z = getElementPosition( player )
	if exports.factions:isPlayerInFaction ( player, 2 ) then
		if player ~= otro then
			if otro then
				if getDistanceBetweenPoints3D( x, y, z, getElementPosition( otro ) ) < 5 then
					if getElementData(otro, "muerto") then
                        -- FASE 1: LIMPIAR TODOS LOS DATOS ASOCIADOS A MUERTE
						-- Cancelar cualquier animación inmediatamente
						setPedAnimation(otro, false)
						removeElementData(otro, "muerto")
						removeElementData(otro, "accidente")
						removeElementData(otro, "recogido")
						removeElementData(otro, "MDavisado")
						removeElementData(otro, "reduccNOMD")
						removeElementData(otro, "autoreanimacionTimer")
						
						-- Anular cualquier sistema de arrastre o seguimiento
						siguimientos[otro] = nil
						
						-- Asegurar que el cursor esté oculto
						showCursor(otro, false)
						
						-- FASE 2: ALMACENAR DATOS PARA RESPAWN
						local x, y, z = getElementPosition(otro)
						local rot = getPedRotation(otro)
						local skin = getElementModel(otro)
						local dim = getElementDimension(otro)
						local int = getElementInterior(otro)
						
						-- Guardar armas antes del respawn
						exports.items:guardarArmas(otro, true)
						
                        -- FASE 3: EFECTUAR RESPAWN COMPLETO
                        -- Primero notificar al cliente que ya no está muerto
                        triggerClientEvent(otro, "onClientNoMuerto", otro)
                        
                        -- Respawn real del jugador
                        spawnPlayer(otro, x, y, z, rot, skin, int, dim)
                        
                        -- Configuración de cámara
                        fadeCamera(otro, true)
                        setCameraTarget(otro, otro)
                        setCameraInterior(otro, int)
                        
                        -- Eliminar heridas
                        for i = 3, 9 do
                            removeElementData(otro, "herida"..tostring(i))
                        end
                        
                        -- FASE 4: REINICIAR COMPLETAMENTE TODOS LOS CONTROLES
                        -- A través de evento específico en cliente
                        triggerClientEvent(otro, "onClientMedicRevive", otro)
                        
                        -- FASE 5: ANIMACIÓN Y FEEDBACK
                        exports.factions:giveFactionPresupuesto(2, 100)
                        exports.chat:me(player, "intenta reanimar a " .. nombre .. " y lo consigue.")
                                                
                        -- FASE 6: SERIES DE VERIFICACIÓN PROGRESIVAS
                        -- Configuración mínima de salud
                        setTimer(function()
                            if otro and isElement(otro) then
                                -- Resetar estado inmediatamente
                                setElementFrozen(otro, false)
                                setElementData(otro, "congelado", nil)
                                setPedAnimation(otro, false)
                                toggleAllControls(otro, true)
                                setElementHealth(otro, 20)
                                
                                -- Intentar mover ligeramente al jugador para resetear físicas
                                local tx, ty, tz = getElementPosition(otro)
                                setElementPosition(otro, tx + 0.01, ty + 0.01, tz)
                            end
                        end, 500, 1)
                        
                        -- Segunda verificación más completa
                        setTimer(function()
                            if otro and isElement(otro) then
                                -- Asegurar que no hay físicas o controles bloqueados
                                setPedAnimation(otro, false)
                                toggleAllControls(otro, true)
                                setElementFrozen(otro, false)
                                
                                -- Intentar mover al jugador de nuevo
                                local tx, ty, tz = getElementPosition(otro)
                                setElementPosition(otro, tx - 0.01, ty - 0.01, tz)
                                
                                -- Mensaje al jugador
                                outputChatBox("Has sido reanimado. Si no puedes moverte, usa /liberarme", otro, 0, 255, 0)
                            end
                        end, 2000, 1)
                        
                        -- Verificación final
                        setTimer(function()
                            if otro and isElement(otro) then
                                setPedAnimation(otro, false)
                                toggleAllControls(otro, true)
                                
                                -- Última notificación
                                outputChatBox("Si sigues sin poder moverte, usa /liberarme, o pide que reinicien el resource (medico)", otro, 255, 255, 0)
                            end
                        end, 5000, 1)
                        
                        -- Registros
                        outputDebugString("El médico "..getPlayerName(player):gsub("_", " ").. " ha reanimado a "..nombre..".")
                        exports.logsic:addLogMessage("medico", "El médico "..getPlayerName(player):gsub("_", " ").. " ha reanimado a "..nombre.."\n")	
                        outputChatBox("La facción ha ganado 100 dólares con la reanimación.", player, 0, 255, 0)
					else
						outputChatBox("El jugador no necesita una reanimación.", player, 255, 0, 0)
					end
				else
				    outputChatBox("Estás demasiado lejos del jugador.", player, 255, 0, 0)
				end
			else
				outputChatBox("Jugador no encontrado.", player, 255, 0, 0)
			end
		else
			outputChatBox("No puedes reanimarte a tí mismo.", player, 255, 0, 0)
		end
    end
end
addCommandHandler("reanimar", reanimarJugador)

--[[local firefighterPed = createPed ( 279, 1858.79, -2572.08, 80.74, 357.48, false )
setElementDimension ( firefighterPed, 10 )
setElementInterior ( firefighterPed, 3 )

function onChatFirefighter ( message )
	if (message ~= "") then
	local x, y, z = getElementPosition(firefighterPed)
	local x2, y2, z2 = getElementPosition(source)
		local distance = getDistanceBetweenPoints3D (x, y, z, x2, y2, z2)
		if ( distance <= 7.5 ) then
			if (exports.factions:isPlayerInFaction(source, 12)) then
				if (message == "extintor") then
					giveWeapon ( source, 42, 5000, true )
				elseif (message == "motosierra") then
					outputChatBox("Debido a los abusos, ya no puedes obtener una motosierra.", source, 255, 0, 0)
				end
			end
		end
	end
end
addEventHandler ("onPlayerChat", getRootElement(), onChatFirefighter)]]

function consultarHeridas ( player, commandName, otherPlayer )
	heridas = nil
	if not otherPlayer then
		otro = player
		nombre = getPlayerName(player):gsub("_", " ")
	else
		otro, nombre = exports.players:getFromName ( player, otherPlayer )
	end
	local x, y, z = getElementPosition( player )
	if otro then
		if getDistanceBetweenPoints3D( x, y, z, getElementPosition( otro ) ) < 20 then					
			outputChatBox("~~~~Heridas de: "..tostring(nombre).." ~~~~", player, 255, 255, 255)
			for i = 3, 9 do
				if getElementData(otro, "herida"..tostring(i)) then 
					heridas = true
					if i == 3 then -- Torso 
						outputChatBox("Tiene heridas en el torso.", player, 255, 0, 0)
					elseif i == 4 then -- Trasero
						outputChatBox("Tiene heridas en el trasero.", player, 255, 0, 0)
					elseif i == 5 then -- Brazo izquierdo
						outputChatBox("Tiene heridas en el brazo izquierdo.", player, 255, 0, 0)
					elseif i == 6 then -- Brazo derecho 
						outputChatBox("Tiene heridas en el brazo derecho.", player, 255, 0, 0)
					elseif i == 7 then -- Pierna izquierda
						outputChatBox("Tiene heridas en la pierna izquierda.", player, 255, 0, 0)
					elseif i == 8 then -- Pierna derecha
						outputChatBox("Tiene heridas en la pierna derecha.", player, 255, 0, 0)
					elseif i == 9 then -- Cabeza
						outputChatBox("Tiene heridas en la cabeza.", player, 255, 0, 0)
					end
				end
				i = i+1
			end
			if not heridas then outputChatBox("Este jugador no tiene ninguna herida.", player, 0, 255, 0) end
		end
	else
		outputChatBox ( "Sintaxis: /heridas [jugador]. Pon /heridas para ver tus heridas.", player, 255, 255, 255 )
	end
end
addCommandHandler ( "heridas", consultarHeridas )

siguimientos = {}

function sigueme(arrastrado)
	if siguimientos[arrastrado] == nil then
	else
		if not arrastrado then return end
		arrastrador = siguimientos[arrastrado]
		local copx, copy, copz = getElementPosition ( siguimientos[arrastrado] )
		local prisonerx, prisonery, prisonerz = getElementPosition ( arrastrado )
		copangle = ( 360 - math.deg ( math.atan2 ( ( copx - prisonerx ), ( copy - prisonery ) ) ) ) % 360
		setPedRotation ( arrastrado, copangle )
		local dist = getDistanceBetweenPoints2D ( copx, copy, prisonerx, prisonery )	
		if getElementInterior(siguimientos[arrastrado]) ~= getElementInterior(arrastrado) then setElementInterior(arrastrado, getElementInterior(siguimientos[arrastrado])) end
		if getElementDimension(siguimientos[arrastrado]) ~= getElementDimension(arrastrado) then setElementDimension(arrastrado, getElementDimension(siguimientos[arrastrado])) end
		if dist >= 200 then
			local x,y,z = getElementPosition(siguimientos[arrastrado])
			setElementPosition(arrastrado, x, y, z)
		elseif dist >= 9 then
			setPedAnimation(arrastrado, "ped", "sprint_civi")
		elseif dist >= 6 then
			setPedAnimation(arrastrado, "ped", "run_player")
		elseif dist >= 3 then
			setPedAnimation(arrastrado, "ped", "WALK_player")
		else
			setPedAnimation(arrastrado, false)
		end
		if isPedInVehicle ( arrastrador ) then
			car = getPedOccupiedVehicle ( arrastrador )
			for i = 0, getVehicleMaxPassengers( car ) do
			local p = getVehicleOccupant( car, i )
				if not p then
					warpPedIntoVehicle ( arrastrado, car, i )
				end
			end
		else
			if isPedInVehicle ( arrastrado ) then
				removePedFromVehicle ( arrastrado )
			end
		end
		
		-- Asegurar que el chat esté siempre disponible durante el arrastre
		toggleControl(arrastrado, "chatbox", true)
		toggleControl(arrastrado, "chat", true)

		local zombify = setTimer ( sigueme, 750, 1, arrastrado )
	end
end

addCommandHandler("llevarse",
function(player, cmd, other)
    if not player then return end
    if other then
        target, targetName = exports.players:getFromName(player, other)
        if not target then return end

        x1, y1, z1 = getElementPosition(player)
        x2, y2, z2 = getElementPosition(target)
        distance = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)

        if target == player then return end
        if (distance < 2) then
            if not getElementData(target, "muerto") then 
                outputChatBox("¡No puedes arrastrar a un jugador sin heridas graves/muerto!", player, 255, 0, 0) 
                return 
            end
            
            if siguimientos[target] == nil then
                -- **CANCELAR AUTOREANIMACIÓN**
                if isTimer(getElementData(target, "autoreanimacionTimer")) then
                    killTimer(getElementData(target, "autoreanimacionTimer"))
                    removeElementData(target, "autoreanimacionTimer")
                end
                triggerClientEvent(target, "onClientNoMuerto", target) -- Cierra interfaz y resetea cámara
                
                -- **AHORA SIGUE EL CÓDIGO NORMAL**
                siguimientos[target] = player
                sigueme(target)
                exports.chat:me(player, "recoge del suelo y arrastra a "..targetName)
                outputChatBox("SI NO ROLEAS EL LLEVARLO Y NO VAS DESPACIO SERÁS SANCIONADO.", player, 255, 0, 0)
                showCursor(target, true)
                toggleControl(target, "chatbox", true)
                toggleControl(target, "chat", true)  -- Asegurar que siempre puedan chatear
                setElementData(target, "recogido", true)
            else
                siguimientos[target] = nil
                exports.chat:me(player, "deja de arrastrar y suelta a "..targetName)
                showCursor(target, false)
                toggleAllControls(target, true)
                removeElementData(target, "recogido")
                setPedAnimation(target, "crack", "crckidle2", -1, true, false, false)
                setElementData(target, "muerto", true)
            end
        else
            outputChatBox("¡Estás muy lejos de este jugador!", player, 255, 0, 0)
        end
    else
        outputChatBox("Sintaxis: /llevarse [jugador]. Recuerda que debe de estar gravemente herido o muerto para esto.", player, 255, 255, 255)
    end
end)


function anularLlevarse (target)
	siguimientos[target] = nil
	showCursor(target, false)
	toggleAllControls(target, true)  
	toggleControl(target, "chatbox", true) -- Asegurar chat activo
	toggleControl(target, "chat", true)    -- Asegurar comandos activos
	removeElementData(target, "recogido")
end

local cmdS = {
	["duda"] = true,
	["LocalOOC"] = true,
	["ame"] = true,
	["do"] = true,
	["me"] = true,
	["revivir"] = true,
	["pm"] = true,
	["mp"] = true,
	["a"] = true,
	["m"] = true,
	["adminchat"] = true,
	["modchat"] = true,
	["id"] = true,
	["avisarsura"] = true,
	["aduda"] = true,
	["anularduda"] = true,
	["srun"] = true,
	["restart"] = true,
	["heridas"] = true,
	["staff"] = true,
	["say"] = true,       -- Comando principal del chat (tecla T)
	["teamsay"] = true,   -- Chat de equipo (usualmente tecla Y)
	["chatbox"] = true,   -- Otro posible comando de chat
	-- Comandos adicionales del chat que podrían ser necesarios
	["n"] = true,
	["w"] = true,
	["d"] = true,
	["department"] = true,
	["en"] = true,
	["o"] = true,
	["b"] = true,
	["GlobalOOC"] = true,
	["WalkieTalkie"] = true,
	["susurrar"] = true,
	["gritar"] = true
}

function noComandosSiMuerto(c)
	if source and getElementData(source, "muerto") == true then
		-- Asegurarse de que los comandos de chat siempre funcionen
		if tostring(c) == "say" or tostring(c) == "b" then
			return -- Permitir los comandos de chat sin restricciones
		end
		
		if not cmdS[tostring(c)] then
			outputChatBox("No puedes usar este comando ahora. Estás muerto.", source, 255, 0, 0)
			cancelEvent()
			return
		end
	end
end
addEventHandler("onPlayerCommand", getRootElement(), noComandosSiMuerto)

function entrarIngresos(player)
	if exports.factions:isPlayerInFaction(player, 2) or getElementData(player, "visita") or getElementData(player, "account:gmduty") then
		local x, y, z = getElementPosition(player)
		local dimension = getElementDimension(player)
		if dimension == 4 and getDistanceBetweenPoints3D(x, y, z, -295.64453125, 1051.8701171875, 508.41561889648) <= 5 then
			setElementPosition(player, -329.3056640625, 1034.4560546875, 508.41561889648)
		end
	else
		outputChatBox("No eres médico y no estás de visita.", player, 255, 0, 0)
	end
end
addCommandHandler("ingresarcirugia", entrarIngresos)

function salirIngresos(player)
	if exports.factions:isPlayerInFaction(player,2) or getElementData(player, "visita") or getElementData(player, "account:gmduty") then
		local x, y, z = getElementPosition(player)
		local dimension = getElementDimension(player)
		if dimension == 4 and getDistanceBetweenPoints3D(x, y, z, -327.6015625, 1040.0810546875, 508.41561889648) <= 5 then
			setElementPosition(player, -332.55859375, 1044.447265625, 508.41561889648)
		end
	else
		outputChatBox("No eres médico y no estás de visita.", player, 255, 0, 0)
	end
end
addCommandHandler("salircirugia", salirIngresos)

function darVisita(player, cmd, otherPlayer)
	if exports.factions:isPlayerInFaction(player, 2) then
		local other, name = exports.players:getFromName(player, otherPlayer)
		if other then
			if getElementData(other, "visita") then
				outputChatBox("Has quitado el pase de visita a "..tostring(name)..".", player, 255, 0, 0)
				outputChatBox("El médico "..getPlayerName(player):gsub("_", " ").. " te ha quitado el pase de visita.", other, 255, 0, 0)
				removeElementData(other, "visita")
			else
				outputChatBox("Has dado el pase de visita a "..tostring(name)..".", player, 0, 255, 0)
				outputChatBox("El médico "..getPlayerName(player):gsub("_", " ").. " te ha dado el pase de visita.", other, 0, 255, 0)
				setElementData(other, "visita", true)
			end
		end
	else
		outputChatBox("No eres médico.", player, 255, 0, 0)
	end
end
addCommandHandler("pase", darVisita)

local function getMedicos()
	local p = { }
	for index,value in ipairs(getElementsByType("player")) do 
		if exports.factions:isPlayerInFaction( value, 2 ) then 
			table.insert( p, value )
		end 
	end 
	return p
end


function curameJugador (player)
	if exports.players:isLoggedIn(player) then
		if not isElementInRange(player, 1238.15, 327.64, 19.76, 5) then outputChatBox("(( No estás en el hospital ))", player, 255, 0, 0) return end
		local medicos = getMedicos ()
		if #medicos > 0 then
			outputChatBox("Hay médicos conectados. ¿Por qué no avisas al 112 con tu teléfono móvil?", player, 255, 0, 0)
		else					
			setElementHealth(player, 100)
			outputChatBox("Has sido curado correctamente. Por favor, ROLÉALO!", player, 0, 255, 0)
		end
	end
end
addCommandHandler("curame", curameJugador)

function refMedicos( player, cmd, aviso )
	if player then
		if isPedDead(player) or getElementData(player, "muerto") == true then outputChatBox("No puedes activar el botón de refuerzos una vez muerto.", player, 255, 0, 0) return end
		if exports.factions:isPlayerInFaction(player, 2) then
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if x and y and z then
				if not getElementData(player, "ref") then
					if not aviso then
						exports.factions:sendMessageToFaction(2, "#7F7FFF(( #FF0000MD#7F7FFF )) "..getPlayerName( player ):gsub( "_", " " ).." pide más recursos en su posición, acuda.",127, 127, 255,true )
					end
					for key, value in ipairs( getElementsByType("player") ) do
						if exports.factions:isPlayerInFaction(value, 2) then
							b = createBlip ( x, y, z, 41, 2, 255, 0, 0, 255, 0, 99999.0, value )
							attachElements( b, player )
							setElementData(b, "mdref", tostring(getPlayerName(player)))
							setPlayerHudComponentVisible ( value, "radar", true )
						end
					end
					setElementData(player, "ref", true)
					else
					for key, value in ipairs(getElementsByType("blip")) do
						if getElementData(value, "mdref") == getPlayerName(player) then destroyElement(value) end
					end	
					if not aviso then
						exports.factions:sendMessageToFaction(2, "#7F7FFF(( #FF0000MD#7F7FFF )) "..getPlayerName( player ):gsub( "_", " " ).." ya no necesita más asistencia.",127, 127, 255,true )
					end
					removeElementData(player, "ref")
				end
			end
		end
	end
end
addCommandHandler( "ref", refMedicos )

-- Comando para que los jugadores puedan desbloquearse manualmente
function liberarJugador(player)
    if player then
        outputChatBox("Ejecutando desbloqueo completo. Por favor espera mientras se reinician tus controles...", player, 255, 165, 0)
        
        -- FASE 1: LIMPIAR TODOS LOS ESTADOS
        -- Limpiar todos los estados posibles que podrían bloquear al jugador
        removeElementData(player, "muerto")
        removeElementData(player, "recogido")
        removeElementData(player, "accidente")
        removeElementData(player, "MDavisado")
        removeElementData(player, "reduccNOMD")
        removeElementData(player, "congelado")
        
        -- Eliminar del sistema de arrastre
        siguimientos[player] = nil
        
        -- FASE 2: RESTABLECER ANIMACIÓN Y CONTROLES
        -- Detener cualquier animación activa
        setPedAnimation(player, false)
        
        -- Asegurar que el cursor esté oculto
        showCursor(player, false)
        
        -- Descongelar al jugador
        setElementFrozen(player, false)
        
        -- Habilitar todos los controles
        toggleAllControls(player, true)
        
        -- FASE 3: REINICIAR POSICIÓN
        -- Obtener posición actual
        local x, y, z = getElementPosition(player)
        local rot = getPedRotation(player)
        
        -- Aplicar un pequeño desplazamiento para "sacudir" la física
        setElementPosition(player, x + 0.05, y + 0.05, z)
        setTimer(function()
            if isElement(player) then
                setElementPosition(player, x, y, z)
                setPedRotation(player, rot)
                
                -- Verificar si el jugador estaba en un vehículo y sacarlo si es necesario
                if isPedInVehicle(player) then
                    removePedFromVehicle(player)
                    setTimer(function()
                        if isElement(player) then
                            setElementPosition(player, x, y, z + 0.5) -- Un poco más alto para evitar colisiones
                        end
                    end, 100, 1)
                end
            end
        end, 100, 1)
        
        -- FASE 4: REINICIAR ESTADO DEL JUGADOR
        setTimer(function()
            if isElement(player) then
                -- Si la salud es muy baja, darle un poco más
                if getElementHealth(player) < 10 then
                    setElementHealth(player, 20)
                end
                
                -- Descongelar y desanimar nuevamente
                setElementFrozen(player, false)
                setPedAnimation(player, false)
                toggleAllControls(player, true)
                
                -- Notificar al cliente para que ejecute el desbloqueo del lado del cliente
                triggerClientEvent(player, "onClientMedicRevive", player)
                
                -- Notificación
                outputChatBox("Te has liberado manualmente de cualquier bloqueo.", player, 0, 255, 0)
                outputChatBox("Si continúas teniendo problemas, inténtalo de nuevo o pide que reinicien el resource (medico).", player, 255, 255, 0)
            end
        end, 500, 1)
        
        -- Log para administración
        outputDebugString("[SISTEMA] El jugador " .. getPlayerName(player) .. " usó /liberarme para desbloquearse.")
    end
end
addCommandHandler("liberarme", liberarJugador)

-- Comando para que los administradores puedan desbloquear a otro jugador
function desbloquearJugador(admin, cmd, targetName)
    if admin and hasObjectPermissionTo(admin, "command.modchat", false) then
        if not targetName then
            outputChatBox("Uso: /desbloquear [jugador]", admin, 255, 255, 255)
            return
        end
        
        -- Buscar al jugador objetivo
        local target, targetRealName = exports.players:getFromName(admin, targetName)
        
        if target then
            -- Aplicar el mismo proceso que /liberarme pero para el jugador objetivo
            outputChatBox("Ejecutando desbloqueo completo para " .. targetRealName .. "...", admin, 255, 165, 0)
            outputChatBox("Un administrador está ejecutando un desbloqueo completo para ti. Por favor espera...", target, 255, 165, 0)
            
            -- FASE 1: LIMPIAR TODOS LOS ESTADOS
            removeElementData(target, "muerto")
            removeElementData(target, "recogido")
            removeElementData(target, "accidente")
            removeElementData(target, "MDavisado")
            removeElementData(target, "reduccNOMD")
            removeElementData(target, "congelado")
            
            -- Eliminar del sistema de arrastre
            siguimientos[target] = nil
            
            -- FASE 2: RESTABLECER ANIMACIÓN Y CONTROLES
            setPedAnimation(target, false)
            showCursor(target, false)
            setElementFrozen(target, false)
            toggleAllControls(target, true)
            
            -- FASE 3: REINICIAR POSICIÓN
            local x, y, z = getElementPosition(target)
            local rot = getPedRotation(target)
            local dim = getElementDimension(target)
            local int = getElementInterior(target)
            
            -- Guardar armas antes del respawn
            exports.items:guardarArmas(target, true)
            
            -- FASE 4: HACER UN RESPAWN COMPLETO DEL JUGADOR
            triggerClientEvent(target, "onClientNoMuerto", target)
            spawnPlayer(target, x, y, z, rot, getElementModel(target), int, dim)
            fadeCamera(target, true)
            setCameraTarget(target, target)
            setCameraInterior(target, int)
            
            -- Eliminar heridas
            for i = 3, 9 do
                removeElementData(target, "herida"..tostring(i))
            end
            
            -- FASE 5: VERIFICACIONES CON TIMERS
            setTimer(function()
                if target and isElement(target) then
                    setElementFrozen(target, false)
                    setPedAnimation(target, false)
                    toggleAllControls(target, true)
                    setElementHealth(target, 50) -- Darle más salud para que pueda moverse
                    
                    -- Notificar al cliente para desbloqueo en el lado del cliente
                    triggerClientEvent(target, "onClientMedicRevive", target)
                    
                    -- Notificación
                    outputChatBox("Has sido desbloqueado por un administrador.", target, 0, 255, 0)
                    outputChatBox("Desbloqueaste exitosamente a " .. targetRealName, admin, 0, 255, 0)
                end
            end, 500, 1)
            
            -- Log para administración
            outputDebugString("[SISTEMA] El admin " .. getPlayerName(admin) .. " desbloqueó a " .. targetRealName)
        else
            outputChatBox("Jugador no encontrado.", admin, 255, 0, 0)
        end
    else
        outputChatBox("No tienes permiso para usar este comando.", admin, 255, 0, 0)
    end
end
addCommandHandler("desbloquear", desbloquearJugador)

-- Eventos de exportación para compatibilidad con otros recursos
addEvent("reanimarJugadorExterno", true)
addEventHandler("reanimarJugadorExterno", getRootElement(), function(targetPlayer, sourcePlayer)
    if targetPlayer and sourcePlayer and isElement(targetPlayer) and isElement(sourcePlayer) then
        -- Implementar la misma lógica de reanimación pero como evento
        local x, y, z = getElementPosition(sourcePlayer)
        if exports.factions:isPlayerInFaction(sourcePlayer, 2) then
            if getDistanceBetweenPoints3D(x, y, z, getElementPosition(targetPlayer)) < 5 then
                if getElementData(targetPlayer, "muerto") then
                    -- Llamar a la función de reanimación
                    reanimarJugador(sourcePlayer, nil, getPlayerName(targetPlayer):gsub(" ", "_"))
                end
            end
        end
    end
end)

-- Exportar funciones para que otros recursos puedan usarlas
function exportedAnularLlevarse(player)
    return anularLlevarse(player)
end

function exportedLiberarJugador(player)
    return liberarJugador(player)
end