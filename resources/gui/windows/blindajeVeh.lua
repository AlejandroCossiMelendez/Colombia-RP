if isElement(localPlayer) then

	addEventHandler( "onClientResourceStart", resourceRoot,
		function()

			local precios = {
				[1] = 15000000,
				[2] = 30000000,
				[3] = 50000000,
				[4] = 90000000,
			}
			windows.vehBlindaje = {
				{
					type = "label",
					text = "Blindajes Vehicular",
					font = "default-bold",
					alignX = "center",
				},
				{
					type = "pane",
					panes = {
						{
							image = "images/blindajeVeh.png",
							title = "Blindaje lv1",
							text = "Soporta asta un 20% más de daños.\nPrecio: $"..tostring(precios[1]):sub(1,2)..' Mill.',
							wordBreak = true,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 75, 75, 140 } ) ) )
							end,
							onClick = function( key )
								if key == 1 then
									if isElement(vehSelected) then
										if getPlayerMoney() >= precios[1] then
											triggerServerEvent('buy:blindajeVeh', vehSelected, 1, precios[1])
										else
											outputChatBox('Dinero insuficiente.', 255, 0, 0)
										end
									end
								end
							end,
						},
						{
							image = "images/blindajeVeh.png",
							title = "Blindaje lv2",
							text = "Soporta asta un 35% más de daños.\nPrecio: $"..tostring(precios[2]):sub(1,2)..' Mill.',
							wordBreak = true,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 75, 75, 140 } ) ) )
							end,
							onClick = function( key )
								if key == 1 then
									if isElement(vehSelected) then
										if getPlayerMoney() >= precios[2] then
											triggerServerEvent('buy:blindajeVeh', vehSelected, 2, precios[2])
										else
											outputChatBox('Dinero insuficiente.', 255, 0, 0)
										end
									end
								end
							end,
						},

						{
							image = "images/blindajeVeh.png",
							title = "Blindaje lv3",
							text = "Soporta asta un 50% más de daños.\nPrecio: $"..tostring(precios[3]):sub(1,2)..' Mill.',
							wordBreak = true,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 75, 75, 140 } ) ) )
							end,
							onClick = function( key )
								if key == 1 then
									if isElement(vehSelected) then
										if getPlayerMoney() >= precios[3] then
											triggerServerEvent('buy:blindajeVeh', vehSelected, 3, precios[3])
										else
											outputChatBox('Dinero insuficiente.', 255, 0, 0)
										end
									end
								end
							end,
						},

						{
							image = "images/blindajeVeh.png",
							title = "Blindaje lv4",
							text = "Soporta asta un 70% más de daños.\nPrecio: $"..tostring(precios[4]):sub(1,2)..' Mill.',
							wordBreak = true,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 75, 75, 140 } ) ) )
							end,
							onClick = function( key )
								if key == 1 then
									if isElement(vehSelected) then
										if getPlayerMoney() >= precios[4] then
											triggerServerEvent('buy:blindajeVeh', vehSelected, 4, precios[4])
										else
											outputChatBox('Dinero insuficiente.', 255, 0, 0)
										end
									end
								end
							end,
						},

						{
							image = "images/blindajeVeh2.png",
							title = "Remove Blindaje",
							text = "",
							wordBreak = true,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 75, 75, 140 } ) ) )
							end,
							onClick = function( key )
								if key == 1 then
									if isElement(vehSelected) then
										triggerServerEvent('remove:blindajeVeh', vehSelected)
									end
								end
							end,
						},
							
						{
							image = "images/mecanico/-2.png",
							title = "Cerrar",
							text = "Haz click aquí para cerrar el panel.",
							wordBreak = true,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
							end,
							onClick = function( key )
								if key == 1 then
									hide()
									--toggleAllControls(true)
									setElementData(localPlayer, "nocursor", nil)
								end
							end,
						}
					}
				}
			}

		end
	)

	local sx, sy = guiGetScreenSize(  )
	addEventHandler( "onClientRender", getRootElement(),
		function()
			local veh = getPedOccupiedVehicle( localPlayer )
			if isElement( veh ) then
				local tab = getElementData(veh, 'BlindajeVehicular')
				if getVehicleOccupant(veh) == localPlayer then
					if tab and tab[3] and tab[3] > 0 then
						dxDrawText('Blindaje '..tostring(math.ceil(100*(tab[2]/tab[3])))..'%', sx*0.8, sy*0.95, 0, 0, tocolor( 255,255,255 ), 1, 'default-bold')
					end
				end
			end
		end
	)

	addEvent('showBlindajeVeh', true)
	addEventHandler('showBlindajeVeh', root,
		function(element)
			if not exports.gui:getShowing() then
				vehSelected = element
				show('vehBlindaje')
			else
				hide()
			end
		end
	)

