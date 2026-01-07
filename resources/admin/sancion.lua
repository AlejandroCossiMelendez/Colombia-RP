local sanciones = {
	[-1] = "Liberación de Jail",
	[1] = "DM - DeathMatch - Matar sin razón",
	[2] = "PG - PowerGaming - Hacer algo irreal",
	[3] = "MG - MetaGaming - Usar info OOC en IC",
	[4] = "RK - RevengeKill - Matar por venganza",
	[5] = "TK - TeamKill - Matar miembros de facción",
	[6] = "CK - CarKill - Atropellar sin rol",
	[7] = "HK - HelicopterKill - Matar con hélices",
	[8] = "NA - NoobAbusser - Abusar de novatos",
	[9] = "BA - BugAbusser - Abusar de bugs",
	[10] = "AA - AdminAbusser - Abuso de poder admin",
	[11] = "ZZ - ZigZag - Correr en zigzag evitando balas",
	[12] = "BH - BunnyHop - Saltar para no cansarse",
	[13] = "CJ - CarJacked - Robar auto sin rol",
	[14] = "BPC - BadParkingCar - Mal estacionamiento",
	[15] = "BD - BadDriving - Mal manejo",
	[16] = "DB - DriveBy - Disparar desde vehículo",
	[17] = "SK - SpawnKill - Matar en zona spawn",
	[18] = "IHQ - InvasionHeadQuarters - Invadir HQ",
	[19] = "NRE - No Rolear Entorno",
	[20] = "NRA - No Rolear Arma",
	[21] = "NRH - No Rolear Herida",
	[22] = "NRC - No Rolear Choque",
	[23] = "TTO - Matar PJ Agonizando",
	[24] = "PG2 - Evasión de rol",
	[25] = "AIOOC - Insultar staff OOC",
	[26] = "AA2 - Animacion Abuse",
	[27] = "AVP - Afk en via publica",
	[28] = "AHQ - Abusar de facción/esconderse HQ",
	[29] = "AR - Anti Rol",
	[30] = "CA - Command Abuser",
	[31] = "EK - Evadir Kill",
	[32] = "FK - Free Kill - Matar sin razón masivo",
	[33] = "FA - Faccion Abuse",
	[34] = "ICN - Incumplimiento normativa",
	[35] = "IDS - Interferir dinámica servidor",
	[36] = "LA2 - Lider Abuser",
	[37] = "LA - Lag Abuser",
	[38] = "MA - Mal Anuncio",
	[39] = "MG2 - MetaGaming indirecto",
	[40] = "MK - Meta Kill - Matar por motivos OOC",
	[41] = "MUD - Mal uso /duda",
	[42] = "RSL - Rambo sin licencia",
	[43] = "TA - Tazer Abuser",
	[44] = "NRR2 - No rolear reparación",
	[45] = "MUDVT - Mal uso vehículos trabajo",
	[46] = "PK - Player Kill - Amnesia de rol",
	[47] = "CK2 - CharacterKill - Muerte definitiva",
	[48] = "Anti FAIR PLAY - Juego no limpio",
	[49] = "IOOC - Insultar OOC",
	[50] = "HQ - HeadQuarters - Base facción"
}

