function rellenarTienda(thePlayer, command, int, productos)

	if hasObjectPermissionTo(thePlayer, "command.modchat", false) then

		if tonumber(int) and tonumber(productos) then

			local rellenar = exports.interiors:giveProductos(tonumber(int), tonumber(productos))

			if rellenar then

				outputChatBox('Tienda rellenada.', thePlayer, 0, 255, 100)
				outputChatBox("[ANUNCIO] La tienda ID "..tonumber(int).." ha sido rellenada con "..productos.." productos.", root, 0, 255, 200)

			else

				outputChatBox('Error en rellenar la tienda, intente con otro id de interior.', thePlayer, 255, 0, 100)

			end

		else

			outputChatBox('SYNTAX: /'..command..' [Id Interior] [Cantidad de suministros] ', thePlayer, 255, 100, 0)

		end
		
	end
end
addCommandHandler('rellenar', rellenarTienda)
addCommandHandler('rellenartienda', rellenarTienda)
addCommandHandler('rellenarint', rellenarTienda)
