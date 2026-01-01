local peticionSeguro = {}

local tipos_seguro = { ["Terceros"] = 500, ["Terceros completo"] = 650, ["Todo riesgo"] = 750 }

local comandoseguros = { {"Terceros",500}, {"Terceros completo",650}, {"Todo riesgo", 750},  }

addCommandHandler( "verseguro",
	function(p,cmd,id)
		if exports.players:isLoggedIn(p) and exports.factions:isPlayerInFaction(p,14) then
			local id = tonumber(id)
			if id then
				local veh = exports.vehicles:getVehicle(id)
				if veh then
					local seguro = getElementData(veh,"seguro")
					local tseguro = getElementData(veh,"tiposeguro")
					outputChatBox( "["..exports.factions:getFactionName(14).."] Datos del vehiculo con matricula "..id..":", p, 255, 255, 0 )
					outputChatBox( "     - Seguro: "..( tseguro or "Nada" ), p, 255, 255, 255 )
					outputChatBox( "     - Fecha: "..(os.date('%d-%m-%Y %H:%M', seguro )), p, 255, 255, 255 )
					if (seguro - getRealTime().timestamp ) > 0 then
						outputChatBox( "     - Estado: #00ff00VIGENTE", p, 255, 255, 255, true )
					else
						outputChatBox( "     - Estado: #FE0000CADUCADO", p, 255, 255, 255, true )
					end
				else
					outputChatBox( "(( No se encuentra el vehiculo con esa ID. ))", p, 255, 0, 0 )
				end
			else
				outputChatBox( "Syntax: /"..cmd.." [id coche]", p, 255, 255, 255 )
			end	
		end
	end
)

addCommandHandler( "seguros",
	function(p)
		if exports.players:isLoggedIn(p) and exports.factions:isPlayerInFaction( p, 14 ) then
			outputChatBox( "Seguros disponibles:", p, 255, 255, 0 )
			for i=1, #comandoseguros do 
				local v = comandoseguros[i]
				outputChatBox( "		- ["..i.."] "..v[1]..": "..v[2].."$", p, 255, 255, 255 )
			end
		end
	end
)

addCommandHandler( "pseguro",
	function(p)
		if peticionSeguro[p] then
			local jugador, vehiculo, tipo = unpack( peticionSeguro[p] )
			local dinero = getPlayerMoney( p )
			if dinero >= tipos_seguro[tipo] then
				if isElement(vehiculo) then
					if exports.players:takeMoney( p, tipos_seguro[tipo] ) then
						if isElement(jugador) and exports.players:isLoggedIn(jugador) then
							exports.players:giveMoney( jugador, tipos_seguro[tipo] * 0.2 )
							exports.factions:setFactionPresupuesto( 14, tipos_seguro[tipo] )
							setElementData( vehiculo, "seguro", ( getRealTime().timestamp + (86400*31) ) )
							setElementData( vehiculo, "tiposeguro", tipo )
							outputChatBox( "Has ganado un 20% asegurando este vehiculo.", jugador, 0, 255, 0 )
							outputChatBox( "Le has asegurado el vehiculo a "..getPlayerName(p):gsub("_"," "), jugador, 0, 255, 0 )
							outputChatBox( "Tu vehiculo ha sido asegurado 1 mes por "..tipos_seguro[tipo].."$", p, 0, 255, 0 )
							outputChatBox( "Tipo de seguro elegido: #ffffff"..tipo, p, 0, 255, 0, true )
							exports.fichas:addToFicha( exports.players:getCharacterID( jugador ), 11, tipos_seguro[tipo] )
						else
							exports.factions:setFactionPresupuesto( 14, tipos_seguro[tipo] )
							outputChatBox( "(( El asegurador se ha desconectado. Se queda sin su comision. ))", p, 255, 0, 0 )
							outputChatBox( "Tu vehiculo ha sido asegurado 1 mes por "..tipos_seguro[tipo].."$", p, 0, 255, 0 )
							setElementData( vehiculo, "seguro", ( getRealTime().timestamp + (86400*31) ) )
							setElementData( vehiculo, "tiposeguro", tipo )
							outputChatBox( "Tipo de seguro elegido: #ffffff"..tipo, p, 0, 255, 0, true )						
						end
					else
						outputChatBox( "Error, no tienes suficiente dinero", p, 255, 0, 0 )
					end
				else
					outputChatBox( "El vehiculo que querias asegurar no se encuentra.", p, 255, 0, 0 )
				end
			else
				outputChatBox( "No tienes suficiente dinero para pagar el seguro.", p, 255, 0, 0 )
			end
		end
	end
)