--[[
LISTADO DE NORMAS Y SANCIONES.

#1 DM
	1º VEZ: 10 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 80 MINUTOS.
	5º VEZ: 120 MINUTOS.
	6º VEZ Y SUCESIVAS: 150 MINUTOS.
#2 PG / Forzar Rol
	1º VEZ: 10 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 60 MINUTOS.
	4º VEZ: 100 MINUTOS.
	5º VEZ: 140 MINUTOS.
	6º VEZ Y SUCESIVAS: 200 MINUTOS.
#3 MG
	1º VEZ: 10 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 100 MINUTOS.
	5º VEZ: 150 MINUTOS.
	6º VEZ Y SUCESIVAS: 200 MINUTOS.
#4 RK
	1º VEZ: 30 MINUTOS.
	2º VEZ: 60 MINUTOS.
	3º VEZ: 90 MINUTOS.
	4º VEZ: 140 MINUTOS.
	5º VEZ: 180 MINUTOS.
	6º VEZ Y SUCESIVAS: 300 MINUTOS.
#5 Faltas Respeto / Mentir o ignorar Staff
	1º VEZ: 30 MINUTOS.
	2º VEZ: 60 MINUTOS.
	3º VEZ: 150 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: BAN DE 1 SEMANA.
#6 Abuso Canal OOC / Cortar Rol
	1º VEZ: 20 MINUTOS.
	2º VEZ: 40 MINUTOS.
	3º VEZ: 120 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: 500 MINUTOS.
#7 Troll / BD / CJ
	1º VEZ: 5 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 80 MINUTOS.
	5º VEZ: 120 MINUTOS.
	6º VEZ Y SUCESIVAS: 300 MINUTOS.
#8 SPAM
	1º VEZ: BAN DE 1 DÍA.
	2º VEZ: BAN DE 5 DÍAS.
	3º VEZ: BAN DE 30 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#9 BA
	// Sólo se aplicará en bugs GRAVES. Además, conllevará CK de todos los PJ de la cuenta.
	1º VEZ: BAN DE 7 DÍAS.
	2º VEZ: BAN DE 15 DÍAS.
	3º VEZ: BAN DE 40 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#10 Multicuentas
	// Sólo se aplicará en multicuentas GRAVES. Además, conllevará CK de todos los PJ de la cuenta.
	1º VEZ: BAN DE 7 DÍAS.
	2º VEZ: BAN DE 15 DÍAS.
	3º VEZ: BAN DE 40 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#11 NRE / NRH / NRC
	1º VEZ: 20 MINUTOS.
	2º VEZ: 40 MINUTOS.
	3º VEZ: 120 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: 500 MINUTOS.
#12 Evasión de Rol
	//Conllevaria el CK hasta que se reanude el rol.
	1º VEZ: 30 MINUTOS.
	2º VEZ: 60 MINUTOS.
	3º VEZ: 120 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: 500 MINUTOS.
#13 Reporte Innecesario (Reportante)
	1º VEZ: 5 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 60 MINUTOS.
	5º VEZ Y SUCESIVAS: 80 MINUTOS.
#14 NA
	//Conlleva CK auto a la cuenta.
	1º VEZ: BAN DE 7 DÍAS.
	2º VEZ: BAN DE 15 DÍAS.
	3º VEZ: BAN DE 40 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#15 Mal Uso /AD
	1º VEZ: 5 MINUTOS.
	2º VEZ: 15 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ Y SUCESIVAS: 60 MINUTOS.
#16 Tener 2 PJ en una facción
	1º VEZ: 25 MINUTOS.
	2º VEZ: 85 MINUTOS.
	3º VEZ: 300 MINUTOS.
	4º VEZ Y SUCESIVAS: BAN DE 7 DÍAS.
#17 Monopolio
	SANCIÓN FIJA REGULADA POR EL SISTEMA DE ZONA.
]]

function getVecesSancionado(player, norma)
	if player and norma then
		local userID = exports.players:getUserID(player)
		local sql = exports.sql:query_assoc_single("SELECT COUNT(*) AS cuenta FROM sanciones WHERE validez = 1 AND userID = "..userID.." AND regla = "..norma)
		return tonumber(sql.cuenta)
	end
end

