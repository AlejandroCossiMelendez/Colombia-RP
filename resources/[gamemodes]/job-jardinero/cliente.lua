local col = nil
local blip = nil
local plantas = {}
local recogido = 0

local punto = 0
local texto = ""
local color = {255,255,255}

local textoPlanta = { 0, 0, 0 }

local blipJob, sphereJob

addEvent( getResourceName( resource ) .. ":introduce", true )
addEventHandler( getResourceName( resource ) .. ":introduce", root,
	function( )
		exports.gui:hint( "Jardinero", "Acercate al Punto Marcado en el Mapa y ayuda a Limpiar el terreno que hay.", 1 )
		
		if not blipJob and not sphereJob then
			sphereJob = createColSphere( 12.701171875, 66.9853515625, 3.109649658203, 20 )
			blipJob = createBlipAttachedTo( sphereJob, 0, 3, 0, 255, 0, 127 )
			
			addEventHandler( "onClientColShapeHit", sphereJob,
				function( element )
					if element == getLocalPlayer( ) then
						destroyElement( blipJob )
						destroyElement( sphereJob )
						
						sphereJob = nil
						blipJob = nil
						
						exports.gui:hint( "Jardinero", "Coge un tractor y enganchale un remolque. Acto seguido empieza a cosechar." )
					end
				end
			)
		end
	end
)

local sx, sy = guiGetScreenSize()
local timer_texto = nil

function dibujarTextosJob()
	dxDrawText( "Llevas Limpiado: "..recogido, 20, 60, sx, sy, tocolor( 255, 255, 255 ), 2, "default-bold", "left", "bottom" )
	dxDrawText( texto, 20, 60, sx, sy, tocolor( unpack(color) ), 2, "default-bold", "center", "center" )
	if textoPlanta and type( textoPlanta ) == "table" then
		local x, y, z = unpack( textoPlanta )
		local worldX, worldY = getScreenFromWorldPosition( x, y, z )
		if worldX and worldY and getDistanceBetweenPoints3D( x, y, z,getElementPosition( getLocalPlayer() ) ) < 25 then
			dxDrawText( "¡Elimina las malas hierbas aqui!", worldX, worldY+1, worldX, worldY, tocolor(0,0,0), 1, "default-bold", "center", "center" )
			dxDrawText( "¡Elimina las malas hierbas aqui!", worldX, worldY, worldX, worldY, tocolor(255,150,0), 1, "default-bold", "center", "center" )
		end
	end
end

function setTexto( txt, clr )
	texto = txt
	color = clr
	if isTimer( timer_texto ) then killTimer( timer_texto ) end
	timer_texto = setTimer( function()
		texto = ""
		color = {255,255,255}
		timer_texto = nil
	end, 2000, 1)
end

function limpiarTodo()
	if isElement(col) then destroyElement(col) col = nil end
	if isElement( blip ) then destroyElement( blip ) blip = nil end
	textoPlanta = nil
	recogido = 0
	punto = 0
	texto = ""
	color = {255,255,255}
	removeEventHandler( "onClientRender", getRootElement(), dibujarTextosJob )
end

function siguientePunto()
	if punto == #ruta then
		if isElement( blip ) then destroyElement( blip ) end
		if isElement( plantas[punto] ) then destroyElement( plantas[punto] ) end
		outputChatBox( "Limpiaste un total de "..recogido..". Ganaste un total de : ", 0, 200, 0 )
		outputChatBox( "Ganancias: ".. math.floor(recogido*1) .."$.", 0, 200, 0 )
		triggerServerEvent( "jardineria:pagar", getLocalPlayer(), math.floor(recogido*1)  )
		limpiarTodo()
	else
		if isElement( blip ) then destroyElement( blip ) end
		if isElement( col ) then destroyElement( col ) end
		if isElement( plantas[punto] ) then destroyElement( plantas[punto] ) end
		punto = punto + 1
		local x, y, z, _ = unpack( ruta[punto] )
		col = createColSphere( x, y, z, 1 )
		blip = createBlip( x, y, z, 0, 1, 0, 150, 0, 255 )
		textoPlanta = { x, y, z }
	end
end

addEventHandler( "onClientColShapeHit", getRootElement(),
	function( element )
		if getElementType( element ) == "vehicle" and getElementModel( element ) == 610 and getVehicleController( element ) == getLocalPlayer() and source == col then
			local recogido_mas = math.random( 0, 1 )
			recogido = recogido + recogido_mas
			if recogido_mas == 1 then
				setTexto( "¡Quitaste bien las malas hierbas!", {0,255,0} )
			else			
				setTexto( "¡No quitaste bien las malas hierbas!", {255,0,0} )
			end
			siguientePunto()
		end
	end
)

addEvent( "jardineria:empezarTrabajo", true )
addEventHandler( "jardineria:empezarTrabajo", getRootElement(),
	function()
		if not col then
			punto = 0
			local xinicial, yinicial, zinicial, _ = unpack( ruta[1] )
			col = createColSphere( xinicial, yinicial, zinicial, 1 )
			blip = createBlip( xinicial, yinicial, zinicial, 0, 1, 0, 150, 0, 255 )
			textoPlanta = { xinicial, yinicial, zinicial }
			setTexto( "Ya puedes empezar a Limpiar", {0,255,0} )
			addEventHandler( "onClientRender", getRootElement(), dibujarTextosJob )
			for i=1, #ruta do 
				local x, y, z, _ = unpack( ruta[i] )
				plantas[i] = createObject( 826, x, y, z-0.2 )
				setObjectScale( plantas[i], 0.5 )
			end	
		end
	end
)