else

    addEventHandler( "onElementDataChange", getRootElement(),
        function(key, old, new)
            if key == 'BlindajeVehicular' then
                if new and type(new) == 'table' and new[2] <= 0 then
                    setElementData( source, 'BlindajeVehicular', false)
                    removeElementData( source, 'BlindajeVehicular')
                end
            end
        end
    )

	-- Declarar eventos personalizados
	addEvent('buy:blindajeVeh', true)
	addEvent('remove:blindajeVeh', true)

	-- Capacidad de blindaje por nivel
	local lvl = {
		[1] = 200*2,
		[2] = 350*2,
		[3] = 500*2,
		[4] = 700*2,
	}

	-- Aplicar blindaje
	addEventHandler('buy:blindajeVeh', root,
		function(num, price)
			if getPlayerMoney(client) >= price then
				exports.players:takeMoney(client, tonumber(price))
				setElementData( source, 'BlindajeVehicular', {num, lvl[num], lvl[num]})
				outputChatBox('> Blindaje aplicado con exito!', client, 0, 255, 0)
			else
				outputChatBox('Dinero insuficiente.', client, 255, 0, 0)
			end
		end
	)

	-- Remover blindaje
	addEventHandler('remove:blindajeVeh', root,
		function()
			if getElementData(source, 'BlindajeVehicular') then
				removeElementData( source, 'BlindajeVehicular')
				outputChatBox('> Blindaje removido con exito!', client, 0, 255, 0)
			end
		end
	)

	-- Optimización: manejar el daño por evento y reembolsar el daño cubierto tras aplicarse
	addEventHandler("onVehicleDamage", root,
		function(loss)
			local tab = getElementData(source, 'BlindajeVehicular')
			if not tab then return end
			if not loss or loss <= 0 then return end
			if not tab[2] or tab[2] <= 0 then return end

			local covered = math.min(tab[2], loss)
			if covered <= 0 then return end
			tab[2] = tab[2] - covered

			-- Siguiente frame: el daño por defecto ya se aplicó
			setTimer(function(veh, covered, tab)
				if not isElement(veh) then return end
				local hp = getElementHealth(veh)
				setElementHealth(veh, math.min(1000, hp + covered))
				setElementData(veh, 'BlindajeVehicular', tab)
			end, 0, 1, source, covered, tab)
		end
	)

	addEventHandler( "onPlayerClick", getRootElement(),
		function(button, state, element)
			if button == 'left' and state == 'down' then
				if not getPedOccupiedVehicle( source ) then
					if isElement(element) then
						if getElementType( element ) == 'vehicle' then
							if exports.factions:isPlayerInFaction(source, 11) then

								local ex, ey, ez = getElementPosition(element)
								local px, py, pz = getElementPosition(source)

								if getDistanceBetweenPoints3D(ex, ey, ez, px, py, pz) < 3 then
									--if getPlayerName( source ):find('Claw') then

										triggerClientEvent(source, 'showBlindajeVeh', source, element)

									--end
								end

							end
						end
					end
				end
			end 
		end
	)

	local dbC = dbConnect( "sqlite", "blindaje.db" )
	addEventHandler('onVehicleLogin', root,
		function(id)
			if id then
				
				local qh = dbQuery( dbC, "SELECT * FROM info WHERE id=?", tostring(id))
				if qh then
					local resultado = dbPoll( qh, -1 )
					if #resultado == 1 then

						setElementData(source, 'BlindajeVehicular', fromJSON(resultado[1].value))
						dbFree(dbExec(dbC, 'delete FROM info WHERE id=?', tostring(id)))

					end
				end
			end
		end
	)

	addEventHandler('onVehicleLogout', root,
		function(id)
			if id then
				local tab = getElementData(source, 'BlindajeVehicular')
				if tab then
					dbFree(dbExec( dbC, "INSERT INTO info VALUES (?,?)", tostring(id), toJSON(tab)))
				end
			end
		end
	)
end