--[[
Esta función devuelve el tipo de sanción y el tiempo en minutos.
Tipo 1 = Jail
Tipo 2 = Ban
Tipo 3 = Ban + AutoCK de TODOS los PJ de la cuenta.
Tipo 4 = Punto positivo, sin sancion

NOTA: Esta función ya no se utiliza porque ahora el tiempo se establece manualmente.
Se mantiene comentada como referencia del sistema anterior.
]]
--[[
function calcularSancion(player, norma)
	local vez = getVecesSancionado(player, norma)+1
	if norma == 1 then -- #1 DM / DMCar
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 80
		elseif vez == 5 then
			return 1, 120
		elseif vez >= 6 then
			return 1, 150
		end
	elseif norma == 2 then -- #2 PG
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 60
		elseif vez == 4 then
			return 1, 100
		elseif vez == 5 then
			return 1, 140
		elseif vez >= 6 then
			return 1, 200
		end
	elseif norma == 3 then -- #3 MG / MK
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 100
		elseif vez == 5 then
			return 1, 150
		elseif vez >= 6 then
			return 1, 200
		end
	elseif norma == 4 then -- #4 RK
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 90
		elseif vez == 4 then
			return 1, 140
		elseif vez == 5 then
			return 1, 180
		elseif vez >= 6 then
			return 1, 300
		end
	elseif norma == 5 then -- #5 Faltas Respeto / Mentir o ignorar Staff
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 150
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 2, 10080
		end
	elseif norma == 6 then -- #6 Abuso Canal OOC / Cortar Rol
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 1, 500
		end
	elseif norma == 7 then -- #7 Troll / BD / CJ
		if vez == 1 then 
			return 1, 5
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 80
		elseif vez == 5 then
			return 1, 120
		elseif vez >= 6 then
			return 1, 300
		end
	elseif norma == 8 then -- #8 SPAM
		if vez == 1 then 
			return 2, 1440
		elseif vez == 2 then
			return 2, 7200
		elseif vez == 3 then
			return 2, 43200
		elseif vez >= 4 then
			return 2, 259200
		end
	elseif norma == 9 then -- #9 BA
		if vez == 1 then 
			return 3, 10080
		elseif vez == 2 then
			return 3, 21600
		elseif vez == 3 then
			return 3, 57600
		elseif vez >= 4 then
			return 3, 259200
		end
	elseif norma == 10 then -- #10 Multicuentas
		if vez == 1 then 
			return 3, 10080
		elseif vez == 2 then
			return 3, 21600
		elseif vez == 3 then
			return 3, 57600
		elseif vez >= 4 then
			return 3, 259200
		end
	elseif norma == 11 then -- #11 NRE / NRH / NRC
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 1, 500
		end
	elseif norma == 12 then -- #12 Evasión de Rol
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 1, 500
		end
	elseif norma == 13 then -- #13 Reporte Innecesario (Reportante)
		if vez == 1 then 
			return 1, 5
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 60
		elseif vez >= 5 then
			return 1, 80
		end
	elseif norma == 14 then -- #14 NA
		if vez == 1 then 
			return 3, 10080
		elseif vez == 2 then
			return 3, 21600
		elseif vez == 3 then
			return 3, 57600
		elseif vez >= 4 then
			return 3, 259200
		end
	elseif norma == 15 then -- #15 Mal Uso /AD
		if vez == 1 then 
			return 1, 5
		elseif vez == 2 then
			return 1, 15
		elseif vez == 3 then
			return 1, 40
		elseif vez >= 4 then
			return 1, 60
		end
	elseif norma == 16 then -- #16 Tener 2 PJ en una facción
		if vez == 1 then 
			return 1, 25
		elseif vez == 2 then
			return 1, 85
		elseif vez == 3 then
			return 1, 300
		elseif vez >= 4 then
			return 2, 10080
		end
	elseif norma == 17 then -- #17 Fuera de Zona de Rol
		return 1, 20
	elseif norma == 18 then -- #18 Buen rol / buena actuación
		return 4, 1
	elseif norma == 19 then -- #19 TTO
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 80
		elseif vez == 4 then
			return 1, 160
		elseif vez >= 5 then
			return 1, 320
		end
	elseif norma == 20 then -- #20 ICN
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 240
		elseif vez >= 5 then
			return 1, 480
		end
	elseif norma == 21 then -- #21 NVVPJ
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 240
		elseif vez >= 5 then
			return 1, 480
		end
	elseif norma == 22 then -- #22 RSL
		if vez == 1 then 
			return 1, 15
		elseif vez == 2 then
			return 1, 30
		elseif vez == 3 then
			return 1, 60
		elseif vez == 4 then
			return 1, 120
		elseif vez >= 5 then
			return 1, 240
		end
	elseif norma == 23 then -- #23 BA
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 80
		elseif vez >= 5 then
			return 1, 160
		end
	elseif norma == 24 then -- #24 AIOOC
		if vez == 1 then 
			return 1, 40
		elseif vez == 2 then
			return 1, 80
		elseif vez == 3 then
			return 1, 160
		elseif vez == 4 then
			return 1, 320
		elseif vez >= 5 then
			return 1, 640
		end
	elseif norma == 25 then -- #25 IOOC
		if vez == 1 then 
			return 1, 50
		elseif vez == 2 then
			return 1, 100
		elseif vez == 3 then
			return 1, 200
		elseif vez == 4 then
			return 1, 400
		elseif vez >= 5 then
			return 1, 800
		end
	elseif norma == 26 then -- #26 SK
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 240
		elseif vez >= 5 then
			return 1, 480
		end
	elseif norma == 27 then -- #27 IDS
		if vez == 1 then 
			return 1, 60
		elseif vez == 2 then
			return 1, 120
		elseif vez == 3 then
			return 1, 240
		elseif vez == 4 then
			return 1, 480
		elseif vez >= 5 then
			return 1, 960
		end
	elseif norma == 28 then -- #28 HQ
		if vez == 1 then 
			return 1, 40
		elseif vez == 2 then
			return 1, 80
		elseif vez == 3 then
			return 1, 160
		elseif vez == 4 then
			return 1, 320
		elseif vez >= 5 then
			return 1, 640
		end
	elseif norma == 29 then -- #29 AR
		if vez == 1 then 
			return 1, 45
		elseif vez == 2 then
			return 1, 90
		elseif vez == 3 then
			return 1, 180
		elseif vez == 4 then
			return 1, 360
		elseif vez >= 5 then
			return 1, 720
		end
	elseif norma == 30 then -- #30 AA2
		if vez == 1 then 
			return 1, 25
		elseif vez == 2 then
			return 1, 50
		elseif vez == 3 then
			return 1, 100
		elseif vez == 4 then
			return 1, 200
		elseif vez >= 5 then
			return 1, 400
		end
	elseif norma == 31 then -- #31 AVO
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 80
		elseif vez == 4 then
			return 1, 160
		elseif vez >= 5 then
			return 1, 320
		end
	elseif norma == 32 then -- #32 MUD
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 80
		elseif vez >= 5 then
			return 1, 160
		end
	else
		return 0, 0
	end
end
]]

