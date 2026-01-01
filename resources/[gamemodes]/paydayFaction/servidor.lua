

--print(inspect(#exports.factions:getFactions()))
--print(exports.players:getCharacterID(getPlayerFromName('Kim_Carlsson')))


--[[local result = exports.sql:query_assoc( "SELECT * FROM character_to_factions")
print(inspect(result[44]))
	for key, value in ipairs( result ) do
				if value.characterID == 104 then
					print(key, 'si')
				end
			end]]
--exports.sql:query_assoc( "insert into character_to_factions(characterID,factionID,factionLeader, factionRank, factionSueldo) values(104, 1, 1, 13, 4000)")



function darDinero(player, cantidad)
	if paydayPrueba == true then return end
	if setPlayerMoney(player, getPlayerMoney(player)+tonumber(cantidad)) then
		return true
	else
		return false
	end
end

function quitarDinero (player, cantidad) -- Aqui da igual el /paga, la cuestión es que se le retire el dinero al usuario.
	if paydayPrueba == true then return end
	if setPlayerMoney(player, getPlayerMoney(player)-tonumber(cantidad)) then 
		return true 
	else
		local v = executeSQLQuery("SELECT money FROM bankStat WHERE account = "..exports.players:getCharacterID(player))
		if v and v.money and cantidad <= v.money then
			local c, error = executeSQLQuery("UPDATE bankStat SET money = "..(v.money-cantidad).." WHERE account = "..exports.players:getCharacterID(player))
			if error then
				return false
			else
				return true
			end
		else
			return false
		end
	end
end 



function pagarMulta(player, mid, v)
	if paydayPrueba == true then return end
	if player and mid and v and v > 0 then
		local v5 = exports.sql:query_assoc_single( "SELECT * FROM multas WHERE estado = 1 AND cantidad > pagado AND ind = " .. mid)
		if getPlayerMoney(player) >= v then	
			if setPlayerMoney(player, getPlayerMoney(player)-tonumber(v)) then
				exports.factions:giveFactionPresupuesto(1, v)
				g = g - v
				exports.sql:query_free( "UPDATE multas SET pagado = "..v5.pagado+v.." WHERE ind = " .. v5.ind )
				outputChatBox ( "-Multa ID "..v5.ind..": #FF0000"..tostring(v).." dólares", player, 255, 255, 255, true )
				if tonumber(v5.pagado+v) == tonumber(v5.cantidad) then
					exports.sql:query_free( "UPDATE multas SET estado = '0' WHERE ind = " .. v5.ind )
				end
			end
		else
			if not quitarDinero(player, tonumber(v)) then
				local dinero = getPlayerMoney(player)
				if setPlayerMoney(player, getPlayerMoney(player)-tonumber(v)) then
					exports.factions:giveFactionPresupuesto(1, dinero)
					g = g - dinero
					exports.sql:query_free( "UPDATE multas SET pagado = "..v5.pagado+dinero.." WHERE ind = " .. v5.ind )
					outputChatBox ( "-Multa ID "..v5.ind..": #FF0000"..tostring(dinero).." dólares", player, 255, 255, 255, true )
					if tonumber(v5.pagado+dinero) == tonumber(v5.cantidad) then
						exports.sql:query_free( "UPDATE multas SET estado = '0' WHERE ind = " .. v5.ind )
					end
				end
			else
				exports.factions:giveFactionPresupuesto(1, v)
				g = g - v
				exports.sql:query_free( "UPDATE multas SET pagado = "..v5.pagado+v.." WHERE ind = " .. v5.ind )
				outputChatBox ( "-Multa ID "..v5.ind..": #FF0000"..tostring(v).." dólares", player, 255, 255, 255, true )
				if tonumber(v5.pagado+v) == tonumber(v5.cantidad) then
					exports.sql:query_free( "UPDATE multas SET estado = '0' WHERE ind = " .. v5.ind )
				end
			end
		end
	end
end

impVeh = {
	[1] = 0,
	[2] = 450,
	[3] = 150,
	[4] = 150,
	[5] = 100,
	[6] = 150,
	[7] = 175,
	[8] = 125,
	[9] = 100,
	[10] = 0, 
	[11] = 300,
	[12] = 350,
}

function paydayImp(player)
	g = 0
	tieneLocales = 0
	for k6, v6 in ipairs(exports.interiors:getInteriorsTipo(player, 2)) do
		if tieneLocales == 0 then -- LIMITE DE 1 LOCAL POR PERSONAJE
			outputChatBox("Beneficios de "..tostring(v6.interiorName)..": #00FF00"..tostring(v6.interiorPrice*0.003).." Pesos", player, 255, 255, 255, true)
			--darDinero(player, v6.interiorPrice*0.003)
			g = g + v6.interiorPrice*0.003
		end
		tieneLocales = tieneLocales + 1
	end
	if tieneLocales > 1 then outputChatBox("Te recordamos que no está permitido tener más de 1 local por PJ.", player, 255, 0, 0) exports.logs:addLogMessage("localespd", getPlayerName(player).. " DEBE DE SER SANCIONADO, HA RECAUDADO DINERO DE " .. tostring(tieneLocales) .. " LOCALES") end
	tieneLocales = 0
	for k7, v7 in ipairs(exports.interiors:getInteriorsTipo(player, 3)) do
		outputChatBox("Alquiler de "..tostring(v7.interiorName)..": #FF0000"..tostring(v7.interiorPrice).." Pesos", player, 255, 255, 255, true)
		quitarDinero(player, v7.interiorPrice)
		g = g - v7.interiorPrice
	end
	local impuestos = 0
	local sql = exports.sql:query_assoc("SELECT vehicleID, model FROM vehicles WHERE characterID = "..tostring(exports.players:getCharacterID(player)))
	for k4, v4 in ipairs(sql) do			
		local clase = exports.vehicles_auxiliar:getClaseFromModel(getVehicleNameFromModel(v4.model))
		local sql2v = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE pagado < cantidad AND tipo = 1 AND objetoID = "..v4.vehicleID)
		if not clase and not sql2v then
			impuestos = impuestos + 100
		elseif not sql2v then
			impuestos = impuestos + (impVeh[clase])
		end
		sql2v = nil
	end
	if impuestos ~= 0 then 
		outputChatBox("Impuestos por vehículos: #FF0000"..tostring(math.floor(impuestos)).." Pesos", player, 255, 255, 255, true)
		quitarDinero(player, tonumber(math.floor(impuestos)))
		exports.factions:giveFactionPresupuesto(5, tonumber(math.floor(impuestos)))
		g = g - tonumber(math.floor(impuestos))
		exports.sql:query_free("UPDATE ajustes SET valor = valor + "..tostring(math.floor(impuestos)).. " WHERE ajusteID = 4")
	end
	local multas = exports.sql:query_assoc( "SELECT ind, cantidad, pagado FROM multas WHERE estado = 1 AND characterID = " .. exports.players:getCharacterID(player))
	for k5, v5 in ipairs ( multas ) do
		pagarMulta(player, tonumber(v5.ind), tonumber(v5.cantidad-v5.pagado))
	end
	for k6, v6 in ipairs (exports.sql:query_assoc("SELECT * FROM prestamos WHERE cantidad > pagado AND characterID = " .. exports.players:getCharacterID(player))) do
		if quitarDinero(player, v6.cuota) then
			exports.sql:query_free("UPDATE prestamos SET pagado = "..tonumber(v6.pagado+v6.cuota).." WHERE prestamoID = "..v6.prestamoID)
			outputChatBox("Préstamo "..tostring(v6.prestamoID)..": #FF0000"..tostring(v6.cuota).." Pesos", player, 255, 255, 255, true)
			g = g - v6.cuota
		else
			outputChatBox("No se ha podido pagar la cuota de tu préstamo "..tostring(v6.prestamoID)..".Usa /pagarcuota cuando puedas.", player, 255, 0, 0)
		end
	end
	local sqlloto = exports.sql:query_assoc_single("SELECT loteria FROM characters WHERE characterID = " .. exports.players:getCharacterID(player))
	if sqlloto and sqlloto.loteria and sqlloto.loteria >= 1 then 
		if bganador == sqlloto.loteria then
			outputChatBox("Lotería Nº "..tostring(sqlloto.loteria).." (ganador): #00FF00400 Pesos", player, 255, 255, 255, true)
			--darDinero(player, 400)
			g = g + 400
		else
			outputChatBox("Lotería Nº "..tostring(sqlloto.loteria).." (perdedor): #FF00000 Pesos", player, 255, 255, 255, true)
		end
	else
		outputChatBox("Lotería (sin boleto comprado): #FF00000 Pesos", player, 255, 255, 255, true)
	end
	exports.sql:query_free("UPDATE characters SET loteria = 0 WHERE characterID = " .. exports.players:getCharacterID(player))
	if g > 0 then
		outputChatBox("Con esta paga has ganado "..tostring(math.abs(g)).." Pesos.", player, 0, 255, 0)
	else
		outputChatBox("Con esta paga has perdido "..tostring(math.abs(g)).." Pesos. ", player, 255, 0, 0)
	end

	if getElementData(player, "moneyInBank") then 
		setElementData(player, "moneyInBank", tonumber(getElementData(player, "moneyInBank"))+tonumber(g))
	end
end


local payOut = {}
local faccionesPagadas = false

addEventHandler( "onCharacterLogin", root,
function()

	local id = exports.players:getCharacterID(source)
	if tonumber(id) then

		local id = tostring(id)
		if payOut[id] then
	
			for fatName, sueldo in pairs(payOut[id]) do
				outputChatBox('* La facción '..fatName..' depositó $'..sueldo..' en tu cuenta de banco.', source, 0, 220, 0)
			end
			payOut[id] = nil

		end

	end

end 
) 

local function _payDayFaction ()

	local result = exports.sql:query_assoc( "SELECT * FROM character_to_factions")
	for key, v in ipairs( result ) do

		local id = v.characterID
		local fid = v.factionID
		local sueldo = v.factionSueldo
		local nameF = exports.factions:getFactionName( fid )

		local player = exports.players:getPlayerByCharID(id)
		if isElement(player) then

			if getElementData(player, "moneyInBank") then 
				setElementData(player, "moneyInBank", tonumber(getElementData(player, "moneyInBank"))+tonumber(sueldo))
				paydayImp(player)
				outputChatBox('--- Dia de paga ---', player, 0, 220, 0)
				outputChatBox('.- Facción : #00ff00'..nameF, player, 220, 220, 0, true)
				outputChatBox('.- Sueldo : #00ff00$'..sueldo, player, 220, 220, 0, true)
				outputChatBox('.- Este dinero fue depositado a tu cuenta de banco con éxito.', player, 220, 220, 0, true)
				outputChatBox('------------------------', player, 0, 220, 0, true)
			else
				outputChatBox('--- Dia de paga ---', player, 0, 220, 0)
				outputChatBox('.- Facción : #00ff00'..nameF, player, 220, 220, 0, true)
				outputChatBox('.- Sueldo : #00ff00$'..sueldo, player, 220, 220, 0, true)
				outputChatBox('.- No posees una cuenta de banco donde depositar este dinero.', player, 220, 220, 0, true)
				outputChatBox('------------------------', player, 0, 220, 0, true)
				paydayImp(player)
			end

		else
			
			local v = executeSQLQuery("SELECT money FROM bankStat WHERE account = "..id)
			if #v > 0 then
				executeSQLQuery("UPDATE bankStat SET money =? WHERE account = "..id, (tonumber(v[1].money) or 0)+sueldo)
			end

			local id = tostring(id)
			payOut[id] = payOut[id] or {}
			if payOut[id][nameF] then
				payOut[id][nameF] = (payOut[id][nameF] or 0) + sueldo
			else
				payOut[id][nameF] = sueldo
			end

		end

	end
	faccionesPagadas = true
end


setTimer(_payDayFaction, 1000*60*60*12, 0)


addCommandHandler('pagarfacciones',
	function(owner)
		if not faccionesPagadas then
			if isObjectInACLGroup('user.'..owner.account.name, aclGetGroup( 'Desarrollador' ) ) then
				local result = exports.sql:query_assoc( "SELECT * FROM character_to_factions")
				for key, v in ipairs( result ) do

					local id = v.characterID
					local fid = v.factionID
					local sueldo = v.factionSueldo
					local nameF = exports.factions:getFactionName( fid )

					local player = exports.players:getPlayerByCharID(id)
					if isElement(player) then

						if getElementData(player, "moneyInBank") then 
							setElementData(player, "moneyInBank", getElementData(player, "moneyInBank")+tonumber(sueldo))
							paydayImp(player)
							outputChatBox('--- Dia de paga ---', player, 0, 220, 0)
							outputChatBox('.- Facción : #00ff00'..nameF, player, 220, 220, 0, true)
							outputChatBox('.- Sueldo : #00ff00$'..sueldo, player, 220, 220, 0, true)
							outputChatBox('.- Este dinero fue depositado a tu cuenta de banco con éxito.', player, 220, 220, 0, true)
							outputChatBox('------------------------', player, 0, 220, 0, true)
						else
							outputChatBox('--- Dia de paga ---', player, 0, 220, 0)
							outputChatBox('.- Facción : #00ff00'..nameF, player, 220, 220, 0, true)
							outputChatBox('.- Sueldo : #00ff00$'..sueldo, player, 220, 220, 0, true)
							outputChatBox('.- No posees una cuenta de banco donde depositar este dinero.', player, 220, 220, 0, true)
							outputChatBox('------------------------', player, 0, 220, 0, true)
							paydayImp(player)
						end

					else

						local v = executeSQLQuery("SELECT money FROM bankStat WHERE account = "..id)
						if #v > 0 then
							executeSQLQuery("UPDATE bankStat SET money =? WHERE account = "..id, (tonumber(v[1].money) or 0)+sueldo)
						end
							
						local id = tostring(id)
						payOut[id] = payOut[id] or {}
						if payOut[id][nameF] then
							payOut[id][nameF] = (payOut[id][nameF] or 0) + sueldo
						else
							payOut[id][nameF] = sueldo
						end

					end

				end
				faccionesPagadas = true
			end
		else
			owner:outputChat('* El payday de las facciones ya se pago.', 255, 0, 0)
		end
	end
)