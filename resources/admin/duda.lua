dudauto = {
	{pregunta = "discord", respuesta = "el link de nuestro discord es https://discord.gg/uZhyaPAezt"},
	{pregunta = "login", respuesta = "Intenta iniciar sesión ahora, sino reconecta"},
	{pregunta = "sesion", respuesta = "Intenta iniciar sesión ahora, sino reconecta"},
	{pregunta = "inventario", respuesta = "Prueba ahora, se ha aplicado un arreglo"},
	{pregunta = "items", respuesta = "Prueba ahora, se ha aplicado un arreglo"},
	{pregunta = "volcado", respuesta = "Al bajar del vehículo se desvuelca automáticamente"},
	{pregunta = "volque", respuesta = "Al bajar del vehículo se desvuelca automáticamente"},
}

-- URL del webhook de Discord para logs de dudas
local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/1407616407411363910/dYr4y6M3oijJH9puI1eYAA13Nzez8b8f2mV1raotHrK_lpbkzdX-5Bk0JeDgWtjqNBiB"

-- Función para enviar logs al Discord
local function enviarLogDiscord(titulo, descripcion, color)
    local discordMessage = {
        title = titulo,
        description = descripcion,
        color = color, -- Verde: 5763719, Amarillo: 16776960, Rojo: 15158332, Azul: 3447003
        footer = {
            text = "Sistema de Dudas",
            icon_url = "https://imgur.com/n3378F1"
        },
        timestamp = "now"
    }

    exports.discord_webhooks:sendToURL(DISCORD_WEBHOOK_URL, discordMessage)
end

-- Nota: Se ha eliminado la función de limpieza automática de dudas para permitir
-- la generación de informes diarios antes de eliminar las dudas