function GUIsancionarUsuario(player, cmd, otherPlayer)
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		if not exports.players:getOption(player, "staffduty") then
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName(player, otherPlayer)
			if other then
				triggerClientEvent(player, "onAbrirGUISancionar", player, getPlayerName(other))
			end
		else
			outputChatBox("Sintaxis: /sancionar [jugador]", player, 255, 255, 255)
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end
end
addCommandHandler("sancionar", GUIsancionarUsuario)

function GUIsancionesUsuario(player, cmd, otherPlayer)
	if hasObjectPermissionTo(player, "command.modchat", false) and not exports.players:getOption(player, "staffduty") then
		return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
	end
	
	if otherPlayer then
		-- Primero intentar interpretar como ID de usuario si es un número
		if tonumber(otherPlayer) then
			local userID = tonumber(otherPlayer)
			local sql = exports.sql:query_assoc("SELECT * FROM sanciones WHERE userID = "..userID)
			
			-- Debug: Mostrar cantidad de sanciones encontradas
			if #sql > 0 then
				outputChatBox("Encontradas "..#sql.." sanciones para ID: "..userID, player, 0, 255, 0)
				
				-- Obtener el nombre del usuario desde la base de datos si está disponible
				local userInfo = exports.sql:query_assoc_single("SELECT nombreUsuario FROM usuarios WHERE userID = "..userID)
				local nombre = userInfo and userInfo.nombreUsuario or "ID: "..userID
				
				if hasObjectPermissionTo(player, "command.modchat", false) then
					triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, nombre, true)
				else
					triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, nombre, false)
				end
				return
			else
				outputChatBox("No se encontraron sanciones para el usuario con ID: "..userID, player, 255, 0, 0)
			end
		end
		
		-- Si no es un número o no se encontraron sanciones, intentar como nombre de jugador
		local other, name = exports.players:getFromName(player, otherPlayer)
		if other then
			local userID = exports.players:getUserID(other)
			local sql = exports.sql:query_assoc("SELECT * FROM sanciones WHERE userID = "..userID)
			
			outputChatBox("Encontradas "..#sql.." sanciones para: "..name, player, 0, 255, 0)
			
			if hasObjectPermissionTo(player, "command.modchat", false) then
				triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, name, true)
			else
				triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, name, false)
			end
		else
			-- Último intento: buscar por nombre en la base de datos
			local userInfo = exports.sql:query_assoc_single("SELECT userID, nombreUsuario FROM usuarios WHERE nombreUsuario LIKE '%" .. exports.sql:escape_string(otherPlayer) .. "%'")
			if userInfo then
				local sql = exports.sql:query_assoc("SELECT * FROM sanciones WHERE userID = "..userInfo.userID)
				if #sql > 0 then
					outputChatBox("Encontradas "..#sql.." sanciones para: "..userInfo.nombreUsuario, player, 0, 255, 0)
					
					if hasObjectPermissionTo(player, "command.modchat", false) then
						triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, userInfo.nombreUsuario, true)
					else
						triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, userInfo.nombreUsuario, false)
					end
					return
				end
			end
			outputChatBox("Jugador no encontrado. Intenta con un ID de usuario si el jugador no está conectado.", player, 255, 0, 0)
		end
	else
		outputChatBox("Sintaxis: /sanciones [jugador o ID]", player, 255, 255, 255)
	end
