local fuente = dxCreateFont ( "Lato-Light.ttf", 12 )
local mensaje, tipo
local localPlayer = getLocalPlayer( )
local disponible = true
function eliminarMensaje( ) timer = setTimer( function ( ) mensaje = " " tipo = nil end, 2000, 1 ) end

addCommandHandler( "toggletextos",
	function( )
		if disponible == false then
			addEventHandler( "onClientRender", root, dibujar_names )
			disponible = true
		else
			removeEventHandler( "onClientRender", root, dibujar_names )
			disponible = false
		end
	end
)

addEvent( "onChat", true )
addEventHandler( "onChat", getRootElement( ),
	function( message, type )
		if message and type then
			eliminarMensaje( )
			mensaje = message
			tipo = type
		end
	end
)

addCommandHandler( "yo",
	function( )
		setElementData( localPlayer, "yo", "Es bastante alto y fuerte | Tatuaje en el cuello de un caballo" )
	end
)

function dibujar_names( )
	local px, py, pz, tx, ty, tz
	local jugadores = getElementsByType( 'player' )
	px, py, pz = getCameraMatrix( )
	tx, ty, tz = getElementPosition( localPlayer )
	for i=1, #jugadores do
		local v = jugadores[ i ]
		setPlayerNametagShowing( v, false )
		local r, g, b = getPlayerNametagColor ( v )
		local id = getElementData( v, "playerid" ) or nil
		local cascos = getElementData( v, "Cascos" ) or 0
		if getDistanceBetweenPoints3D( tx, ty, tz, getElementPosition( v ) ) <= 8 then
			if isLineOfSightClear( px, py, pz, tx, ty, tz, true, false, false, true, false, false, false,localPlayer ) then
				local sx, sy, sz = getPedBonePosition( v, 6 )
				local xj, yj, zj = getPedBonePosition( localPlayer, 6 )
				local xp, yp = getScreenFromWorldPosition( xj, yj, zj + 0.3 )
				local vida = tonumber( getElementHealth( v ) )
				local x, y = getScreenFromWorldPosition( sx, sy, sz + 0.3 )
					if x then
						-- Dibujado del /yo
						dxDrawText( tostring( getElementData(v, "yo") or "N/A" ), x, y+20+2, x, y, tocolor(0, 0, 0), 0.65, fuente, "center", "center" )
						dxDrawText( tostring( getElementData(v, "yo") or "N/A" ), x, y+20, x, y, tocolor(0, 255, 90), 0.65, fuente, "center", "center" )
						if cascos == 1 then
							dxDrawText( "["..id.."] Desconocido", x, y-7+2, x, y, tocolor(0, 0, 0), 1, fuente, "center", "center" )
							dxDrawText( "["..id.."] Desconocido", x, y-7, x, y, tocolor(r, g, b), 1, fuente, "center", "center" )						
						else
							if vida >= 50 then
								dxDrawText( "["..id.."] ", x, y-7+2, x, y, tocolor(0, 0, 0), 1, fuente, "center", "center" )
								dxDrawText( "["..id.."] ", x, y-7, x, y, tocolor(r, g, b), 1, fuente, "center", "center" )
							end
							if vida <= 50 then
								dxDrawText( "["..id.."] ", x, y-7+2, x, y, tocolor(0, 0, 0), 1, fuente, "center", "center" )
								dxDrawText( "["..id.."] ", x, y-7, x, y, tocolor(255, 145, 0), 1, fuente, "center", "center" )
							end
							if vida <= 10 then
								dxDrawText( "["..id.."] ", x, y-7+2, x, y, tocolor(0, 0, 0), 1, fuente, "center", "center" )
								dxDrawText( "["..id.."] ", x, y-7, x, y, tocolor(255, 0, 0), 1, fuente, "center", "center" )						
							end
						end
					if isChatBoxInputActive() and not isTimer( timer ) then
						dxDrawText( "Hablando o actuando...", xp, yp+43+2, xp, yp, tocolor(0, 0, 0), 0.7, fuente, "center", "center" )
						dxDrawText( "Hablando o actuando... ", xp, yp+43, xp, yp, tocolor(255, 255, 255), 0.7, fuente, "center", "center" )
					end
					if isConsoleActive() and not isTimer( timer ) then
						dxDrawText( "Consola abierta...", xp, yp+43+2, xp, yp, tocolor(0, 0, 0), 0.7, fuente, "center", "center" )
						dxDrawText( "Consola abierta... ", xp, yp+43, xp, yp, tocolor(255, 255, 255), 0.7, fuente, "center", "center" )					
					end
					if tipo == 0 then
						dxDrawText( "> "..mensaje, xp, yp+43+2, xp, yp, tocolor(0, 0, 0), 0.7, fuente, "center", "center" )
						dxDrawText( "> "..mensaje, xp, yp+43, xp, yp, tocolor(255, 255, 255), 0.7, fuente, "center", "center" )
					elseif tipo == 1 then
						dxDrawText( "> "..mensaje, xp, yp+43+2, xp, yp, tocolor(0, 0, 0), 0.7, fuente, "center", "center" )
						dxDrawText( "> "..mensaje, xp, yp+43, xp, yp, tocolor(255, 0, 0), 0.7, fuente, "center", "center" )
					elseif tipo == 2 then
						dxDrawText( "* "..mensaje, xp, yp+43+2, xp, yp, tocolor(0, 0, 0), 0.7, fuente, "center", "center" )
						dxDrawText( "* "..mensaje, xp, yp+43, xp, yp, tocolor(255, 255, 0), 0.7, fuente, "center", "center" )						
					else
						dxDrawText( "", x, y+18, x, y, tocolor(255, 0, 0), 2, fuente, "center", "center" )
					end
				end
			end
		end
	end
end
addEventHandler( "onClientRender", root, dibujar_names )

 
local screenWidth, screenHeight = guiGetScreenSize ( )
addEventHandler("onClientRender", root,
	function()
		local res = getResourceFromName( "players" )
		if res and call( res, "isLoggedIn" ) then
			local yo = getElementData(localPlayer, "yo")
			local info = "Características: Nada. (Usa /yo para asignar)"
			if not yo then
				dxDrawText ( info, 43, screenHeight - 42, screenWidth, screenHeight, tocolor ( 0, 0, 0, 220 ), 1, "default" )
				dxDrawText ( info, 43, screenHeight - 43, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "default" )
			end
		end
    end
)