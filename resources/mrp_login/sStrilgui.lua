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

-- Obtener el usuario vinculado al serial del equipo
addEvent('strilgui.getUserBySerial', true)
addEventHandler('strilgui.getUserBySerial', root,
function()
	local serial = getPlayerSerial(client)
	if not serial then
		return triggerClientEvent(client, 'strilgui.changePassInfo', client, nil)
	end
	local q = exports.sql:query_assoc_single("SELECT `username` FROM `wcf1_user` WHERE `lastSerial` LIKE '%s' OR `regSerial` LIKE '%s'", serial, serial)
	if q and q.username then
		triggerClientEvent(client, 'strilgui.changePassInfo', client, q.username)
	else
		triggerClientEvent(client, 'strilgui.changePassInfo', client, nil)
	end
end)

-- Cambiar contraseña verificando que el serial del equipo coincide
addEvent('strilgui.changePasswordBySerial', true)
addEventHandler('strilgui.changePasswordBySerial', root,
function(newPassword)
	local serial = getPlayerSerial(client)
	if not serial or not newPassword or tostring(newPassword) == '' then
		return triggerClientEvent(client, 'strilgui.passwordChanged', client, false, 'Datos invalidos')
	end
	if string.len(newPassword) < 6 then
		return triggerClientEvent(client, 'strilgui.passwordChanged', client, false, 'La clave debe tener al menos 6 caracteres')
	end
	local q = exports.sql:query_assoc_single("SELECT `userID`, `username` FROM `wcf1_user` WHERE `lastSerial` LIKE '%s' OR `regSerial` LIKE '%s'", serial, serial)
	if not q or not q.userID then
		return triggerClientEvent(client, 'strilgui.passwordChanged', client, false, 'No hay usuario vinculado a este equipo')
	end

	-- Generar salt y hash igual que en gestiones.lua
	local salt = ''
	local chars = { 'a', 'b', 'c', 'd', 'e', 'f', 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
	for i = 1, 40 do
		salt = salt .. tostring(chars[math.random(1, #chars)])
	end
	local newpass = hash('sha1', tostring(salt)..tostring(hash('sha1', tostring(salt)..tostring(hash('sha1', newPassword)))))

	local ok1 = exports.sql:query_free("UPDATE `wcf1_user` SET `salt` = '%s' WHERE `userID` = %d", salt, q.userID)
	local ok2 = exports.sql:query_free("UPDATE `wcf1_user` SET `password` = '%s' WHERE `userID` = %d", newpass, q.userID)
	if ok1 and ok2 then
		triggerClientEvent(client, 'strilgui.passwordChanged', client, true, nil, q.username, newPassword)
	else
		triggerClientEvent(client, 'strilgui.passwordChanged', client, false, 'No se pudo actualizar la clave')
	end
end)