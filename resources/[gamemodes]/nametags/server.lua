addCommandHandler ( "yo",
	function ( player, commandName, ...)
		if ( ... ) then
			local caracteristica = table.concat( { ... }, " " )
			setElementData( player, "yo", tostring( caracteristica ) )
			exports.sql:query_free( "UPDATE characters SET yo = '%s' WHERE characterID = " .. exports.players:getCharacterID( player ), caracteristica )
			outputChatBox ( "Has actualizado tú característica.", player, 255, 255, 255 )
		else
			local borrado = "Nada"
			setElementData ( player, "yo", borrado )
			exports.sql:query_free( "UPDATE characters SET yo = '%s' WHERE characterID = " .. exports.players:getCharacterID( player ), borrado )
			outputChatBox ( "Has borrado el '/yo' de tu personaje.", player, 255, 255, 255 )
		end
	end
)
