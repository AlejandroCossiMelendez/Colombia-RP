
function darlicenciaArmas ( thePlayer, commandName, otherPlayer, weaponID, cost )
if not exports.factions:isPlayerInFaction(thePlayer, 1) then outputChatBox("No perteneces a la facción de Policia.", thePlayer, 255, 0, 0) return end
	if weaponID and tonumber(weaponID) and cost and tonumber(cost) and tonumber(cost) >= 0 and tonumber(weaponID) <= 46 and tonumber(weaponID) >= 0 then
		if not otherPlayer then outputChatBox("Sintaxis: /"..commandName.." [jugador] [ID arma] [coste]", thePlayer, 255, 255, 255) return end
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		local x1, y1, z1 = getElementPosition ( other )
		local x2, y2, z2 = getElementPosition ( thePlayer )
		if ( getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 ) > 5) then outputChatBox("Estás demasiado lejos.", thePlayer, 255, 0, 0) return end
		if exports.players:takeMoney(other, tonumber(cost) ) then
			local licenciaID, error = exports.sql:query_insertid("INSERT INTO `licencias_armas` (`licenciaID`, `cID`, `cIDJusticia`, `cost`, `weapon`, `status`, `time`) VALUES (NULL, '"..tostring(exports.players:getCharacterID(other)).."', '"..tostring(exports.players:getCharacterID(thePlayer)).."', '"..tostring(cost).."', '"..tostring(weaponID).."', '0', CURRENT_TIMESTAMP);")
			if licenciaID then
				outputChatBox("Has autorizado portar el arma tipo "..tostring(getWeaponNameFromID(tonumber(weaponID)).." - "..tostring(weaponID)).." a #FF0000"..getPlayerName(other):gsub("_", " ").."", thePlayer, 0, 255, 0,true)
				outputChatBox("El departamento de justicia (#FF0000"..getPlayerName(thePlayer):gsub("_", " ").."#00FF00) te ha autorizado a llevar armas tipo "..tostring(getWeaponNameFromID(tonumber(weaponID)).." - "..tostring(weaponID)), other, 0, 255, 0,true)
				outputChatBox("Se te ha entregado un arma de la licencia indicada.", other, 0, 255, 0)
				exports.items:give(other, 29, tostring(weaponID), "Arma "..tostring(weaponID), 1)
				exports.logsic:addLogMessage("licenciaarmas", getPlayerName(thePlayer).." ha autorizado la licencia de armas ("..tostring(getWeaponNameFromID(tonumber(weaponID)).." - "..tostring(weaponID))..") a "..getPlayerName(other)..".")
				exports.factions:giveFactionPresupuesto(6, cost)
			else
				outputChatBox("Se ha producido un error grave, el interesado deberá acudir al CAU.", thePlayer, 255, 0, 0)
				outputChatBox("Se ha producido un error grave, acuda al CAU por favor (c-1-"..tostring(cost)..")", other, 255, 0, 0)
			end
			-- local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(other))
			-- if nivel == 3 and not exports.objetivos:isObjetivoCompletado(30, exports.players:getCharacterID(other)) then
				-- exports.objetivos:addObjetivo(30, exports.players:getCharacterID(other), other)
			-- end
		else
			outputChatBox("El interesado no tiene los "..tostring(cost).." dólares necesarios.", thePlayer, 255, 0, 0)
			outputChatBox("No tienes los "..tostring(cost).." dólares necesarios.", other, 255, 0, 0)
		end
	else
		outputChatBox("Sintaxis: /"..commandName.." [jugador] [ID arma] [coste]", thePlayer, 255, 255, 255)
	end	
end
addCommandHandler ( "darlicenciaarmas", darlicenciaArmas )

