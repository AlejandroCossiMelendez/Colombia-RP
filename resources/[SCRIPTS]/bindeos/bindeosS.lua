function peti(nameb)
	--local nameb = exports.players:getCharacterID(player)
	local nameplayer = exports.sql:query_assoc( "SELECT `gordura` FROM `characters` WHERE `characterID` = " ..tostring(nameb))
	local facc = nameplayer[1]['gordura']
	--outputChatBox("tu gordura es " .. tostring(facc), player)
	--outputChatBox("tu id " .. tostring(nameb), player)
	outputChatBox("Recuerda Leer Conceptos De Rol ( Panel F1 )", player, 255, 165, 0)
		if facc == 1 then 
			setTimer(function()
				fac = "pd"
				bindeos(fac)
			end, 1000, 1)
		elseif facc == 2 then
			setTimer(function()
				fac = "sura"
				bindeos(fac)
			end, 1000, 1)
		elseif facc == 3 then
			setTimer(function()
				fac = "meca"
				bindeos(fac)
			end, 1000, 1)
		elseif facc == 4 then
			setTimer(function()
				fac = "ilegal"
				bindeos(fac)
			end, 1000, 1)
					
		end
end
--addCommandHandler("peti", peti)

function topeti()
	player = source
    setTimer(function()
		nameb = exports.players:getCharacterID(player)
		outputChatBox("", player)
		peti(nameb)
	end, 1000, 1)
end
addEventHandler("onPlayerSpawn", getRootElement(), topeti)
--addCommandHandler("peti", topeti)
  




-- Función auxiliar para usar RolCabeza o el sistema de comandos predeterminado
function procesarMensajeRol(player, mensaje, tipo)
    -- Obtener la posición, dimensión e interior del jugador
    local x, y, z = getElementPosition(player)
    local dimension = getElementDimension(player)
    local interior = getElementInterior(player)
    local playerName = getPlayerName(player):gsub("_", " ")
    local nearbyPlayers = getElementsWithinRange(x, y, z, 30, "player")
    
    -- Preparar el mensaje formateado
    local mensaje_final = ""
    if tipo == "me" then
        mensaje_final = "* " .. playerName .. " " .. mensaje
    elseif tipo == "do" then
        mensaje_final = "* " .. mensaje .. " (( " .. playerName .. " ))"
    end
    
    -- Si RolCabeza está disponible, intentar usar su sistema primero
    if getResourceFromName("RolCabeza") and getResourceState(getResourceFromName("RolCabeza")) == "running" then
        -- Enviar eventos solo a jugadores cercanos en la misma dimensión/interior
        -- Primero al jugador que emitió el mensaje
        triggerClientEvent(player, "showRoleplayBubble", player, mensaje, tipo)
        
        -- Luego a los jugadores cercanos
        for _, nearbyPlayer in ipairs(nearbyPlayers) do
            if nearbyPlayer ~= player then
                local nearbyDimension = getElementDimension(nearbyPlayer)
                local nearbyInterior = getElementInterior(nearbyPlayer)
                
                if nearbyDimension == dimension and nearbyInterior == interior then
                    triggerClientEvent(nearbyPlayer, "showRoleplayBubble", player, mensaje, tipo)
                end
            end
        end
    end
    
    -- Siempre mostrar en el chat, pero solo a jugadores cercanos
    -- Primero al jugador que emitió el mensaje
    if tipo == "me" then
        outputChatBox(mensaje_final, player, 255, 0, 0)
    elseif tipo == "do" then
        outputChatBox(mensaje_final, player, 255, 255, 0)
    end
    
    -- Luego a los jugadores cercanos
    for _, nearbyPlayer in ipairs(nearbyPlayers) do
        if nearbyPlayer ~= player then
            local nearbyDimension = getElementDimension(nearbyPlayer)
            local nearbyInterior = getElementInterior(nearbyPlayer)
            
            if nearbyDimension == dimension and nearbyInterior == interior then
                if tipo == "me" then
                    outputChatBox(mensaje_final, nearbyPlayer, 255, 0, 0)
                elseif tipo == "do" then
                    outputChatBox(mensaje_final, nearbyPlayer, 255, 255, 0)
                end
            end
        end
    end
    
    return true
end

-- Función alternativa que usa eventos del cliente para mostrar burbujas directamente
function mostrarBurbujaRol(player, mensaje, tipo)
    -- Usar directamente nuestra implementación mejorada
    return procesarMensajeRol(player, mensaje, tipo)
end

-- Función mejorada para vincular comandos de roleplay
function bindRolCommand(player, key, command, mensaje)
    if command == "me" or command == "do" then
        bindKey(player, key, "down", function(thePlayer)
            -- Usamos la función procesarMensajeRol para enviar mensajes solo a jugadores cercanos
            procesarMensajeRol(thePlayer, mensaje, command)
        end)
    else
        bindKey(player, key, "down", command)
    end
