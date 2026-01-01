local hornTime = nil
local localPlayer = getLocalPlayer( )

bindKey( "horn", "both",
	function( button, state )
		if state == "down" then
			hornTime = getTickCount( )
		elseif hornTime then
			if getTickCount( ) - hornTime < 200 then
				local vehicle = getPedOccupiedVehicle( localPlayer )
				if vehicle and getVehicleOccupant( vehicle ) == localPlayer then
					triggerServerEvent( getResourceName( resource ) .. ":toggleLights", vehicle )
				end
			end
			hornTime = nil
		end
	end
)

--

local screenX, screenY = guiGetScreenSize( )
local vehicle = nil
local lastUpdate = 0
local lastPosition = { 0, 0, 0 }
local updateIntervall = 2000

function renderTaximeter( )
	if getPedOccupiedVehicle( localPlayer ) == vehicle then
		local distance = getElementData( vehicle, "taxi:distance" )
		if distance then
			text = ("Taximetro: %.1fm"):format( distance )
			textoCoste = ("Coste: %.1f"):format( distance/10)
			if getVehicleOccupant( vehicle ) == localPlayer then
				text = text .. " - /resettaxi para reiniciar"
				
				local tick = getTickCount( )
				if tick - lastUpdate > updateIntervall then
					local x, y, z = getElementPosition( vehicle )
					local distance = getDistanceBetweenPoints3D( x, y, z, unpack( lastPosition ) ) / 2
					
					if distance > 0.001 and distance < 40 then
						triggerServerEvent( getResourceName( resource ) .. ":update", vehicle, distance )
					end
					
					lastPosition = { x, y, z }
					lastUpdate = tick
				end
			end
		else
			text = "El taximetro esta apagado"
			if getVehicleOccupant( vehicle ) == localPlayer then
				text = text .. " - /taximeter para encenderlo"
				textoCoste = (" ")
			end
		end
			-- draw the text
		dxDrawText( text, 4, 4, screenX, screenY * 0.98 + 2, tocolor( 0, 0, 0, 255 ), 1, "pricedown", "center", "bottom", false, false, true )
		dxDrawText( text, 0, 0, screenX, screenY * 0.98, tocolor( 255, 255, 255, 255 ), 1, "pricedown", "center", "bottom", false, false, true )
		dxDrawText( textoCoste, 0, 0, screenX + 700, screenY * 0.98 + 2, tocolor( 0, 0, 0, 255 ), 1, "pricedown", "center", "bottom", false, false, true )
		dxDrawText( textoCoste, 0, 0, screenX + 700, screenY * 0.98, tocolor( 255, 255, 255, 255 ), 1, "pricedown", "center", "bottom", false, false, true )
	end
end

addEvent( getResourceName( resource ) .. ":show", true )
addEventHandler( getResourceName( resource ) .. ":show", root,
	function( )
		vehicle = source
		lastPosition = { getElementPosition( source ) }
		addEventHandler( "onClientRender", root, renderTaximeter )
	end
)

addEvent( getResourceName( resource ) .. ":hide", true )
addEventHandler( getResourceName( resource ) .. ":hide", root,
	function( )
		vehicle = nil
		removeEventHandler( "onClientRender", root, renderTaximeter )
	end
)
