
local outputChatBox_ = outputChatBox
function outputChatBox(player,text,r,g,b,color)
	return outputChatBox_(text,player or root,r or 255,g or 255,b or 255,color or false)
end

addEvent("onRequestLoginPanel",true)
addEventHandler("onRequestLoginPanel",getRootElement(),
function()
	local query = exports.sql:query_assoc_single("SELECT `userID`  FROM `wcf1_user` WHERE `lastSerial` OR `regSerial` LIKE '%s'", getPlayerSerial(client))
	local serialRegistered = false
	if query then
		if query.userID then
			serialRegistered = true
		end
	end
	--serialRegistered
	triggerClientEvent(client,"client:init:callBack",client,false)
end
)

addEvent("server:login",true)
addEventHandler("server:login",root,
function(username,password)
	triggerEvent( "players:login", client, username, password )
end
)

addEvent("server:register",true)
addEventHandler("server:register",root,
function(username,password)
	triggerEvent( "players:register", client, username, password )
end
)

addEvent("server:forgotpass",true)
addEventHandler("server:forgotpass",root,
function(username)
	local query = exports.sql:query_assoc_single("SELECT `username` FROM `wcf1_user` WHERE `regSerial` LIKE '%s'", getPlayerSerial(client))
	local usernameValidation = false
	if query then
		if query.username and tostring(query.username) == tostring(username) then
			usernameValidation = true
		end
	end
	triggerClientEvent(client,"client:forgotpass:callBack",client,usernameValidation)
end
)

addEvent("server:changePassword",true)
addEventHandler("server:changePassword",root,
function(username,password)
	local query = exports.sql:query_assoc_single("SELECT `username` FROM `wcf1_user` WHERE `regSerial` LIKE '%s'", getPlayerSerial(client))
	local usernameValidation = false
	if query then
		if query.username and query.username == username then
			usernameValidation = true
		end
	end
	if usernameValidation == true then
		-- Revisar: no se hace el cambio correctamente de la pass, o eso o el boton de login no funciona.
		exports.admin:setPassword(username, password)
		triggerEvent( "players:login", client, username, password )
	else
		triggerClientEvent(client,"client:recoverFailed",client,usernameValidation)
	end
end
)

addEventHandler("onResourceStart",resourceRoot,
	function()
		DB = dbConnect('sqlite','test.db')
		if DB then
			--dbFree(DB:query('create table if not exists Verificacion (Serial TEXT, RolTest TEXT)'))
		end
	end
)


addEvent("server:checkRolTest_",true)
addEventHandler("server:checkRolTest_",root,
	function()
		local check = false

		local tab = DB:query('select * from Verificacion where Serial=?', client:getSerial())
		local qh = dbPoll(tab, -1 )
		if qh and #qh > 0 then
			if qh[1].RolTest == 'Si' then
				check = true
			end
		end

		client:triggerEvent('client:checkRolTest_', resourceRoot, check)
		dbFree( tab )
	end
)

addEvent("server:saveRolTest_",true)
addEventHandler("server:saveRolTest_",root,
	function()
		local tab = DB:query('select * from Verificacion where Serial=?', client:getSerial())
		local qh = dbPoll(tab, -1 )
		if (qh and #qh == 0) then
			dbFree(DB:query('insert into Verificacion values(?,?)', client:getSerial(), 'Si'))
		end

		client:triggerEvent('client:checkRolTest_', resourceRoot, true)
		dbFree( tab )
	end
)

addEvent("server:noPasedRolTest_",true)
addEventHandler("server:noPasedRolTest_",root,
	function()
		client:kick('Reprobaste el test de rol.')
	end
)