end

-- Función para comandos de chat localizados (solo se ven en el área cercana)
function bindLocalChatCommand(player, key, command, mensaje)
    bindKey(player, key, "down", function(thePlayer)
        local x, y, z = getElementPosition(thePlayer)
        local dimension = getElementDimension(thePlayer)
        local interior = getElementInterior(thePlayer)
        local playerName = getPlayerName(thePlayer):gsub("_", " ")
        local nearbyPlayers = getElementsWithinRange(x, y, z, 30, "player")
        
        -- Formato del mensaje según el tipo de comando
        local mensaje_final = ""
        if command == "meg" then
            mensaje_final = "* [Megáfono] " .. playerName .. ": " .. mensaje
        elseif command == "g" then
            mensaje_final = "* [Grito] " .. playerName .. ": " .. mensaje
        elseif command == "cargar" then
            mensaje_final = "* " .. playerName .. " carga a alguien sobre su hombro."
        elseif command == "crack" then
            mensaje_final = "* " .. playerName .. " se traga una pastilla."
        elseif command == "f" or command == "Nsura" then
            -- Estos son comandos de radio, no necesitan ser localizados
            executeCommandHandler(command, thePlayer, mensaje)
            return
        else
            -- Para otros comandos genéricos
            mensaje_final = "* " .. playerName .. ": " .. mensaje
        end
        
        -- Mostrar al jugador que lo emitió
        outputChatBox(mensaje_final, thePlayer, 255, 255, 0)
        
        -- Mostrar a jugadores cercanos en la misma dimensión e interior
        for _, nearbyPlayer in ipairs(nearbyPlayers) do
            if nearbyPlayer ~= thePlayer then
                local nearbyDimension = getElementDimension(nearbyPlayer)
                local nearbyInterior = getElementInterior(nearbyPlayer)
                
                if nearbyDimension == dimension and nearbyInterior == interior then
                    outputChatBox(mensaje_final, nearbyPlayer, 255, 255, 0)
                end
            end
        end
    end)
end

