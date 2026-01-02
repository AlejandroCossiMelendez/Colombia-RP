
local outputChatBox_ = outputChatBox
function outputChatBox(player,text,r,g,b,color)
	return outputChatBox_(text,player or root,r or 255,g or 255,b or 255,color or false)
end

addEvent("onRequestLoginPanel",true)
addEventHandler("onRequestLoginPanel",getRootElement(),
function()
	local sqlResource = getResourceFromName("sql")
	if not sqlResource or getResourceState(sqlResource) ~= "running" then
		outputDebugString("loginpanel: SQL resource not available, retrying...", 2)
		setTimer(function()
			triggerClientEvent(client, "onRequestLoginPanel", client)
		end, 1000, 1)
		return
	end
	
	-- Usar pcall para capturar errores de exports
	local success, query = pcall(function()
		return exports.sql:query_assoc_single("SELECT `userID`  FROM `wcf1_user` WHERE `lastSerial` OR `regSerial` LIKE '%s'", getPlayerSerial(client))
	end)
	
	if not success then
		outputDebugString("loginpanel: SQL export not available, retrying...", 2)
		setTimer(function()
			triggerClientEvent(client, "onRequestLoginPanel", client)
		end, 1000, 1)
		return
	end
	
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
	local sqlResource = getResourceFromName("sql")
	if not sqlResource or getResourceState(sqlResource) ~= "running" then
		outputDebugString("loginpanel: SQL resource not available for forgotpass", 2)
		triggerClientEvent(client,"client:forgotpass:callBack",client,false)
		return
	end
	
	-- Usar pcall para capturar errores de exports
	local success, query = pcall(function()
		return exports.sql:query_assoc_single("SELECT `username` FROM `wcf1_user` WHERE `regSerial` LIKE '%s'", getPlayerSerial(client))
	end)
	
	if not success then
		outputDebugString("loginpanel: SQL export not available for forgotpass", 2)
		triggerClientEvent(client,"client:forgotpass:callBack",client,false)
		return
	end
	
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
	local sqlResource = getResourceFromName("sql")
	if not sqlResource or getResourceState(sqlResource) ~= "running" then
		outputDebugString("loginpanel: SQL resource not available for changePassword", 2)
		triggerClientEvent(client,"client:recoverFailed",client,false)
		return
	end
	
	-- Usar pcall para capturar errores de exports
	local success, query = pcall(function()
		return exports.sql:query_assoc_single("SELECT `username` FROM `wcf1_user` WHERE `regSerial` LIKE '%s'", getPlayerSerial(client))
	end)
	
	if not success then
		outputDebugString("loginpanel: SQL export not available for changePassword", 2)
		triggerClientEvent(client,"client:recoverFailed",client,false)
		return
	end
	
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