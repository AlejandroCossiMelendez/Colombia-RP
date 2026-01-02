local function getJugadoresFaccion( factionID )
	local p = { }
	for index,value in ipairs(getElementsByType("player")) do 
		if exports.factions:isPlayerInFaction( value, factionID ) or getElementData(value, "enc"..tostring(factionID)) then 
			table.insert( p, value )
		end 
	end 
	return p
end

addEvent( "onServer > getOnlineMembers", true )
addEventHandler( "onServer > getOnlineMembers", root,
	function ( )
		triggerClientEvent( source, "onClient > sendOnlineMembers", source, #getJugadoresFaccion( 1 ), #getJugadoresFaccion( 2 ), #getJugadoresFaccion( 3 ), #getJugadoresFaccion( 22 ) )
	end
)