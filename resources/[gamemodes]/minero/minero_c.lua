zoneMina = ColShape.Sphere(589.169921875, 917.0185546875, -43.053913116455, 40)

setDevelopmentMode( true )
procesadora = ColShape.Sphere(673.81640625, 826.474609375, -42.9609375, 2)
Marker(673.78515625, 826.4248046875, -42.9609375-1, 'cylinder', 1, 255,255,0, 100)


local fabrica = Marker(-1053.5029296875, 1548.5556640625, 33.437610626221-1, 'cylinder', 1.3, 255,255,255, 50)

local screenW, screenH = guiGetScreenSize()
local segundos = 0

addEventHandler("onClientRender", root,
    function()

    	if localPlayer:isWithinColShape(zoneMina) then

        	dxDrawText("Zona de Minar", (screenW * 0.8828) + 1.5, (screenH * 0.9544) + 1.5, (screenW * 0.9941) + 1.5, (screenH * 0.9753) + 1.5, tocolor(0, 0, 0, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
        	dxDrawText("Zona de Minar", screenW * 0.8828, screenH * 0.9544, screenW * 0.9941, screenH * 0.9753, tocolor(254, 254, 254, 254), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
    	
    	end

    	if barActive then
			
			local pos = localPlayer.position
			local x,y = getScreenFromWorldPosition( pos, 1, false )
			local now = getTickCount()
	        tick = tick or getTickCount()
			local i = getEasingValue( (now-tick)/segundos, 'Linear' )

			if x and y then

			    dxDrawRectangle( x-75, y, 150, 8, tocolor(90,90,90,150), false)
			    dxDrawRectangle( x-75, y, 150*i, 8, tocolor(25, 53, 23,150), false)
	            dxDrawText(''..math.floor(100*i)..'%', x-75, y, 150+x-75, 8+y, tocolor(255,255,255), .7, 'default-bold', 'center','center')
	            dxDrawText((procesando and 'Procesando...' or fabricando and 'Fabricando...' or 'Picando...'), x-75, y-10, 150+x-75, 8+y-10, tocolor(255,255,255), .7, 'default-bold', 'center','center')

			end

	    else
	        tick = nil
		end

    end
)



addEventHandler( "onClientColShapeLeave", zoneMina,
	function(e)
		if e == localPlayer then
			Server.takeWeapon(localPlayer, 6)
		end
	end
)

addEventHandler( "onClientColShapeHit", zoneMina,
	function(e)
		if e == localPlayer then
			if isWorking then
				Server.giveWeapon(localPlayer, 6, 1, true)
			end
		end
	end
)

addCommandHandler('renunciar',
	function()
		if isWorking then

			isWorking = false
			Server.takeWeapon(localPlayer, 6)
			if TiempoPicar and TiempoPicar:isValid() then
				killTimer( TiempoPicar )
			end
			if isElement(PicoSonido) then
            	PicoSonido:destroy()
            end
            if TiempoProces and TiempoProces:isValid() then
				killTimer( TiempoProces )
			end

            barActive = false
            procesando = false
            localPlayer.frozen = false
            Server.setPedAnimation(localPlayer)

            outputChatBox('Renunciaste', 0,255,0, true)
		end
	end
)

addCommandHandler('procesar',
	function(_, mat)
		if not localPlayer:isWithinColShape(procesadora) then
			return
		end
		if isWorking then
			local mat = mat:lower()
			if precio[mat] then

				local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
				if minerales[mat] > 0 then

					if not procesando then

						procesando = true
						barActive = true
		                localPlayer.frozen = true
		                segundos = 30000
		                tick = getTickCount()



		                TiempoProces = Timer(
		                    function(mat)

		                       	local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
		                       	minerales[mat] = minerales[mat] - 1

		                       	if mat == 'hierro' then
		                       		outputChatBox('-> Haz obtenido 1 de acero!', 0,255,0, true)
		                       		minerales.acero = minerales.acero + 1
		                       	elseif mat == 'carbon' then
		                       		outputChatBox('-> Haz obtenido 1 de polvora!', 0,255,0, true)
		                       		minerales.polvora = minerales.polvora + 1
		                       	elseif mat == 'bauxita' then
		                       		outputChatBox('-> Haz obtenido 1 de aluminio!', 0,255,0, true)
		                       		minerales.aluminio = minerales.aluminio + 1
		                        end    

		                        localPlayer:setData('minero:minerales', minerales)     
		                        

		                        barActive = false
		                        localPlayer.frozen = false
		                        procesando = false

		                    end,
		                30000,1, mat)

		            end
		        else
		        	outputChatBox('No tienes suficiente mineral', 255,0,0, true)
		        end

            end

		end

	end
)

addCommandHandler('picar',
	function()
		if localPlayer:isWithinColShape(zoneMina) then
			if isWorking then
				if localPlayer:getWeapon() == 6 then

					if not TiempoPicar or not TiempoPicar:isValid() then

						barActive = true
	                    localPlayer.frozen = true
	                    segundos = 60000
	                    tick = getTickCount()

	                    Server.setPedAnimation(localPlayer, 'sword','sword_4', -1, true, false, false)
	                    PicoSonido = Sound('files/pico.mp3', true)
	                    PicoSonido:setVolume(2)


	                    TiempoPicar = Timer(
	                        function()

	                           	local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
	                           	local mineralRandom = math.random(1,3)
	                           	local random = math.random(1,3)

	                           	if mineralRandom == 1 then
	                           		minerales.hierro = minerales.hierro + random
	                           		outputChatBox('Encontraste '..random..' de hierro', 255,255,255, true)
	                           	elseif mineralRandom == 2 then
	                           		minerales.carbon = minerales.carbon + random
	                           		outputChatBox('Encontraste '..random..' de carbon', 255,255,255, true)
	                           	else
	                           		minerales.bauxita = minerales.bauxita + random
	                           		outputChatBox('Encontraste '..random..' de bauxita', 255,255,255, true)
	                            end    

	                            localPlayer:setData('minero:minerales', minerales)     
	                            
	                            if isElement(PicoSonido) then
	                            	PicoSonido:destroy()
	                            end

	                            barActive = false
	                            localPlayer.frozen = false
	                            Server.setPedAnimation(localPlayer)

	                        end,
	                    60000,1)

	                end
                end
			end
		end
	end
)

addCommandHandler('materiales',
	function()
	    local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
	    outputChatBox('----- Materiales -----', 0, 255, 0)
	    outputChatBox('-> Hierro : '..minerales.hierro,0, 255, 0)
	    outputChatBox('-> Carbon : '..minerales.carbon,0, 255, 0)
	    outputChatBox('-> Bauxita : '..minerales.bauxita,0, 255, 0)
	    outputChatBox('-> Acero : '..minerales.acero,0, 255, 0)
	    outputChatBox('-> Polvora : '..minerales.polvora,0, 255, 0)
	    outputChatBox('-> Aluminio : '..minerales.aluminio,0, 255, 0)
	end
)


GUIFabrica = {
    gridlist = {},
    window = {},
    button = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
		local screenW, screenH = guiGetScreenSize()
        GUIFabrica.window[1] = guiCreateWindow((screenW - 530) / 2, (screenH - 258) / 2, 530, 258, "Fabricar Armas", false)
        guiWindowSetSizable(GUIFabrica.window[1], false)
        GUIFabrica.window[1]:setVisible(false)

        GUIFabrica.gridlist[1] = guiCreateGridList(16, 40, 497, 171, false, GUIFabrica.window[1])
        guiGridListAddColumn(GUIFabrica.gridlist[1], "Arma", 0.22)
        guiGridListAddColumn(GUIFabrica.gridlist[1], "Balas", 0.15)
        guiGridListAddColumn(GUIFabrica.gridlist[1], "Acero", 0.15)
        guiGridListAddColumn(GUIFabrica.gridlist[1], "Polvora", 0.15)
        guiGridListAddColumn(GUIFabrica.gridlist[1], "Aluminio", 0.15)
        guiGridListAddColumn(GUIFabrica.gridlist[1], "Duración", 0.15)

        GUIFabrica.gridlist[1]:addRow('Pistola','60','50','35','25', '4 min')
        GUIFabrica.gridlist[1]:addRow('Silenciadora','60', '80','50','40','6 min')
        GUIFabrica.gridlist[1]:addRow('Uzi','120','80','70','60','10 min')
        GUIFabrica.gridlist[1]:addRow('Tec-9','120','80','70','60','10 min')
        GUIFabrica.gridlist[1]:addRow('Escopeta','40','120','80','70','15 min')
        GUIFabrica.gridlist[1]:addRow('Ak-47','80','160','100','90','20 min')


        GUIFabrica.button[1] = guiCreateButton(37, 219, 209, 29, "Fabricar Arma", false, GUIFabrica.window[1])
        GUIFabrica.button[2] = guiCreateButton(280, 219, 209, 29, "Salir", false, GUIFabrica.window[1])    
    end
)



addCommandHandler('fabricararma',
	function()
	    if localPlayer:isWithinMarker(fabrica) then
	    	if not fabricando then
	    		GUIFabrica.window[1]:setVisible(true)
	    		showCursor(true)
	    	end
	    end
	end
)


weapons = {
	Pistola= {balas=60,acero=50,polvora=35,aluminio=25, time=10000*4},
    Silenciadora = {balas=60, acero=80,polvora=50,aluminio=40, time=60000*6},
    Uzi = {balas=120,acero=80,polvora=70,aluminio=60,time=60000*10},
    ['Tec-9'] = {balas=120,acero=80,polvora=70,aluminio=60,time=60000*10},
    ['Ak-47'] = {balas=80,acero=160,polvora=100,aluminio=90,time=60000*20},
    ['Escopeta'] = {balas=40,acero=120,polvora=80,aluminio=70,time=60000*15}, 
}

weaponID = {
	Pistola = 22,
	Silenciadora = 23,
	Uzi = 28,
	['Tec-9'] = 32,
	['Ak-47'] = 30,
	['Escopeta'] = 25,
}

addEventHandler( "onClientGUIClick", root,
    function(button, state)
        if button == 'left' then
            if state == 'up' then
                if GUIFabrica.button[1] == source then

                    local wep = GUIFabrica.gridlist[1]:getItemText(GUIFabrica.gridlist[1]:getSelectedItem(), 1)
                    if not fabricando and weapons[wep] then
			    		GUIFabrica.window[1]:setVisible(true)
			    		showCursor(true)
			    		fabricarWeapon(wep)
			    		GUIFabrica.window[1]:setVisible(false)
                    	showCursor(false)
			    	end

                elseif GUIFabrica.button[2] == source then
                    GUIFabrica.window[1]:setVisible(false)
                    showCursor(false)
                end
            end
        end
    end
)

function fabricarWeapon(wep)
	if not fabricando then
    	local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
    	local t = weapons[wep]

    	if minerales.acero >= t.acero and minerales.polvora >= t.polvora and minerales.aluminio >= t.aluminio then

			fabricando = true
			barActive = true
            localPlayer.frozen = true
            segundos = t.time
            tick = getTickCount()


            TiempoFabri = Timer(
                function(wep, acero, polvora, aluminio, balas)

                   	local minerales = localPlayer:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}

                   	minerales.acero = minerales.acero - acero
                   	minerales.polvora = minerales.polvora - polvora
                   	minerales.aluminio = minerales.aluminio - aluminio
                      

                    localPlayer:setData('minero:minerales', minerales)
					Server.giveWeapon(localPlayer, weaponID[wep], balas, true)
                    outputChatBox('Fabricaste '..wep..' con '..balas..' balas.', 0,255,0, true)

                    barActive = false
                    localPlayer.frozen = false
                    fabricando = false

                end,
            t.time,1, wep, t.acero, t.polvora, t.aluminio, t.balas)

        else
            outputChatBox('Te faltan materiales', 255,0,0, true)
        end
   	end
end

localPlayer:setData('minero:minerales', {hierro=0, carbon=0, bauxita=0, acero=200, polvora=200, aluminio=200})