addCommandHandler( "cseguro",
	function(p)
		if peticionSeguro[p] then
			local jugador, vehiculo, tipo = unpack( peticionSeguro[p] )
			if isElement(jugador) and exports.players:isLoggedIn(jugador) then
				outputChatBox( "El jugador "..getPlayerName(p):gsub("_"," ").." ha rechazado el seguro.", jugador, 255, 0, 0 )
				outputChatBox( "Has rechazado la oferta de seguro.", p, 255, 0, 0 )
				peticionSeguro[p] = nil
			else
				outputChatBox( "Has rechazado la oferta de seguro.", p, 255, 0, 0 )
				peticionSeguro[p] = nil
			end
		end
	end
)

addCommandHandler( "asegurar",
	function( p, cmd, otro, ... )
		if exports.players:isLoggedIn(p) and exports.factions:isPlayerInFaction( p, 14 ) then
			local other, name = exports.players:getFromName( p, otro )
			local other = getPlayerFromName(name:gsub(' ', '_'))
			local tipo = table.concat( {...}, " " )
			if other then
				if tipos_seguro[tipo] then
					local veh = getPedOccupiedVehicle( other )
					if veh then
						peticionSeguro[other] = { p, veh, tipo }
						outputChatBox( "Peticion enviada a "..name..".", p, 0, 255, 0 )
						outputChatBox( "Has recibido una peticion para asegurar tu vehiculo. Utiliza /pseguro para aceptarla o /cseguro para rechazarla.", other, 255, 150, 0 )
					else
						outputChatBox( name.." no está subido a un vehículo.", p, 255, 0, 0 )
					end
				else
					outputChatBox( "Ese tipo de seguros no existe. Tipos:", p, 255, 255, 0 )
					for k, v in pairs( tipos_seguro ) do 
						outputChatBox( "		- Tipo: "..k.." | Precio: "..v.."$ por mes.", p, 255, 255, 255 )
					end
 				end
			else
				outputChatBox( "Syntax: /"..cmd.." [id jugador (debe estar subido a un vehiculo)]", p, 255, 255, 255 )
			end
		end
	end
)

-- RASTREAR


local blip = {}
local timer = {}

addCommandHandler( "rastrear",
	function(p,cmd,id)
		if exports.players:isLoggedIn(p) then
			if exports.factions:isPlayerInFaction(p,14) or exports.factions:isPlayerInFaction(p,1) or exports.factions:isPlayerInFaction(p,14) then
				local id = tonumber(id)
				if id then
					local veh = exports.vehicles:getVehicle(id)
					if veh then
						if getElementDimension(veh) == 0 then
							local x, y, z = getElementPosition(veh)
							outputChatBox( "[IESS] Vehículo encontrado. Punto marcado en el mapa. Se eliminará en 2 minutos.", p, 0, 255, 0 )
							blip[p] = createBlip( x, y, z, 0, 2, 0, 255, 0 )
							setElementVisibleTo( blip[p], root, false )
							setElementVisibleTo( blip[p], p, true )
							timer[p] = setTimer( function( player )
								if player then
									if isElement( blip[player] ) then destroyElement( blip[player] ) blip[player] = nil end
									timer[player] = nil
								end	
							end, 2*60000, 1, p )
						else
							local intname = exports.interiors:getInteriorName( getElementDimension(veh) )
							if intname then
								outputChatBox( "[IESS] El vehiculo esta en "..intname, p, 0, 255, 0 )
							else
								outputChatBox( "[IESS] El vehiculo esta en una propiedad.", p, 0, 255, 0 )
							end
						end
					else
						outputChatBox( "[IESS] No se encuentra el vehículo.", p, 255, 0, 0 )
					end
				else
					outputChatBox( "Syntax: /"..cmd.." [id del coche]", p, 255, 255, 255 )
				end
			end
		end
	end
)