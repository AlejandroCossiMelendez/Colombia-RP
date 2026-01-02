addCommandHandler( "setskin",
	function( player, commandName, otherPlayer, skin )
		skin = tonumber( skin )
		if otherPlayer and skin then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local oldSkin = getElementModel( other )
				local characterID = exports.players:getCharacterID( other )
				if oldSkin == skin then
					outputChatBox( name .. " ya usas esta skin.", player, 255, 255, 0 )
				elseif characterID and setElementModel( other, skin ) then
					if exports.sql:query_free( "UPDATE characters SET skin = " .. skin .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Cambiada la skin de " .. name .. " a " .. skin, player, 0, 255, 153 )
						exports.players:updateCharacters( other )
					else
						outputChatBox( "Fallo con guardar la skin en la base de datos.", player, 255, 0, 0 )
						setElementModel( other, oldSkin )
					end
				else
					outputChatBox( "La skin " .. skin .. " es invalida.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [skin]", player, 255, 255, 255 )
		end
	end,
	true
)

function toggleInvis( source )
	local accName = getAccountName ( getPlayerAccount ( source ) )
    local staffAyudante = isObjectInACLGroup("user."..accName, aclGetGroup("Helper"))
    local staffModerador = isObjectInACLGroup("user."..accName, aclGetGroup("Moderador"))
    local staffSuperModerador = isObjectInACLGroup("user."..accName, aclGetGroup("GameOperator"))
    local staffAdministrador = isObjectInACLGroup("user."..accName, aclGetGroup("Administrador"))
    local staffCreador = isObjectInACLGroup("user."..accName, aclGetGroup("Desarrollador"))
	
	if accName then
	if staffAyudante or staffAdministrador or staffModerador or staffSuperModerador or staffCreador == true then
	if iv == 0 then
		iv = 1
		triggerClientEvent( root, "nmtgs:removePlayer", root, source )
		setElementAlpha(source, 0)
		outputChatBox ("#00ff00Has entrado en el modo invisible.", source,0,0,0, true)
	else
		iv = 0
		triggerClientEvent( root, "nmtgs:addPlayer", root, source )
		setElementAlpha(source, 255)
		outputChatBox ("#ff0000Has salido del modo invisible.", source,0,0,0, true)
	end
end
end
end

addCommandHandler ( "invisible", toggleInvis )