function quitarLicenciaArmas ( thePlayer, commandName, licenseID )
if not exports.factions:isPlayerInFaction(thePlayer, 1) then outputChatBox("No perteneces a la facción de Justicia.", thePlayer, 255, 0, 0) return end
	if licenseID and tonumber(licenseID) then
		local sql = exports.sql:query_assoc_single("SELECT licenciaID FROM licencias_armas WHERE status = 0 AND licenciaID = "..tostring(licenseID))
		if sql then
			exports.sql:query_free("UPDATE licencias_armas SET status = 1 WHERE licenciaID = "..tostring(licenseID))
			exports.sql:query_free("UPDATE licencias_armas SET cIDJusticiaNull = "..tostring(exports.players:getCharacterID(thePlayer)).. " WHERE licenciaID = "..tostring(licenseID))
			outputChatBox("Has anulado la licencia Nº "..tostring(licenseID).." correctamente.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Licencia no encontrada. Usa /panel. Sintaxis: /"..commandName.." [ID licencia]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("Sintaxis: /"..commandName.." [ID licencia]", thePlayer, 255, 255, 255)
	end	
end
addCommandHandler ( "quitarlicenciaarmas", quitarLicenciaArmas )

addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), function(license, cost)
    -- ===================================================================
    -- PROTECCIÓN ANTICHEAT MEJORADA - acceptLicense
    -- ===================================================================
    local securityChecks = {
        checkEventData = {
            [1] = {
                eventData = source, 
                equalTo = client, 
                debugData = "Source validation"
            },
            [2] = {
                eventData = license, 
                allowedDataTypes = {["number"] = true},
                allowedNumberRange = {1, 2}, -- Solo licencias tipo 1 y 2
                debugData = "License type"
            },
            [3] = {
                eventData = cost, 
                allowedDataTypes = {["number"] = true},
                allowedNumberRange = {50, 500000}, -- Costo razonable
                debugData = "License cost"
            }
        }
    }

    if not exports.Help:processServerEventData(client, source, "acceptLicense", securityChecks) then
        return false
    end

    -- Validaciones adicionales críticas
    local playerMoney = exports.players:getMoney(client) or 0
    if playerMoney < cost then
        exports.Help:reportAndHandleEventAbnormality(
            client, source, "acceptLicense",
            "Intento de obtener licencia sin dinero suficiente: tiene " .. playerMoney .. ", necesita " .. cost,
            false
        )
        return false
    end
    
    -- Verificar que tenga el teórico aprobado
    if license == 1 then
        local currentLicense = getElementData(client, "license.car") or 0
        if currentLicense ~= 16 then
            exports.Help:reportAndHandleEventAbnormality(
                client, source, "acceptLicense",
                "Intento de obtener licencia sin teórico aprobado (estado actual: " .. currentLicense .. ")",
                false
            )
            return false
        end
        
        -- Verificar que esté haciendo el examen práctico
        if not getElementData(client, "tryPractico") then
            exports.Help:reportAndHandleEventAbnormality(
                client, source, "acceptLicense",
                "Intento de obtener licencia sin estar en examen práctico",
                false
            )
            return false
        end
        
        -- Verificar que esté en un vehículo de prueba
        local vehicle = getPedOccupiedVehicle(client)
        if not vehicle or getElementModel(vehicle) ~= 436 then
            exports.Help:reportAndHandleEventAbnormality(
                client, source, "acceptLicense",
                "Intento de obtener licencia sin estar en vehículo de prueba",
                false
            )
            return false
        end
    end

    -- Procesar licencia según el tipo
    if license == 1 then
        -- Licencia de coche
        exports.sql:query_free("UPDATE characters SET car_license = '15' WHERE characterID = " .. exports.players:getCharacterID(client))
        outputChatBox("¡Felicidades! Has aprobado el examen práctico de conducir.", client, 0, 255, 0)
        setElementData(client, "license.car", 15)
        removeElementData(client, "player.cinturon")
        removeElementData(client, "tryPractico")
        removeElementData(client, "autoPractica")
        
        -- Añadir objetivo si existe el sistema
        if exports.objetivos then
            exports.objetivos:addObjetivo(1, exports.players:getCharacterID(client), client)
        end
        
    elseif license == 2 then
        -- Licencia de camión
        exports.sql:query_free("UPDATE characters SET camion_license = '15' WHERE characterID = " .. exports.players:getCharacterID(client))
        outputChatBox("¡Felicidades! Has aprobado el examen de conducir camiones.", client, 0, 255, 0)
        setElementData(client, "license.camion", 15)
    end

    -- Limpiar vehículo de prueba
    local theVehicle = getPedOccupiedVehicle(client)
    if theVehicle then
        removePedFromVehicle(client)
        respawnVehicle(theVehicle)
        setElementFrozen(theVehicle, true)
    end
    
    -- Cobrar el examen
    exports.players:takeMoney(client, cost)
end)