local function getStaff( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.modchat", false ) then
			if not duty or exports.players:getOption( value, "staffduty" ) or exports.players:getOption( value, "helpduty" ) or getElementData(value, "pm") == true then
				t[ #t + 1 ] = value
			end
		end
	end
	return t
end

local function staffMessage( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 204, 255,true)
	end
end

local function getAdmins( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.adminchat", false ) then
			if not duty or exports.players:getOption( value, "staffduty" ) or getElementData(value, "pm") == true then
				t[ #t + 1 ] = value
			end
		end
	end
	return t
end

local function adminMessage( message )
	for key, value in ipairs( getAdmins( true ) ) do
		outputChatBox( message, value, 255, 204, 255,true )
	end
end

function reportarUsuario (player, cmd, otherPlayer, ...)
	local razon = table.concat( { ... }, " " )
	local other, name = exports.players:getFromName(player, otherPlayer, true)
	if not other or not razon then outputChatBox("Sintaxis: /"..tostring(cmd).. " [jugador]", player, 255, 255, 255) return end
	outputChatBox("El sistema de reportes IG está obsoleto. Saca fotos al F12 y acude al foro.", player, 255, 0, 0)
end
addCommandHandler("report", reportarUsuario)
addCommandHandler("reportar", reportarUsuario)
	
function preguntarDuda (thePlayer, commandName, ...)
	if thePlayer and ... then
		if not exports.players:isLoggedIn(thePlayer) then showChat(thePlayer, true) end
		local razon = table.concat( { ... }, " " )
		if not getElementData(thePlayer, "laduda") then
			setElementData(thePlayer, "laduda", tostring(razon))
			-- Procedemos a abrir la duda en SQL
			if not razon or not (...) then return outputChatBox("[DUDA] Error. No has puesto tu duda. Tienes que poner /duda [duda que tengas].", thePlayer, 255, 0, 0) end
			local dudaID = exports.sql:query_insertid("INSERT INTO `dudas` (`dudaID`, `userIDStaff`, `userIDUsuario`, `charIDUsuario`, `dudaPregunta`, `dudaRespuesta`, `valoracion`, `codigoIncidencia`, `fechaCreacion`) VALUES (NULL, '-1', '"..exports.players:getUserID(thePlayer).."', '"..exports.players:getCharacterID(thePlayer).."', '"..tostring(razon).."', 'Sin Respuesta', '-1', '-1', NOW())")
			setElementData(thePlayer, "dudaID", tostring(dudaID))
			
			-- Log de Discord para nueva duda
            local descripcion = 
                "> [ + ] Jugador: **" .. getPlayerName(thePlayer):gsub("_", " ") .. "**\n" ..
                "> [ + ] ID: **" .. exports.players:getID(thePlayer) .. "**\n" ..
                "> [ + ] UserID: **" .. exports.players:getUserID(thePlayer) .. "**\n" ..
                "> [ + ] Duda: **" .. tostring(razon) .. "**\n" ..
                "> [ + ] ID Duda: **" .. tostring(dudaID) .. "**"
                
            enviarLogDiscord("Nueva Duda Creada", descripcion, 3447003) -- Azul
			
			-- Informar al jugador --
			outputChatBox("[DUDA] Has preguntado: " ..tostring(razon), thePlayer, 0, 255, 0)
			outputChatBox("[DUDA] Nº Duda: "..tostring(dudaID)..".", thePlayer, 0, 255, 0)
			outputChatBox("[DUDA] Espera a que un staff te responda. Puedes usar /aduda para anularla.", thePlayer, 0, 255, 0)
			for k, v in ipairs(dudauto) do
				if string.find(string.lower(razon), tostring(v.pregunta)) then
					outputChatBox("[DUDA] Respuesta: " ..tostring(v.respuesta)..".", thePlayer, 0, 255, 0)
					outputChatBox("[DUDA] Staff que te atendió: Sistema Automático de Resolución de Dudas.", thePlayer, 0, 255, 0)
					if tostring(v.respuesta) == "Intenta iniciar sesión ahora, sino reconecta" or tostring(v.respuesta) == "Prueba ahora, se ha aplicado un arreglo" then
						executeCommandHandler("dgui", thePlayer)
					end
					removeElementData(thePlayer, "laduda")
					exports.sql:query_free("UPDATE `dudas` SET `userIDStaff` = '-2',`dudaRespuesta` = '"..tostring(v.respuesta).."' WHERE `dudaID` = "..tostring(dudaID))
					
					-- Log de Discord para duda resuelta automáticamente
                    local descripcionAuto = 
                        "> [ + ] Jugador: **" .. getPlayerName(thePlayer):gsub("_", " ") .. "**\n" ..
                        "> [ + ] ID: **" .. exports.players:getID(thePlayer) .. "**\n" ..
                        "> [ + ] UserID: **" .. exports.players:getUserID(thePlayer) .. "**\n" ..
                        "> [ + ] Duda: **" .. tostring(razon) .. "**\n" ..
                        "> [ + ] Respuesta: **" .. tostring(v.respuesta) .. "**\n" ..
                        "> [ + ] Resuelto por: Sistema Automático"
                        
                    enviarLogDiscord("Duda Resuelta Automáticamente", descripcionAuto, 5763719) -- Verde
				return
				end
			end
			-- Informar al staff disponible y de servicio --
			staffMessage( "[DUDA] El jugador [" .. exports.players:getID( thePlayer ) .. "] "  .. getPlayerName( thePlayer ):gsub( "_", " " ) .. " tiene una duda. Pon /resolverduda o /rd ".. exports.players:getID( thePlayer ) .." [respuesta] " )
			staffMessage( "[DUDA] ID [" .. exports.players:getID( thePlayer ) .. "] pregunta: ".. razon )
			if hasObjectPermissionTo(thePlayer, 'command.vip', false) and not getElementData(thePlayer, "enc") then -- Es VIP
				staffMessage("[DUDA] ATENCIÓN: USUARIO VIP.")
			end
		else
			outputChatBox("[DUDA] Tienes una duda pendiente. Espera a que sea resuelta para volver a preguntar", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("[DUDA] Error. No has puesto tu duda. Tienes que poner /duda [duda que tengas].", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("duda", preguntarDuda)

function resolverDuda(thePlayer, commandName, otherPlayer, ...)
	if hasObjectPermissionTo( thePlayer, "command.acceptreport", false ) then
		if not exports.players:getOption(thePlayer, "staffduty") then
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", thePlayer, 255, 0, 0)
		end
		
		local other, name = exports.players:getFromName(thePlayer, otherPlayer, true)
		if ... and other then
			local respuesta = table.concat( { ... }, " " )
			if getElementData(other, "laduda") then
				-- Informar al usuario --
				outputChatBox("[DUDA] Respuesta: " ..respuesta, other, 0, 255, 0)
				if getElementData(thePlayer, "enc") == true then
					outputChatBox("[DUDA] Staff que te atendió: Desconocido. Usa /valorar [nota del 1 al 10] para ayudarnos a mejorar.", other, 0, 255, 0)
				else
					outputChatBox("[DUDA] Staff que te atendió: "..getPlayerName(thePlayer):gsub("_", " ")..". Usa /valorar [nota del 1 al 10] para ayudarnos a mejorar.", other, 0, 255, 0)
				end
				removeElementData(other, "laduda")
				-- Informar al staff que responde --
				outputChatBox("[DUDA] Has respondido la duda de: " ..name..".", thePlayer, 0, 255, 0)
				outputChatBox("[DUDA] Respuesta dada: " ..respuesta, thePlayer, 0, 255, 0)
				-- Informar a todo el staff duty --
				if getElementData(thePlayer, "enc") == true then
					outputChatBox("[DUDA] Protección al staff Encubierto activa.", thePlayer, 0, 255, 0)
					--staffMessage("[DUDA] Un staff desde el servicio web ha resuelto la duda de [" .. exports.players:getID( other ) .. "] "  .. name .. ".")
					--adminMessage("[DUDA_ADMIN] Respuesta dada: " .. respuesta)
				else
					staffMessage("[DUDA] El staff "..getPlayerName(thePlayer):gsub("_", " ").." ha resuelto la duda de [" .. exports.players:getID( other ) .. "] "  .. name .. ".")
					adminMessage("[DUDA_ADMIN] Respuesta dada: " .. respuesta)
				end
				-- Sistema AntiAbsusos de Dudas
				if other == thePlayer then
					banPlayer(thePlayer, true, true, true, "AntiAbuso DTRP", "Seteo de Dudas Resueltas", 0)
				end
				local dudaID = getElementData(other, "dudaID")
				exports.sql:query_free("UPDATE `dudas` SET `userIDStaff` = '"..exports.players:getUserID(thePlayer).."',`dudaRespuesta` = '"..tostring(respuesta).."' WHERE `dudaID` = "..tostring(dudaID))
				
				-- Log de Discord para duda resuelta por staff
                local staffName = getElementData(thePlayer, "enc") and "Staff Encubierto" or getPlayerName(thePlayer):gsub("_", " ")
                local descripcionResuelta = 
                    "> [ + ] Jugador: **" .. name .. "**\n" ..
                    "> [ + ] ID: **" .. exports.players:getID(other) .. "**\n" ..
                    "> [ + ] UserID: **" .. exports.players:getUserID(other) .. "**\n" ..
                    "> [ + ] Duda: **" .. tostring(getElementData(other, "laduda")) .. "**\n" ..
                    "> [ + ] Respuesta: **" .. tostring(respuesta) .. "**\n" ..
                    "> [ + ] Resuelto por: **" .. staffName .. "**"
                    
                enviarLogDiscord("Duda Resuelta por Staff", descripcionResuelta, 5763719) -- Verde
				
				setElementData(other, "valorarDuda", tostring(dudaID))
				removeElementData(other, "dudaID")
			else
				outputChatBox("[DUDA] El jugador seleccionado no tiene una duda pendiente. Se la habrá resuelto otro staff.", thePlayer, 0, 200, 0)
			end
		else
			outputChatBox("Síntaxis: /resolverduda [id] [respuesta]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("Acceso denegado", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("resolverduda", resolverDuda)
addCommandHandler("rd", resolverDuda)

function gestionDudas(source)
	if hasObjectPermissionTo( source, "command.acceptreport", false ) then
		if not exports.players:getOption(source, "staffduty") then
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", source, 255, 0, 0)
		end
		
		hd = false
		for key2, value2 in ipairs( getElementsByType("player") ) do
			if getElementData(value2, "laduda") then
				hd = true
				outputChatBox("[DUDA] [" .. exports.players:getID( value2 ) .. "] "  .. getPlayerName( value2 ):gsub( "_", " " ) .. " tiene una duda pendiente. Usa /gd " .. exports.players:getID( value2 ) .. " para saber qué pregunta.", source, 255, 204, 255)
			end
		end
		if hd == false then
			outputChatBox("[DUDA] No hay dudas pendientes.",source, 255, 204, 255)
		end
	else
		outputChatBox("(( Acceso Denegado ))", source, 255, 0, 0)
	end
end
addCommandHandler("dudas", gestionDudas)


function gestionarDuda (thePlayer, commandName, otherPlayer)
	if hasObjectPermissionTo( thePlayer, "command.acceptreport", false ) then
		if not exports.players:getOption(thePlayer, "staffduty") then
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", thePlayer, 255, 0, 0)
		end
		
		local other, name = exports.players:getFromName(thePlayer, otherPlayer, true)
		if other and thePlayer then
			if getElementData(other, "laduda") then
				outputChatBox("[DUDA] ID [" .. exports.players:getID( other ) .. "] pregunta: ".. tostring(getElementData(other, "laduda")), thePlayer, 255, 204, 255)
			else
				outputChatBox("[DUDA] Este jugador no tiene una duda pendiente.",thePlayer, 255, 204, 255)
			end
		end
	else
		outputChatBox("(( Acceso Denegado ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("gd", gestionarDuda)

function anularDuda (thePlayer)
	if thePlayer then
		if getElementData(thePlayer, "laduda") then
			local dudaID = getElementData(thePlayer, "dudaID")
			local dudaPregunta = getElementData(thePlayer, "laduda")
			
			removeElementData(thePlayer, "laduda")
			exports.sql:query_free("UPDATE `dudas` SET `userIDStaff` = '-3',`dudaRespuesta` = 'Duda anulada por el usuario.' WHERE `dudaID` = "..tostring(dudaID))
			
			-- Log de Discord para duda anulada
            local descripcionAnulada = 
                "> [ + ] Jugador: **" .. getPlayerName(thePlayer):gsub("_", " ") .. "**\n" ..
                "> [ + ] ID: **" .. exports.players:getID(thePlayer) .. "**\n" ..
                "> [ + ] UserID: **" .. exports.players:getUserID(thePlayer) .. "**\n" ..
                "> [ + ] Duda: **" .. tostring(dudaPregunta) .. "**\n" ..
                "> [ + ] ID Duda: **" .. tostring(dudaID) .. "**\n" ..
                "> [ + ] Razón: Anulada por el usuario"
                
            enviarLogDiscord("Duda Anulada", descripcionAnulada, 16776960) -- Amarillo
			
			staffMessage( "[DUDA] El jugador [" .. exports.players:getID( thePlayer ) .. "] "  .. getPlayerName( thePlayer ):gsub( "_", " " ) .. " ha anulado su duda." )
			outputChatBox("[DUDA] Has anulado tu duda correctamente. Puedes volver a utilizar el /duda.", thePlayer, 0, 255, 0)
			removeElementData(thePlayer, "dudaID")
		else
			outputChatBox("[DUDA] No tienes ninguna duda pendiente para anular.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("aduda", anularDuda)

function onDuty (thePlayer)
	if hasObjectPermissionTo( thePlayer, "command.acceptreport", false ) then
		if exports.players:getOption(thePlayer, "staffduty") == true or exports.players:getOption(thePlayer, "helpduty") == true then
		local nndudas = recuentoEmergencia()
		outputChatBox("Bienvenido, "..getPlayerName(thePlayer):gsub("_", " ")..". Actualmente hay:",thePlayer,0,255,0)
			if nndudas == 0 then
				outputChatBox("No hay ninguna duda sin resolver.",thePlayer,0,255,0)
			elseif nndudas == 1 then
				outputChatBox("- 1 duda sin resolver.",thePlayer,0,255,0)
			elseif nndudas >= 2 then
				outputChatBox("- "..tostring(nndudas).." dudas sin resolver.",thePlayer,0,255,0)
			end
		else
			outputChatBox("Hasta luego "..getPlayerName(thePlayer):gsub("_", " ")..". Recuerda usar /dudas de vez en cuando.",thePlayer,0,255,0)
		end	
	else return end
end
addEvent("onAvisarDudas", true)
addEventHandler("onAvisarDudas", getRootElement(), onDuty)


function recuentoEmergencia()
	recuento = 0
	for k, v in ipairs (getElementsByType("player")) do
		if getElementData(v, "laduda") then
			recuento = recuento + 1
		end
	end
	return tonumber(recuento)
end
addEventHandler("onResourceStart", getResourceRootElement(), recuentoEmergencia)
addEventHandler("onResourceRestart", getResourceRootElement(), recuentoEmergencia)

-- Función para crear una tabla de nombres de staff
function crearTablaNombresStaff()
    exports.sql:query_free([[
        CREATE TABLE IF NOT EXISTS staff_names (
            userID INT PRIMARY KEY,
            staffName VARCHAR(255),
            lastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
    
    -- Actualizar la tabla con los nombres de los staff conectados
    for _, player in ipairs(getElementsByType("player")) do
        if hasObjectPermissionTo(player, "command.acceptreport", false) then
            local userID = exports.players:getUserID(player)
            local staffName = getPlayerName(player):gsub("_", " ")
            
            exports.sql:query_free("REPLACE INTO staff_names (userID, staffName, lastUpdated) VALUES (" .. 
                userID .. ", '" .. staffName .. "', NOW())")
        end
    end
end

-- Ejecutar al iniciar el recurso
addEventHandler("onResourceStart", getResourceRootElement(), crearTablaNombresStaff)

-- Actualizar cuando un staff se conecta
addEventHandler("onPlayerLogin", root, function()
    if hasObjectPermissionTo(source, "command.acceptreport", false) then
        local userID = exports.players:getUserID(source)
        local staffName = getPlayerName(source):gsub("_", " ")
        
        exports.sql:query_free("REPLACE INTO staff_names (userID, staffName, lastUpdated) VALUES (" .. 
            userID .. ", '" .. staffName .. "', NOW())")
    end
end)

-- Función para obtener el nombre de un staff por su userID
local function obtenerNombreStaff(userID)
    -- Primero intentamos encontrar al jugador online
    for _, p in ipairs(getElementsByType("player")) do
        if exports.players:getUserID(p) == tonumber(userID) then
            return getPlayerName(p):gsub("_", " ")
        end
    end
    
    -- Si no está online, buscamos en la base de datos
    local resultado = exports.sql:query_assoc("SELECT characterName FROM characters WHERE userID = " .. userID .. " ORDER BY lastLogin DESC LIMIT 1")
    
    if resultado and #resultado > 0 and resultado[1].characterName then
        return resultado[1].characterName:gsub("_", " ")
    end
    
    -- Si no se encuentra, devolvemos el ID
    return "Staff ID: " .. userID
end

-- Función para calcular estadísticas detalladas de valoración de un staff
local function calcularEstadisticasValoracion(staffID, condicion)
    -- Total de dudas resueltas por el staff
    local totalDudas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. 
                condicion .. " AND userIDStaff = " .. staffID)
            
    -- Dudas con valoración (mayor a -1)
    local dudasValoradas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total, AVG(valoracion) AS promedio FROM dudas " .. 
                condicion .. " AND userIDStaff = " .. staffID .. " AND valoracion > -1")
            
    -- Dudas sin valoración (igual a -1)
    local dudasSinValorar = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. 
        condicion .. " AND userIDStaff = " .. staffID .. " AND valoracion = -1")
    
    -- Verificar que los resultados no sean nulos
    if not totalDudas then totalDudas = {total = 0} end
    if not dudasValoradas then dudasValoradas = {total = 0, promedio = 0} end
    if not dudasSinValorar then dudasSinValorar = {total = 0} end
    
    -- Asegurarse de que los valores no sean nulos
    totalDudas.total = totalDudas.total or 0
    dudasValoradas.total = dudasValoradas.total or 0
    dudasValoradas.promedio = dudasValoradas.promedio or 0
    dudasSinValorar.total = dudasSinValorar.total or 0
    
    -- Calcular promedio considerando las no valoradas como 0
    local promedioTotal = 0
    if totalDudas.total > 0 then
        local sumaValoraciones = 0
        if dudasValoradas.total > 0 then
            sumaValoraciones = dudasValoradas.promedio * dudasValoradas.total
        end
        promedioTotal = sumaValoraciones / totalDudas.total
    end
    
    -- Obtener desglose de valoraciones (cuántas de cada puntuación)
    local desglose = {}
    for i = 1, 10 do
        local cantidad = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. 
            condicion .. " AND userIDStaff = " .. staffID .. " AND valoracion = " .. i)
        desglose[i] = cantidad and cantidad.total or 0
    end
    
    return {
        total = totalDudas.total,
        valoradas = dudasValoradas.total,
        sinValorar = dudasSinValorar.total,
        promedioValoradas = dudasValoradas.promedio,
        promedioTotal = promedioTotal,
        desglose = desglose
    }
end

function consultarMisDudas (player)
	if player and hasObjectPermissionTo( player, "command.acceptreport", false ) then
		local userID = exports.players:getUserID(player)
		
		-- Consultas directas como en la versión anterior
		local sql1 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasResueltas FROM dudas WHERE userIDStaff = "..userID)
		local sql2 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasValoradas FROM dudas WHERE valoracion > -1 AND userIDStaff = "..userID)
		local sql3 = exports.sql:query_assoc_single("SELECT SUM(valoracion) AS puntosDudas FROM dudas WHERE valoracion > -1 AND userIDStaff = "..userID)
		
		-- Verificar que los resultados no sean nulos
		if not sql1 then sql1 = {dudasResueltas = 0} end
		if not sql2 then sql2 = {dudasValoradas = 0} end
		if not sql3 then sql3 = {puntosDudas = 0} end
		
		-- Asegurarse de que los valores no sean nulos
		sql1.dudasResueltas = sql1.dudasResueltas or 0
		sql2.dudasValoradas = sql2.dudasValoradas or 0
		sql3.puntosDudas = sql3.puntosDudas or 0
		
		-- Mostrar estadísticas personales
		outputChatBox("Has resuelto un total de "..tostring(sql1.dudasResueltas).." dudas, de las cuales te han valorado "..tostring(sql2.dudasValoradas)..".", player, 0, 255, 0)
		
		if tonumber(sql2.dudasValoradas) > 0 then
			local notaMedia = sql3.puntosDudas / sql2.dudasValoradas
			local porcentaje = math.floor((notaMedia / 10) * 100)
			outputChatBox("Nota media de las dudas resueltas: "..tostring(notaMedia).." ("..porcentaje.."%)", player, 0, 255, 0)
			
			-- Obtener desglose de valoraciones
			local desglose = {}
			local desgloseTexto = "Desglose de valoraciones: "
			local hayDesglose = false
			
			for i = 1, 10 do
				local cantidad = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas WHERE userIDStaff = "..userID.." AND valoracion = "..i)
				if cantidad and cantidad.total and cantidad.total > 0 then
					desgloseTexto = desgloseTexto .. i .. "★(" .. cantidad.total .. ") "
					hayDesglose = true
				end
			end
			
			if hayDesglose then
				outputChatBox(desgloseTexto, player, 0, 255, 0)
			end
		end
	end
	
	-- Estadísticas generales
	outputChatBox("~~Estadísticas Generales~~", player, 255, 255, 255)
	local sql4 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasTotales FROM dudas")
	local sql5 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasAnuladas FROM dudas WHERE userIDStaff = -3")
	local sql6 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasAuto FROM dudas WHERE userIDStaff = -2")
	local sql7 = exports.sql:query_assoc_single("SELECT SUM(valoracion) AS puntosDudasTotales FROM dudas WHERE valoracion > -1")
	local sql8 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasTotalesValoradas FROM dudas WHERE valoracion > -1")
	
	-- Verificar que los resultados no sean nulos
	if not sql4 then sql4 = {dudasTotales = 0} end
	if not sql5 then sql5 = {dudasAnuladas = 0} end
	if not sql6 then sql6 = {dudasAuto = 0} end
	if not sql7 then sql7 = {puntosDudasTotales = 0} end
	if not sql8 then sql8 = {dudasTotalesValoradas = 0} end
	
	-- Asegurarse de que los valores no sean nulos
	sql4.dudasTotales = sql4.dudasTotales or 0
	sql5.dudasAnuladas = sql5.dudasAnuladas or 0
	sql6.dudasAuto = sql6.dudasAuto or 0
	sql7.puntosDudasTotales = sql7.puntosDudasTotales or 0
	sql8.dudasTotalesValoradas = sql8.dudasTotalesValoradas or 0
	
	outputChatBox("Hay un total de "..tostring(sql4.dudasTotales).." dudas emitidas por usuarios.", player, 0, 255, 0)
	outputChatBox("Se han anulado "..tostring(sql5.dudasAnuladas).." dudas y el Sistema Automático ha resuelto "..tostring(sql6.dudasAuto).." dudas.", player, 0, 255, 0)
	
	-- Evitar división por cero
	if sql8.dudasTotalesValoradas > 0 and sql7.puntosDudasTotales and sql7.puntosDudasTotales > 0 then
		local valoracionGlobal = sql7.puntosDudasTotales / sql8.dudasTotalesValoradas
		local porcentajeGlobal = math.floor((valoracionGlobal / 10) * 100)
		outputChatBox("Valoración Global del Staff: "..valoracionGlobal.." ("..porcentajeGlobal.."%)", player, 255, 255, 255)
	else
		outputChatBox("Valoración Global del Staff: No hay valoraciones disponibles", player, 255, 255, 255)
	end
end
addCommandHandler("misdudas", consultarMisDudas)
addCommandHandler("edudas", consultarMisDudas)

function valorarStaff (player, cmd, nota)
	if player and nota and tonumber(nota) and tonumber(nota) >= 0 and tonumber(nota) <= 10 then
		local dudaID = getElementData(player, "valorarDuda")
		if dudaID then
			exports.sql:query_free("UPDATE `dudas` SET `valoracion` = '"..tostring(nota).."' WHERE `dudaID` = "..tostring(dudaID))
			
			-- Obtener información de la duda para el log
			local infoDuda = exports.sql:query_assoc_single("SELECT dudaPregunta, dudaRespuesta, userIDStaff FROM dudas WHERE dudaID = " .. dudaID)
			
			if infoDuda then
				-- Log de Discord para valoración
				local staffInfo = ""
				if tonumber(infoDuda.userIDStaff) == -2 then
					staffInfo = "Sistema Automático"
				else
					local staffPlayer = nil
					for _, p in ipairs(getElementsByType("player")) do
						if exports.players:getUserID(p) == tonumber(infoDuda.userIDStaff) then
							staffPlayer = p
							break
						end
					end
					
					if staffPlayer then
						staffInfo = getPlayerName(staffPlayer):gsub("_", " ")
					else
						staffInfo = "Staff ID: " .. infoDuda.userIDStaff
					end
				end
				
				local descripcionValoracion = 
					"> [ + ] Jugador: **" .. getPlayerName(player):gsub("_", " ") .. "**\n" ..
					"> [ + ] ID: **" .. exports.players:getID(player) .. "**\n" ..
					"> [ + ] UserID: **" .. exports.players:getUserID(player) .. "**\n" ..
					"> [ + ] Duda: **" .. tostring(infoDuda.dudaPregunta) .. "**\n" ..
					"> [ + ] Respuesta: **" .. tostring(infoDuda.dudaRespuesta) .. "**\n" ..
					"> [ + ] Staff: **" .. staffInfo .. "**\n" ..
					"> [ + ] Valoración: **" .. tostring(nota) .. "/10**"
					
				local colorValoracion = 15158332 -- Rojo por defecto (nota baja)
				if tonumber(nota) >= 7 then
					colorValoracion = 5763719 -- Verde (nota alta)
				elseif tonumber(nota) >= 5 then
					colorValoracion = 16776960 -- Amarillo (nota media)
				end
				
				enviarLogDiscord("Valoración de Duda", descripcionValoracion, colorValoracion)
			end
			
			outputChatBox("Has dado "..tostring(nota).." puntos al staff que te atendió. ¡Gracias por ayudarnos a mejorar!", player, 0, 255, 0)
			removeElementData(player, "valorarDuda")
		else
			outputChatBox("Se ha producido un error grave, notifica a un Desarrollador.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("valorar", valorarStaff)

-- Comando para eliminar dudas de un día específico
function eliminarDudasDia(player, cmd, fecha)
    if not hasObjectPermissionTo(player, "command.adminchat", false) then
        return outputChatBox("Acceso denegado", player, 255, 0, 0)
    end
    
    -- Si no se especifica fecha, usar la fecha actual
    fecha = fecha or os.date("%Y-%m-%d")
    
    -- Validar formato de fecha (YYYY-MM-DD)
    if not string.match(fecha, "^%d%d%d%d%-%d%d%-%d%d$") then
        return outputChatBox("Formato de fecha incorrecto. Usa: YYYY-MM-DD (ej: 2023-10-15)", player, 255, 0, 0)
    end
    
    -- Confirmar con el usuario
    outputChatBox("ATENCIÓN: Vas a eliminar TODAS las dudas del día " .. fecha, player, 255, 0, 0)
    outputChatBox("Para confirmar, usa: /confirmareliminar " .. fecha, player, 255, 0, 0)
    
    -- Guardar la fecha para confirmar
    setElementData(player, "confirmarEliminarDudas", fecha)
end
addCommandHandler("eliminardudas", eliminarDudasDia)
addCommandHandler("elimdudas", eliminarDudasDia)

-- Función para verificar la estructura de la tabla dudas
function verificarEstructuraTabla()
    -- Verificar si existe el campo fechaCreacion
    local resultado = exports.sql:query_assoc("SHOW COLUMNS FROM dudas LIKE 'fechaCreacion'")
    if not resultado or #resultado == 0 then
        -- El campo no existe, lo añadimos
        exports.sql:query_free("ALTER TABLE `dudas` ADD COLUMN `fechaCreacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP;")
        outputDebugString("[DUDAS] Campo fechaCreacion añadido a la tabla dudas")
        
        -- Actualizar registros existentes
        exports.sql:query_free("UPDATE dudas SET fechaCreacion = NOW() WHERE fechaCreacion IS NULL;")
    end
end

-- Ejecutar al iniciar el recurso
addEventHandler("onResourceStart", getResourceRootElement(), verificarEstructuraTabla)

-- Comando para ver estadísticas de dudas por período
function estadisticasDudas(player, cmd, periodo)
    if not hasObjectPermissionTo(player, "command.acceptreport", false) then
        return outputChatBox("Acceso denegado", player, 255, 0, 0)
    end
    
    periodo = periodo or "hoy"
    local condicion = ""
    
    if periodo == "hoy" then
        condicion = "WHERE DATE(fechaCreacion) = CURDATE()"
        outputChatBox("Estadísticas de dudas de HOY:", player, 255, 255, 255)
    elseif periodo == "semana" then
        condicion = "WHERE fechaCreacion >= DATE_SUB(NOW(), INTERVAL 7 DAY)"
        outputChatBox("Estadísticas de dudas de la ÚLTIMA SEMANA:", player, 255, 255, 255)
    elseif periodo == "mes" then
        condicion = "WHERE fechaCreacion >= DATE_SUB(NOW(), INTERVAL 30 DAY)"
        outputChatBox("Estadísticas de dudas del ÚLTIMO MES:", player, 255, 255, 255)
    else
        outputChatBox("Uso: /estadudas [hoy/semana/mes]", player, 255, 255, 255)
        return
    end
    
    local total = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion)
    local resueltas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff > 0")
    local auto = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -2")
    local anuladas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -3")
    local pendientes = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -1")
    
    -- Verificar que los resultados no sean nulos
    if not total then total = {total = 0} end
    if not resueltas then resueltas = {total = 0} end
    if not auto then auto = {total = 0} end
    if not anuladas then anuladas = {total = 0} end
    if not pendientes then pendientes = {total = 0} end
    
    -- Asegurarse de que los valores no sean nulos
    total.total = total.total or 0
    resueltas.total = resueltas.total or 0
    auto.total = auto.total or 0
    anuladas.total = anuladas.total or 0
    pendientes.total = pendientes.total or 0
    
    outputChatBox("Total de dudas: " .. total.total, player, 0, 255, 0)
    outputChatBox("Resueltas por staff: " .. resueltas.total, player, 0, 255, 0)
    outputChatBox("Resueltas automáticamente: " .. auto.total, player, 0, 255, 0)
    outputChatBox("Anuladas por usuarios: " .. anuladas.total, player, 0, 255, 0)
    outputChatBox("Pendientes: " .. pendientes.total, player, 0, 255, 0)
    
    -- Top staff
    local topStaff = exports.sql:query_assoc("SELECT userIDStaff, COUNT(dudaID) AS total FROM dudas " .. 
        condicion .. " AND userIDStaff > 0 GROUP BY userIDStaff ORDER BY total DESC LIMIT 3")
    
    if topStaff and #topStaff > 0 then
        outputChatBox("Top 3 Staff con más dudas resueltas:", player, 255, 255, 0)
        for i, staff in ipairs(topStaff) do
            local staffName = "Staff ID: " .. staff.userIDStaff
            for _, p in ipairs(getElementsByType("player")) do
                if exports.players:getUserID(p) == tonumber(staff.userIDStaff) then
                    staffName = getPlayerName(p):gsub("_", " ")
                    break
                end
            end
            outputChatBox(i .. ". " .. staffName .. " - " .. staff.total .. " dudas", player, 255, 255, 0)
        end
    end
end
addCommandHandler("estadudas", estadisticasDudas)
addCommandHandler("edudas", estadisticasDudas)

-- Comando para ver porcentajes de valoración de cada staff
function valoracionesStaff(player, cmd, periodo)
    if not hasObjectPermissionTo(player, "command.acceptreport", false) then
        return outputChatBox("Acceso denegado", player, 255, 0, 0)
    end
    
    periodo = periodo or "hoy"
    local condicion = ""
    local periodoTexto = ""
    
    if periodo == "hoy" then
        condicion = "WHERE DATE(fechaCreacion) = CURDATE()"
        periodoTexto = "HOY"
    elseif periodo == "semana" then
        condicion = "WHERE fechaCreacion >= DATE_SUB(NOW(), INTERVAL 7 DAY)"
        periodoTexto = "ÚLTIMA SEMANA"
    elseif periodo == "mes" then
        condicion = "WHERE fechaCreacion >= DATE_SUB(NOW(), INTERVAL 30 DAY)"
        periodoTexto = "ÚLTIMO MES"
    elseif periodo == "total" then
        condicion = ""
        periodoTexto = "TOTAL"
    else
        outputChatBox("Uso: /valoracionstaff [hoy/semana/mes/total]", player, 255, 255, 255)
        return
    end
    
    outputChatBox("Valoraciones de Staff (" .. periodoTexto .. "):", player, 255, 255, 255)
    
    -- Obtener todos los staff que han resuelto dudas en el período
    local staffs = exports.sql:query_assoc("SELECT DISTINCT userIDStaff FROM dudas " .. 
        condicion .. " AND userIDStaff > 0")
    
    if not staffs or #staffs == 0 then
        outputChatBox("No hay valoraciones de staff en este período.", player, 255, 204, 0)
        return
    end
    
    -- Preparar la descripción para el log de Discord
    local descripcionLog = "> **Valoraciones de Staff (" .. periodoTexto .. ")**\n\n"
    
    -- Para cada staff, calcular su porcentaje de valoración
    for _, staffData in ipairs(staffs) do
        local staffID = staffData.userIDStaff
        
        -- Obtener nombre del staff usando la nueva función
        local staffName = obtenerNombreStaff(staffID)
        
        -- Obtener estadísticas de valoración
        local stats = calcularEstadisticasValoracion(staffID, condicion)
        
        -- Calcular porcentajes (considerando que la valoración es de 0 a 10)
        local porcentajeValoradas = math.floor((stats.promedioValoradas / 10) * 100)
        local porcentajeTotal = math.floor((stats.promedioTotal / 10) * 100)
        
        -- Mostrar al jugador
        local color = {255, 0, 0} -- Rojo por defecto
        if porcentajeTotal >= 90 then
            color = {0, 255, 0} -- Verde para 90% o más
        elseif porcentajeTotal >= 70 then
            color = {255, 255, 0} -- Amarillo para 70-89%
        end
        
        outputChatBox(staffName .. " - Total dudas: " .. stats.total, player, 255, 255, 255)
        outputChatBox("  Valoradas: " .. stats.valoradas .. " | Sin valorar: " .. stats.sinValorar, player, 255, 255, 255)
        outputChatBox("  Promedio (solo valoradas): " .. porcentajeValoradas .. "%", player, 255, 255, 255)
        outputChatBox("  Promedio (todas, sin valorar = 0): " .. porcentajeTotal .. "%", player, color[1], color[2], color[3])
        
        -- Mostrar desglose de valoraciones
        local desgloseTexto = "  Desglose: "
        for i = 1, 10 do
            if stats.desglose[i] > 0 then
                desgloseTexto = desgloseTexto .. i .. "★(" .. stats.desglose[i] .. ") "
            end
        end
        outputChatBox(desgloseTexto, player, 255, 255, 255)
        
        -- Añadir a la descripción del log
        descripcionLog = descripcionLog .. "> [ + ] **" .. staffName .. "**:\n" ..
            ">   - Total dudas: **" .. stats.total .. "**\n" ..
            ">   - Valoradas: **" .. stats.valoradas .. "** | Sin valorar: **" .. stats.sinValorar .. "**\n" ..
            ">   - Promedio (solo valoradas): **" .. porcentajeValoradas .. "%**\n" ..
            ">   - Promedio (todas, sin valorar = 0): **" .. porcentajeTotal .. "%**\n" ..
            ">   - Desglose: "
            
        for i = 1, 10 do
            if stats.desglose[i] > 0 then
                descripcionLog = descripcionLog .. "**" .. i .. "★(" .. stats.desglose[i] .. ")** "
            end
        end
        
        descripcionLog = descripcionLog .. "\n\n"
    end
    
    -- Enviar log a Discord
    enviarLogDiscord("Valoraciones de Staff", descripcionLog, 3447003) -- Azul
    
    outputChatBox("Se ha enviado un log detallado al Discord.", player, 0, 255, 0)
end
addCommandHandler("valoracionstaff", valoracionesStaff)
addCommandHandler("vstaff", valoracionesStaff)

-- Comando para generar informe diario de dudas por staff
function informeDiarioStaff(player, cmd, fecha)
    if not hasObjectPermissionTo(player, "command.adminchat", false) then
        return outputChatBox("Acceso denegado", player, 255, 0, 0)
    end
    
    -- Si no se especifica fecha, usar la fecha actual
    fecha = fecha or os.date("%Y-%m-%d")
    
    -- Validar formato de fecha (YYYY-MM-DD)
    if not string.match(fecha, "^%d%d%d%d%-%d%d%-%d%d$") then
        return outputChatBox("Formato de fecha incorrecto. Usa: YYYY-MM-DD (ej: 2023-10-15)", player, 255, 0, 0)
    end
    
    outputChatBox("Generando informe de dudas para la fecha: " .. fecha, player, 255, 255, 255)
    
    -- Obtener todas las dudas de la fecha especificada
    local condicion = "WHERE DATE(fechaCreacion) = '" .. fecha .. "'"
    
    -- Estadísticas generales
    local total = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion)
    local resueltas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff > 0")
    local auto = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -2")
    local anuladas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -3")
    local pendientes = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -1")
    
    -- Verificar que los resultados no sean nulos
    if not total then total = {total = 0} end
    if not resueltas then resueltas = {total = 0} end
    if not auto then auto = {total = 0} end
    if not anuladas then anuladas = {total = 0} end
    if not pendientes then pendientes = {total = 0} end
    
    -- Asegurarse de que los valores no sean nulos
    total.total = total.total or 0
    resueltas.total = resueltas.total or 0
    auto.total = auto.total or 0
    anuladas.total = anuladas.total or 0
    pendientes.total = pendientes.total or 0
    
    outputChatBox("=== INFORME DE DUDAS: " .. fecha .. " ===", player, 255, 255, 0)
    outputChatBox("Total de dudas: " .. total.total, player, 0, 255, 0)
    outputChatBox("Resueltas por staff: " .. resueltas.total, player, 0, 255, 0)
    outputChatBox("Resueltas automáticamente: " .. auto.total, player, 0, 255, 0)
    outputChatBox("Anuladas por usuarios: " .. anuladas.total, player, 0, 255, 0)
    outputChatBox("Pendientes: " .. pendientes.total, player, 0, 255, 0)
    
    -- Preparar la descripción para el log de Discord
    local descripcionLog = "> **INFORME DE DUDAS: " .. fecha .. "**\n\n" ..
        "> [ + ] Total de dudas: **" .. (total.total or 0) .. "**\n" ..
        "> [ + ] Resueltas por staff: **" .. (resueltas.total or 0) .. "**\n" ..
        "> [ + ] Resueltas automáticamente: **" .. (auto.total or 0) .. "**\n" ..
        "> [ + ] Anuladas por usuarios: **" .. (anuladas.total or 0) .. "**\n" ..
        "> [ + ] Pendientes: **" .. (pendientes.total or 0) .. "**\n\n" ..
        "> **DETALLE POR STAFF:**\n"
    
    -- Obtener todos los staff que han resuelto dudas en la fecha
    local staffs = exports.sql:query_assoc("SELECT DISTINCT userIDStaff FROM dudas " .. 
        condicion .. " AND userIDStaff > 0")
    
    if staffs and #staffs > 0 then
        outputChatBox("=== DETALLE POR STAFF ===", player, 255, 255, 0)
        
        -- Para cada staff, obtener sus estadísticas
        for _, staffData in ipairs(staffs) do
            local staffID = staffData.userIDStaff
            
            -- Obtener nombre del staff usando la nueva función
            local staffName = obtenerNombreStaff(staffID)
            
            -- Obtener estadísticas de valoración
            local stats = calcularEstadisticasValoracion(staffID, condicion)
            
            -- Calcular porcentajes
            local porcentajeValoradas = math.floor((stats.promedioValoradas / 10) * 100)
            local porcentajeTotal = math.floor((stats.promedioTotal / 10) * 100)
            
            -- Mostrar al jugador
            outputChatBox(staffName .. " - Dudas resueltas: " .. stats.total, player, 255, 255, 255)
            outputChatBox("  Valoradas: " .. stats.valoradas .. " | Sin valorar: " .. stats.sinValorar, player, 255, 255, 255)
            
            -- Colorear según valoración
            local color = {255, 0, 0} -- Rojo por defecto
            if porcentajeTotal >= 90 then
                color = {0, 255, 0} -- Verde para 90% o más
            elseif porcentajeTotal >= 70 then
                color = {255, 255, 0} -- Amarillo para 70-89%
            end
            
            outputChatBox("  Promedio (solo valoradas): " .. porcentajeValoradas .. "%", player, 255, 255, 255)
            outputChatBox("  Promedio (todas, sin valorar = 0): " .. porcentajeTotal .. "%", player, color[1], color[2], color[3])
            
            -- Mostrar desglose de valoraciones
            local desgloseTexto = "  Desglose: "
            for i = 1, 10 do
                if stats.desglose[i] > 0 then
                    desgloseTexto = desgloseTexto .. i .. "★(" .. stats.desglose[i] .. ") "
                end
            end
            outputChatBox(desgloseTexto, player, 255, 255, 255)
            
            -- Añadir a la descripción del log
            descripcionLog = descripcionLog .. "> [ + ] **" .. staffName .. "**:\n" ..
                ">   - Total dudas: **" .. stats.total .. "**\n" ..
                ">   - Valoradas: **" .. stats.valoradas .. "** | Sin valorar: **" .. stats.sinValorar .. "**\n" ..
                ">   - Promedio (solo valoradas): **" .. porcentajeValoradas .. "%**\n" ..
                ">   - Promedio (todas, sin valorar = 0): **" .. porcentajeTotal .. "%**\n" ..
                ">   - Desglose: "
                
            for i = 1, 10 do
                if stats.desglose[i] > 0 then
                    descripcionLog = descripcionLog .. "**" .. i .. "★(" .. stats.desglose[i] .. ")** "
                end
            end
            
            descripcionLog = descripcionLog .. "\n\n"
        end
    else
        outputChatBox("No hay dudas resueltas por staff en esta fecha.", player, 255, 204, 0)
        descripcionLog = descripcionLog .. "> No hay dudas resueltas por staff en esta fecha.\n"
    end
    
    -- Enviar log a Discord
    enviarLogDiscord("Informe Diario de Dudas", descripcionLog, 3447003) -- Azul
    
    outputChatBox("Se ha enviado un informe detallado al Discord.", player, 0, 255, 0)
end
addCommandHandler("informedudas", informeDiarioStaff)
addCommandHandler("idudas", informeDiarioStaff)

-- Comando para confirmar la eliminación de dudas
function confirmarEliminarDudas(player, cmd, fecha)
    if not hasObjectPermissionTo(player, "command.adminchat", false) then
        return outputChatBox("Acceso denegado", player, 255, 0, 0)
    end
    
    -- Verificar que la fecha coincida con la confirmación
    local fechaConfirmar = getElementData(player, "confirmarEliminarDudas")
    if not fechaConfirmar or fechaConfirmar ~= fecha then
        return outputChatBox("No hay ninguna operación de eliminación pendiente para esta fecha.", player, 255, 0, 0)
    end
    
    -- Obtener dudas de la fecha especificada
    local dudasEliminar = exports.sql:query_assoc("SELECT dudaID FROM dudas WHERE DATE(fechaCreacion) = '" .. fecha .. "'")
    
    if dudasEliminar and #dudasEliminar > 0 then
        -- Eliminar las dudas
        exports.sql:query_free("DELETE FROM dudas WHERE DATE(fechaCreacion) = '" .. fecha .. "'")
        
        outputChatBox("[DUDA] Has eliminado " .. #dudasEliminar .. " dudas del día " .. fecha, player, 0, 255, 0)
        
        -- Log de Discord para limpieza manual
        local descripcionLimpieza = 
            "> [ + ] Admin: **" .. getPlayerName(player):gsub("_", " ") .. "**\n" ..
            "> [ + ] Dudas eliminadas: **" .. #dudasEliminar .. "**\n" ..
            "> [ + ] Fecha: **" .. fecha .. "**\n" ..
            "> [ + ] Acción: Eliminación manual por fecha"
            
        enviarLogDiscord("Eliminación de Dudas por Fecha", descripcionLimpieza, 15158332) -- Rojo
    else
        outputChatBox("[DUDA] No se encontraron dudas para la fecha " .. fecha, player, 255, 204, 0)
    end
    
    -- Limpiar datos de confirmación
    removeElementData(player, "confirmarEliminarDudas")
end
addCommandHandler("confirmareliminar", confirmarEliminarDudas)

-- Función para generar informe semanal
function informeSemanalStaff(player, cmd, semanaAtras)
    if not hasObjectPermissionTo(player, "command.adminchat", false) then
        return outputChatBox("Acceso denegado", player, 255, 0, 0)
    end
    
    -- Determinar el período de la semana (por defecto la semana actual)
    semanaAtras = tonumber(semanaAtras) or 0
    
    -- Calcular fechas de inicio y fin de la semana
    local fechaFin = os.date("*t")
    
    -- Ajustar para semanas anteriores
    if semanaAtras > 0 then
        fechaFin.day = fechaFin.day - (semanaAtras * 7)
    end
    
    -- Ajustar al domingo de la semana
    local diaSemana = fechaFin.wday - 1 -- 0 = domingo, 6 = sábado
    if diaSemana == -1 then diaSemana = 6 end -- Ajuste para domingo
    
    fechaFin.day = fechaFin.day - diaSemana
    
    -- Fecha de inicio (lunes anterior)
    local fechaInicio = {
        year = fechaFin.year,
        month = fechaFin.month,
        day = fechaFin.day - 6, -- 6 días antes del domingo
        hour = 0,
        min = 0,
        sec = 0
    }
    
    -- Ajustar si el día es negativo (mes anterior)
    while fechaInicio.day <= 0 do
        fechaInicio.month = fechaInicio.month - 1
        if fechaInicio.month == 0 then
            fechaInicio.month = 12
            fechaInicio.year = fechaInicio.year - 1
        end
        
        -- Días en el mes anterior
        local diasEnMes = 31
        if fechaInicio.month == 4 or fechaInicio.month == 6 or fechaInicio.month == 9 or fechaInicio.month == 11 then
            diasEnMes = 30
        elseif fechaInicio.month == 2 then
            -- Febrero (con ajuste para año bisiesto)
            if fechaInicio.year % 4 == 0 and (fechaInicio.year % 100 ~= 0 or fechaInicio.year % 400 == 0) then
                diasEnMes = 29
            else
                diasEnMes = 28
            end
        end
        
        fechaInicio.day = fechaInicio.day + diasEnMes
    end
    
    -- Formatear fechas para SQL
    local fechaInicioStr = string.format("%04d-%02d-%02d", fechaInicio.year, fechaInicio.month, fechaInicio.day)
    local fechaFinStr = string.format("%04d-%02d-%02d", fechaFin.year, fechaFin.month, fechaFin.day)
    
    outputChatBox("Generando informe semanal del " .. fechaInicioStr .. " al " .. fechaFinStr, player, 255, 255, 255)
    
    -- Condición SQL para la semana
    local condicion = "WHERE fechaCreacion >= '" .. fechaInicioStr .. "' AND fechaCreacion <= '" .. fechaFinStr .. " 23:59:59'"
    
    -- Estadísticas generales
    local total = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion)
    local resueltas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff > 0")
    local auto = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -2")
    local anuladas = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -3")
    local pendientes = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS total FROM dudas " .. condicion .. " AND userIDStaff = -1")
    
    -- Verificar que los resultados no sean nulos
    if not total then total = {total = 0} end
    if not resueltas then resueltas = {total = 0} end
    if not auto then auto = {total = 0} end
    if not anuladas then anuladas = {total = 0} end
    if not pendientes then pendientes = {total = 0} end
    
    -- Asegurarse de que los valores no sean nulos
    total.total = total.total or 0
    resueltas.total = resueltas.total or 0
    auto.total = auto.total or 0
    anuladas.total = anuladas.total or 0
    pendientes.total = pendientes.total or 0
    
    outputChatBox("=== INFORME SEMANAL: " .. fechaInicioStr .. " al " .. fechaFinStr .. " ===", player, 255, 255, 0)
    outputChatBox("Total de dudas: " .. total.total, player, 0, 255, 0)
    outputChatBox("Resueltas por staff: " .. resueltas.total, player, 0, 255, 0)
    outputChatBox("Resueltas automáticamente: " .. auto.total, player, 0, 255, 0)
    outputChatBox("Anuladas por usuarios: " .. anuladas.total, player, 0, 255, 0)
    outputChatBox("Pendientes: " .. pendientes.total, player, 0, 255, 0)
    
    -- Preparar la descripción para el log de Discord
    local descripcionLog = "> **INFORME SEMANAL: " .. fechaInicioStr .. " al " .. fechaFinStr .. "**\n\n" ..
        "> [ + ] Total de dudas: **" .. total.total .. "**\n" ..
        "> [ + ] Resueltas por staff: **" .. resueltas.total .. "**\n" ..
        "> [ + ] Resueltas automáticamente: **" .. auto.total .. "**\n" ..
        "> [ + ] Anuladas por usuarios: **" .. anuladas.total .. "**\n" ..
        "> [ + ] Pendientes: **" .. pendientes.total .. "**\n\n" ..
        "> **DETALLE POR STAFF:**\n"
    
    -- Obtener todos los staff que han resuelto dudas en la semana
    local staffs = exports.sql:query_assoc("SELECT DISTINCT userIDStaff FROM dudas " .. 
        condicion .. " AND userIDStaff > 0")
    
    if staffs and #staffs > 0 then
        outputChatBox("=== DETALLE POR STAFF ===", player, 255, 255, 0)
        
        -- Para cada staff, obtener sus estadísticas
        for _, staffData in ipairs(staffs) do
            local staffID = staffData.userIDStaff
            
            -- Obtener nombre del staff
            local staffName = obtenerNombreStaff(staffID)
            
            -- Obtener estadísticas de valoración
            local stats = calcularEstadisticasValoracion(staffID, condicion)
            
            -- Calcular porcentajes
            local porcentajeValoradas = math.floor((stats.promedioValoradas / 10) * 100)
            local porcentajeTotal = math.floor((stats.promedioTotal / 10) * 100)
            
            -- Mostrar al jugador
            outputChatBox(staffName .. " - Dudas resueltas: " .. stats.total, player, 255, 255, 255)
            outputChatBox("  Valoradas: " .. stats.valoradas .. " | Sin valorar: " .. stats.sinValorar, player, 255, 255, 255)
            
            -- Colorear según valoración
            local color = {255, 0, 0} -- Rojo por defecto
            if porcentajeTotal >= 90 then
                color = {0, 255, 0} -- Verde para 90% o más
            elseif porcentajeTotal >= 70 then
                color = {255, 255, 0} -- Amarillo para 70-89%
            end
            
            outputChatBox("  Promedio (solo valoradas): " .. porcentajeValoradas .. "%", player, 255, 255, 255)
            outputChatBox("  Promedio (todas, sin valorar = 0): " .. porcentajeTotal .. "%", player, color[1], color[2], color[3])
            
            -- Mostrar desglose de valoraciones
            local desgloseTexto = "  Desglose: "
            for i = 1, 10 do
                if stats.desglose[i] > 0 then
                    desgloseTexto = desgloseTexto .. i .. "★(" .. stats.desglose[i] .. ") "
                end
            end
            outputChatBox(desgloseTexto, player, 255, 255, 255)
            
            -- Añadir a la descripción del log
            descripcionLog = descripcionLog .. "> [ + ] **" .. staffName .. "**:\n" ..
                ">   - Total dudas: **" .. stats.total .. "**\n" ..
                ">   - Valoradas: **" .. stats.valoradas .. "** | Sin valorar: **" .. stats.sinValorar .. "**\n" ..
                ">   - Promedio (solo valoradas): **" .. porcentajeValoradas .. "%**\n" ..
                ">   - Promedio (todas, sin valorar = 0): **" .. porcentajeTotal .. "%**\n" ..
                ">   - Desglose: "
                
            for i = 1, 10 do
                if stats.desglose[i] > 0 then
                    descripcionLog = descripcionLog .. "**" .. i .. "★(" .. stats.desglose[i] .. ")** "
                end
            end
            
            descripcionLog = descripcionLog .. "\n\n"
        end
    else
        outputChatBox("No hay dudas resueltas por staff en esta semana.", player, 255, 204, 0)
        descripcionLog = descripcionLog .. "> No hay dudas resueltas por staff en esta semana.\n"
    end
    
    -- Enviar log a Discord
    enviarLogDiscord("Informe Semanal de Dudas", descripcionLog, 3447003) -- Azul
    
    outputChatBox("Se ha enviado un informe semanal detallado al Discord.", player, 0, 255, 0)
    
    return fechaInicioStr, fechaFinStr, descripcionLog
end
addCommandHandler("informesemanal", informeSemanalStaff)
addCommandHandler("isemanal", informeSemanalStaff)

-- Sistema para generar informes semanales automáticamente
function generarInformeSemanalAutomatico()
    -- Verificar si hoy es domingo (día 0 en la semana)
    local hoy = os.date("*t")
    local diaSemana = hoy.wday - 1 -- 0 = domingo, 6 = sábado
    
    if diaSemana == 0 then -- Si es domingo
        -- Generar informe semanal automáticamente (sin jugador)
        local fechaInicio, fechaFin, descripcionLog = informeSemanalStaff(nil, nil, 0)
        
        -- Notificar a los administradores conectados
        for _, admin in ipairs(getAdmins(false)) do
            outputChatBox("[SISTEMA] Se ha generado el informe semanal de dudas automáticamente.", admin, 0, 255, 0)
            outputChatBox("[SISTEMA] Período: " .. fechaInicio .. " al " .. fechaFin, admin, 0, 255, 0)
            outputChatBox("[SISTEMA] El informe completo ha sido enviado al Discord.", admin, 0, 255, 0)
        end
        
        -- Enviar log a Discord
        enviarLogDiscord("Informe Semanal Automático de Dudas", descripcionLog, 3447003) -- Azul
    end
end

-- Configurar timer para verificar diariamente si es domingo
function configurarTimerInformeSemanal()
    -- Ejecutar cada día a las 00:05 (5 minutos después de medianoche)
    local tiempoHastaMedianoche = (24 * 60 * 60 * 1000) - ((tonumber(os.date("%H")) * 60 * 60 + tonumber(os.date("%M")) * 60 + tonumber(os.date("%S"))) * 1000)
    tiempoHastaMedianoche = tiempoHastaMedianoche + (5 * 60 * 1000) -- Añadir 5 minutos
    
    -- Primer timer para la primera ejecución
    setTimer(function()
        generarInformeSemanalAutomatico()
        -- Configurar timer recurrente diario
        setTimer(generarInformeSemanalAutomatico, 24 * 60 * 60 * 1000, 0) -- Cada 24 horas
    end, tiempoHastaMedianoche, 1)
end

-- Iniciar el sistema de informes semanales al cargar el recurso
addEventHandler("onResourceStart", getResourceRootElement(), configurarTimerInformeSemanal)