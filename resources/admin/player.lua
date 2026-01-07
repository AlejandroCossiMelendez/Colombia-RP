local anuncios = { "Recuerda usar /duda antes de /pm. ¡Por una atención rápida y eficaz!", 
"Recuerda: las multicuentas, el pasar un vehículo a otro de tus PJ... ¡Es Sancionable!",
"Recuerda: respetar los entornos de los lugares y tener un rol adecuado del personaje.",
"¿Nos necesitas? Utiliza /duda para cualquier problema ;)"}

function mensajeAleatorio()
	outputChatBox(anuncios[math.random(1, #anuncios)], root, 127, 255, 127)
end
setTimer(mensajeAleatorio, 10000, 1)
setTimer(mensajeAleatorio, 900000, 0)
--addCommandHandler("mst", mensajeAleatorio)

-- addCommandHandler supporting arrays as command names (multiple commands with the same function)
local addCommandHandler_ = addCommandHandler
      addCommandHandler  = function( commandName, fn, restricted, caseSensitive )
	-- add the default command handlers
	if type( commandName ) ~= "table" then
		commandName = { commandName }
	end
	for key, value in ipairs( commandName ) do
		if key == 1 then
			if value and not fn then
				outputDebugString(tostring(value))
			end
			addCommandHandler_( value, fn, restricted, caseSensitive )
		else
			addCommandHandler_( value,
				function( player, ... )
					-- check if he has permissions to execute the command, default is not restricted (aka if the command is restricted - will default to no permission; otherwise okay)
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) or hasObjectPermissionTo( player, "command.modchat", not restricted ) then
						fn( player, ... )
					end
				end
			)
		end
	end
end

-- Función centralizada para registrar intentos de uso de comandos sin staffduty
function logStaffCommandWithoutDuty(player, commandName, targetPlayer, otherInfo)
    if not player or not commandName then return false end
    
    -- Información básica del staff
    local staffName = getPlayerName(player):gsub("_", " ")
    local staffSerial = getPlayerSerial(player)
    local staffIP = getPlayerIP(player)
    local staffUserID = exports.players:getUserID(player)
    
    -- Información sobre el objetivo del comando (si existe)
    local targetName = "N/A"
    local targetSerial = "N/A"
    local targetUserID = "N/A"
    
    if targetPlayer then
        if type(targetPlayer) == "string" then
            -- Si es un string, intentar obtener el jugador
            local targetElement, targetElementName = exports.players:getFromName(player, targetPlayer, true)
            if targetElement then
                targetName = targetElementName or getPlayerName(targetElement):gsub("_", " ")
                targetSerial = getPlayerSerial(targetElement)
                targetUserID = exports.players:getUserID(targetElement)
            else
                targetName = targetPlayer
            end
        elseif isElement(targetPlayer) and getElementType(targetPlayer) == "player" then
            -- Si es un elemento jugador directamente
            targetName = getPlayerName(targetPlayer):gsub("_", " ")
            targetSerial = getPlayerSerial(targetPlayer)
            targetUserID = exports.players:getUserID(targetPlayer)
        end
    end
    
    -- Información adicional proporcionada
    local additionalInfo = otherInfo or "N/A"
    
    -- Construir mensaje para el webhook de Discord
    local message = {
        title = "⚠️ Comando Administrativo Sin Servicio",
        description = 
            "> [ + ] **Staff:** " .. staffName .. " (ID: " .. exports.players:getID(player) .. ")\n" ..
            "> [ + ] **UserID:** " .. tostring(staffUserID) .. "\n" ..
            "> [ + ] **Serial:** " .. staffSerial .. "\n" ..
            "> [ + ] **IP:** " .. staffIP .. "\n" ..
            "> [ + ] **Comando:** /" .. commandName .. "\n" ..
            "> [ + ] **Objetivo:** " .. targetName .. "\n" ..
            (targetSerial ~= "N/A" and "> [ + ] **Serial Objetivo:** " .. targetSerial .. "\n" or "") ..
            (targetUserID ~= "N/A" and "> [ + ] **UserID Objetivo:** " .. tostring(targetUserID) .. "\n" or "") ..
            (additionalInfo ~= "N/A" and "> [ + ] **Información adicional:** " .. tostring(additionalInfo) or ""),
        color = 15158332, -- Rojo
        footer = {
            text = "Sistema Anti-Abuso",
            icon_url = "https://imgur.com/n3378F1"
        },
        timestamp = "now"
    }
    
    -- Enviar a Discord usando el webhook
    exports.discord_webhooks:sendToURL(
        "https://discord.com/api/webhooks/1407618304301863014/Xsm5ZzSaay8aGOVC0WzMsuTvpogDr8TmvGByJm6mO2qB_eQ1QoSKCoH1vtnIv0SyE238",
        message
    )
    
    -- Devolver true para indicar que el log se envió correctamente
    return true
end

-- Modificar las funciones que verifican staffduty para usar la nueva función centralizada:

function consultarLowPlayers(player)
	if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
	if not exports.players:getOption(player, "staffduty") then
		logStaffCommandWithoutDuty(player, "low", nil, "Consulta de jugadores con vida baja")
		return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
	end
	
	outputChatBox("~~Jugadores que están en LOW-HP~~", player, 255, 255, 255)
	for k, v in ipairs(getElementsByType("player")) do
		if getElementHealth(v) <= 30 then
			outputChatBox("Nombre: "..tostring(getPlayerName(v):gsub("_", " "))..". HP: "..tostring(getElementHealth(v))..".", player, 255, 255, 0)
		end
	end
end
addCommandHandler("low", consultarLowPlayers)

addCommandHandler( "genero",
	function( player, commandName, otherPlayer, genero )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Cambio de género a: " .. (genero or "N/A"))
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer and genero then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local characterID = exports.players:getCharacterID( other )
				if string.lower(genero) == "hombre" then 
					generoID = 1
				elseif string.lower(genero) == "mujer" then
					generoID = 2
				else
					outputChatBox("Género inválido ("..tostring(genero).."). Usa hombre o mujer.", player, 255, 0, 0)
					return
				end
				if characterID then
					if exports.sql:query_free( "UPDATE characters SET genero = " .. generoID .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Has cambiado el género de " .. name .. " a " .. tostring(genero), player, 0, 255, 153 )
					else
						outputChatBox( "No se ha podido cambiar el género de "..tostring(name), player, 255, 0, 0 )
					end
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [hombre o mujer]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "color",
	function( player, commandName, otherPlayer, color )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Cambio de color a: " .. (color or "N/A"))
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer and color then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local characterID = exports.players:getCharacterID( other )
				if string.lower(color) == "blanco" then 
					colorID = 1
				elseif string.lower(color) == "negro" then
					colorID = 0
				else
					outputChatBox("Color inválido ("..tostring(color).."). Usa blanco o negro.", player, 255, 0, 0)
					return
				end
				if characterID then
					if exports.sql:query_free( "UPDATE characters SET color = " .. colorID .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Has cambiado el color de " .. name .. " a " .. tostring(color), player, 0, 255, 153 )
					else
						outputChatBox( "No se ha podido cambiar el color de "..tostring(name), player, 255, 0, 0 )
					end
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [blanco o negro]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "edad",
	function( player, commandName, otherPlayer, edad )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Cambio de edad a: " .. (edad or "N/A"))
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer and edad and tonumber(edad) then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local characterID = exports.players:getCharacterID( other )
				if characterID then
					if exports.sql:query_free( "UPDATE characters SET edad = " .. tonumber(edad) .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Has cambiado la edad de " .. name .. " a " .. tostring(edad), player, 0, 255, 153 )
					else
						outputChatBox( "No se ha podido cambiar la edad de "..tostring(name), player, 255, 0, 0 )
					end
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [edad]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "revivir",
	function( player, commandName, otherPlayer, health )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Revivir con vida: " .. (health or "N/A"))
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then	
				local x, y, z = getElementPosition( other )
				local rot = getElementRotation( other )
				local skin = getElementModel( other )
				local dim = getElementDimension( other )
				local int = getElementInterior( other )			
				outputChatBox( "Has revivido a " .. name .. ".", player, 0, 255, 153 )
				if getElementData(player, "enc") then
					outputChatBox( "Alguien te ha revivido.", other, 0, 255, 153 )
				else
					outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha revivido.", other, 0, 255, 153 )
				   -- staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha revivido administrativamente a "..getPlayerName( other ):gsub( "_", " " ) ..".")
				end
				for i = 3, 9 do
					removeElementData(other, "herida"..tostring(i))
					i = i+1
				end
				triggerClientEvent(other, "onClientNoMuerto", other)
				exports.medico:anularLlevarse(other)
				removeElementData(other, "muerto")
				removeElementData(other, "accidente")
				exports.items:guardarArmas(other, true)
				spawnPlayer( other, x, y, z, rot, skin, int, dim )
				fadeCamera( other, true )
				setCameraTarget( other, other )
				setCameraInterior( other, int )
				if health then
					setElementHealth(other, tonumber(health))
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [(optional) health]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "reconectar",
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then	
				local x, y, z = getElementPosition( other )
				local rot = getElementRotation( other )
				local skin = getElementModel( other )
				local dim = getElementDimension( other )
				local int = getElementInterior( other )			
				outputChatBox( "Has reconectado a " .. name .. ".", player, 0, 255, 153 )
				if getElementData(player, "enc") then
					outputChatBox( "Alguien te ha reconectado.", other, 0, 255, 153 )
				else
					outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha reconectado.", other, 0, 255, 153 )	
				end
				outputChatBox(" En 5 segundos reconectarás automáticamente al servidor.", other, 0, 255, 153 )
				setTimer(redirectPlayer, 5000, 1, other, "", 0)
				exports.items:guardarArmas(other, true)
				spawnPlayer( other, x, y, z, rot, skin, int, dim )
				fadeCamera( other, true )
				setCameraTarget( other, other )
				setCameraInterior( other, int )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "desbug",
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then	
				local x, y, z = getElementPosition( other )
				local rot = getElementRotation( other )
				local skin = getElementModel( other )
				local dim = getElementDimension( other )
				local int = getElementInterior( other )			
				outputChatBox( "Has desbugeado a " .. name .. ".", player, 0, 255, 153 )
				if getElementData(player, "enc") then
					outputChatBox( "Alguien te ha desbugeado.", other, 0, 255, 153 )
				else
					outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha desbugeado.", other, 0, 255, 153 )	
				end
				exports.items:guardarArmas(other, true)
				if dim > 0 then
					local px, py, pz, pdim, pint = exports.interiors:getPos(dim)
					spawnPlayer( other, px, py, pz, rot, skin, pint, pdim )
				else
					spawnPlayer( other, x, y, z, rot, skin, pint, pdim )
				end
				fadeCamera( other, true )
				setCameraTarget( other, other )
				setCameraInterior( other, int )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "mandarls",
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if getElementData(other, "tjail") and getElementData(other, "tjail") >= 1 then outputChatBox("Este jugador está en jail administrativo.", player, 255, 0, 0) return end
				if getElementData(other, "ajail") and getElementData(other, "ajail") >= 1 then outputChatBox("Este jugador está arrestado en la comisaria.", player, 255, 0, 0) return end
				outputChatBox( "Has mandado a Los Santos a " .. name .. ".", player, 0, 255, 153 )
				staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha mandado a Los Santos a "..getPlayerName( other ):gsub( "_", " " ) ..".")
				outputChatBox( "El Staff "..getPlayerName( player ):gsub( "_", " " ) .. " te ha mandado a Los Santos.", other, 0, 255, 153 )
				removePedFromVehicle ( other ) 
				setElementPosition(other, 1496.6, -1649.43, 14.05 )
				setElementDimension(other,0)
				setElementInterior(other,0)
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "get",
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local x, y, z = getElementPosition( player )
				if other ~= player then
					if getElementData(other, "spec") == true then outputChatBox("Este jugador está en spec. No puedes darle TP.", player, 255, 0, 0) return end
					if exports.freecam:isPlayerFreecamEnabled( other ) then outputChatBox("Este jugador está en freecam. No puedes darle TP.", player, 255, 0, 0) return end
					if getElementData(other, "tjail") and getElementData(other, "tjail") >= 1 then outputChatBox("Este jugador está en jail administrativo.", player, 255, 0, 0) return end
					if getElementData(other, "ajail") and getElementData(other, "ajail") >= 1 then outputChatBox("Este jugador está arrestado en la comisaria.", player, 255, 0, 0) return end
					local teleported = false
					local vehicle = getPedOccupiedVehicle( player )
					if vehicle then
						if isVehicleLocked(vehicle) then setVehicleLocked ( vehicle, false ) end
						for i = 0, getVehicleMaxPassengers( vehicle ) do
							local p = getVehicleOccupant( vehicle, i )
							if not p then
								setElementPosition( other, x, y, z + 3)
								setElementInterior( other, getElementInterior( vehicle ) )
								setElementDimension( other, getElementDimension( vehicle ) )
								warpPedIntoVehicle( other, vehicle, i )
								teleported = true
								break
							end
						end
						if not teleported then
							teleport( other, x + 1, y, z, getElementInterior( player ), getElementDimension( player ) )
							outputChatBox( "Has transportado a " .. name .. " hacia ti.", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha transportado hacia él.", other, 0, 255, 153 )
						end
					else
						if teleported or teleport( other, x + 1, y, z, getElementInterior( player ), getElementDimension( player ) ) then
							outputChatBox( "Has transportado a " .. name .. " hacia ti.", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha transportado hacia él.", other, 0, 255, 153 )
						end
					end
				else
					outputChatBox( "(( No te puedes teletransportar a ti mismo. ))", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "goto",
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local x, y, z = getElementPosition( other )
				if other ~= player then
					if getElementData(other, "spec") == true then outputChatBox("Este jugador está en spec. No puedes darte TP.", player, 255, 0, 0) return end
					local teleported = false
					local vehicle = getPedOccupiedVehicle( other )
					if vehicle then
						if isVehicleLocked(vehicle) then setVehicleLocked ( vehicle, false ) end
						for i = 0, getVehicleMaxPassengers( vehicle ) do
							local p = getVehicleOccupant( vehicle, i )
							if not p then		
								setElementPosition( player, x, y, z + 3)
								setElementInterior( player, getElementInterior( vehicle ) )
								setElementDimension( player, getElementDimension( vehicle ) )
								warpPedIntoVehicle( player, vehicle, i )
								teleported = true
								break
							end
						end
						if not teleported then
							teleport( player, x + 1, y, z, getElementInterior( other ), getElementDimension( other ) )
							outputChatBox( "Te has transportado a " .. name .. ".", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " se ha transportado hacia ti.", other, 0, 255, 153 )
						end
					else	
						if teleported or teleport( player, x + 1, y, z, getElementInterior( other ), getElementDimension( other ) ) then
							outputChatBox("Te has transportado a " .. name .. ".", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " se ha transportado hacia ti.", other, 0, 255, 153 )
						end
					end
				else
					outputChatBox( "(( No te puedes teletransportar hacia ti mismo ))", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "setname",
	function( player, commandName, otherPlayer, ... )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			local newName = ((...) and table.concat({...}, " ")) or "N/A"
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Nuevo nombre: " .. newName)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer and ( ... ) then
			local newName = table.concat( { ... }, " " ):gsub( "_", " " )
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if name == newName then
					outputChatBox( name .. " ya está utilizando ese nombre.", player, 255, 0, 0 )
				elseif newName:lower( ) == name:lower( ) or not exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s'", newName ) then
						if exports.sql:query_free( "UPDATE characters SET characterName = '%s' WHERE characterID = " .. exports.players:getCharacterID( other ), newName ) and setPlayerName( other, newName:gsub( " ", "_" ) ) then
							exports.players:updateNametag( other )
							triggerClientEvent( other, "updateCharacterName", other, exports.players:getCharacterID( other ), newName )
							outputChatBox( "Has cambiado el nombre de " .. name .. " a " .. newName .. ". Recuerda el cobro por el cambio.", player, 0, 255, 0 )
						    staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha cambiado el nombre de " .. name .. " a " .. newName .. ".")
						    exports.logsic:addLogMessage("setnamestaff", "El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha cambiado el nombre de " .. name .. " a " .. newName .. ".")
						else
							outputChatBox( "Error al cambiar el nombre " .. name .. " a " .. newName .. ".", player, 255, 0, 0 )
						end
				else
					outputChatBox( "Otro jugador ya está utilizando ese nombre.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [nombre nuevo]", player, 255, 255, 255 )
		end
	end,
	true
)
 
addCommandHandler( "pagostaff",
	function( player, commandName, otherPlayer, cantidad, ... )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			local razon = (...) and table.concat({...}, " ") or "N/A"
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Cantidad: " .. (cantidad or "N/A") .. ", Razón: " .. razon)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer and cantidad and ( ... ) then
			local razon = table.concat( { ... }, " " ):gsub( "_", " " )
			local cantidad = tonumber(cantidad)
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if exports.players:takeMoney(other, cantidad) then
					outputChatBox("Has cobrado a " ..tostring(name).. " " ..tostring(cantidad).. "$ por '"..tostring(razon).."'.", player, 0, 255, 0)
					outputChatBox("El staff " ..tostring(getPlayerName(player):gsub("_", " ")).. " te ha cobrado " ..tostring(cantidad).. "$ por '"..tostring(razon).."'.", other, 255, 255, 0)
					outputChatBox("Por seguridad, te recomendamos que tomes una SS (foto) pulsando al F12.", other, 255, 255, 0)
					exports.logsic:addLogMessage("pagostaff", "Nombre del afectado: "..tostring(name)..". $"..tostring(cantidad)..". Staff: "..getPlayerName(player)..". Razón: "..tostring(razon)..". \n")
				else
					outputChatBox( "Error al realizar el pago. Comprueba que tenga "..tostring(cantidad).."$ el jugador.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [cantidad] [razon]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "freeze", "unfreeze" },
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if player and other then
					local frozen = isElementFrozen( other )
					if frozen then
						outputChatBox( "Has descongelado a " .. name .. ".", player, 0, 255, 153 )
						if player ~= other then
							outputChatBox( "Has sido descongelado por " .. getPlayerName( player ):gsub("_", " ") .. ".", other, 0, 255, 153 )
						end
					else
						outputChatBox( "Has congelado a " .. name .. ".", player, 0, 255, 153 )
						if player ~= other then
							outputChatBox( "Has sido congelado por " .. getPlayerName( player ):gsub("_", " ") .. ".", other, 0, 255, 153 )
						end
					end
					toggleAllControls( other, frozen, true, false )
					setElementFrozen( other, not frozen )
					local vehicle = getPedOccupiedVehicle( other )
					if vehicle then
						setElementFrozen( vehicle, not frozen )
					end
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "sethealth", "sethp" },
	function( player, commandName, otherPlayer, health )
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Vida: " .. (health or "N/A"))
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end
		
		local health = tonumber( health )
		if otherPlayer and health and health >= 0 and health <= 100 then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local oldHealth = getElementHealth( other )
				if health < 1 then
					if triggerEvent("onSufrirDamageCapitalRP", other, player, 0, 60, true) then
						outputChatBox( "Has matado a " .. name .. ".", player, 0, 255, 153 )
						outputChatBox( "El staff " .. getPlayerName(player):gsub("_", " ") .. " te ha matado.", other, 0, 255, 153 )
					end
				elseif setElementHealth( other, health ) then
					removeElementData(other, "muerto")
					outputChatBox( "Has cambiado la vida de " .. name .. " a " .. health .. ".", player, 0, 255, 153 )
					if getElementData(player, "enc") then
						outputChatBox( "Alguien te ha cambiado la vida a "..health.. ".", other, 0, 255, 153 )
					else
						outputChatBox( "El staff " .. getPlayerName(player):gsub("_", " ") .. " te ha cambiado la vida a "..health.. ".", other, 0, 255, 153 )
					    staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha cambiado la vida ("..health.. ") al usuario "..getPlayerName( other ):gsub( "_", " " ) ..".")
					end
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [health]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler("kick",
	function(player, commandName, otherPlayer, ...)
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			local reason = (...) and table.concat({...}, " ") or "N/A"
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Razón: " .. reason)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end

		if otherPlayer then
			local other, name = exports.players:getFromName(player, otherPlayer, true)
			if other and name then
				local reason = table.concat({...}, " ")
				local serial = getPlayerSerial(other)
				kickPlayer(other, player, #reason > 0 and reason or "Sin motivo")
				outputChatBox("[STAFF] "..getPlayerName(player).." kickeó a "..name..". Razón: "..(#reason > 0 and reason or "Sin motivo")..".", root, 255, 100, 100)
			else
				outputChatBox("Jugador no encontrado.", player, 255, 0, 0)
			end
		else
			outputChatBox("Syntax: /"..commandName.." [player] [motivo]", player, 255, 255, 255)
		end
	end,
true
)


addCommandHandler("ban",
	function(player, commandName, otherPlayer, hours, ...)
		if not hasObjectPermissionTo(player, "command.modchat", false) then return end
		if not exports.players:getOption(player, "staffduty") then
			local reason = (...) and table.concat({...}, " ") or "N/A"
			logStaffCommandWithoutDuty(player, commandName, otherPlayer, "Horas: " .. (hours or "N/A") .. ", Razón: " .. reason)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
		end

		hours = tonumber(hours)
		if otherPlayer and hours and hours >= 0 and (...) then
			local other, name = exports.players:getFromName(player, otherPlayer, true)
			if other then
				local serial = getPlayerSerial(other)
				local reasonText = table.concat({...}, " ")
				local tiempo = (hours == 0 and "Permanente") or (hours < 1 and (math.ceil(hours*60).." minutos")) or (hours.." horas")
				local razonCompleta = reasonText.." ("..tiempo..")"

				if exports.sql:query_free("UPDATE wcf1_user SET banned = 1, banReason = '%s', banUser = "..exports.players:getUserID(player).." WHERE userID = "..exports.players:getUserID(other), reasonText) then
					banPlayer(other, true, false, false, player, reasonText, math.ceil(hours * 60 * 60))
					if serial then
						addBan(nil, nil, serial, player, razonCompleta.." ("..name..")", math.ceil(hours * 60 * 60))
					end
					outputChatBox("[STAFF] "..getPlayerName(player).." baneó a "..name..". Razón: "..razonCompleta..".", root, 255, 0, 0)
				end
			else
				outputChatBox("Jugador no encontrado.", player, 255, 0, 0)
			end
		else
			outputChatBox("Syntax: /"..commandName.." [player] [tiempo en horas, 0 = Permanente] [motivo]", player, 255, 255, 255)
		end
	end,
true
)


function obtenerDatos(p, c, op)
    if hasObjectPermissionTo(p, 'command.kick', false) then
		if not exports.players:getOption(p, "staffduty") then
			logStaffCommandWithoutDuty(p, c, op)
			return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", p, 255, 0, 0)
		end
		
        local o, n = exports.players:getFromName(p, op, true)
        local sqlh, userID, cID, serial, ip, username, charactername
        
        if o then
            -- Jugador conectado
            userID = exports.players:getUserID(o)
            cID = exports.players:getCharacterID(o)
            serial = getPlayerSerial(o)
            ip = getPlayerIP(o)
            username = exports.players:getUserName(o)
            charactername = n
            sqlh = exports.sql:query_assoc_single("SELECT horas FROM characters WHERE characterID = " .. tostring(cID))
            
            outputChatBox("Nombre: "..tostring(charactername)..". Cuenta: "..tostring(username).." . IP: "..tostring(ip).." . Nivel: "..tostring(exports.objetivos:getNivel(cID))..".", p, 0, 255, 0)
            outputChatBox("Serial: "..tostring(serial)..". cID: "..tostring(cID).." . uID: "..tostring(userID)..".", p, 0, 255, 0)
            outputChatBox("Horas jugadas (por personaje): "..tostring(sqlh and sqlh.horas or "0").." horas jugadas.", p, 0, 255, 0)
        else
            -- Buscar en la base de datos por charactername
            local query = exports.sql:query_assoc_single("SELECT * FROM characters WHERE charactername = '"..exports.sql:escape_string(op).."'")
            if query then
                userID = query.userID
                cID = query.characterID
                charactername = query.charactername
                local userQuery = exports.sql:query_assoc_single("SELECT username FROM users WHERE id = "..tostring(userID))
                username = userQuery and userQuery.username or "Desconocido"
                
                outputChatBox("Nombre: "..tostring(charactername).." (DESCONEXIÓN). Cuenta: "..tostring(username).." . cID: "..tostring(cID).." . uID: "..tostring(userID)..".", p, 255, 165, 0)
            else
                outputChatBox("No se encontró información del jugador: "..tostring(op), p, 255, 0, 0)
            end
        end
    end
end
addCommandHandler("capitaldatos", obtenerDatos)

function fecha( player, commandName, ... )
	if not hasObjectPermissionTo(player, "command.modchat", false) then return end
	if not exports.players:getOption(player, "staffduty") then
		local nombre = (...) and table.concat({...}, " ") or "N/A"
		logStaffCommandWithoutDuty(player, commandName, nil, "Nombre consultado: " .. nombre)
		return outputChatBox("Debes estar de servicio (/staffduty) para usar este comando.", player, 255, 0, 0)
	end
	
	if (...) then
		local nombre = table.concat( { ... }, " " )
		local f = exports.sql:query_assoc_single( "SELECT lastLogin FROM characters WHERE characterName = '%s'", nombre )
		if f then 
			outputChatBox(tostring(nombre).." se conectó la última vez el "..tostring(f.lastLogin), player, 0, 255, 0) 
		else
			outputChatBox("El nombre introducido es incorrecto o no existe.", player, 255, 0, 0)
			outputChatBox( "Syntax: /" .. commandName .. " [nombre del personaje a consultar sin la _]", player, 255, 255, 255 )
		end
	else
		outputChatBox( "Syntax: /" .. commandName .. " [nombre del personaje a consultar sin la _]", player, 255, 255, 255 )
	end
end 
addCommandHandler("fecha", fecha)

function checkAlEntrar()
	setPedStat(source, 71, 999)
	setPedStat(source, 72, 999)
	setPedStat(source, 76, 999)
	setPedStat(source, 77, 999)
	setPedStat(source, 78, 999)
	setPlayerHudComponentVisible(source, "vehicle_name", false)
	setPlayerHudComponentVisible(source, "radio", false)
end
addEventHandler("onCharacterLogin", getRootElement(), checkAlEntrar)


addEventHandler("onPlayerJoin",root,
function()
    setPedStat ( source, 70, 999 )
    setPedStat ( source, 71, 999 )
    setPedStat ( source, 72, 999 )
    setPedStat ( source, 74, 999 )
    setPedStat ( source, 76, 999 )
    setPedStat ( source, 77, 999 )
    setPedStat ( source, 78, 999 )
    setPedStat ( source, 79, 999 )
end
)

setWeaponProperty(23, "poor", "flag_move_and_aim", true ) 
setWeaponProperty( 24, "poor", "flag_move_and_aim",true) 
setWeaponProperty( 25, "poor", "flag_move_and_aim",true ) 
setWeaponProperty( 26, "poor", "flag_move_and_aim",true) 
setWeaponProperty( 27, "poor", "flag_move_and_aim", true ) 
setWeaponProperty( 29, "poor", "flag_move_and_aim", true ) 
setWeaponProperty( 30, "poor", "flag_move_and_aim", true ) 
setWeaponProperty( 31, "poor", "flag_move_and_aim",true ) 
setWeaponProperty( 33, "poor", "flag_move_and_aim", true) 
setWeaponProperty( 34, "poor", "flag_move_and_aim", true )
setWeaponProperty(23, "poor", "flag_move_and_shoot", true ) 
setWeaponProperty( 24, "poor", "flag_move_and_shoot",true) 
setWeaponProperty( 25, "poor", "flag_move_and_shoot",true ) 
setWeaponProperty( 26, "poor", "flag_move_and_shoot",true) 
setWeaponProperty( 27, "poor", "flag_move_and_shoot", true ) 
setWeaponProperty( 29, "poor", "flag_move_and_shoot", true ) 
setWeaponProperty( 30, "poor", "flag_move_and_shoot", true ) 
setWeaponProperty( 31, "poor", "flag_move_and_shoot",true ) 
setWeaponProperty( 33, "poor", "flag_move_and_shoot", true) 
setWeaponProperty( 34, "poor", "flag_move_and_shoot", true )
---
setWeaponProperty(23, "std", "flag_move_and_aim", true ) 
setWeaponProperty( 24, "std", "flag_move_and_aim",true) 
setWeaponProperty( 25, "std", "flag_move_and_aim",true ) 
setWeaponProperty( 26, "std", "flag_move_and_aim",true) 
setWeaponProperty( 27, "std", "flag_move_and_aim", true ) 
setWeaponProperty( 29, "std", "flag_move_and_aim", true ) 
setWeaponProperty( 30, "std", "flag_move_and_aim", true ) 
setWeaponProperty( 31, "std", "flag_move_and_aim",true ) 
setWeaponProperty( 33, "std", "flag_move_and_aim", true) 
setWeaponProperty( 34, "std", "flag_move_and_aim", true )
setWeaponProperty(23, "std", "flag_move_and_shoot", true ) 
setWeaponProperty( 24, "std", "flag_move_and_shoot",true) 
setWeaponProperty( 25, "std", "flag_move_and_shoot",true ) 
setWeaponProperty( 26, "std", "flag_move_and_shoot",true) 
setWeaponProperty( 27, "std", "flag_move_and_shoot", true ) 
setWeaponProperty( 29, "std", "flag_move_and_shoot", true ) 
setWeaponProperty( 30, "std", "flag_move_and_shoot", true ) 
setWeaponProperty( 31, "std", "flag_move_and_shoot",true ) 
setWeaponProperty( 33, "std", "flag_move_and_shoot", true) 
setWeaponProperty( 34, "std", "flag_move_and_shoot", true )
---
setWeaponProperty(23, "pro", "flag_move_and_aim", true ) 
setWeaponProperty( 24, "pro", "flag_move_and_aim",true) 
setWeaponProperty( 25, "pro", "flag_move_and_aim",true ) 
setWeaponProperty( 26, "pro", "flag_move_and_aim",true) 
setWeaponProperty( 27, "pro", "flag_move_and_aim", true ) 
setWeaponProperty( 29, "pro", "flag_move_and_aim", true ) 
setWeaponProperty( 30, "pro", "flag_move_and_aim", true ) 
setWeaponProperty( 31, "pro", "flag_move_and_aim",true ) 
setWeaponProperty( 33, "pro", "flag_move_and_aim", true) 
setWeaponProperty( 34, "pro", "flag_move_and_aim", true )
setWeaponProperty(23, "pro", "flag_move_and_shoot", true ) 
setWeaponProperty( 24, "pro", "flag_move_and_shoot",true) 
setWeaponProperty( 25, "pro", "flag_move_and_shoot",true ) 
setWeaponProperty( 26, "pro", "flag_move_and_shoot",true) 
setWeaponProperty( 27, "pro", "flag_move_and_shoot", true ) 
setWeaponProperty( 29, "pro", "flag_move_and_shoot", true ) 
setWeaponProperty( 30, "pro", "flag_move_and_shoot", true ) 
setWeaponProperty( 31, "pro", "flag_move_and_shoot",true ) 
setWeaponProperty( 33, "pro", "flag_move_and_shoot", true) 
setWeaponProperty( 34, "pro", "flag_move_and_shoot", true )

function createStaffTimesTable()
    local query = [[
    CREATE TABLE IF NOT EXISTS staff_times (
        userID INTEGER PRIMARY KEY,
        playerName TEXT,
        totalServiceTime INTEGER NOT NULL DEFAULT 0
    );
    ]]
    dbExec(dbConnect("sqlite", "staff_times.db"), query)
end
createStaffTimesTable()

function guardarTiempoDeServicio(player)
    if exports.players:isLoggedIn(player) then
        local userID = getElementData(player, "userID")
        local playerName = getElementData(player, "playerName")
        local startTime = getElementData(player, "staffDutyStartTime")
    
    if startTime then
        local currentTime = getRealTime().timestamp
        local timeInService = currentTime - startTime

        if timeInService < 0 then timeInService = 0 end

        local db = dbConnect("sqlite", "staff_times.db")
        local query = "SELECT totalServiceTime FROM staff_times WHERE userID = ?"
        local result = dbPoll(dbQuery(db, query, userID), -1)
        local totalTime = (result and result[1] and tonumber(result[1].totalServiceTime) or 0) + timeInService

	  dbExec(db, "REPLACE INTO staff_times (userID, playerName, totalServiceTime) VALUES (?, ?, ?)", userID, playerName, totalTime)

        local timeString = string.format("%02d:%02d:%02d", math.floor(timeInService / 3600), math.floor((timeInService % 3600) / 60), timeInService % 60)
        local totalTimeString = string.format("%02d:%02d:%02d", math.floor(totalTime / 3600), math.floor((totalTime % 3600) / 60), totalTime % 60)

        local discordMessage = {
            title = "Salida del Servicio Staff",
            description = 
                "> [ + ] Nombre: **" .. playerName .. "**\n" ..
                "> [ + ] UserID: **" .. tostring(userID) .. "**\n" ..
                "> [ + ] Tiempo en servicio: **" .. (timeString or "N/A") .. "**\n" ..
                "> [ + ] Tiempo Total: **" .. (totalTimeString or "N/A") .. "**",
            color = 16711680,
            footer = {
                text = "By Jeicordero",
                icon_url = "https://imgur.com/n3378F1"
            },
            timestamp = "now"
        }

        exports.discord_webhooks:sendToURL(
            "https://discord.com/api/webhooks/1407618304301863014/Xsm5ZzSaay8aGOVC0WzMsuTvpogDr8TmvGByJm6mO2qB_eQ1QoSKCoH1vtnIv0SyE238",
            discordMessage
        )
        removeElementData(player, "staffDutyStartTime")
    end
end
end


addCommandHandler({ "staffduty", "adminduty", "modduty", "helperduty" },
    function(player, commandName)
        outputServerLog("[STAFFDUTY] Comando ejecutado por: " .. getPlayerName(player))
        local old = exports.players:getOption(player, "staffduty")
        outputServerLog("[STAFFDUTY] Estado anterior: " .. tostring(old))
        local hasPermission = hasObjectPermissionTo(player, 'command.modchat', false)
        outputServerLog("[STAFFDUTY] Tiene permisos command.modchat: " .. tostring(hasPermission))
        if not hasPermission then
            outputChatBox("No tienes permisos para usar este comando. Necesitas el permiso 'command.modchat'.", player, 255, 0, 0)
            outputServerLog("[STAFFDUTY] ERROR: " .. getPlayerName(player) .. " no tiene permisos command.modchat")
            return
        end
        local newValue = old ~= true
        outputServerLog("[STAFFDUTY] Intentando cambiar staffduty de " .. tostring(old) .. " a " .. tostring(newValue))
        if exports.players:setOption(player, "staffduty", newValue) then
            outputServerLog("[STAFFDUTY] setOption exitoso. Nuevo estado: " .. tostring(exports.players:getOption(player, "staffduty")))
            exports.players:updateNametag(player)
            
            local playerName = getPlayerName(player):gsub("_", " ")
            local userID = exports.players:getUserID(player)
            local discordColor = old and 16711680 or 65280
            local dutyStatus = old and "Salida del Servicio" or "Ingreso en el Servicio"
            local currentTime = getRealTime().timestamp

            if not old then
                setElementData(player, "staffDutyStartTime", currentTime)
                
                local discordMessage = {
                    title = dutyStatus .. " Staff",
                    description = string.format("> [ + ] Nombre: **%s**\n> [ + ] UserID: **%d**\n", playerName, userID),
                    color = discordColor,
                    footer = {
                        text = "By Jeicordero",
                        icon_url = "https://imgur.com/n3378F1"
                    },
                    timestamp = "now"
                }

                exports.discord_webhooks:sendToURL(
                    "https://discord.com/api/webhooks/1407618304301863014/Xsm5ZzSaay8aGOVC0WzMsuTvpogDr8TmvGByJm6mO2qB_eQ1QoSKCoH1vtnIv0SyE238",
                    discordMessage
                )
                
            else
                guardarTiempoDeServicio(player)
            end

            local message = playerName .. " " .. (old and "está ahora fuera" or "está ahora") .. " de servicio (" .. exports.players:getID(player) .. ")."
            local groups = exports.players:getGroups(player)
            triggerEvent("onAvisarDudas", player, player)
            
            if groups and #groups >= 1 then
                message = groups[1].displayName .. " " .. message
            end
            
            if exports.players:getOption(player, "staffduty") == true then
                setElementData(player, "account:gmduty", true)
            else
                setElementData(player, "account:gmduty", false)
            end	

            for key, value in ipairs(getElementsByType("player")) do
                if value ~= player and groups and groups[1] and groups[1].displayName ~= "Encubierto" and groups[1].displayName ~= "Admin Supremo" and groups[1].displayName ~= "Administrador" and groups[1].displayName ~= "Programador" then
                    outputChatBox(message, value, old and 255 or 0, old and 191 or 255, 0)
                end
            end
            
            -- Mensaje de confirmación al jugador
            if exports.players:getOption(player, "staffduty") == true then
                outputChatBox("Has entrado en servicio de staff.", player, 0, 255, 0)
            else
                outputChatBox("Has salido de servicio de staff.", player, 255, 191, 0)
            end
        else
            outputChatBox("Error al cambiar el estado de servicio. Intenta de nuevo.", player, 255, 0, 0)
            outputServerLog("[STAFFDUTY] ERROR: setOption falló para " .. getPlayerName(player))
        end
    end,
    false
)

addEventHandler("onCharacterLogin", root, function()
    if exports.players:isLoggedIn(source) then
        local playerName = getPlayerName(source):gsub("_", " ")
        local userID = exports.players:getUserID(source)
        setElementData(source, "playerName", playerName)
        setElementData(source, "userID", userID)
    end
end)

addEventHandler("onCharacterLogout", root, function()
    if exports.players:isLoggedIn(source) and getElementData(source, "staffDutyStartTime") then
        guardarTiempoDeServicio(source)
        exports.players:setOption(source, "staffduty", false)
        setElementData(source, "account:gmduty", false)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if exports.players:isLoggedIn(source) and getElementData(source, "staffDutyStartTime") then
        guardarTiempoDeServicio(source)
        exports.players:setOption(source, "staffduty", false)
        setElementData(source, "account:gmduty", false)
    end
end)

function formatearTiempo(segundos)
    local horas = math.floor(segundos / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    local segundos = segundos % 60
    return string.format("%02d:%02d:%02d", horas, minutos, segundos)
end

function verHorasStaff(player)
    local db = dbConnect("sqlite", "staff_times.db")
    local query = "SELECT userID, playerName, totalServiceTime FROM staff_times ORDER BY totalServiceTime DESC"
    local result = dbPoll(dbQuery(db, query), -1)

    if result and #result > 0 then
        local chatMessages = {}
        local discordMessages = {}
        local chatMessage = "Listado de Staff por Tiempo en Duty:\n"
        local logMessage = ""
        local limiteChat = 256
        local limiteDiscord = 1900
        local discordCounter = 1

        for _, row in ipairs(result) do
            local userID = row.userID
            local playerName = row.playerName or "N/A"
            local totalTime = row.totalServiceTime
            local timeFormatted = formatearTiempo(totalTime)

            local chatLinea = string.format("%d. %s - %s\n", userID, playerName, timeFormatted)

            local discordLinea = 
                "> [ + ] Nombre: **" .. playerName .. "**\n" ..
                "> [ + ] UserID: **" .. tostring(userID) .. "**\n" ..
                "> [ + ] Tiempo Total: **" .. timeFormatted .. "**\n\n"

            if #chatMessage + #chatLinea > limiteChat then
                table.insert(chatMessages, chatMessage)
                chatMessage = ""
            end
            chatMessage = chatMessage .. chatLinea

            if #logMessage + #discordLinea > limiteDiscord then
                table.insert(discordMessages, {
                    header = discordCounter .. ") Listado de Staff por Tiempo en Duty",
                    content = logMessage
                })
                logMessage = ""
                discordCounter = discordCounter + 1
            end
            logMessage = logMessage .. discordLinea
        end

        if #chatMessage > 0 then
            table.insert(chatMessages, chatMessage)
        end
        if #logMessage > 0 then
            table.insert(discordMessages, {
                header = discordCounter .. ") Parte Listado de Staff por Tiempo en Duty",
                content = logMessage
            })
        end

        for _, mensaje in ipairs(chatMessages) do
            outputChatBox(mensaje, player, 0, 255, 0, true)
        end

        for _, mensaje in ipairs(discordMessages) do
            local discordMessage = {
                title = mensaje.header,
                description = mensaje.content,
                color = 3447003,
                footer = {
                    text = "By Jeicordero",
                    icon_url = "https://imgur.com/n3378F1"
                },
                timestamp = "now"
            }

            exports.discord_webhooks:sendToURL(
                "https://discord.com/api/webhooks/1407618304301863014/Xsm5ZzSaay8aGOVC0WzMsuTvpogDr8TmvGByJm6mO2qB_eQ1QoSKCoH1vtnIv0SyE238",
                discordMessage
            )
        end
    else
        outputChatBox("No se encontraron registros de tiempo en duty.", player, 255, 0, 0, true)
    end
end

addCommandHandler("verhorastaff", function(player)
    if exports.players:isLoggedIn(player) and hasObjectPermissionTo(player, "command.adminchat", false) then
        verHorasStaff(player)
    else
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
    end
end)

function limpiarHorasStaff(player)
    local db = dbConnect("sqlite", "staff_times.db")
    if dbExec(db, "DELETE FROM staff_times") then
        outputChatBox("Todas las horas de los staffs han sido limpiadas.", player, 0, 255, 0, true)

        local discordMessage = {
            title = "Limpieza de Horas de Staff",
            description = "**Todas las horas de los staffs han sido limpiadas por " .. getPlayerName(player):gsub("_", " ") .. "**",
            color = 15158332,
            footer = {
                text = "By Jeicordero",
                icon_url = "https://imgur.com/n3378F1"
            },
            timestamp = "now"
        }

        exports.discord_webhooks:sendToURL(
            "https://discord.com/api/webhooks/1407618304301863014/Xsm5ZzSaay8aGOVC0WzMsuTvpogDr8TmvGByJm6mO2qB_eQ1QoSKCoH1vtnIv0SyE238",
            discordMessage
        )
    else
        outputChatBox("Hubo un error al intentar limpiar las horas de los staffs.", player, 255, 0, 0, true)
    end
end

addCommandHandler("limpiarhorasstaff", function(player)
    if exports.players:isLoggedIn(player) and hasObjectPermissionTo(player, "command.adminchat", false) then
        limpiarHorasStaff(player)
    else
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
    end
end)

function sumarHorasStaff(player, command, userID, horas, minutos, segundos)
    userID = tonumber(userID)
    horas = tonumber(horas) or 0
    minutos = tonumber(minutos) or 0
    segundos = tonumber(segundos) or 0

    if not userID then
        outputChatBox("Uso: /sumarhorasstaff [userID] [horas] [minutos] [segundos]", player, 255, 255, 0, true)
        return
    end

    local tiempoTotalAgregar = (horas * 3600) + (minutos * 60) + segundos

    local db = dbConnect("sqlite", "staff_times.db")
    local query = "SELECT totalServiceTime, playerName FROM staff_times WHERE userID = ?"
    local result = dbPoll(dbQuery(db, query, userID), -1)
    local totalTime = (result and result[1] and tonumber(result[1].totalServiceTime) or 0) + tiempoTotalAgregar
    local playerName = "Desconocido"

    -- Intentar obtener el nombre del jugador si está conectado
    for _, p in ipairs(getElementsByType("player")) do
        if exports.players:getUserID(p) == userID then
            local tempName = getPlayerName(p)
            if tempName then
                playerName = tempName:gsub("_", " ")
            end
            break
        end
    end

    -- Si no encontramos el jugador conectado, usar el nombre guardado en la base de datos
    if playerName == "Desconocido" and result and result[1] and result[1].playerName then
        playerName = result[1].playerName
    end

    if dbExec(db, "REPLACE INTO staff_times (userID, playerName, totalServiceTime) VALUES (?, ?, ?)", userID, playerName, totalTime) then
        outputChatBox("Tiempo agregado correctamente al staff con userID: " .. userID, player, 0, 255, 0, true)

        local timeFormatted = formatearTiempo(tiempoTotalAgregar)
        local totalFormatted = formatearTiempo(totalTime)
        
        local discordMessage = {
            title = "Suma de Horas al Staff",
            description = 
                "> [ + ] Nombre: **" .. playerName .. "**\n" ..
                "> [ + ] UserID: **" .. tostring(userID) .. "**\n" ..
                "> [ + ] Tiempo agregado: **" .. timeFormatted .. "**\n" ..
                "> [ + ] Tiempo Total: **" .. totalFormatted .. "**",
            color = 3066993,
            footer = {
                text = "By Jeicordero",
                icon_url = "https://imgur.com/n3378F1"
            },
            timestamp = "now"
        }

        exports.discord_webhooks:sendToURL(
            "https://discord.com/api/webhooks/1407618304301863014/Xsm5ZzSaay8aGOVC0WzMsuTvpogDr8TmvGByJm6mO2qB_eQ1QoSKCoH1vtnIv0SyE238",
            discordMessage
        )
    else
        outputChatBox("Hubo un error al intentar sumar horas al staff.", player, 255, 0, 0, true)
    end
end

addCommandHandler("sumarhorastaff", function(player, command, userID, horas, minutos, segundos)
    if exports.players:isLoggedIn(player) and hasObjectPermissionTo(player, "command.adminchat", false) then
        sumarHorasStaff(player, command, userID, horas, minutos, segundos)
    else
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
    end
end)

-- addCommandHandler( "vip",
	-- function( player, commandName )
		-- local old = exports.players:getOption( player, "vip" )
		-- if hasObjectPermissionTo(player, 'command.vip', false) then
		-- if exports.players:setOption( player, "vip", old ~= true or false ) then
			-- exports.players:updateNametag( player )
		    -- if exports.players:getOption( player, "vip" ) == true then
			-- outputChatBox("Has #33cc33activado#ff00ff el color vip en el tabulador", player, 255, 0, 255,true)
			-- outputChatBox("Si necesitas soporte VIP presiona (F1) o usa /ayudavip.", player, 255, 255, 0)
		    -- outputDebugString( "El usuario " .. getPlayerName(player):gsub("_", " ") .. " se ha colocado el color VIP." )
			-- else
			-- outputChatBox("Has #ff3300desactivado#ff00ff el color vip en el tabulador", player, 255, 0, 255,true)
			-- outputChatBox("Si necesitas soporte VIP presiona (F1) o usa /ayudavip.", player, 255, 255, 0)
			-- outputDebugString( "El usuario " .. getPlayerName(player):gsub("_", " ") .. " se ha quitado el color VIP." )
			-- end	
		-- end
		-- end
	-- end,
	-- true
-- )



function getStaff( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.acceptreport", false ) then
			if not duty or exports.players:getOption( value, "staffduty" ) then
				t[ #t + 1 ] = value
			end
		end
	end
	return t
end

function staffMessageAdmin( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 0, 0 )
	end
end

function cambiarClave(player, cmd, targetUsername, nuevaPassword)
    if not targetUsername or not nuevaPassword then
        outputChatBox("Syntax: /cambiarclave [usuario] [nueva clave]", player, 255, 255, 255)
        return
    end

    -- Verificar si el jugador tiene permisos de "Desarrollador"
    if not isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Desarrollador")) then
        outputChatBox("No tienes permisos para cambiar contraseñas.", player, 255, 0, 0)
        return
    end

    -- Intentar cambiar la contraseña en la base de datos
    if setPassword(targetUsername, nuevaPassword) then
        outputChatBox("Has cambiado la clave del usuario "..targetUsername.." correctamente en la base de datos.", player, 0, 255, 0)
    else
        outputChatBox("No se pudo cambiar la clave de "..targetUsername..". Verifica si el usuario existe en la base de datos.", player, 255, 0, 0)
    end
end
addCommandHandler("cambiarclave", cambiarClave)


function consultaIdiomas(player)
	outputChatBox("~~Lista de idiomas~~", player, 255, 255, 0)
	idi = 0
	for k, v in ipairs(exports.players:getLanguages()) do
		if idi == 0 then
			mens = v[1] .. " - " .. v[2]
			idi = 1
		else
			outputChatBox(mens .. " - " .. v[1] .. " - " .. v[2], player, 0, 255, 0)
			idi = 0
		end
	end
end
addCommandHandler("idiomas", consultaIdiomas)
	
-- function darIdioma(player, cmd, otherPlayer, codigo)
	-- if player and hasObjectPermissionTo(player, "command.kick", false) then
		-- if not otherPlayer or not codigo then outputChatBox("Sintaxis: /daridioma [jugador] [código de idioma de 2 letras]", player, 255, 255, 255) return end
		-- local other, name = exports.players:getFromName(player, otherPlayer)
		-- if other then
			-- if exports.players:isValidLanguage(tostring(codigo)) and exports.players:learnLanguage(other, tostring(codigo)) then
				-- outputChatBox("Has dado correctamente a " .. name .. " el idioma código " .. tostring(codigo), player, 0, 255, 0 )
				-- outputChatBox("El staff " .. getPlayerName(player):gsub("_", " ") .. " te ha dado un idioma (Tecla L)", other, 0, 255, 0)
				-- exports.logsic:addLogMessage("daridioma", "El staff " .. getPlayerName(player):gsub("_", " ") .. " ha dado a " .. name .. " el idioma código " .. tostring(codigo) )
			-- else
				-- outputChatBox("Se ha producido un error. Revisa que el código del idioma sea el correcto.", player, 255, 0, 0)
			-- end
		-- end
	-- else
		-- outputChatBox("(( Acceso denegado ))", player, 255, 0, 0)
	-- end
-- end
-- addCommandHandler("daridioma", darIdioma)

-- Modificar la función teleport para que sea global en lugar de local
function teleport( player, x, y, z, interior, dimension )
	if isPedInVehicle( player ) and getPedOccupiedVehicleSeat( player ) == 0 then
		local vehicle = getPedOccupiedVehicle( player )
		setElementPosition( vehicle, x, y, z )
		setElementInterior( vehicle, interior )
		setElementDimension( vehicle, dimension )
		
		for i = 0, getVehicleMaxPassengers( vehicle ) do
			local p = getVehicleOccupant( vehicle, i )
			if p then
				setElementInterior( p, interior )
				setElementDimension( p, dimension )
			end
		end
		
		setElementAngularVelocity( vehicle, 0, 0, 0 )
		setElementVelocity( vehicle, 0, 0, 0 )
		return true
	else
		if isPedInVehicle( player ) then
			removePedFromVehicle( player )
		end
		setElementPosition( player, x, y, z )
		setElementInterior( player, interior )
		setElementDimension( player, dimension )
		return true
	end
end

addCommandHandler({ "adminactivo", "staffon" },
    function(player, commandName, ...)
        if exports.players:isLoggedIn(player) then
            outputChatBox("Equipo Administrativo en línea:", player, 0, 255, 255)
            local count = 0
            local admins = {}

            for _, value in ipairs(getElementsByType("player")) do
                local groups = exports.players:getGroups(value)

                if groups and not getElementData(value, "enc") then  -- 🔥 Aquí se filtran los encubiertos
                    for _, group in ipairs(groups) do
                        if group.groupID == 1 or group.groupID == 2 or group.groupID == 3 or group.groupID == 12 or group.groupID == 13 then
                            local title = group.displayName
                            local duty = exports.players:getOption(value, "staffduty")
                            local pm = getElementData(value, "pm", true)

                            table.insert(admins, {
                                id = exports.players:getID(value),
                                title = title,
                                username = exports.players:getUserName(value),
                                name = getPlayerName(value):gsub("_", " "),
                                duty = duty,
                                pm = pm
                            })

                            count = count + 1
                            break
                        end
                    end
                end
            end

            if count > 0 then
                for _, admin in ipairs(admins) do
                    outputChatBox(" [" .. admin.id .. "] " .. admin.title .. " [" .. tostring(admin.username) .. "] " .. admin.name ..
                        (admin.duty and " - #00FF00De servicio" or " - Fuera de servicio") ..
                        (admin.pm and " - #00FF00PM On" or " #FFFFFF- PM Off"),
                        player, 255, 255, 255, true)
                end
            else
                outputChatBox("No hay administradores en línea.", player, 255, 0, 0)
            end
        end
    end
)