local config = getConfig ( )

addEvent('strilgui.register', true)
addEventHandler('strilgui.register', root, 
function (player, account, password)
	triggerEvent( "players:register", player, account, password )
end)

addEvent('strilgui.loggin', true)
addEventHandler('strilgui.loggin', root, 
function (player, user, password)
		triggerEvent( "players:login", player, user, password )
		triggerClientEvent(player, 'strilgui.saveLoginToXML', player, user, password)
end)

function logindec()
	local query = exports.sql:query_assoc_single("SELECT `userID`  FROM `wcf1_user` WHERE `lastSerial` OR `regSerial` LIKE '%s'", getPlayerSerial(client))
	local serialRegistered = false
	if query then
		if query.userID then
			serialRegistered = true
		end
	end
    triggerClientEvent(source, "showLoginPanel", source)
end
addEvent("onRequestLoginPanel", true)
addEventHandler("onRequestLoginPanel", getRootElement(), logindec)
