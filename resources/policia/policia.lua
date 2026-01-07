-- 
local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end

--
-- /duty
addCommandHandler( "duty",
	function( thePlayer, commandName )
		if exports.players:isLoggedIn( thePlayer ) then
            local characterID = exports.players:getCharacterID( thePlayer )
			if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
			local result = exports.sql:query_assoc_single( "SELECT factionRank FROM character_to_factions WHERE factionID = 1 AND characterID = " .. exports.players:getCharacterID(thePlayer))
			local rango = result.factionRank
			if getElementDimension(thePlayer) == 104 then
				if getElementData( thePlayer, "duty" ) == true then
					outputChatBox ("Estás fuera de servicio agente.", thePlayer, 211, 211, 211)
					setPedArmor (thePlayer, 0)
					removeElementData(thePlayer, "duty")
					removeElementData(thePlayer, "wid")
				else
					outputChatBox ( "Estás de servicio agente.", thePlayer, 211, 211, 211 )
					setElementData( thePlayer, "duty", true)
					setPedArmor ( thePlayer, 100 )
					if not exports.items:has(thePlayer, 29, 3) then
						exports.items:give(thePlayer, 29, "3", "Arma 3", 1)
					end
				end
			end
		end
	end
end
)

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
		if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 4) then
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if x and y and z then
				if not getElementData(player, "ref") then
					if not aviso then
						exports.factions:sendMessageToFaction(1, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." pide refuerzos, acuda a sus 10-20.",127, 127, 255,true )
                        exports.factions:sendMessageToFaction(4, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." pide refuerzos, acuda a sus 10-20.",127, 127, 255,true )
					end
					for key, value in ipairs( getElementsByType("player") ) do
						if exports.factions:isPlayerInFaction(value, 1) or exports.factions:isPlayerInFaction(player, 4) then
							b = createBlip ( x, y, z, 41, 2, 255, 0, 0, 255, 0, 99999.0, value )
							attachElements( b, player )
							setElementData(b, "police", tostring(getPlayerName(player)))
							setPlayerHudComponentVisible ( value, "radar", true )
						end
					end
					setElementData(player, "ref", true)
					else
					for key, value in ipairs(getElementsByType("blip")) do
						if getElementData(value, "police") == getPlayerName(player) then destroyElement(value) end
					end	
					if not aviso then
						exports.factions:sendMessageToFaction(1, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." ya no necesita refuerzos , Codigo 4.",127, 127, 255,true )
                        exports.factions:sendMessageToFaction(4, "#7F7FFF(( #FF0000SD#7F7FFF )) El agente "..getPlayerName( player ):gsub( "_", " " ).." ya no necesita refuerzos , Codigo 4.",127, 127, 255,true )
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
		if exports.factions:isPlayerInFaction(player, 1) or getElementData(player, "enc1") or exports.factions:isPlayerInFaction(player, 4) then
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if x and y and z then
				if not getElementData(player, "ref2") then
				for key, value in ipairs( getElementsByType("player") ) do
					if exports.factions:isPlayerInFaction(value, 1) or getElementData(value, "enc1") or exports.factions:isPlayerInFaction(player, 4) then
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
						if exports.factions:isPlayerInFaction(v2, 1) or hasObjectPermissionTo(v2, "command.encubierto", false) or exports.factions:isPlayerInFaction(v2, 4) then
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
		if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 2) or exports.factions:isPlayerInFaction(player, 3) or exports.factions:isPlayerInFaction(player, 4) or exports.factions:isPlayerInFaction(player, 11) then
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
						exports.factions:sendMessageToFaction(3, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(4, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
                        exports.factions:sendMessageToFaction(11, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
					end
					for key, value in ipairs( getElementsByType("player") ) do
						if exports.factions:isPlayerInFaction(value, 1) or exports.factions:isPlayerInFaction(value, 2) or exports.factions:isPlayerInFaction(value, 3) or exports.factions:isPlayerInFaction(player, 4) or exports.factions:isPlayerInFaction(value, 11) then
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
						exports.factions:sendMessageToFaction(1, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(2, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(3, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
						exports.factions:sendMessageToFaction(4, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
                        exports.factions:sendMessageToFaction(11, "[DEPARTAMENTO] "..getPlayerName( player ):gsub( "_", " " ).." ha mandado su posición.", 0, 153, 0)
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
--addCommandHandler( "cachear" , cachearJugador)

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

-- Marcador unificado para arrestos (visible para todos)
local markerArresto = createMarker(-254.5224609375, 1560.6044921875, 77.106437683105 -1, "cylinder", 5.0, 255, 0, 0, 50)
setElementDimension(markerArresto, 0)
setElementInterior(markerArresto, 0)

-- Coordenadas de las celdas unificadas
local celdas = {
    {-307.9296875, 1565.091796875, 77.254875183105},     -- celda1
    {-298.8662109375, 1565.263671875, 77.254875183105},  -- celda2
    {-290.3154296875, 1564.8125, 77.254875183105},       -- celda3
    {-280.9892578125, 1565.00390625, 77.254875183105},   -- celda4
    {-309.8388671875, 1574.6171875, 77.254875183105},    -- celda5
    {-306.42578125, 1582.673828125, 77.254875183105},    -- celda6
    {-302.685546875, 1590.623046875, 77.254875183105},   -- celda7
    {-281.3154296875, 1565.0556640625, 82.911125183105}, -- celda8
    {-290.6767578125, 1565.078125, 82.911125183105},     -- celda9
    {-299.3271484375, 1564.97265625, 82.911125183105},   -- celda10
    {-307.58984375, 1565.302734375, 82.911125183105},    -- celda11
    {-309.958984375, 1573.91015625, 82.911125183105},    -- celda12
    {-305.9609375, 1582.3271484375, 82.911125183105},    -- celda13
    {-302.634765625, 1590.0400390625, 82.918838500977},  -- celda14
    {-355.8291015625, 1591.0146484375, 77.254875183105}, -- celda15
    {-352.0732421875, 1581.8701171875, 77.254875183105}, -- celda16
    {-348.8359375, 1574.619140625, 77.254875183105},     -- celda17
    {-350.404296875, 1565.26171875, 77.254875183105},    -- celda18
    {-359.525390625, 1565.0478515625, 77.254875183105},  -- celda19
    {-368.7470703125, 1565.40234375, 77.254875183105},   -- celda20
    {-377.2275390625, 1564.892578125, 77.254875183105},  -- celda21
    {-377.6025390625, 1564.984375, 82.911125183105},     -- celda22
    {-368.48046875, 1564.8525390625, 82.911125183105},   -- celda23
    {-359.626953125, 1564.828125, 82.911125183105},      -- celda24
    {-351.103515625, 1564.919921875, 82.918838500977},   -- celda25
    {-348.669921875, 1574.0927734375, 82.911125183105},  -- celda26
    {-352.1689453125, 1581.9345703125, 82.918838500977}, -- celda27
    {-355.8916015625, 1591.3310546875, 82.911125183105}  -- celda28
}

-- Tabla local para almacenar las skins originales de los jugadores
local skinOriginal = {}

-- Tabla para almacenar los temporizadores de liberación de cada jugador
local timerLiberacion = {}

-- Tabla para almacenar los temporizadores de actualización
local tiempoActualizacion = {}

-- Base de datos SQLite local - independiente de MySQL
local dbArresto = nil

-- Inicializar la base de datos SQLite
function iniciarBaseDatosSQLite()
    -- Conectar a la base de datos SQLite
    dbArresto = dbConnect("sqlite", "arrestos_pd.db")
    
    if not dbArresto then
        outputDebugString("[ARRESTO] ERROR: No se pudo conectar a la base de datos SQLite", 1)
        return false
    end
    
    -- Crear tabla si no existe
    dbExec(dbArresto, [[
        CREATE TABLE IF NOT EXISTS arrestos (
            charID INTEGER PRIMARY KEY,
            tiempo INTEGER,
            skin INTEGER,
            timestamp INTEGER
        )
    ]])
    
    outputDebugString("[ARRESTO] Base de datos SQLite inicializada correctamente")
    return true
end

-- Guardar arresto en SQLite
function guardarArrestoSQLite(charID, tiempo, skin)
    if not dbArresto then return false end
    
    -- Eliminar registro previo si existe
    dbExec(dbArresto, "DELETE FROM arrestos WHERE charID = ?", charID)
    
    -- Insertar nuevo arresto
    local timestamp = getRealTime().timestamp
    local resultado = dbExec(dbArresto, "INSERT INTO arrestos (charID, tiempo, skin, timestamp) VALUES (?, ?, ?, ?)",
        charID, tiempo, skin or 0, timestamp)
    
    outputDebugString("[ARRESTO] Guardado en SQLite: charID=" .. charID .. ", tiempo=" .. tiempo)
    return resultado
end

-- Obtener arresto de SQLite
function obtenerArrestoSQLite(charID)
    if not dbArresto then return nil end
    
    local query = dbQuery(dbArresto, "SELECT * FROM arrestos WHERE charID = ?", charID)
    local resultado = dbPoll(query, -1)
    
    if resultado and #resultado > 0 then
        return resultado[1]
    end
    
    return nil
end

-- Actualizar tiempo en SQLite
function actualizarTiempoArrestoSQLite(charID, tiempo)
    if not dbArresto then return false end
    
    -- Simplemente actualizar el tiempo sin modificar timestamp
    local resultado = dbExec(dbArresto, "UPDATE arrestos SET tiempo = ? WHERE charID = ?", tiempo, charID)
    outputDebugString("[ARRESTO] Tiempo actualizado en SQLite: charID=" .. charID .. ", tiempo=" .. tiempo)
    return resultado
end

-- Eliminar arresto de SQLite
function eliminarArrestoSQLite(charID)
    if not dbArresto then return false end
    
    local resultado = dbExec(dbArresto, "DELETE FROM arrestos WHERE charID = ?", charID)
    outputDebugString("[ARRESTO] Eliminado de SQLite: charID=" .. charID)
    return resultado
end

-- Mostrar arresto en SQLite (para depuración)
function mostrarArrestosEnSQLite()
    if not dbArresto then return {} end
    
    local query = dbQuery(dbArresto, "SELECT * FROM arrestos")
    local resultado = dbPoll(query, -1)
    
    return resultado or {}
end

-- Función para arrestar jugador
function arrestarJugador(player, commandName, otherPlayer, tiempo, ...)
	local razon = table.concat({...}, " ")
    
    if not otherPlayer or not tiempo or not razon then
        outputChatBox("Sintaxis: /arrestar [jugador] [tiempo] [razón]", player, 255, 255, 255)
        return
    end
    
	local other, name = exports.players:getFromName(player, otherPlayer)
    
    if not other then
        outputChatBox("Jugador no encontrado", player, 255, 0, 0)
        return
    end
    
    if not exports.factions:isPlayerInFaction(player, 1) then
        outputChatBox("No eres policía.", player, 255, 0, 0)
        return
    end
    
    -- Verificar zona de arresto
			if not isElementWithinMarker(player, markerArresto) then
				outputChatBox("(( Solo puedes arrestar en la zona designada ))", player, 255, 0, 0)
				return
			end
			
    -- Verificar distancia
			local x1, y1, z1 = getElementPosition(player)
			local x2, y2, z2 = getElementPosition(other)
			local distancia = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
			
			if distancia > 5 then
				outputChatBox("(( El sospechoso está demasiado lejos para arrestarlo ))", player, 255, 0, 0)
				return
			end
			
    -- Validar tiempo
    local tiempoArresto = math.max(1, math.min(tonumber(tiempo), 60))
			local charID = exports.players:getCharacterID(other)
    
    -- Limpiar cualquier arresto previo para evitar conflictos
    if getElementData(other, "ajail") then
        -- Eliminar temporizadores si ya existen
        if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
            killTimer(timerLiberacion[charID])
            timerLiberacion[charID] = nil
        end
        
        if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
            killTimer(tiempoActualizacion[charID])
            tiempoActualizacion[charID] = nil
        end
    end
    
    -- Guardar skin original
    local skinActual = getElementModel(other)
    skinOriginal[charID] = skinActual
    setElementData(other, "skinOriginalPrision", skinActual)
    
    -- Aplicar skin de prisionero
			setElementModel(other, 111)
			
    -- Teleportar a celda
			local celdaRandom = math.random(1, #celdas)
			local celdaPos = celdas[celdaRandom]
			setElementPosition(other, celdaPos[1], celdaPos[2], celdaPos[3])
			setElementInterior(other, 0)
			setElementDimension(other, 0)
			
    -- Notificar
    for k, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) then
            outputChatBox(name.." ha sido arrestado.", v, 255, 0, 0)
            outputChatBox("Tiempo: (("..tostring(tiempoArresto).." minutos)) Razón: "..razon, v, 255, 0, 0)
        end
    end
    
    outputChatBox("Has sido arrestado durante "..tostring(tiempoArresto).." minutos.", other, 255, 0, 0)
			outputChatBox("Razón: "..tostring(razon), other, 255, 0, 0)
			
    -- Establecer datos
			setElementData(other, "ajail", tiempoArresto)
			
    -- IMPORTANTE: Guardar en SQLite local (independiente de MySQL)
    guardarArrestoSQLite(charID, tiempoArresto, skinActual)
    
    -- Eliminar cualquier temporizador existente del jugador
    if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
        killTimer(timerLiberacion[charID])
        timerLiberacion[charID] = nil
    end
    
    if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
        killTimer(tiempoActualizacion[charID])
    end
    
    -- Crear SOLO temporizador de actualización (que también libera cuando termina)
    tiempoActualizacion[charID] = setTimer(function()
        if not isElement(other) then return end
        
        local tiempo = tonumber(getElementData(other, "ajail") or 0)
        if tiempo > 0 then
            -- Reducir tiempo
            local nuevoTiempo = tiempo - 1
            setElementData(other, "ajail", nuevoTiempo)
            
            -- Actualizar en SQLite
            actualizarTiempoArrestoSQLite(charID, nuevoTiempo)
            
            -- Verificar si ya cumplió la condena
            if nuevoTiempo <= 0 then
                liberarJugadorAutomatico(other)
            end
        end
    end, 60000, 0) -- Cada minuto, infinitamente
    
    -- También agregar a historial MySQL para compatibilidad
    local agente = getPlayerName(player):gsub("_", " ")
    exports.sql:query_insertid("INSERT INTO `historiales` (`historialID`, `nombre`, `dni`, `residencia`, `profesion`, `delitos`, `agente`, `fecha`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP);", 
        getPlayerName(other):gsub("_", " "), 
        tostring(20000000+charID), 
        "No Procede", 
        "No Procede", 
        tostring(razon).." (( "..tostring(tiempoArresto).." minutos.))", 
        agente)
    
    -- Actualizar también MySQL para compatibilidad con otros scripts
    exports.sql:query_free("UPDATE characters SET ajail = ? WHERE characterID = ?", {tiempoArresto, charID})
end

-- Función para verificar arrestos al login
function verificarArrestoAlLogin()
    local player = source
    local charID = exports.players:getCharacterID(player)
    if not charID then return end
    
    -- Obtener datos de arresto de SQLite local
    local datosArresto = obtenerArrestoSQLite(charID)
    
    if datosArresto and datosArresto.tiempo and tonumber(datosArresto.tiempo) > 0 then
        local tiempoArresto = tonumber(datosArresto.tiempo)
        outputDebugString("[ARRESTO] Jugador " .. getPlayerName(player) .. " reconectado con " .. tiempoArresto .. " minutos restantes")
        
        -- Restaurar skin de prisionero
        if datosArresto.skin and tonumber(datosArresto.skin) > 0 then
            skinOriginal[charID] = tonumber(datosArresto.skin)
            setElementData(player, "skinOriginalPrision", tonumber(datosArresto.skin))
        end
        setElementModel(player, 111)
        
        -- Teleportar a celda
        local celdaRandom = math.random(1, #celdas)
        local celdaPos = celdas[celdaRandom]
        setElementPosition(player, celdaPos[1], celdaPos[2], celdaPos[3])
        setElementInterior(player, 0)
        setElementDimension(player, 0)
        
        -- Establecer tiempo restante (el mismo que tenía cuando se desconectó)
        setElementData(player, "ajail", tiempoArresto)
        outputChatBox("Continúas cumpliendo condena. Te quedan " .. tiempoArresto .. " minutos.", player, 255, 0, 0)
        
        -- Eliminar cualquier temporizador existente del jugador
        if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
            killTimer(timerLiberacion[charID])
            timerLiberacion[charID] = nil
        end
        
        if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
            killTimer(tiempoActualizacion[charID])
        end
        
        -- Crear SOLO temporizador de actualización (que también libera cuando termina)
        tiempoActualizacion[charID] = setTimer(function()
            if not isElement(player) then return end
            
            local tiempoActual = tonumber(getElementData(player, "ajail") or 0)
            if tiempoActual > 0 then
                local nuevoTiempo = tiempoActual - 1
                setElementData(player, "ajail", nuevoTiempo)
                actualizarTiempoArrestoSQLite(charID, nuevoTiempo)
                
                if nuevoTiempo <= 0 then
                    liberarJugadorAutomatico(player)
                end
            end
        end, 60000, 0)
    end
end

-- Función para guardar tiempo al desconectar
function guardarTiempoAlDesconectar()
    local player = source
    local charID = exports.players:getCharacterID(player)
    
    if charID and getElementData(player, "ajail") then
        local tiempoRestante = tonumber(getElementData(player, "ajail"))
        
        if tiempoRestante and tiempoRestante > 0 then
            -- Guardar en SQLite
            actualizarTiempoArrestoSQLite(charID, tiempoRestante)
            outputDebugString("[ARRESTO] Jugador " .. getPlayerName(player) .. " desconectado con " .. tiempoRestante .. " minutos")
            
            -- Limpiar temporizadores
            if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
                killTimer(timerLiberacion[charID])
                timerLiberacion[charID] = nil
            end
            
            if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
                killTimer(tiempoActualizacion[charID])
                tiempoActualizacion[charID] = nil
            end
            
            -- Actualizar también MySQL para compatibilidad (asegurarse de que coincida con SQLite)
            exports.sql:query_free("UPDATE characters SET ajail = ? WHERE characterID = ?", {tiempoRestante, charID})
        end
    end
end

-- Función para liberar jugador
function liberarJugadorAutomatico(jugador)
    if not isElement(jugador) then return end
    
    local charID = exports.players:getCharacterID(jugador)
    if not charID then return end
    
    -- Prevenir liberaciones repetidas verificando si el jugador ya está liberado
    if not getElementData(jugador, "ajail") then
        outputDebugString("[ARRESTO] Intento de liberación repetida para: " .. getPlayerName(jugador))
        return
    end
    
    -- Limpiar temporizadores
    if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
        killTimer(timerLiberacion[charID])
        timerLiberacion[charID] = nil
    end
    
    if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
        killTimer(tiempoActualizacion[charID])
        tiempoActualizacion[charID] = nil
    end
    
    -- Restaurar skin
    if skinOriginal[charID] then
        setElementModel(jugador, skinOriginal[charID])
        skinOriginal[charID] = nil
    elseif getElementData(jugador, "skinOriginalPrision") then
        setElementModel(jugador, getElementData(jugador, "skinOriginalPrision"))
        removeElementData(jugador, "skinOriginalPrision")
    end
    
    -- Limpiar datos
    removeElementData(jugador, "ajail")
    
    -- Limpiar en SQLite
    eliminarArrestoSQLite(charID)
    
    -- Limpiar también en MySQL para compatibilidad
    exports.sql:query_free("UPDATE characters SET ajail = 0 WHERE characterID = ?", {charID})
    
    -- Teleport de liberación
    setElementPosition(jugador, -434.5859375, 1447.6396484375, 33.993980407715)
    setElementDimension(jugador, 0)
    setElementInterior(jugador, 0)
    
    outputChatBox('Has cumplido tu condena y has sido liberado.', jugador, 0, 255, 0)
    outputDebugString("[ARRESTO] Jugador " .. getPlayerName(jugador) .. " liberado")
end

-- Comando para liberar jugador
function liberarJugador(player, commandName, otherPlayer)
    if not otherPlayer then outputChatBox("Sintaxis: /liberar [jugador]", player, 255, 255, 255) return end
    
    local otro = exports.players:getFromName(player, otherPlayer)
    if not otro then return end
    
    local charID = exports.players:getCharacterID(otro)
    
    if hasObjectPermissionTo(player, 'command.modchat', false) or exports.factions:isPlayerInFaction(player, 1) then
        if getElementData(otro, "ajail") then
            liberarJugadorAutomatico(otro)
            
            if getElementData(player, "enc") then
                outputChatBox('Alguien te ha sacado de la celda.', otro, 0, 255, 0)
            else
                outputChatBox('El agente/staff '..getPlayerName(player):gsub("_", " ").. ' te ha sacado de la celda.', otro, 0, 255, 0)
            end
            outputChatBox('Has sacado de la celda a '..getPlayerName(otro):gsub("_", " ").. '.', player, 0, 255, 0)
        else
            -- Verificar si existe en SQLite
            local datosArresto = obtenerArrestoSQLite(charID)
            if datosArresto and datosArresto.tiempo and tonumber(datosArresto.tiempo) > 0 then
                eliminarArrestoSQLite(charID)
                outputChatBox('Has sacado de la celda a '..getPlayerName(otro):gsub("_", " ").. '.', player, 0, 255, 0)
            else
                outputChatBox("El jugador seleccionado no está arrestado.", player, 255, 0, 0)
            end
        end
    else
        outputChatBox("Acceso denegado.", player, 255, 0, 0)
    end
end
addCommandHandler("liberar", liberarJugador)

-- Comando para ver tiempo restante
function verTiempoRestante(player)
    if getElementData(player, "ajail") then
        local tiempo = tonumber(getElementData(player, "ajail"))
        outputChatBox("Te quedan " .. tiempo .. " minutos para cumplir tu condena.", player, 255, 0, 0)
        
        -- Verificar datos en SQLite (solo para depuración para admins)
        if hasObjectPermissionTo(player, "command.modchat", false) then
            local charID = exports.players:getCharacterID(player)
            local datosArresto = obtenerArrestoSQLite(charID)
            
            if datosArresto then
                outputChatBox("(Admin-info: Tiempo en BD: " .. datosArresto.tiempo .. " minutos)", player, 255, 165, 0)
            end
        end
    else
        -- Verificar si existe en SQLite (por si el elemento data se perdió)
        local charID = exports.players:getCharacterID(player)
        local datosArresto = obtenerArrestoSQLite(charID)
        
        if datosArresto and datosArresto.tiempo and tonumber(datosArresto.tiempo) > 0 then
            -- Restaurar datos
            setElementData(player, "ajail", tonumber(datosArresto.tiempo))
            outputChatBox("Te quedan " .. datosArresto.tiempo .. " minutos para cumplir tu condena (restaurado desde BD).", player, 255, 0, 0)
            
            -- Recordar al jugador que debe reiniciar los temporizadores
            outputChatBox("IMPORTANTE: Usa /debugarresto reiniciar para activar los temporizadores.", player, 255, 165, 0)
        else
            outputChatBox("No tienes una condena pendiente.", player, 255, 0, 0)
        end
    end
end
addCommandHandler("verrestante", verTiempoRestante)
addCommandHandler("tiempo", verTiempoRestante)

-- Comando para debug del sistema
function depurarSistemaArresto(player, cmd, accion)
    if not hasObjectPermissionTo(player, "command.modchat", false) then
        outputChatBox("No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if accion == "info" then
        -- Mostrar toda la información de la BD
        local arrestados = mostrarArrestosEnSQLite()
        
        outputChatBox("=== Arrestos en SQLite ===", player, 255, 255, 0)
        if arrestados and #arrestados > 0 then
            for i, row in ipairs(arrestados) do
                outputChatBox("CharID: " .. row.charID .. ", Tiempo: " .. row.tiempo .. " min, Skin: " .. row.skin, player, 255, 255, 0)
            end
        else
            outputChatBox("No hay arrestos guardados en SQLite", player, 255, 255, 0)
        end
    elseif accion == "limpiar" then
        -- Limpiar todos los arrestos
        for charID, timer in pairs(timerLiberacion) do
            if isTimer(timer) then
                killTimer(timer)
                timerLiberacion[charID] = nil
            end
        end
        
        for charID, timer in pairs(tiempoActualizacion) do
            if isTimer(timer) then
                killTimer(timer)
                tiempoActualizacion[charID] = nil
            end
        end
        
        -- Limpiar BD
        if dbArresto then
            dbExec(dbArresto, "DELETE FROM arrestos")
            outputChatBox("Base de datos SQLite limpiada", player, 0, 255, 0)
        end
    elseif accion == "reiniciar" then
        -- Reiniciar todos los temporizadores
        for _, pl in ipairs(getElementsByType("player")) do
            if getElementData(pl, "ajail") then
                local charID = exports.players:getCharacterID(pl)
                local tiempo = tonumber(getElementData(pl, "ajail"))
                
                -- Limpiar temporizadores existentes
                if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
                    killTimer(timerLiberacion[charID])
                    timerLiberacion[charID] = nil
                end
                
                if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
                    killTimer(tiempoActualizacion[charID])
                end
                
                -- Crear SOLO temporizador de actualización (que también libera cuando termina)
                tiempoActualizacion[charID] = setTimer(function()
                    if not isElement(pl) then return end
                    
                    local tiempoActual = tonumber(getElementData(pl, "ajail") or 0)
                    if tiempoActual > 0 then
                        local nuevoTiempo = tiempoActual - 1
                        setElementData(pl, "ajail", nuevoTiempo)
                        actualizarTiempoArrestoSQLite(charID, nuevoTiempo)
                        
                        if nuevoTiempo <= 0 then
                            liberarJugadorAutomatico(pl)
                        end
                    end
                end, 60000, 0)
                
                outputChatBox("Temporizador de actualización reiniciado para: " .. getPlayerName(pl), player, 0, 255, 0)
            end
        end
        outputChatBox("Sistema de arrestos reiniciado", player, 0, 255, 0)
    else
        outputChatBox("Uso: /" .. cmd .. " [info/limpiar/reiniciar]", player, 255, 255, 255)
    end
end
addCommandHandler("debugarresto", depurarSistemaArresto)

-- Inicialización al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    -- Inicializar base de datos SQLite
    iniciarBaseDatosSQLite()
    
    -- Registrar manejadores de eventos
    addEventHandler("onCharacterLogin", root, verificarArrestoAlLogin)
    addEventHandler("onPlayerQuit", root, guardarTiempoAlDesconectar)
    
    -- Registrar comandos
    if pcall(function() removeCommandHandler("arrestar") end) then
        addCommandHandler("arrestar", arrestarJugador)
    end
    
    outputDebugString("[ARRESTO] Sistema de arresto con SQLite inicializado")
    
    -- Verificar jugadores ya conectados (forma correcta, sin usar verificarArrestoAlLogin)
    for _, jugador in ipairs(getElementsByType("player")) do
        if exports.players:isLoggedIn(jugador) then
            local charID = exports.players:getCharacterID(jugador)
            local datosArresto = obtenerArrestoSQLite(charID)
            
            if datosArresto and datosArresto.tiempo and tonumber(datosArresto.tiempo) > 0 then
                -- Restaurar arresto para jugadores ya conectados 
                -- Usamos una función específica para evitar mensajes duplicados
                restaurarArrestoConectado(jugador, charID, datosArresto)
            end
        end
    end
end)

-- Función especial para restaurar el arresto de un jugador ya conectado
function restaurarArrestoConectado(jugador, charID, datosArresto)
    if not isElement(jugador) or not charID or not datosArresto then return end
    
    local tiempoArresto = tonumber(datosArresto.tiempo)
    outputDebugString("[ARRESTO] Restaurando arresto para jugador ya conectado: " .. getPlayerName(jugador) .. ", tiempo: " .. tiempoArresto)
    
    -- Restaurar skin de prisionero
    if datosArresto.skin and tonumber(datosArresto.skin) > 0 then
        skinOriginal[charID] = tonumber(datosArresto.skin)
        setElementData(jugador, "skinOriginalPrision", tonumber(datosArresto.skin))
    end
    setElementModel(jugador, 111)
    
    -- Teleportar a celda
    local celdaRandom = math.random(1, #celdas)
    local celdaPos = celdas[celdaRandom]
    setElementPosition(jugador, celdaPos[1], celdaPos[2], celdaPos[3])
    setElementInterior(jugador, 0)
    setElementDimension(jugador, 0)
    
    -- Establecer tiempo restante
    setElementData(jugador, "ajail", tiempoArresto)
    outputChatBox("Continúas cumpliendo condena. Te quedan " .. tiempoArresto .. " minutos.", jugador, 255, 0, 0)
    
    -- Limpiar temporizadores existentes
    if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
        killTimer(timerLiberacion[charID])
        timerLiberacion[charID] = nil
    end
    
    if tiempoActualizacion[charID] and isTimer(tiempoActualizacion[charID]) then
        killTimer(tiempoActualizacion[charID])
    end
    
    -- Crear temporizador de actualización
    tiempoActualizacion[charID] = setTimer(function()
        if not isElement(jugador) then return end
        
        local tiempoActual = tonumber(getElementData(jugador, "ajail") or 0)
        if tiempoActual > 0 then
            local nuevoTiempo = tiempoActual - 1
            setElementData(jugador, "ajail", nuevoTiempo)
            actualizarTiempoArrestoSQLite(charID, nuevoTiempo)
            
            if nuevoTiempo <= 0 then
                liberarJugadorAutomatico(jugador)
            end
        end
    end, 60000, 0)
end

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
	if exports.factions:isPlayerInFaction(player, 1) then -- no tiene cierre
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