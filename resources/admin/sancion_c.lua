local nUsuario = ""
local nUsuario2 = ""
local x, y = guiGetScreenSize()

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

function GUISancionar(nombrep)
	if nombrep then
		triggerEvent("onCursor", getLocalPlayer())
		nUsuario = nombrep
        vSancion = guiCreateWindow(x*535/1366, y*252/768, x*274/1366, y*400/768, "Sancionar Usuario", false)
        guiWindowSetSizable(vSancion, false)
        lUsuarioSancionado = guiCreateLabel(24*x/1366, 30*y/768, 222*x/1366, 18*y/768, "Usuario: "..tostring(nombrep), false, vSancion)
        guiLabelSetHorizontalAlign(lUsuarioSancionado, "center", true)
        cboxSanciones = guiCreateComboBox(34*x/1366, 64*y/768, 204*x/1366, 200*y/768, "", false, vSancion)

        -- Agregar todas las sanciones al ComboBox
        for i = 1, #sanciones do
            guiComboBoxAddItem(cboxSanciones, sanciones[i])
        end
        
        -- Añadir campo para tiempo manual
        lTiempoManual = guiCreateLabel(34*x/1366, 270*y/768, 204*x/1366, 20*y/768, "Tiempo en minutos:", false, vSancion)
        eTiempoManual = guiCreateEdit(34*x/1366, 290*y/768, 204*x/1366, 30*y/768, "", false, vSancion)

        bCerrarSancionar = guiCreateButton(23*x/1366, 340*y/768, 99*x/1366, 42*y/768, "Cerrar", false, vSancion)
        bAplicarSancion = guiCreateButton(149*x/1366, 340*y/768, 99*x/1366, 42*y/768, "Sancionar", false, vSancion)
		addEventHandler("onClientGUIClick", bCerrarSancionar, regularSancionarGUI)
		addEventHandler("onClientGUIClick", bAplicarSancion, regularSancionarGUI)
	end
end
addEvent("onAbrirGUISancionar", true)
addEventHandler("onAbrirGUISancionar", getRootElement(), GUISancionar)

function regularSancionarGUI()
	if source == bCerrarSancionar then
		destroyElement(vSancion)
		triggerEvent("offCursor", getLocalPlayer())
	elseif source == bAplicarSancion then
		local norma = guiComboBoxGetSelected(cboxSanciones)
		if norma == -1 then
			outputChatBox("¡Selecciona una norma primero!", 255, 0, 0)
		else
			local textonorma = tostring(guiComboBoxGetItemText(cboxSanciones, norma))
			local tiempoManual = guiGetText(eTiempoManual)
			
			-- Verificación más estricta del tiempo
			if tiempoManual == "" then
				outputChatBox("¡Debes introducir un tiempo válido en minutos!", 255, 0, 0)
				return
			end
			
			-- Asegurar que es un número entero positivo
			local tiempoNum = tonumber(tiempoManual)
			if not tiempoNum or tiempoNum <= 0 or math.floor(tiempoNum) ~= tiempoNum then
				outputChatBox("¡El tiempo debe ser un número entero positivo!", 255, 0, 0)
				return
			end
			
			-- Debug para verificar el tiempo enviado
			outputDebugString("Enviando sanción: Norma=" .. (norma+1) .. ", Tiempo=" .. tiempoNum .. " minutos")
			
			triggerServerEvent("onAplicarSancionAUsuario", getLocalPlayer(), nUsuario, norma+1, textonorma, tiempoNum)
			destroyElement(vSancion)
			triggerEvent("offCursor", getLocalPlayer())
		end
	end
end

