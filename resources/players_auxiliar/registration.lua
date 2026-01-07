--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2018 DownTown Roleplay

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

local allowRegistration = true

local function trim( str )
	return str:gsub("^%s*(.-)%s*$", "%1")
end

addEvent( "players:register", true )
addEventHandler( "players:register", root,
	function( username, password )
		outputServerLog("[REGISTER] Evento players:register recibido. Usuario: " .. tostring(username) .. ", Source: " .. tostring(getPlayerName(source)) .. ", Client: " .. tostring(client and getPlayerName(client) or "nil"))
		
		if (source == client) or not client then
			if allowRegistration then
				if username and password then
					username = trim( username )
					password = trim( password )
					-- client length checks are the same
					if #username >= 3 and #password >= 8 then
						outputServerLog("[REGISTER] Validación de longitud OK. Verificando usuario en BD...")
						-- see if that username is free at all
						local info, errTest = exports.sql:query_assoc_single( "SELECT COUNT(userID) AS usercount FROM wcf1_user WHERE username = '%s'", username )
						outputServerLog("[REGISTER] Resultado query: " .. tostring(info and info.usercount or "nil") .. ", Error: " .. tostring(errTest or "nil"))
						if not info then
							outputServerLog("[REGISTER] ERROR: Query falló, no se pudo verificar usuario")
							triggerClientEvent( source, "players:registrationResult", source, 1 )
							return
						end
						
						if info.usercount > 0 then
							outputServerLog("[REGISTER] Usuario ya existe, rechazando registro")
							triggerClientEvent( source, "players:registrationResult", source, 3 )
							return
						end
						
						outputServerLog("[REGISTER] Usuario no existe, verificando IPs y Serial...")
						local info2, err2 = exports.sql:query_assoc( "SELECT regIP, lastIP, regSerial FROM wcf1_user" )
						if not info2 then
							outputServerLog("[REGISTER] ERROR: No se pudo obtener lista de IPs/Serials: " .. tostring(err2))
							triggerClientEvent( source, "players:registrationResult", source, 1 )
							return
						end
						
						outputServerLog("[REGISTER] Verificando " .. #info2 .. " registros existentes...")
						local ipReg = 0
						local playerSerial = getPlayerSerial(source)
						local playerIP = getPlayerIP(source)
						
						for k, v in ipairs(info2) do
							if v.regSerial == playerSerial then 
								outputServerLog("[REGISTER] Serial ya registrado: " .. playerSerial)
								triggerClientEvent( source, "players:registrationResult", source, 5 )
								return 
							end
							if tostring(v.regIP) == tostring(playerIP) then 
								ipReg = ipReg + 1 
								outputServerLog("[REGISTER] IP encontrada en regIP: " .. tostring(playerIP))
							end
							if tostring(v.lastIP) == tostring(playerIP) and tostring(v.regIP) ~= tostring(v.lastIP) then 
								ipReg = ipReg + 1 
								outputServerLog("[REGISTER] IP encontrada en lastIP: " .. tostring(playerIP))
							end
						end
						
						outputServerLog("[REGISTER] Conteo de IPs: " .. ipReg)
						
						-- Verificar si el jugador es staff (tiene permisos de modchat o está logueado como staff)
						local isStaff = false
						if hasObjectPermissionTo(source, "command.modchat", false) then
							isStaff = true
							outputServerLog("[REGISTER] Staff detectado por permisos ACL")
						elseif exports.players and exports.players.isLoggedIn and exports.players:isLoggedIn(source) then
							-- Verificar si el jugador logueado tiene grupos de staff
							local groups = exports.players:getGroups(source)
							if groups then
								for _, group in ipairs(groups) do
									if group.groupID == 1 or group.groupID == 2 or group.groupID == 3 or group.groupID == 12 or group.groupID == 13 then
										isStaff = true
										outputServerLog("[REGISTER] Staff detectado por grupo: " .. tostring(group.groupName))
										break
									end
								end
							end
						else
							-- Si no está logueado, verificar si alguna cuenta existente desde esta IP es staff
							outputServerLog("[REGISTER] Jugador no logueado, verificando si alguna cuenta desde esta IP es staff...")
							local staffCheck, errStaff = exports.sql:query_assoc_single(
								"SELECT COUNT(utg.userID) as staffCount FROM wcf1_user u " ..
								"INNER JOIN wcf1_user_to_groups utg ON u.userID = utg.userID " ..
								"WHERE (u.regIP = '%s' OR u.lastIP = '%s') AND utg.groupID IN (1, 2, 3, 12, 13)",
								playerIP, playerIP
							)
							if staffCheck and staffCheck.staffCount and staffCheck.staffCount > 0 then
								isStaff = true
								outputServerLog("[REGISTER] Staff detectado: existe cuenta staff desde esta IP (count: " .. staffCheck.staffCount .. ")")
							end
						end
						
						local maxIPRegistrations = isStaff and 10 or 2  -- Staff puede tener hasta 10 cuentas, usuarios normales 2
						outputServerLog("[REGISTER] Verificación staff: " .. tostring(isStaff) .. ", Límite de IPs: " .. maxIPRegistrations)
						
						if ipReg >= maxIPRegistrations then 
							outputServerLog("[REGISTER] Límite de IPs alcanzado (" .. ipReg .. "/" .. maxIPRegistrations .. "), rechazando registro")
							triggerClientEvent( source, "players:registrationResult", source, 6 )
							return
						end
						
						if isStaff then
							outputServerLog("[REGISTER] Staff detectado, permitiendo registro (límite: " .. maxIPRegistrations .. ")")
						end
						
						outputServerLog("[REGISTER] Generando salt...")
						local salt = ''
						local chars = { 'a', 'b', 'c', 'd', 'e', 'f', 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
						for i = 1, 40 do
							salt = salt .. chars[ math.random( 1, #chars ) ]
						end
						
						outputServerLog("[REGISTER] Insertando usuario en BD...")
						local userID, error = exports.sql:query_insertid( "INSERT INTO wcf1_user (username,salt,password) VALUES ('%s', '%s', SHA1(CONCAT('%s', SHA1(CONCAT('%s', '" .. hash("sha1", password) .. "')))))", username, salt, salt, salt )
						if error then
							outputServerLog("[REGISTER] ERROR al insertar usuario: " .. tostring(error))
							triggerClientEvent( source, "players:registrationResult", source, 4 )
						else
							outputServerLog("[REGISTER] Usuario registrado exitosamente con userID: " .. tostring(userID))
							triggerClientEvent( source, "players:registrationResult", source, 0 ) -- Inicio de sesion automático.
							exports.sql:query_free( "UPDATE wcf1_user SET regIP = '%s' WHERE username = '%s'", playerIP, username )
							exports.sql:query_free( "UPDATE wcf1_user SET regSerial = '%s' WHERE username = '%s'", playerSerial, username )
							outputChatBox ( "Bienvenido por primera vez a DownTown RolePlay.", source, 0, 255, 0 )
							outputChatBox ( "Te recomendamos que utilices /duda para obtener asistencia", source, 0, 255, 0)
						end
					else
						-- shouldn't happen
						triggerClientEvent( source, "players:registrationResult", source, 1 )
					end
				else
					-- can't do much without a username and password
					triggerClientEvent( source, "players:registrationResult", source, 1 )
				end
			else
				triggerClientEvent( source, "players:registrationResult", source, 2, "Registro desactivado" )
			end
		end
	end
)