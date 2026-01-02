function showBoxSide( target, text, type )

	if ( isElement( target ) and text and type ) then

		triggerClientEvent( target, "showBoxSide", target, text, type )

	end

end