function GUIVerSanciones(datos, nombreu, staff)
	nUsuario2 = nombreu
	
	-- Debug de cantidad de sanciones
	outputDebugString("GUIVerSanciones: Recibidos " .. #datos .. " registros para " .. nombreu)
	outputChatBox("Mostrando " .. #datos .. " sanciones para: " .. nombreu, 0, 255, 0)
	
	vVerSanciones = guiCreateWindow(325*x/1366, 181*y/768, 692*x/1366, 413*y/768, "Sanciones de "..tostring(nombreu), false)
	guiWindowSetSizable(vVerSanciones, false)
	triggerEvent("onCursor", getLocalPlayer())
	gridVerSanciones = guiCreateGridList(46*x/1366, 49*y/768, 599*x/1366, 306*y/768, false, vVerSanciones)
	guiGridListAddColumn(gridVerSanciones, "ID", 0.1)
	guiGridListAddColumn(gridVerSanciones, "Regla", 0.35)
	guiGridListAddColumn(gridVerSanciones, "Fecha", 0.25)
	guiGridListAddColumn(gridVerSanciones, "Staff", 0.15)
	guiGridListAddColumn(gridVerSanciones, "Estado", 0.15)
	
	-- Debug de las sanciones recibidas
	for k, v in ipairs(datos) do
		outputDebugString("Sanción: ID=" .. tostring(v.sancionID) .. ", Regla=" .. tostring(v.regla) .. ", Validez=" .. tostring(v.validez))
		
		local r = guiGridListAddRow(gridVerSanciones)
		
		-- ID Sanción
		guiGridListSetItemText(gridVerSanciones, r, 1, tostring(v.sancionID), false, false)
		
		-- Regla (obtener del array sanciones o mostrar directamente el número)
		if v.regla and sanciones[v.regla] then
			guiGridListSetItemText(gridVerSanciones, r, 2, tostring(sanciones[v.regla]), false, false)
		elseif v.regla then
			guiGridListSetItemText(gridVerSanciones, r, 2, "Regla #" .. tostring(v.regla), false, false)
		else
			guiGridListSetItemText(gridVerSanciones, r, 2, "Desconocido", false, false)
		end
		
		-- Fecha (formatear adecuadamente)
		if v.fecha then
			guiGridListSetItemText(gridVerSanciones, r, 3, tostring(v.fecha), false, false)
		else
			guiGridListSetItemText(gridVerSanciones, r, 3, "N/A", false, false)
		end
		
		-- Staff ID
		if v.staffID then
			guiGridListSetItemText(gridVerSanciones, r, 4, tostring(v.staffID), false, false)
		else
			guiGridListSetItemText(gridVerSanciones, r, 4, "N/A", false, false)
		end
		
		-- Estado
		if v.validez == 1 then
			if v.regla == 18 then
				guiGridListSetItemText(gridVerSanciones, r, 5, "Positivo", false, false)
				
				-- Colorear en azul las sanciones positivas
				for col = 1, 5 do
					guiGridListSetItemColor(gridVerSanciones, r, col, 66, 137, 244)
				end
			else
				guiGridListSetItemText(gridVerSanciones, r, 5, "Activa", false, false)
				
				-- Colorear en verde las sanciones activas
				for col = 1, 5 do
					guiGridListSetItemColor(gridVerSanciones, r, col, 0, 255, 0)
				end
			end
		else
			guiGridListSetItemText(gridVerSanciones, r, 5, "Anulada", false, false)
			
			-- Colorear en rojo las sanciones anuladas
			for col = 1, 5 do
				guiGridListSetItemColor(gridVerSanciones, r, col, 255, 0, 0)
			end
		end
	end
	
	bCerrarvVerSanciones = guiCreateButton(48*x/1366, 367*y/768, 111*x/1366, 36*y/768, "Cerrar ventana", false, vVerSanciones)
	addEventHandler("onClientGUIClick", bCerrarvVerSanciones, regularVerSancionesGUI)
	if staff == true then
		bAnularSancion = guiCreateButton(169*x/1366, 367*y/768, 180*x/1366, 36*y/768, "Anular sanción", false, vVerSanciones)
		addEventHandler("onClientGUIClick", bAnularSancion, regularVerSancionesGUI)
	end
end
addEvent("onAbrirGUIVerSanciones", true)
addEventHandler("onAbrirGUIVerSanciones", getRootElement(), GUIVerSanciones)

function regularVerSancionesGUI()
	if source == bCerrarvVerSanciones then
		destroyElement(vVerSanciones)
		triggerEvent("offCursor", getLocalPlayer())
	elseif source == bAnularSancion then
		local row = guiGridListGetSelectedItem(gridVerSanciones)
		if row > -1 then
			local sancionID = guiGridListGetItemText(gridVerSanciones, row, 1)
			
			-- Limpiar ID si tiene texto adicional
			sancionID = string.gsub(sancionID, " %(Anulada%)", "")
			
			outputChatBox("Anulando sanción ID: " .. sancionID, 255, 165, 0)
			triggerServerEvent("onRemoverSancionAUsuario", getLocalPlayer(), nUsuario2, sancionID)
			outputChatBox("[Discord] #" .. sancionID .. " - La sanción ha sido anulada", 255, 255, 0)
			destroyElement(vVerSanciones)
			triggerEvent("offCursor", getLocalPlayer())
		else
			outputChatBox("¡Selecciona primero la sanción a anular!", 255, 0, 0)
		end
	end
end

function addLogMessage(type, message)
	local type = string.lower(type)
	local r = getRealTime( )
	local fecha = "[" .. ("%04d-%02d-%02d %02d:%02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute, r.second) .. "] "
	if fileExists ( type..".txt" ) then
		local file = fileOpen(type..".txt")
		local size = fileGetSize(file)
		fileSetPos (file, size)
		fileWrite(file, fecha..message.."\n")
		fileClose(file)
	else
		local file = fileCreate(type..".txt")
		fileWrite(file, fecha..message.."\n")
		fileClose(file)
	end
end

function aplicarSancion(nplayer, norma, textonorma, tiempoManual)
    if source and client and source == client and hasObjectPermissionTo(source, "command.modchat", false) and nplayer and norma and textonorma and tiempoManual then
        -- El manejo real de la sanción se hace en el servidor ahora
        -- Simplemente pasamos los parámetros al servidor
        triggerServerEvent("onAplicarSancionAUsuario", getLocalPlayer(), nplayer, norma, textonorma, tiempoManual)
    end
end
addEvent("onAplicarSancionAUsuario", true)
addEventHandler("onAplicarSancionAUsuario", getRootElement(), aplicarSancion)