end
addCommandHandler("sanciones", GUIsancionesUsuario)

function aplicarSancion(nplayer, norma, textonorma, tiempoManual)
	if source and client and source == client and hasObjectPermissionTo(source, "command.modchat", false) and nplayer and norma and textonorma then
		if not exports.players:getOption(source, "staffduty") then
			outputChatBox("Debes estar de servicio (/staffduty) para aplicar sanciones.", source, 255, 0, 0)
			return
		end
		
		local player = getPlayerFromName(nplayer)
		local userID, playerName
		
		-- Obtener datos del jugador
		if player then
			userID = exports.players:getUserID(player)
			playerName = getPlayerName(player)
			
			-- Todas las sanciones serán tipo jail, excepto los puntos positivos (norma 18)
			local tipoSancion = (norma == 18) and 4 or 1
			local minutos = tiempoManual and tonumber(tiempoManual) or 0
			
			-- Aplicar la sanción en el juego si el jugador está conectado
			if tipoSancion == 4 then -- Punto positivo
				outputChatBox("Has dado un toque positivo correctamente.", source, 255, 0, 0)
			else -- Jail para todos los demás casos
				exports.jail:jailPlayer(source, player, minutos, tostring(textonorma))
				outputDebugString("Aplicando jail a " .. playerName .. " por " .. minutos .. " minutos")
			end
		else
			-- Buscar el userID por nombre si el jugador no está conectado
			local queryResult = exports.sql:query_assoc_single("SELECT userID, nombreUsuario FROM usuarios WHERE nombreUsuario LIKE '%" .. exports.sql:escape_string(nplayer) .. "%' LIMIT 1")
			
			if queryResult and queryResult.userID then
				userID = queryResult.userID
				playerName = queryResult.nombreUsuario
				outputChatBox("Jugador no conectado. La sanción se guardará en la base de datos.", source, 255, 165, 0)
			else
				-- Último intento: comprobar si es un ID
				if tonumber(nplayer) then
					local checkID = exports.sql:query_assoc_single("SELECT userID, nombreUsuario FROM usuarios WHERE userID = " .. tonumber(nplayer))
					if checkID and checkID.userID then
						userID = checkID.userID
						playerName = checkID.nombreUsuario or "ID: " .. userID
						outputChatBox("Aplicando sanción a usuario con ID: " .. userID, source, 255, 165, 0)
					else
						outputChatBox("No se encontró usuario con el ID: " .. nplayer, source, 255, 0, 0)
						return
					end
				else
					outputChatBox("No se encontró al jugador en la base de datos. No se puede aplicar la sanción.", source, 255, 0, 0)
					return
				end
			end
		end
		
		-- Guardar en la base de datos siempre (conectado o no)
		local userIDStaff = exports.players:getUserID(source)
		local minutos = tiempoManual and tonumber(tiempoManual) or 0
		
		-- Guardar en la base de datos usando la estructura original (sin campo tiempo)
		local sancionID = exports.sql:query_insertid("INSERT INTO sanciones (userID, staffID, regla, validez) VALUES (" .. table.concat({userID, userIDStaff, norma, 1}, ", ") .. ")")
		
		if not sancionID or sancionID <= 0 then
			outputChatBox("Error al guardar la sanción en la base de datos.", source, 255, 0, 0)
			outputDebugString("ERROR inserción sanción: userID=" .. tostring(userID) .. ", staffID=" .. tostring(userIDStaff) .. ", regla=" .. tostring(norma), 1)
			return
		end
		
		outputChatBox("Sanción ID #" .. sancionID .. " aplicada y guardada correctamente.", source, 0, 255, 0)
		
		-- Enviar log a Discord usando el sistema discord_webhooks
		local staffName = getPlayerName(source)
		
		local tipoTexto = (norma == 18) and "Positivo" or "Jail"
		
		local discordMessage = {
			title = "🔨 SANCIÓN APLICADA",
			description = 
				"> [ + ] Staff: **" .. staffName .. "**\n" ..
				"> [ + ] Sancionado: **" .. playerName .. "**\n" ..
				"> [ + ] UserID: **" .. tostring(userID) .. "**\n" ..
				"> [ + ] Motivo: **" .. textonorma .. "**\n" ..
				"> [ + ] Tiempo: **" .. minutos .. " minutos**\n" ..
				"> [ + ] Tipo: **" .. tipoTexto .. "**\n" ..
				"> [ + ] ID Sanción: **" .. tostring(sancionID) .. "**\n" ..
				"> [ + ] Conectado: **" .. (player and "Sí" or "No") .. "**",
			color = 15158332, -- Rojo
			footer = {
				text = "Sistema de sanciones",
				icon_url = "https://imgur.com/n3378F1"
			},
			timestamp = "now"
		}
		
		-- Usar el sistema discord_webhooks
		exports.discord_webhooks:sendToURL(
			"https://discord.com/api/webhooks/1407619136053448735/Evh23keHH_dIwJZYQP5QpTrvGEQtdUaAUDAMyLKAw7_XSxGewekJMG66eJBNGkWM57WT",
			discordMessage
		)
	end