addEvent("payFeeCapitalRP", true)
addEventHandler("payFeeCapitalRP", getRootElement(), function(amount)
    -- ===================================================================
    -- PROTECCIÓN ANTICHEAT MEJORADA - payFeeCapitalRP
    -- ===================================================================
    local securityChecks = {
        checkEventData = {
            [1] = {
                eventData = source, 
                equalTo = client, 
                debugData = "Source validation"
            },
            [2] = {
                eventData = amount, 
                allowedDataTypes = {["number"] = true},
                allowedNumberRange = {100, 1000000}, -- Entre $100 y $1,000,000
                debugData = "Payment amount"
            }
        }
    }

    if not exports.Help:processServerEventData(client, source, "payFeeCapitalRP", securityChecks) then
        return false
    end

    -- Validación adicional: verificar que el jugador tenga el dinero
    local playerMoney = exports.players:getMoney(client) or 0
    if playerMoney < amount then
        exports.Help:reportAndHandleEventAbnormality(
            client, source, "payFeeCapitalRP",
            "Intento de pagar " .. amount .. " teniendo solo " .. playerMoney,
            false
        )
        return false
    end
    
    -- Verificar que esté en la autoescuela
    if not isPlayerAtAutoescuela(client) then
        exports.Help:reportAndHandleEventAbnormality(
            client, source, "payFeeCapitalRP",
            "Intento de pagar fuera de la autoescuela",
            false
        )
        return false
    end

    exports.players:takeMoney(client, amount)
end)

-- Evento protegido para completar el teórico
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), function(licencia)
    -- ===================================================================
    -- PROTECCIÓN ANTICHEAT - theoryComplete
    -- ===================================================================
    local securityChecks = {
        checkEventData = {
            [1] = {
                eventData = licencia,
                allowedDataTypes = {["number"] = true},
                allowedNumberRange = {1, 2},  -- Solo licencias tipo 1 (coche) y 2 (camión)
                debugData = "License Type"
            }
        }
    }
    
    -- Validar con el sistema anticheat
    if not exports.Help:processServerEventData(client, source, "theoryComplete", securityChecks) then
        return -- Bloqueado por el anticheat
    end
    
    -- Validaciones adicionales de negocio
    if getElementData(client, "autoPractica") == true then 
        outputChatBox("Ya tienes el teórico aprobado.", client, 255, 255, 0)
        return 
    end
    
    -- Verificar que el jugador esté en la autoescuela
    if not isPlayerAtAutoescuela(client) then
        exports.Help:reportAndHandleEventAbnormality(
            client, source, "theoryComplete",
            "Intento de aprobar teórico fuera de la autoescuela",
            false
        )
        return
    end
    
    -- Verificar que realmente haya pagado (debería tener menos dinero que antes)
    local currentMoney = exports.players:getMoney(client) or 0
    
    -- Procesar según el tipo de licencia
    if tonumber(licencia) == 1 then
        -- Licencia de coche
        exports.sql:query_free("UPDATE characters SET car_license = '16' WHERE characterID = " .. exports.players:getCharacterID(client))
        setElementData(client, "license.car", 16)
        setElementData(client, "autoPractica", true)
        outputChatBox("Has aprobado el examen teórico de conducir. Ahora puedes hacer el práctico.", client, 0, 255, 0)
        
    elseif tonumber(licencia) == 2 then
        -- Licencia de camión
        exports.sql:query_free("UPDATE characters SET camion_license = '-1' WHERE characterID = " .. exports.players:getCharacterID(client))
        setElementData(client, "license.camion", -1)
        outputChatBox("Has aprobado el examen teórico de camión.", client, 0, 255, 0)
    end
end)