-- Actualizar la función bindeos con la nueva función bindLocalChatCommand
function bindeos(fac)
	outputChatBox("Facción recibida: " .. tostring(fac), player)
	fac = tostring(fac)
	if fac == "pd" or fac == "sura" or fac == "meca" or fac == "ilegal" then
	
		-- Desasociar primero todos los bindeos existentes
		for i = 0, 9 do
			unbindKey(player, tostring(i), "down")
		end
		
		setTimer(function()
		if fac == "pd" then
		
			bindRolCommand(player, "1", "me", "saca su arma de su CT y la desenfunda.")
			bindRolCommand(player, "1", "do", ".:Click-Clack:. Arma lista para usar")
			bindRolCommand(player, "2", "me", "examina de pies a cabeza al sujeto")
			bindRolCommand(player, "2", "do", "podria?")
			bindRolCommand(player, "3", "me", "saca un cuchillo y destruye/corta cualquier objeto de comunicación")
			bindRolCommand(player, "3", "do", "se vería el sujeto totalmente incomunicado")
			bindRolCommand(player, "4", "me", "se retiene las heridas")
			bindRolCommand(player, "4", "do", "aun tendría ánimos para continuar")
			bindLocalChatCommand(player, "4", "crack", "")
			bindRolCommand(player, "5", "me", "saca unas esposas de su CT y las abre/cierra")
			bindRolCommand(player, "5", "do", "se veria esposado/desesposado al sujeto")
			bindRolCommand(player, "6", "me", "coge el megáfono de la silla, lo enciende y seguidamente habla por el.")
			bindLocalChatCommand(player, "6", "meg", "Le habla la policía nacional, por favor estacione su vehículo en la parte derecha de la carretera, apague el motor y espere las indicaciones.")
			bindRolCommand(player, "7", "me", "abre/cierra la puerta de la patrulla")
			bindRolCommand(player, "7", "do", "el sujeto entraria/saldria de la patrulla por si solo")
			bindRolCommand(player, "8", "me", "agarra/suelta al sujeto y lo sube/baja de su hombro")
			bindRolCommand(player, "8", "do", "se veria como se lo echa/baja de su hombro")
			bindLocalChatCommand(player, "8", "cargar", "")
			bindRolCommand(player, "9", "me", "se soba su cabeza y continua conduciendo/viendo.")
			bindRolCommand(player, "9", "do", "El cinturón/casco actuaría ante el choque.")
			outputChatBox("Se han actualizado tus bnd para la Policía Nacional. teclas[1 al 9]", player, 0, 255, 0)
		elseif fac == "sura" then		
			-- Bind 1 | Revisión de Pulso
			bindRolCommand(player, "1", "me", "coloca dos dedos en el cuello del paciente buscando pulso")
			bindRolCommand(player, "1", "do", "Sentiría el pulso estable, podría?")
		
			-- Bind 2 | Inspección de heridas
			bindRolCommand(player, "2", "me", "revisa cuidadosamente al paciente en busca de heridas visibles o internas")
			bindRolCommand(player, "2", "do", "Que heridas tendria?")
		
			-- Bind 3 | Aplicación primeros auxilios (botiquín)
			bindRolCommand(player, "3", "me", "abre rápidamente el botiquín y aplica primeros auxilios sobre el paciente")
			bindRolCommand(player, "3", "do", "reaccionaría favorablemente al tratamiento")
		
			-- Bind 4 | Evaluación pre-quirúrgica
			bindRolCommand(player, "4", "me", "prepara cuidadosamente al paciente verificando anestesia antes de cirugía")
			bindRolCommand(player, "4", "do", "estaría listo y anestesiado correctamente, podría?")
		
			-- Bind 5 | Incisión quirúrgica
			bindRolCommand(player, "5", "me", "realiza una incisión precisa en la zona indicada para iniciar cirugía")
			bindRolCommand(player, "5", "do", "la incisión estaría hecha correctamente, podría?")
		
			-- Bind 6 | Procedimiento quirúrgico (extracción o reparación interna)
			bindRolCommand(player, "6", "me", "efectúa cuidadosamente el procedimiento quirúrgico necesario en el área afectada")
			bindRolCommand(player, "6", "do", "el procedimiento estaría avanzando satisfactoriamente, podría?")
		
			-- Bind 7 | Suturas y cierre de cirugía
			bindRolCommand(player, "7", "me", "realiza suturas quirúrgicas para cerrar la incisión cuidadosamente")
			bindRolCommand(player, "7", "do", "la herida quedaría perfectamente cerrada, podría?")
		
			-- Bind 8 | Vendaje postoperatorio
			bindRolCommand(player, "8", "me", "aplica un vendaje especializado para proteger la herida tratada")
			bindRolCommand(player, "8", "do", "el vendaje estaría firme y correctamente colocado, podría?")
		
			-- Bind 9 | Chequeo final de signos vitales
			bindRolCommand(player, "9", "me", "verifica nuevamente pulso, respiración y signos vitales generales tras el procedimiento")
			bindRolCommand(player, "9", "do", "los signos vitales serían estables y normales, podría?")
			
			-- Bind 0 | Atención de llamados (canal /Nsura y /f)
			bindKey(player, "0", "down", function(thePlayer)
				executeCommandHandler("Nsura", thePlayer, "Acudo al llamado")
				executeCommandHandler("f", thePlayer, "Acudo al llamado")
			end)
			bindRolCommand(player, "0", "me", "activa su radio e informa claramente que se dirige al lugar solicitado")
			bindRolCommand(player, "0", "do", "la comunicación se escucharía perfectamente, podría?")

		
			outputChatBox("Se han actualizado tus bnd para SURA. teclas[1 al 9]", player, 0, 255, 0)
		
		
		elseif fac == "meca" then
		
			bindRolCommand(player, "1", "me", "Abre el capo del vehículo y lo observa detalladamente")
			bindRolCommand(player, "1", "do", "Luego de 5 minutos encontraría un daño grave en el motor")
			bindRolCommand(player, "1", "me", "Comienza a reparar el daño")
			bindRolCommand(player, "1", "do", "Luego de 2 horas el motor quedaría reparado")
			bindRolCommand(player, "2", "me", "Comienza a retirar la pieza que se encuentra dañada")
			bindRolCommand(player, "2", "do", "Esta caería")
			bindRolCommand(player, "2", "me", "Busca una nueva pieza, la pone en el vehículo y la aprieta")
			bindRolCommand(player, "2", "do", "después de 1 hora terminaría la reparación")
			bindRolCommand(player, "3", "me", "Toma su radio y llama a otros mecánicos")
			bindRolCommand(player, "3", "me", "busca una lata de pintura con el color elegido por el cliente")
			bindRolCommand(player, "3", "do", "Se vería a varios mecánicos pintar el vehículo (NPC)")
			bindRolCommand(player, "3", "do", "Después de 3 horas el vehículo estaría pintado")
			bindRolCommand(player, "4", "me", "Toma una computadora de la mesa y la conecta al vehiculo")
			bindRolCommand(player, "4", "me", "Realiza la reprogramación del sistema del vehículo")
			bindRolCommand(player, "4", "do", "Este tendría una mejora en la velocidad y la aceleración del vehículo")
			bindRolCommand(player, "4", "do", "Después de 1 hora finalizaría el full Tuning")
			bindRolCommand(player, "5", "me", "Toma el gato y levanta el vehículo y posteriormente con su cruceta destornilla la llanta")
			bindRolCommand(player, "5", "me", "Busca una nueva llanta y la atornilla en su lugar")
			bindRolCommand(player, "5", "do", "Esta quedaría firme")
			bindRolCommand(player, "5", "do", "Después de 20 minutos finaliza el cambio de llanta")
			bindRolCommand(player, "6", "me", "Toma sus herramientas y comienza a retirar el foco antiguo")
			bindRolCommand(player, "6", "me", "Coloca un par de bombillos led nuevos en su lugar")
			bindRolCommand(player, "6", "do", "Brillarían del color elegido por el cliente")
			bindRolCommand(player, "6", "do", "Después de 15 minutos finaliza el cambio de luces")
			outputChatBox("Se han actualizado tus bnd para MECA. teclas[1 al 6]", player, 0, 255, 0)
		elseif fac == "ilegal" then		
			bindRolCommand(player, "1", "me", "saca el arma de su cinturón y la desenfunda")
			bindRolCommand(player, "1", "do", ",;Click Clack ;, el arma estaría lista para disparar")
			bindRolCommand(player, "2", "me", "examina de pies a cabeza al sujeto")
			bindRolCommand(player, "2", "do", "podría?")
			bindRolCommand(player, "3", "me", "saca un cuchillo y destruye/corta cualquier objeto de comunicación")
			bindRolCommand(player, "3", "do", "se vería el sujeto totalmente incomunicado")
			bindRolCommand(player, "4", "me", "se retiene las heridas")
			bindRolCommand(player, "4", "do", "aun tendría ánimos para continuar")
			bindLocalChatCommand(player, "4", "crack", "")
			bindLocalChatCommand(player, "5", "g", "Levante las mano ahora mismo, esto es un robo")
			bindRolCommand(player, "6", "me", "agarra/suelta al sujeto y lo sube/baja de su hombro")
			bindRolCommand(player, "6", "do", "se veria como se lo echa/baja de su hombro")
			bindLocalChatCommand(player, "6", "cargar", "")
		    bindRolCommand(player, "9", "me", "se soba su cabeza y continua conduciendo/viendo")
			bindRolCommand(player, "9", "do", "El cinturón/casco actuaría ante el choque")
			outputChatBox("Se han actualizado tus bnd para ILEGAL. teclas[1 al 6, 9]", player, 0, 255, 0)
			
		end
		end, 1000, 1)
	else
		outputChatBox("USA: /bnd [pd, sura, meca, ilegal]", 255, 0, 0)
    end