end
addEvent("onAplicarSancionAUsuario", true)
addEventHandler("onAplicarSancionAUsuario", getRootElement(), aplicarSancion)

function removerSancion(target, idsancion)
	if source and client and source == client and hasObjectPermissionTo(source, "command.modchat", false) and target and idsancion then
		if not exports.players:getOption(source, "staffduty") then
			outputChatBox("Debes estar de servicio (/staffduty) para remover sanciones.", source, 255, 0, 0)
			return
		end
		
		-- Limpiar el ID de sanción (eliminar texto "Anulada" si existe)
		idsancion = string.gsub(idsancion, "%s*%(Anulada%)", "")
		
		local sql = exports.sql:query_assoc_single("SELECT * FROM sanciones WHERE sancionID = "..idsancion)
		if not sql then
			outputChatBox("Esta sanción no existe o ya ha sido anulada.", source, 255, 0, 0)
			return
		end
		
		-- Obtener datos de la sanción y del jugador
		local userID = sql.userID
		local staffID = exports.players:getUserID(source)
		local staffIDSancionador = sql.staffID
		local playerName = target
		
		-- Verificar si el jugador está conectado
		local player = getPlayerFromName(target:gsub(" ", "_"))
		if player then
			playerName = getPlayerName(player)
		else
			-- Si no está conectado, buscar su nombre en la BD
			local userInfo = exports.sql:query_assoc_single("SELECT nombreUsuario FROM usuarios WHERE userID = "..userID)
			if userInfo and userInfo.nombreUsuario then
				playerName = userInfo.nombreUsuario
			end
		end
		
		-- MODIFICADO: Permitir que cualquier staff pueda anular sanciones
		-- Anular la sanción
		exports.sql:query_free("UPDATE sanciones SET validez = 0 WHERE sancionID = "..idsancion)
		outputChatBox("Has anulado correctamente la sanción ID #" .. idsancion, source, 0, 255, 0)
		
		-- Enviar log a Discord sobre la remoción de sanción
		local staffName = getPlayerName(source)
		
		local discordMessage = {
			title = "🔓 SANCIÓN REMOVIDA",
			description = 
				"> [ + ] Staff: **" .. staffName .. "**\n" ..
				"> [ + ] Jugador: **" .. playerName .. "**\n" ..
				"> [ + ] UserID: **" .. tostring(userID) .. "**\n" ..
				"> [ + ] ID Sanción: **" .. tostring(idsancion) .. "**\n" ..
				"> [ + ] Motivo original: **" .. (sanciones[sql.regla] or "Desconocido") .. "**\n" ..
				"> [ + ] Staff original: **" .. tostring(staffIDSancionador) .. "**",
			color = 5763719, -- Verde
			footer = {
				text = "Sistema de sanciones",
				icon_url = "https://imgur.com/n3378F1"
			},
			timestamp = "now"
		}
		
		-- Usar el sistema discord_webhooks
		exports.discord_webhooks:sendToURL(
			"https://discord.com/api/webhooks/1407619136053448735/Evh23keHH_dIwJZYQP5QpTrvGEQtdUaAUDAMyLKAw7_XSxGewekJMG66eJBNGkWM57WT",
			discordMessage
		)
		
		-- Si el jugador está en jail, indicar que debe usar el ID en vez del nombre
		local result = exports.sql:query_assoc("SELECT * FROM sanciones WHERE sancionID = " .. idsancion .. " AND enJail = '1'")
		
		if result and #result > 0 then
			outputChatBox("El jugador sigue en jail. Usa /unjail " .. idsancion .. " para sacarlo.", source, 255, 0, 0)
		end
	end