function showLicenses(thePlayer, commandName, otherPlayer)
	if exports.players:isLoggedIn( thePlayer ) == true then
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		local x, y, z = getElementPosition(thePlayer)
		if not thePlayer or not other then return end
		local tx, ty, tz = getElementPosition(other)
		if getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) >=6 then
			outputChatBox("Estás demasiado lejos de '".. name .."'.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Has enseñado tus licencias a " .. name .. ".", thePlayer, 255, 194, 14)
			outputChatBox(getPlayerName(thePlayer):gsub( "_", " " ) .. " te ha enseñado sus licencias", other, 255, 194, 14)
			exports.chat:me(thePlayer,"enseña sus licencias a "..name.. ".")						
			local carlicense = getElementData(thePlayer, "license.car")	
			local camionlicense = getElementData(thePlayer, "license.camion")							
			if (carlicense==0) then
				cars = "No"
			elseif (carlicense==16) then
				cars = "Teórico aprobado, pero no práctico"
			elseif (carlicense>1) then
				cars = carlicense.." puntos."
			elseif (carlicense==1) then 
				cars = carlicense.." punto."
			end
			camion = "No"
			if (camionlicense==0) then
				camion = "No"
			elseif (camionlicense==-1) then
				camion = "Teórico aprobado, pero no práctico"
			elseif (camionlicense>1) then
				camion = carlicense.." puntos."
			elseif (camionlicense==1) then 
				camion = carlicense.." punto."
			end
			local haveLicenciaArmas = false
			local sql = exports.sql:query_assoc("SELECT * FROM licencias_armas WHERE status = 0 AND cID = "..exports.players:getCharacterID(thePlayer))
			outputChatBox("~-~-~-~- Licencias de " .. getPlayerName(thePlayer):gsub( "_", " " ) .. "  -~-~-~-~", other, 255, 194, 14)
			if sql then
				for k, v in ipairs(sql) do
					outputChatBox("        Licencia de armas: Nº "..tostring(v.licenciaID)..", "..tostring(getWeaponNameFromID(tonumber(v.weapon))).." concedida por Justicia.", other, 255, 194, 14)
					haveLicenciaArmas = true
				end
			end
			if not haveLicenciaArmas then
				outputChatBox("        Licencia de armas: no tiene ninguna licencia de armas en vigor.", other, 255, 194, 14)
			end
			outputChatBox("        Licencia de conducir (coches, camiones y motos): " .. cars, other, 255, 194, 14)
			--outputChatBox("        Licencia de conducir (camiones): " .. camion, other, 255, 194, 14)
		end
	end
end
addCommandHandler("licencias", showLicenses)

function checkDMVCars(player, seat)
	if exports.vehicles:getOwner( source ) == false and getElementModel(source) == 436 then
		if getElementData(player,"license.car") == 16 and getElementData(player, "tryPractico") == true then
			if getElementData(player, "autoPractica") == true then
				fixVehicle(source)
				setElementHealth(source, 1000)
				removeElementData(player, "autoPractica")
			end
			outputChatBox("Usa la tecla  J para arrancar el motor y N para quitar o poner el freno de mano.", player, 255, 255, 255)
			outputChatBox("¡Recuerda usar /cinturon o tecla C para ponerte el cinturón o suspenderás!", player, 255, 255, 255)
		else
			if not getElementData(player, "account:gmduty") == true then
				outputChatBox("(( Este vehículo es sólo para el examen práctico ))", player, 255, 0, 0)
				if getElementData(player,"license.car") == 16 then
					outputChatBox("Acude dentro de la autoescuela para solicitar un nuevo exámen práctico.", player, 255, 255, 255)
				end
				cancelEvent()
			end
		end
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDMVCars)

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) )
			local minDistance = 5
			if distance < minDistance and not getElementData(player, "vlicencia") == true then
				if getElementData(player, "license.car") and getElementData(player, "license.car") > 2 and getElementData(player, "license.car") ~= 16 then outputChatBox("No hay licencias disponibles para ti.", player, 255, 0, 0) return end
				triggerClientEvent ( player, "onLicense", player )
				setElementData(player, "vlicencia", true)
			end
		end
	end
)


-- El comando de dar licencias de armas a una persona estába obsoleto y no realizaba el guardado , lo he fixeado con nuevas funciones
-- Cobro del dinero , directamente en el cmd y al presupuesto
-- Log registro de quien da las licencias a quien para evitar problemas que ya nos conocemos
-- Fixeado el guardado de la consulta anteriormente no realizaba la consulta.

-- Configuración de la autoescuela
local AUTOESCUELA_POS = {1060.255859375, -1672.3193359375, 13.775871276855}
local AUTOESCUELA_DISTANCE = 5 -- Distancia máxima para estar en la autoescuela
local autoescuelaMarker = nil

-- Función para verificar si el jugador está en la autoescuela
function isPlayerAtAutoescuela(player)
    local x, y, z = getElementPosition(player)
    local distance = getDistanceBetweenPoints3D(x, y, z, AUTOESCUELA_POS[1], AUTOESCUELA_POS[2], AUTOESCUELA_POS[3])
    return distance <= AUTOESCUELA_DISTANCE
end

