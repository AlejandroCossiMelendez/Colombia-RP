function getBalance( player )
	if isElement( player ) then
		local currentBalance = exports.bank:getDinero( player )
		if currentBalance then
			triggerClientEvent( player, "onClentRequestBalance", player, currentBalance )
		end
	end
end
addEvent( "onRequestBalance", true )
addEventHandler( "onRequestBalance", root, getBalance )

function ingresarDinero ( player, cantidad )
	if exports.players:isLoggedIn( player ) then
		local cantidad = tonumber(math.floor(cantidad))
		if cantidad < 1 then outputChatBox("No puedes ingresar esta cantidad de dinero.", player, 255, 0, 0) return end
		if not exports.bank:getDinero( player ) then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
		if exports.players:takeMoney( player, cantidad ) then
			if exports.sql:query_free("UPDATE characters SET banco = " .. (exports.bank:getDinero( player ) + cantidad) .. " WHERE characterID = " .. exports.players:getCharacterID ( player )) then
				exports.chat:me(player, "ingresa dinero en su cuenta bancaria.")
				outputChatBox("Has ingresado $" .. tostring ( cantidad ) .. " en tu cuenta.", player, 0, 255, 0)
				outputChatBox("Balance actual: $" .. tostring (exports.bank:getDinero( player )) .. ".", player, 0, 255, 0)
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
				local nuevoBalance = tonumber(exports.bank:getDinero(player))
				if nivel < 2 then outputChatBox("No puedes usar el banco porque necesitas nivel 2. Usa /objetivos.", player, 255, 0, 0) return end
				if nivel == 2 and not exports.objetivos:isObjetivoCompletado(15, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(15, exports.players:getCharacterID(player), player)
				end
				if nivel == 2 and nuevoBalance >= 10000 and not exports.objetivos:isObjetivoCompletado(17, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(17, exports.players:getCharacterID(player), player)
				end
				if nivel == 3 and nuevoBalance >= 50000 and not exports.objetivos:isObjetivoCompletado(22, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(22, exports.players:getCharacterID(player), player)
				end
				if nivel == 3 and nuevoBalance >= 100000 and not exports.objetivos:isObjetivoCompletado(31, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(31, exports.players:getCharacterID(player), player)
				end
				if nivel == 4 and nuevoBalance >= 200000 and not exports.objetivos:isObjetivoCompletado(34, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(34, exports.players:getCharacterID(player), player)
				end
				if nivel == 4 and nuevoBalance >= 300000 and not exports.objetivos:isObjetivoCompletado(35, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(35, exports.players:getCharacterID(player), player)
				end
			else
				outputChatBox("Se ha producido un ERROR GRAVE. Pulsa F12 y reclama tus $" .. tostring( cantidad ) .. " perdidos.", player, 255, 0, 0)
			end
		else
			outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
		end
	end
end
addEvent( "onPlayerAddBalance", true )
addEventHandler( "onPlayerAddBalance", root, ingresarDinero )

addEvent( "onPlayerRemoveBalance", true )
addEventHandler( "onPlayerRemoveBalance", root,
	function ( player, cantidad )
		if exports.players:isLoggedIn( player ) then
			local cantidad = tonumber(math.floor(cantidad))
			if cantidad < 1 then outputChatBox("No puedes retirar esta cantidad de dinero.", player, 255, 0, 0) return end
			if not exports.bank:getDinero( player ) then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
			if ( exports.bank:getDinero( player ) - cantidad ) < 0 then outputChatBox("No tienes tanto dinero en tu cuenta bancaria.", player, 255, 0, 0) return end
			if exports.sql:query_free("UPDATE characters SET banco = " .. (exports.bank:getDinero( player ) - cantidad) .. " WHERE characterID = " .. exports.players:getCharacterID ( player )) then
				if exports.players:giveMoney( player, cantidad ) then
					exports.chat:me(player, "retira dinero de su cuenta bancaria.")
					outputChatBox("Has retirado $" .. tostring ( cantidad ) .. " de tu cuenta.", player, 0, 255, 0)
					outputChatBox("Balance actual: $" .. tostring (exports.bank:getDinero( player )) .. ".", player, 0, 255, 0)
				else 
					outputChatBox("Se ha producido un ERROR GRAVE. Pulsa F12 y reclama tus $" .. tostring( cantidad ) .. " perdidos.", player, 255, 0, 0)
				end
			else
				outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
			end
		end
	end
)