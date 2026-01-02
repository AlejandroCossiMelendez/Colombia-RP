local p = { }

addEvent( "nametags:chatbubble", true )
addEventHandler( "nametags:chatbubble", root,
	function( state )
		if source == client then
			if state == true or state == false or state == 1 then
				if state == true then
					p[ source ] = true
				else
					p[ source ] = nil
				end
				local x, y, z = getElementPosition( source )
				local dimension = getElementDimension( source )
				local interior = getElementInterior( source )
				for key, player in ipairs( getElementsByType( "player" ) ) do
					if player ~= source and getElementDimension( player ) == dimension and getElementInterior( player ) == interior and getDistanceBetweenPoints3D( x, y, z, getElementPosition( player ) ) < 250 and not getElementData( source, "collisionless" ) == true then
						triggerClientEvent( player, "nametags:chatbubble", source, state )
					end
				end
			end
		else
			if p[ source ] then
				triggerClientEvent( client, "nametags:chatbubble", source, true )
			end
		end
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
	end
)