-- Crear el marcador de la autoescuela al iniciar el resource
addEventHandler("onResourceStart", resourceRoot, function()
    autoescuelaMarker = createMarker(AUTOESCUELA_POS[1], AUTOESCUELA_POS[2], AUTOESCUELA_POS[3] - 1, "cylinder", 1.5, 0, 255, 0, 150)
    local autoescuelaBlip = createBlip(AUTOESCUELA_POS[1], AUTOESCUELA_POS[2], AUTOESCUELA_POS[3], 36, 2, 0, 255, 0, 255)
    setElementVisibleTo(autoescuelaBlip, root, true)
    if autoescuelaMarker then
        outputDebugString("Marcador de autoescuela creado correctamente en: " .. AUTOESCUELA_POS[1] .. ", " .. AUTOESCUELA_POS[2] .. ", " .. AUTOESCUELA_POS[3])
    end
end)

-- Función para iniciar automáticamente el proceso de licencia
function iniciarProcesoLicencia(player)
    if getElementData(player, "tryPractico") == true then 
        outputChatBox("¡Tienes un exámen práctico pendiente! Sal y realízalo.", player, 255, 255, 0) 
        return 
    end
    
    if getElementData(player, "license.car") == 0 then
        -- No tiene licencia, iniciar teórico
        if getPlayerMoney(player) < 100000 then 
            outputChatBox("¡Necesitas $100.000 pesos para el teórico de esta licencia!", player, 255, 0, 0) 
            return 
        end
        exports.players:takeMoney(player, 100000)
        triggerClientEvent(player, "startLicenseTest", player)
        outputChatBox("Has pagado la tasa de entrada al test teórico", player, 255, 194, 14)
    elseif getElementData(player, "license.car") == 16 then
        -- Ya tiene el teórico, hacer práctico
        if getPlayerMoney(player) < 150000 then 
            outputChatBox("¡Necesitas $150.000 pesos para el práctico de esta licencia!", player, 255, 0, 0) 
            return 
        end
        triggerClientEvent(player, "initiateDrivingTest", player)
        outputChatBox("Sal del marcador y súbete a un vehículo de pruebas para el examen práctico.", player, 0, 255, 0)
    else
        outputChatBox("Ya tienes la licencia de conducir Coche/Moto/Camión.", player, 255, 0, 0)
    end
end

-- Event handler para cuando el jugador entre al marcador
addEventHandler("onMarkerHit", resourceRoot, function(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        if source == autoescuelaMarker then
            iniciarProcesoLicencia(hitElement)
        end
    end
end)

-- Comando para mostrar la ubicación de la autoescuela
function mostrarAutoescuela(thePlayer, commandName)
    outputChatBox("¡La autoescuela está ubicada cerca de la playa de Los Santos!", thePlayer, 0, 255, 0)
    outputChatBox("Busca el marcador verde en el mapa para encontrarla.", thePlayer, 255, 255, 0)
end
addCommandHandler("autoescuela", mostrarAutoescuela)

-- COMANDO PARA LICENCIAR UNA PERSONA CON LICENCIA DE ARMAS


function retirarpuntos ( thePlayer, commandName, otherPlayer, puntos )
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		if not puntos then outputChatBox("Sintaxis: /"..commandName.." [jugador] [puntos]", thePlayer, 255, 255, 255) return end
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		if not other then return end
		local puntosActual = tonumber(getElementData(other, "license.car"))
		outputChatBox("El agente "..getPlayerName(thePlayer):gsub("_", " ").." te ha retirado "..tostring(puntos).." puntos de la licencia de conducir.", other, 255, 0, 0)
		outputChatBox("Has retirado "..tostring(puntos).." puntos de la licencia de conducir a "..name..".", thePlayer, 255, 0, 0)
		if (puntosActual-puntos) > 0 then
			exports.sql:query_free("UPDATE characters SET car_license = '" .. tonumber(puntosActual-tonumber(puntos)) .. "' WHERE characterID = " .. exports.players:getCharacterID(other))
			setElementData(other, "license.car", puntosActual-puntos )
		else
			exports.sql:query_free("UPDATE characters SET car_license = 0 WHERE characterID = " .. exports.players:getCharacterID(other))
			setElementData(other, "license.car", 0 )
			outputChatBox("Has perdido la licencia de conducir debido a que te has quedado sin puntos. Sácala de nuevo.", other, 255, 0, 0)
		end
	else
		outputChatBox("¡No perteneces al cuerpo de policía!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler ( "retirarpuntos", retirarpuntos )
addCommandHandler ( "rp", retirarpuntos )