end
addEvent("onRemoverSancionAUsuario", true)
addEventHandler("onRemoverSancionAUsuario", getRootElement(), removerSancion)

-- Función para liberar a un jugador del jail
function unJailPlayer(idONombre)
	if not idONombre then return false end
	
	-- Verificar si el staff está en servicio
	if source and hasObjectPermissionTo(source, "command.modchat", false) and not exports.players:getOption(source, "staffduty") then
		outputChatBox("Debes estar de servicio (/staffduty) para liberar jugadores.", source, 255, 0, 0)
		return false
	end
	
	local player
	local idSancion = tonumber(idONombre)
	
	if idSancion then
		-- Si es un número, intentar buscar la sanción por ID
		local result = exports.sql:query_assoc("SELECT userID, sancionID FROM sanciones WHERE sancionID = " .. idSancion .. " AND enJail = '1'")
		
		if result and #result > 0 then
			local userID = result[1].userID
			local sancionID = result[1].sancionID
			-- Buscar si el jugador está online por userID
			for _, plr in ipairs(getElementsByType("player")) do
				if exports.players:getUserID(plr) == userID then
					player = plr
					break
				end
			end
			
			if player then
				local realName = getPlayerName(player)
				
				-- Verificar si el jugador está en jail
				if getElementData(player, "tjail") and tonumber(getElementData(player, "tjail")) > 0 then
					-- Intentar liberarlo
					if exports.jail:unjailPlayer(player) then
						if source then -- Si se llamó desde un comando
							outputChatBox("Has liberado a " .. realName .. " de la cárcel (Sanción #" .. sancionID .. ").", source, 0, 255, 0)
							outputChatBox("Has sido liberado de la cárcel por " .. getPlayerName(source) .. ".", player, 0, 255, 0)
							
							-- Actualizar el estado en la base de datos
							exports.sql:query_free("UPDATE sanciones SET enJail = '0' WHERE sancionID = " .. sancionID)
							
							-- Enviar log a Discord
							local staffName = getPlayerName(source)
							
							local discordMessage = {
								title = "🔓 JUGADOR LIBERADO DE JAIL",
								description = 
									"> [ + ] Staff: **" .. staffName .. "**\n" ..
									"> [ + ] Jugador: **" .. realName .. "**\n" ..
									"> [ + ] UserID: **" .. exports.players:getUserID(player) .. "**\n" ..
									"> [ + ] ID Sanción: **" .. sancionID .. "**\n" ..
									"> [ + ] Acción: **Liberación manual de jail**",
								color = 5763719, -- Verde
								footer = {
									text = "Sistema de sanciones",
									icon_url = "https://imgur.com/n3378F1"
								},
								timestamp = "now"
							}
							
							-- Usar el sistema discord_webhooks
							exports.discord_webhooks:sendToURL(
								"https://discord.com/api/webhooks/1407619136053448735/Evh23keHH_dIwJZYQP5QpTrvGEQtdUaAUDAMyLKAw7_XSxGewekJMG66eJBNGkWM57WT",
								discordMessage
							)
						end
						
						return true
					else
						if source then
							outputChatBox("Error al liberar al jugador con sanción #" .. sancionID .. ". Verifica el sistema de jail.", source, 255, 0, 0)
						end
					end
				else
					if source then
						outputChatBox("El jugador con sanción #" .. sancionID .. " no está en la cárcel.", source, 255, 165, 0)
					end
				end
			else
				if source then
					outputChatBox("El jugador con sanción #" .. sancionID .. " no está conectado. Debe estar online para liberarlo.", source, 255, 0, 0)
				end
			end
		else
			if source then
				outputChatBox("No se encontró una sanción activa con ID #" .. idSancion .. " o el jugador no está en jail.", source, 255, 0, 0)
			end
		end
	else
		-- Si no es un número, intentar por nombre (mantener compatibilidad)
		-- Intentar obtener el jugador por nombre exacto o parcial
		if getPlayerFromName(idONombre) then
			player = getPlayerFromName(idONombre)
		elseif getPlayerFromName(idONombre:gsub(" ", "_")) then
			player = getPlayerFromName(idONombre:gsub(" ", "_"))
		else
			-- Buscar entre todos los jugadores por nombre parcial
			for _, plr in ipairs(getElementsByType("player")) do
				local name = getPlayerName(plr)
				if string.find(string.lower(name), string.lower(idONombre)) then
					player = plr
					break
				end
			end
		end
		
		if player then
			local realName = getPlayerName(player)
			local userID = exports.players:getUserID(player)
			
			-- Buscar si el jugador tiene una sanción activa
			local result = exports.sql:query_assoc("SELECT sancionID FROM sanciones WHERE userID = " .. userID .. " AND enJail = '1' ORDER BY sancionID DESC LIMIT 1")
			local sancionID = result and result[1] and result[1].sancionID or "Desconocido"
			
			-- Verificar si el jugador está en jail
			if getElementData(player, "tjail") and tonumber(getElementData(player, "tjail")) > 0 then
				-- Intentar liberarlo
				if exports.jail:unjailPlayer(player) then
					if source then -- Si se llamó desde un comando
						outputChatBox("Has liberado a " .. realName .. " de la cárcel (Sanción #" .. sancionID .. ").", source, 0, 255, 0)
						outputChatBox("Has sido liberado de la cárcel por " .. getPlayerName(source) .. ".", player, 0, 255, 0)
						
						-- Actualizar el estado en la base de datos si tenemos ID
						if sancionID ~= "Desconocido" then
							exports.sql:query_free("UPDATE sanciones SET enJail = '0' WHERE sancionID = " .. sancionID)
						end
						
						-- Enviar log a Discord
						local staffName = getPlayerName(source)
						
						local discordMessage = {
							title = "🔓 JUGADOR LIBERADO DE JAIL",
							description = 
								"> [ + ] Staff: **" .. staffName .. "**\n" ..
								"> [ + ] Jugador: **" .. realName .. "**\n" ..
								"> [ + ] UserID: **" .. userID .. "**\n" ..
								"> [ + ] ID Sanción: **" .. sancionID .. "**\n" ..
								"> [ + ] Acción: **Liberación manual de jail**",
							color = 5763719, -- Verde
							footer = {
								text = "Sistema de sanciones",
								icon_url = "https://imgur.com/n3378F1"
							},
							timestamp = "now"
						}
						
						-- Usar el sistema discord_webhooks
						exports.discord_webhooks:sendToURL(
							"https://discord.com/api/webhooks/1407619136053448735/Evh23keHH_dIwJZYQP5QpTrvGEQtdUaAUDAMyLKAw7_XSxGewekJMG66eJBNGkWM57WT",
							discordMessage
						)
					end
					
					return true
				else
					if source then
						outputChatBox("Error al liberar a " .. realName .. ". Verifica el sistema de jail.", source, 255, 0, 0)
					end
				end
			else
				if source then
					outputChatBox("El jugador " .. realName .. " no está en la cárcel.", source, 255, 165, 0)
				end
			end
		else
			if source then
				outputChatBox("No se encontró al jugador '" .. idONombre .. "'. Debe estar conectado para liberarlo.", source, 255, 0, 0)
			end
		end
	end
	
	return false
end
addEvent("onUnJailPlayer", true)
addEventHandler("onUnJailPlayer", getRootElement(), unJailPlayer)

-- Comando adicional para liberar jugadores de jail
--function commandUnJail(player, command, idONombre)
--	if hasObjectPermissionTo(player, "command.modchat", false) then
--		if not idONombre then
--			outputChatBox("Uso: /" .. command .. " [ID de Sanción/Nombre del jugador]", player, 255, 194, 14)
--		else
--			if not unJailPlayer(idONombre) then
--				outputChatBox("No se pudo liberar al jugador. Asegúrate de que esté en línea y en la cárcel.", player, 255, 0, 0)
--			end
--		end
--	end
--end
--addCommandHandler("unjail", commandUnJail)
--addCommandHandler("liberar", commandUnJail)