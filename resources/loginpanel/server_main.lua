
local outputChatBox_ = outputChatBox
function outputChatBox(player,text,r,g,b,color)
	return outputChatBox_(text,player or root,r or 255,g or 255,b or 255,color or false)
end

addEvent("onRequestLoginPanel",true)
addEventHandler("onRequestLoginPanel",getRootElement(),
function()
	local theClient = client -- Guardar client en una variable local
	if not theClient then
		outputDebugString("loginpanel: No client available", 2)
		return
	end
	
	-- Mostrar el panel inmediatamente, incluso si SQL no está disponible
	-- Si SQL no está disponible, asumimos que el usuario no tiene cuenta
	local serialRegistered = false
	
	local sqlResource = getResourceFromName("sql")
	if sqlResource and getResourceState(sqlResource) == "running" then
		-- Intentar verificar si el serial está registrado
		local success, query = pcall(function()
			return exports.sql:query_assoc_single("SELECT `userID`  FROM `wcf1_user` WHERE `lastSerial` OR `regSerial` LIKE '%s'", getPlayerSerial(theClient))
		end)
		
		if success and query and query.userID then
			serialRegistered = true
		end
	else
		-- SQL no está disponible, mostrar panel de todas formas
		outputDebugString("loginpanel: SQL resource not available, showing panel anyway", 2)
	end
	
	-- Mostrar el panel siempre, independientemente del estado de SQL
	if theClient and isElement(theClient) then
		triggerClientEvent(theClient,"client:init:callBack",theClient,serialRegistered)
	end
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