end

function actbind(play, c, id)
	player = play
	if id then
		if id == "pd" then
			ply = exports.players:getCharacterID(play)
			outputChatBox("Cargando Actualizacion de bnd", play, 0, 255, 0)
			exports.sql:query_free( "UPDATE `characters` SET `gordura` = 1 WHERE `characterID` =  " .. tostring(ply))
			fac = "pd"
			bindeos(fac)
		elseif id == "sura" then
			ply = exports.players:getCharacterID(play)
			outputChatBox("Cargando Actualizacion de bnd", play, 0, 255, 0)
			exports.sql:query_free( "UPDATE `characters` SET `gordura` = 2 WHERE `characterID` =  " .. tostring(ply))
			fac = "sura"
			bindeos(fac)
		elseif id == "meca" then
			ply = exports.players:getCharacterID(play)
			outputChatBox("Cargando Actualizacion de bnd", play, 0, 255, 0)
			exports.sql:query_free( "UPDATE `characters` SET `gordura` = 3 WHERE `characterID` =  " .. tostring(ply))
			fac = "meca"
			bindeos(fac)
		elseif id == "ilegal" then
			ply = exports.players:getCharacterID(play)
			outputChatBox("Cargando Actualizacion de bnd", play, 0, 255, 0)
			exports.sql:query_free( "UPDATE `characters` SET `gordura` = 4 WHERE `characterID` =  " .. tostring(ply))
			fac = "ilegal"
			bindeos(fac)
		else
			outputChatBox("No existe el bindeo, USA: /bnd [pd, sura, meca, ilegal]", play, 255, 0, 0)
		end		
	else
		outputChatBox("USA: /bnd [pd, sura, meca, ilegal]", play, 255, 0, 0)
    end
end

addCommandHandler("bnd", actbind)

function unbnd (pl)
	upl = exports.players:getCharacterID(pl)
	exports.sql:query_free( "UPDATE `characters` SET `gordura` = 0 WHERE `characterID` =  " .. tostring(upl))
	outputChatBox("Se han retirado tus bnd", pl, 255, 0, 0)
	
	-- Desasociar todos los bindeos de las teclas numéricas usando un bucle
	for i = 0, 9 do
		unbindKey(pl, tostring(i), "down")
	end
end
addCommandHandler("unbnd", unbnd)