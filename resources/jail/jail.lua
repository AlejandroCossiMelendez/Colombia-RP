--[[
Copyright (c) 2019 DownTown RolePlay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

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
    {-302.634765625, 1590.0400390625, 82.918838500977}   -- celda14
}

timerjail = setTimer ( 	
function ()	  
	for k, player in ipairs(getElementsByType("player")) do
		local tjail = tonumber(getElementData(player, "tjail"))
		local ajail = tonumber(getElementData(player, "ajail"))
		local tpd = tonumber(getElementData(player, "tpd"))
		if tjail and tjail >= 1 then
			setElementHealth(player, 100)
			setElementData(player, "tjail", tjail-1)
			local userID = exports.players:getUserID(player)
			if userID then
				exports.sql:query_free( "UPDATE wcf1_user SET tjail = "..tonumber(tjail-1).." WHERE userID = " .. userID )
			end
			if tjail == 1 then
				setElementHealth(player, 100)
				triggerEvent("onJailFinalizar", player, player)
			end
		end
		if tpd then				
			if tpd == 59 then -- Pasó un minuto y ya hay que dar el PayDay ;D
				exports.payday:darPayday(player)
				setElementData(player, "tpd", 0)
			else
				setElementData(player, "tpd", tonumber(tpd+1))
			end
		end
	end			
end 
, 60000, 0 )
 
function jailPlayer ( player, otro, tiemp, razon )
	local nombre = getPlayerName(otro):gsub("_", " ")
	local tiempo2 = getElementData( otro, "ajail" )
	local tiempoJ = getElementData(otro, "tjail")
	if tiempoJ and tiempoJ > 0 then
		tiempo = tiemp+tiempoJ
		outputChatBox("Se te ha sumado este jail a los minutos que ya tenías.", otro, 255, 0, 0)
	else
		tiempo = tiemp
	end
	if tiempo2 and tiempo2 > 0 then outputChatBox("No puedes dar jail a este jugador porque está arrestado IC.", otro, 255, 0, 0) return end
	if getPedOccupiedVehicle(otro) then 
		removePedFromVehicle(otro)	
	end
	if exports.sql:query_free( "UPDATE wcf1_user SET tjail = "..tiempo.." WHERE userID = " .. exports.players:getUserID(otro)) then
		exports.chat:sendLocalOOC( otro, "[Jail] " .. nombre .. " ha sido jaileado por un staff." )
		setTimer( function (otro)
		setElementPosition(otro, -329.6220703125, 1580.267578125, 77.106437683105)
		setElementInterior(otro, 0)
		setElementDimension(otro, 0) end, 500, 1, otro )
		setElementData(otro, "tjail", tonumber(tiempo))
		exports.items:guardarArmas(otro, true)
		triggerClientEvent(otro, "bloquearTeclaI", otro, true)
		if getElementData(player, "enc") then
			outputChatBox("Has dado jail a " .. nombre .. " correctamente.", player, 255, 0, 0)
			outputChatBox("Razón: " ..razon.. ". Tiempo: " ..tiempo.. " minutos.", player, 255, 0, 0)
		else
			staffMessageJail("El staff " ..getPlayerName(player):gsub("_", " ").. " ha jaileado al jugador " ..nombre.. ".")
			staffMessageJail("Razón: " ..razon.. ". Tiempo: " ..tiempo.. " minutos.")
		end
		outputChatBox("Has sido jaileado por " ..getPlayerName(player):gsub("_", " ").. " durante " ..tiempo.. " minutos. Razón: " ..razon.. ".", otro, 255, 0, 0)
	end
end
  

function serverJail ( player, tiempo, ... )
	local tiempo = tonumber(tiempo)
	local razon = table.concat({...}, " ")
	local cid = exports.players:getCharacterID(player)
	local userID = exports.players:getUserID(player)
	local vehicle = getPedOccupiedVehicle(player)
		if vehicle then 
			removePedFromVehicle(player)
			-- if getElementData(vehicle, "idveh") >= 1 then
				-- exports.vehicles:saveVehicle( vehicle )
				-- respawnVehicle( vehicle ) 	
			-- else
				-- destroyElement( vehicle )
			-- end		
		end	
	if tiempo and razon and cid and player then
		if exports.sql:query_free( "UPDATE wcf1_user SET tjail = "..tiempo.." WHERE userID = " .. userID) then
			setTimer( function (player)
				setElementPosition(player, -329.6220703125, 1580.267578125, 77.106437683105)
				setElementInterior(player, 0)
				setElementDimension(player, 0) 
			end, 500, 1, player )
			setElementData(player, "tjail", tiempo)
			exports.items:guardarArmas(player, true)
			triggerClientEvent(player, "bloquearTeclaI", player, true)
			if tostring(razon) ~= "DM en Jail" then
				staffMessageJail(getPlayerName(player):gsub("_", " ").." ha sido jaileado por el servidor.")
				staffMessageJail("Razón: "..razon..". Tiempo: "..tostring(tiempo).." minutos.")
			end
			outputChatBox("Has sido jaileado durante "..tostring(tiempo).." minutos. Razón: " ..razon.. ".", player, 255, 0, 0)
			return true
		end
	end
end


function tiempoJail ( player )
	local tiempo = getElementData( player, "tjail" )
	if tiempo and tiempo >= 2 then
		outputChatBox("Te quedan " ..tiempo.. " minutos.", player, 255, 0, 0)
	elseif tiempo and tiempo == 1 then
		outputChatBox("Te queda " ..tiempo.. " minuto.", player, 255, 0, 0)
	end
	
	-- Verificar tiempo de arresto IC
	local tiempo2 = getElementData( player, "ajail" )
	if tiempo2 and tonumber(tiempo2) >= 2 then
		outputChatBox("Te quedan " ..tiempo2.. " minutos de arresto.", player, 255, 0, 0)
	elseif tiempo2 and tonumber(tiempo2) == 1 then
		outputChatBox("Te queda " ..tiempo2.. " minuto de arresto.", player, 255, 0, 0)
	end
end
addCommandHandler("tiempo", tiempoJail)

function verJailUsuario ( player, cmd, otherPlayer )
	local other, name = exports.players:getFromName( player, otherPlayer )
	
	-- Verificar que other existe antes de continuar
	if not other then
		outputChatBox("No se encontró al jugador especificado.", player, 255, 0, 0)
		return
	end
	
	local tiempover1 = getElementData( other, "tjail" )
	local tiempover2 = getElementData( other, "ajail" )
	if hasObjectPermissionTo(player, 'command.modchat', false) then
		if tiempover1 then
			if tiempover1 and tiempover1 >= 2 then
				outputChatBox("INFO: Le quedan " ..tiempover1.. " minutos de sanción OOC a "..tostring(name)..".", player, 255, 0, 0)
			elseif tiempover1 and tiempover1 == 1 then
				outputChatBox("INFO: Le queda " ..tiempover1.. " minuto de sanción OOC a "..tostring(name)..".", player, 255, 0, 0)
			end
		else
			outputChatBox("Este jugador no tiene jail OOC.", player, 255, 0, 0)
		end
		if tiempover2 then
			if tiempover2 and tiempover2 >= 2 then
				outputChatBox("INFO: Le quedan " ..tiempover2.. " minutos de arresto IC a "..tostring(name)..".", player, 255, 0, 0)
			elseif tiempover2 and tiempover2 == 1 then
				outputChatBox("INFO: Le queda " ..tiempover2.. " minuto de arresto IC a "..tostring(name)..".", player, 255, 0, 0)
			end
		else
			outputChatBox("Este jugador no tiene jail IC.", player, 255, 0, 0)
		end
    else
		outputChatBox("Acceso denegado.", player, 0, 255, 0)
	end
end
addCommandHandler("verjailde", verJailUsuario)
addCommandHandler("jailde", verJailUsuario)
addCommandHandler("vertiempode", verJailUsuario)
addCommandHandler("tiempode", verJailUsuario)

function unjail ( player, commandName, idsancion )
	if hasObjectPermissionTo(player, 'command.modchat', false) then
		if not idsancion then
			outputChatBox("Sintaxis: /unjail [ID de sanción]", player, 255, 255, 255)
			return
		end
		local idsancion = tonumber(idsancion)
		if idsancion and idsancion >= 1 then
			local sancion = exports.sql:query_assoc_single("SELECT * FROM sanciones WHERE sancionID = "..idsancion)
			if sancion then
				local staffID = exports.players:getUserID(player)
				local userID = tonumber(sancion.userID)
				if tonumber(sancion.validez) == 1 then -- Si la sanción es válida, NO puede salir de jail.
					outputChatBox("La sanción especificada sigue siendo válida. Usa /sanciones [jugador] y anúlala primero.", player, 255, 0, 0)
					return
				end
				if tonumber(staffID) == tonumber(sancion.staffID) or tonumber(sancion.staffID) == -1 then
					local otro = -1
					for k, v in ipairs(getElementsByType("player")) do
						if exports.players:getUserID(v) == userID then
							otro = v
						end
					end
					if isElement(otro) then
						if getElementData( otro, "tjail") and tonumber(getElementData( otro, "tjail")) >= 1 then
							setElementPosition(otro, 1861.0107421875, -1667.984375, 13.704649925232)
							outputChatBox('El staff '..getPlayerName(player):gsub("_", " ").. ' te ha liberado del jail.', otro, 0, 255, 0)
							outputChatBox('Has liberado a '..getPlayerName(otro):gsub("_", " ").. ' del jail.', player, 0, 255, 0)
							exports.logsic:addLogMessage("unjail", 'El staff '..getPlayerName(player):gsub("_", " ").. ' ha liberado a '..getPlayerName(otro):gsub("_", " ").. ' del jail.' )
							setElementInterior(otro, 0)
							setElementDimension(otro, 0)
							removeElementData(otro, "tjail")
							triggerClientEvent(otro, "bloquearTeclaI", otro, false)
							exports.sql:query_free("UPDATE wcf1_user SET tjail = 0 WHERE userID = " .. userID)
							exports.sql:query_free("UPDATE characters SET interior = 0, dimension = 0, x = 2408.85, y = 49.22, z = 26.48 WHERE userID = "..userID)
							exports.sql:query_insertid( "INSERT INTO sanciones (userID, staffID, regla, validez) VALUES (" .. table.concat( { userID, staffID, -1, idsancion }, ", " ) .. ")" )
						else
							outputChatBox("El jugador seleccionado no está en jail.", player, 0, 255, 0)
						end
					else
						outputChatBox("El jugador de esa sanción no está conectado.", player, 255, 0, 0)
					end
				else
					outputChatBox("¡Esta ID de sanción no ha sido emitida por ti!", player, 255, 0, 0)
				end
			end
		else
			outputChatBox("El ID de sanción debe de ser un número mayor o igual a 1.", player, 255, 0, 0)
		end
	else
		outputChatBox("Acceso denegado.", player, 0, 255, 0)
	end
end
addCommandHandler("unjail", unjail)

function entradaJail ()
	removeElementData(source, "ajail")
	local userID = exports.players:getUserID(source)
	local characterID = exports.players:getCharacterID(source)
	
	-- Verificar jail OOC (tjail)
	local v = exports.sql:query_assoc_single("SELECT tjail FROM wcf1_user WHERE userID = "..tonumber(userID))
	if v and v.tjail and tonumber(v.tjail) > 1 then
		triggerEvent("onJailAntiCapitalRP", source, source, tonumber(v.tjail), 1)
	end
	
	-- Verificar jail IC (ajail)
	local v2 = exports.sql:query_assoc_single("SELECT ajail FROM characters WHERE characterID = "..tonumber(characterID))
	if v2 and v2.ajail and tonumber(v2.ajail) > 0 then
		-- Establecer el tiempo de jail IC
		setElementData(source, "ajail", tonumber(v2.ajail))
		-- Restaurar skin de prisionero
		setElementModel(source, 111)
		-- Teleportar a una celda aleatoria
		local celdaRandom = math.random(1, #celdas)
		local celdaPos = celdas[celdaRandom]
		setElementPosition(source, celdaPos[1], celdaPos[2], celdaPos[3])
		setElementInterior(source, 0)
		setElementDimension(source, 0)
		outputChatBox("Continúas cumpliendo tu condena. Te quedan "..tonumber(v2.ajail).." minutos.", source, 255, 0, 0)
	end
end
addEventHandler( "onCharacterLogin", root, entradaJail )

function continuarjail (otro, tiempo, tipo)
	if tipo == 1 then
		setElementPosition(otro, -329.6220703125, 1580.267578125, 77.106437683105)
		setElementInterior(otro, 0)
		setElementDimension(otro, 0)
		setElementData(otro, "tjail", tonumber(tiempo))
		outputChatBox ("Sigues jaileado, y tienes que cumplir tu tiempo.", otro, 255, 0, 0)
	elseif tipo == 2 then
		setElementPosition(otro, -329.6220703125, 1580.267578125, 77.106437683105)
		setElementInterior(otro, 0)
		setElementDimension(otro, 0)
		setElementData(otro, "ajail", tonumber(tiempo))
		outputChatBox("Sigues arrestado, y tienes que cumplir tu tiempo.", otro, 255, 0, 0)
	end
end
addEvent("onJailAntiCapitalRP", true)
addEventHandler("onJailAntiCapitalRP", root, continuarjail)

function tiempofinal ( otro )
	local userID = getElementData(otro, "data.userid")
    setElementPosition(otro, 1861.0107421875, -1667.984375, 13.704649925232)
	outputChatBox("Tu tiempo en jail ha finalizado. Esperamos no volver a verte.", otro, 0, 255, 0)
    setElementInterior(otro, 0)
    setElementDimension(otro, 0)
	removeElementData(otro, "tjail")
	triggerClientEvent(otro, "bloquearTeclaI", otro, false)
    exports.sql:query_free("UPDATE wcf1_user SET tjail = 0 WHERE userID = " .. userID)
	exports.sql:query_free("UPDATE characters SET interior = 0, dimension = 0, x = 2408.85, y = 49.22, z = 26.48 WHERE userID = "..userID)
end
addEvent("onJailFinalizar", true)
addEventHandler("onJailFinalizar", root, tiempofinal)

function getStaff( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.modchat", false ) then
			t[ #t + 1 ] = value
		end
	end
	return t
end

function staffMessageJail( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 0, 0 )
	end
end