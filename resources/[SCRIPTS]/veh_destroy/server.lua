addEventHandler( "onCharacterLogout", root,
	function ( )
		if isElement( source ) then
			local ID = exports.players:getCharacterID( source )
			if ID then
				for k, veh in ipairs( getElementsByType( "vehicle" ) ) do
					if isElement( veh ) then
						if getElementData( veh, "idowner" ) == ID then
							triggerEvent( "onVehicles > deleteOwnerVehicles", source, veh );
						end
					end
				end
			end
		end
	end
)

addEventHandler( "onCharacterLogin", root,
	function ( )
		if isElement( source ) then
			local ID = exports.players:getCharacterID( source )
			if ID then
				for k, veh in ipairs( getElementsByType( "vehicle" ) ) do
					if isElement( veh ) then
						if getElementData( veh, "idowner" ) == ID then
							triggerEvent( "onVehicles > deleteVehicles", source, veh );
						end
					end
				end
			end
		end
	end
)