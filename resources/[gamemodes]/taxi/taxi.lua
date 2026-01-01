local function hasPassengers( vehicle, ignoreSeat )
	if vehicle then
		for i = 1, getVehicleMaxPassengers( vehicle ) do
			if i ~= ignoreSeat and getVehicleOccupant( vehicle, i ) then
				return true
			end
		end
	end
	return false
end

addEventHandler( "onVehicleEnter", root,
function( player, seat )
	if getElementModel(source) == 420 then
		if seat == 0 then
			if not hasPassengers( source ) then
				outputChatBox( "(( Espera a que alguien llame a un taxi. ))", player, 255, 204, 0 )
				if not isVehicleTaxiLightOn( source ) then
					setVehicleTaxiLightOn( source, true )
				end
			end
		else
			-- passenger
			if isVehicleTaxiLightOn( source ) then
				setVehicleTaxiLightOn( source, false )
			end
		end
		triggerClientEvent( player, getResourceName( resource ) .. ":show", source )
		unbindKey( player, "num_3" )
	end
end
)

addEventHandler( "onVehicleExit", root,
	function( player, seat )
		if getElementModel(source) == 420 then
			if seat == 0 then
				if isVehicleTaxiLightOn( source ) then
					setVehicleTaxiLightOn( source, false )
				end
			else
				-- passenger
				if getVehicleOccupant( source ) and not hasPassengers( source, seat ) then
					setVehicleTaxiLightOn( source, true )
				end
			end
			triggerClientEvent( player, getResourceName( resource ) .. ":hide", source )
		end
	end
)

--

function getDrivers( )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if getElementModel(getPedOccupiedVehicle( value )) == 420 then
			if getPedOccupiedVehicleSeat( value ) == 0 then
				table.insert( t, value )
			end
		end
	end
	return t
end

--

addEvent( getResourceName( resource ) .. ":toggleLights", true )
addEventHandler( getResourceName( resource ) .. ":toggleLights", root,
	function( )
		if source == getPedOccupiedVehicle( client ) and getVehicleOccupant( source ) == client then
			setVehicleTaxiLightOn( source, not isVehicleTaxiLightOn( source ) )
		end
	end
)

--

addCommandHandler( "taximeter",
	function( player, commandName )
		local vehicle = getPedOccupiedVehicle( player )
		if vehicle and getVehicleOccupant( vehicle ) == player then
			setElementData( vehicle, "taxi:distance", type( getElementData( vehicle, "taxi:distance" ) ) ~= "number" and 0 or false )
		end
	end
)

addCommandHandler( "resettaxi",
	function( player, commandName )
		local vehicle = getPedOccupiedVehicle( player )
		if vehicle and getVehicleOccupant( vehicle ) == player then
			setElementData( vehicle, "taxi:distance", type( getElementData( vehicle, "taxi:distance" ) ) == "number" and 0 or false )
		end
	end
)

addEvent( getResourceName( resource ) .. ":update", true )
addEventHandler( getResourceName( resource ) .. ":update", root,
	function( distance )
		if source == getPedOccupiedVehicle( client ) and getVehicleOccupant( source ) == client and getElementData( source, "taxi:distance" ) and type( distance ) == "number" and distance > 0.001 and distance < 40 then
			setElementData( source, "taxi:distance", getElementData( source, "taxi:distance" ) + distance )
		end
	end
)
