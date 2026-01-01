addEvent( "jardineria:pagar", true )
addEventHandler( "jardineria:pagar", getRootElement( ),
	function( cantidad )
		if exports.players:giveMoney( source, tonumber(cantidad) ) then
			outputChatBox( " [Ingles] Richard Flowers dice: Vuelve cuando quieras, muchacho!", source, 255, 255, 255 )
		else
			outputChatBox( "(( Error, no has podido cobrar tus ganancias de jardineria. ))", source, 255, 0, 0 )
		end
	end
)

local vehicles = { ["Tractor"] = true }

addEventHandler( "onVehicleStartEnter", root,
	function( player, seat )
		if seat == 0 and vehicles[getVehicleNameFromModel(getElementModel(source))] and "job-" .. tostring( exports.players:getJob( player ) ) ~= getResourceName( resource ) then
			outputChatBox( "(( Puedes obtener este trabajo en la granja. ))", player, 255, 0, 0 )
			cancelEvent( )
		end
	end
)

addEventHandler( "onTrailerAttach", getRootElement(),
	function( veh )
		local p = getVehicleController(veh)
		if vehicles[getVehicleNameFromModel(getElementModel(veh))] and getElementModel(source) == 610 and "job-" .. tostring( exports.players:getJob( p ) ) == getResourceName( resource ) then
			triggerClientEvent( p, "jardineria:empezarTrabajo", p )
		end
	end
)

addEventHandler( "onTrailerDetach", getRootElement(),
	function( veh )
		local p = getVehicleController(veh)
		if vehicles[getVehicleNameFromModel(getElementModel(veh))] and getElementModel(source) == 610 and "job-" .. tostring( exports.players:getJob( p ) ) == getResourceName( resource ) then
			respawnVehicle( source )
		end
	end
)


local function createOurPedJardinero( )
	if pedJ then
		destroyElement( pedJ )
	end
	pedJ = createPed( 162, 289.884765625, 1137.6884765625, 8.5859375, 0, false )
	setElementData( pedJ, "npcname", "Richard Flowers" )
	setElementRotation(pedJ,0,0,88)
	setTimer(setElementFrozen, 2000, 1, pedJ, true)
end
addEventHandler( "onPedWasted", resourceRoot, createOurPedJardinero )
addEventHandler( "onResourceStart", resourceRoot, createOurPedJardinero )

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) and source == pedJ then
				triggerClientEvent("onAbrirJob", player, "jardinero")
			end
		end
	end
)



