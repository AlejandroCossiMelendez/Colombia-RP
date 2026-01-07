--[[
Copyright (c) 2019 MTA: Paradise & DownTown RolePlay
 
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

-- Events
addEvent( "onCharacterLogin", false )
addEvent( "onCharacterLogout", false )

--

local team = createTeam( "MTA: Paradise" ) -- this is used as a dummy team. We need this for faction chat to work.
 
p = { }
local pendingSpawn = { }

-- Early availability for other scripts (ids.lua uses this during startup)
function isLoggedIn( player )
    return player and p[ player ] and p[ player ].charID and true or false
end

-- Import Groups
-- CONTRA PRIORITY MAS BAJO, QUIERE DECIR QUE TIENE MAS PRIORIDAD

-- Funciones wrapper seguras para ACL
local function safeAclGroupAddObject(aclGroupName, objectName)
	if not aclGroupName or not objectName then
		outputDebugString("Warning: safeAclGroupAddObject called with invalid parameters: aclGroupName=" .. tostring(aclGroupName) .. ", objectName=" .. tostring(objectName), 1)
		return false
	end
	
	local aclGroup = aclGetGroup(aclGroupName)
	if not aclGroup then
		outputDebugString("Warning: ACL group '" .. tostring(aclGroupName) .. "' does not exist when trying to add object '" .. tostring(objectName) .. "'", 1)
		return false
	end
	
	return aclGroupAddObject(aclGroup, objectName)
end

local function safeAclGroupRemoveObject(aclGroupName, objectName)
	if not aclGroupName or not objectName then
		outputDebugString("Warning: safeAclGroupRemoveObject called with invalid parameters: aclGroupName=" .. tostring(aclGroupName) .. ", objectName=" .. tostring(objectName), 1)
		return false
	end
	
	local aclGroup = aclGetGroup(aclGroupName)
	if not aclGroup then
		outputDebugString("Warning: ACL group '" .. tostring(aclGroupName) .. "' does not exist when trying to remove object '" .. tostring(objectName) .. "'", 1)
		return false
	end
	
	return aclGroupRemoveObject(aclGroup, objectName)
end

local groups = {
	{ groupName = "Developers", groupID = 1, aclGroup = "Desarrollador", displayName = "Desarrollador", nametagColor = { 0, 0, 0 }, priority = 2 },
	{ groupName = "MTA Administrators", groupID = 2, aclGroup = "Admin", displayName = "Administrador", nametagColor = { 207, 41, 41 }, priority = 1 },
	{ groupName = "MTA Moderators", groupID = 13, aclGroup = "Moderador", displayName = "Moderador", nametagColor = { 230, 91, 14 }, priority = 4 },
	{ groupName = "GameOperator", groupID = 3, aclGroup = "GameOperator", displayName = "GameOperator", nametagColor = { 136, 230, 14 }, priority = 3 },
	{ groupName = "Helper", groupID = 12, aclGroup = "Helper", displayName = "Helper", nametagColor = { 14, 223, 230 }, priority = 5 },
	{ groupName = "VIP", groupID = 15, aclGroup = "VIP", displayName = "VIP", nametagColor = { 255, 215, 0 }, priority = 6 },
}

-- Facciones System
-- Las facciones no tienen color de nametag (nil), solo se sincronizan con ACL
local factions = {
	{ groupName = "POLICIA NACIONAL DE COLOMBIA", groupID = 4, aclGroup = "Policia", displayName = "Policía Nacional", nametagColor = nil, priority = 100, isFaction = true },
	{ groupName = "SURA", groupID = 5, aclGroup = "Sura", displayName = "SURA", nametagColor = nil, priority = 101, isFaction = true },
	{ groupName = "MECANICOS", groupID = 6, aclGroup = "Meca", displayName = "Mecánicos", nametagColor = nil, priority = 102, isFaction = true },
	{ groupName = "EJERCITO NACIONAL DE COLOMBIA", groupID = 7, aclGroup = "Ejercito", displayName = "Ejército Nacional", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "MAFIA RUSA", groupID = 16, aclGroup = "MAFIARUSA", displayName = "MAFIA RUSA", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "JEFESCLUBKYOTO", groupID = 20, aclGroup = "JEFESCLUBKYOTO", displayName = "JEFESCLUBKYOTO", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "KYOTOCLUB", groupID = 21, aclGroup = "KYOTOCLUB", displayName = "KYOTOCLUB", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "EJERCITO LIBERACION NACIONAL", groupID = 22, aclGroup = "ELN", displayName = "ELN", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "CARTEL DE JALISCO", groupID = 23, aclGroup = "CDJ", displayName = "CDJ", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "CARTEL DEL GOLFO", groupID = 24, aclGroup = "CDG", displayName = "CDG", nametagColor = nil, priority = 103, isFaction = true },
	{ groupName = "TREN DE ARAGUA", groupID = 25, aclGroup = "TDA", displayName = "TDA", nametagColor = nil, priority = 103, isFaction = true },
}

-- Sistema Rainbow para VIP
local rainbowHue = 0
local vipRainbowColor = { 255, 0, 0 } -- Color inicial

-- Función para convertir HSV a RGB
local function HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    local remainder = i % 6
    
    if remainder == 0 then
        r, g, b = v, t, p
    elseif remainder == 1 then
        r, g, b = q, v, p
    elseif remainder == 2 then
        r, g, b = p, v, t
    elseif remainder == 3 then
        r, g, b = p, q, v
    elseif remainder == 4 then
        r, g, b = t, p, v
    elseif remainder == 5 then
        r, g, b = v, p, q
    end
    
    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

-- Función para actualizar el color rainbow
local function updateRainbowColor()
    rainbowHue = rainbowHue + 0.01
    if rainbowHue >= 1 then
        rainbowHue = 0
    end
    
    local r, g, b = HSVtoRGB(rainbowHue, 1, 1) -- Saturación y valor al máximo para colores vibrantes
    vipRainbowColor = { r, g, b }
end

local function updateNametagColor( player )
	local nametagColor = { 127, 127, 127, priority = 100 }
	if p[ player ] and isLoggedIn( player ) then
		nametagColor = { 255, 255, 255, priority = 100 }
		
		-- PRIORIDAD 1: Verificar si es VIP con VIP duty activado (RAINBOW)
		local vipDuty = getOption( player, "vipduty" )
		local isVipWithRainbow = false
		
		if vipDuty then
			-- Verificar si realmente es VIP (por ACL o por opción)
			local isRealVip = false
			
			-- VIP por grupo ACL
			if p[ player ] and p[ player ].username then
				if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( "VIP" ) ) then
					isRealVip = true
				end
			end
			
			-- VIP por opción antigua
			if getOption( player, "vip" ) then
				isRealVip = true
			end
			
			-- Si es VIP real y tiene VIP duty, aplicar rainbow
			if isRealVip then
				nametagColor = { vipRainbowColor[1], vipRainbowColor[2], vipRainbowColor[3] }
				nametagColor.priority = 6 -- Prioridad del grupo VIP
				isVipWithRainbow = true
			end
		end
		
		-- PRIORIDAD 2: Si no es VIP con rainbow, verificar staff duty normal
		if not isVipWithRainbow and getOption( player, "staffduty" ) then
			for key, value in ipairs( groups ) do
				if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) ) and value.nametagColor then
					if value.priority < nametagColor.priority then
						-- Para staff (incluyendo staff que son VIP), usar color normal del grupo
						nametagColor = value.nametagColor
						nametagColor.priority = value.priority
					end
				end
			end
		end
	end
	setPlayerNametagColor( player, unpack( nametagColor ) )
end

-- Función para actualizar todos los VIP con el nuevo color rainbow
local function updateAllVipColors()
	for player in pairs( p ) do
		if isLoggedIn( player ) then
			-- Solo actualizar jugadores que tengan VIP duty activado
			if getOption( player, "vipduty" ) then
				updateNametagColor( player )
			end
		end
	end
end

-- Función para obtener todos los grupos (staff + facciones) combinados
local function getAllGroups()
	local allGroups = {}
	-- Agregar grupos de staff
	for key, value in ipairs(groups) do
		table.insert(allGroups, value)
	end
	-- Agregar facciones
	for key, value in ipairs(factions) do
		table.insert(allGroups, value)
	end
	return allGroups
end

function getGroups( player )
	local g = { }
	if p[ player ] then
		for key, value in ipairs( groups ) do
			if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) ) then
				table.insert( g, value )
			end
		end
		table.sort( g, function( a, b ) return a.priority < b.priority end )
	end
	return g
end

-- Función para obtener las facciones de un jugador
function getFactions( player )
	local f = { }
	if p[ player ] then
		for key, value in ipairs( factions ) do
			if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) ) then
				table.insert( f, value )
			end
		end
		table.sort( f, function( a, b ) return a.priority < b.priority end )
	end
	return f
end

-- Función para obtener todos los grupos y facciones de un jugador
function getPlayerGroupsAndFactions( player )
	local result = { }
	if p[ player ] then
		local allGroups = getAllGroups()
		for key, value in ipairs( allGroups ) do
			if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) ) then
				table.insert( result, value )
			end
		end
		table.sort( result, function( a, b ) return a.priority < b.priority end )
	end
	return result
end


local function aclUpdate( player, saveAclIfChanged )
	local saveAcl = false
	
	if player then
		local info = p[ player ]
		if info and info.username then
			local shouldHaveAccount = false
			local account = getAccount( info.username )
			local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. info.userID )
			local sql = exports.sql:query_assoc_single( "SELECT regSerial, regSerial2 FROM wcf1_user WHERE userID = " .. info.userID )
			if groupinfo then
				-- loop through all retrieved groups
				local allGroups = getAllGroups()
				for key, group in ipairs( groupinfo ) do
					for key2, group2 in ipairs( allGroups ) do
						-- we have a acl group of interest
						if group.groupID == group2.groupID then
							-- mark as person to have an account
							shouldHaveAccount = true
							
							-- add an account if it doesn't exist
							if not account then
								outputServerLog( tostring( info.username ) .. " " .. tostring( info.mtasalt ) )
								account = addAccount( info.username, info.mtasalt ) -- due to MTA's limitations, the password can't be longer than 30 chars
								if not account then
									outputDebugString( "Account Error for " .. info.username .. " - addAccount failed.", 1 )
								else
									outputDebugString( "Added account " .. info.username, 3 )
								end
							end
							
							if account then
								-- if the player has a different account password, change it
								if not getAccount( info.username, info.mtasalt ) then
									setAccountPassword( account, info.mtasalt )
								end
								
								if isGuestAccount( getPlayerAccount( player ) ) and not logIn( player, account, info.mtasalt ) then
									-- something went wrong here
									outputDebugString( "Account Error for " .. info.username .. " - login failed.", 1 )
								else
									-- show him a message
									outputChatBox( "Te has conectado como " .. group2.displayName .. ".", player, 0, 255, 0 )
									local serial = getPlayerSerial(player)
									if serial ~= sql.regSerial and tostring(serial) ~= tostring(sql.regSerial2) then
										outputChatBox("MODO DE EMERGENCIA: por seguridad sólo se puede acceder desde el PC que registró la cuenta.", player, 255, 0, 0)
										outputChatBox("Sus datos (IP, Serial) serán grabados por seguridad. Su sesión ha sido cerrada. Contacte con Jefferson.", player, 255, 0, 0)
										--outputChatBox("Puede usar /clogin [codigo] para permitir el login desde este PC temporalmente.", player, 0, 255, 0)
										exports.logsic:addLogMessage("cuentastaff", "Cuenta: " .. info.username .. " IP:" .. getPlayerIP(player) .. " Serial: " .. getPlayerSerial(player))
										logOut(player)
										triggerEvent( "onCharacterLogout", player )
										setPlayerTeam( player, nil )
										setElementFrozen(player, true)
										setElementDimension(player, 6666)
									end
									local staffd = getOption(player, "staffduty")
									if staffd == true then
										setElementData(player, "account:gmduty", true)
									else
										setElementData(player, "account:gmduty", false)
									end
									if group2.aclGroup then
										if safeAclGroupAddObject( group2.aclGroup, "user." .. info.username ) then
											saveAcl = true
											outputDebugString( "Added account " .. info.username .. " to " .. group2.aclGroup .. " ACL", 3 )
										end
									else
										outputDebugString( "Warning: Group " .. tostring(group2.groupName) .. " (ID: " .. tostring(group2.groupID) .. ") has no aclGroup defined", 1 )
									end
								end
							end
						end
					end
				end
			end
			if not shouldHaveAccount and account then
				-- remove account from all ACL groups we use
				local allGroups = getAllGroups()
				for key, value in ipairs( allGroups ) do
					if value.aclGroup then
						if safeAclGroupRemoveObject( value.aclGroup, "user." .. info.username ) then
							saveAcl = true
							outputDebugString( "Removed account " .. info.username .. " from " .. value.aclGroup .. " ACL", 3 )
							outputChatBox( "No estás conectado como " .. value.displayName .. ".", player, 255, 0, 0 )
						end
					else
						outputDebugString( "Warning: Group " .. tostring(value.groupName) .. " (ID: " .. tostring(value.groupID) .. ") has no aclGroup defined", 1 )
					end
				end
				
				-- remove the account
				removeAccount( account )
				outputDebugString( "Removed account " .. info.username, 3 )
			end
			
			if saveAcl then
				updateNametagColor( player )
			end
		end
	else
		-- verify all accounts and remove invalid ones
		local checkedPlayers = { }
		local accounts = getAccounts( )
		for key, account in ipairs( accounts ) do
			local accountName = getAccountName( account )
			local player = getAccountPlayer( account )
			if player then
				checkedPlayers[ player ] = true
			end
			if accountName ~= "Console" then -- console may exist untouched
				local user = exports.sql:query_assoc_single( "SELECT userID FROM wcf1_user WHERE username = '%s'", accountName )
				if user then
					-- account should be deleted if no group is found
					local shouldBeDeleted = true
					local userChanged = false
					
					if user.userID then -- if this doesn't exist, the user does not exist in the db
						-- fetch all of his groups groups
						local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. user.userID )
						if groupinfo then
							-- look through all of our pre-defined groups
							local allGroups = getAllGroups()
							for key, group in ipairs( allGroups ) do
								-- user does not have this group
								local hasGroup = false
								
								-- check if he does have it
								for key2, group2 in ipairs( groupinfo ) do
									if group.groupID == group2.groupID then
										-- has the group
										hasGroup = true
										
										-- shouldn't delete his account
										shouldBeDeleted = false
										
										-- make sure acl rights are set correctly
										if group.aclGroup then
											if safeAclGroupAddObject( group.aclGroup, "user." .. accountName ) then
												outputDebugString( "Added account " .. accountName .. " to ACL " .. group.aclGroup, 3 )
												saveAcl = true
												userChanged = true
												if player then
													outputChatBox( "Te has conectado como " .. group.displayName .. ".", player, 0, 255, 0 )
												end
											end
										else
											outputDebugString( "Warning: Group " .. tostring(group.groupName) .. " (ID: " .. tostring(group.groupID) .. ") has no aclGroup defined", 1 )
										end
									end
								end
								
								-- doesn't have it
								if not hasGroup then
									-- make sure acl rights are removed
									if group.aclGroup then
										if safeAclGroupRemoveObject( group.aclGroup, "user." .. accountName ) then
											outputDebugString( "Removed account " .. accountName .. " from ACL " .. group.aclGroup, 3 )
											saveAcl = true
											userChanged = true
											if player then
												outputChatBox( "No estás conectado como " .. group.displayName .. ".", player, 255, 0, 0 )
											end
										end
									else
										outputDebugString( "Warning: Group " .. tostring(group.groupName) .. " (ID: " .. tostring(group.groupID) .. ") has no aclGroup defined", 1 )
									end
								end
							end
						end
					end
					
					-- has no relevant group, thus we don't need the MTA account
					if shouldBeDeleted then
						if player then
							logOut( player )
						end
						outputDebugString( "Removed account " .. accountName, 3 )
						removeAccount( account )
					elseif player and isGuestAccount( getPlayerAccount( player ) ) and not logIn( player, account, p[ player ].mtasalt ) then
						-- something went wrong here
						outputDebugString( "Account Error for " .. accountName .. " - login failed.", 1 )
					end
					
					-- update the color since we have none
					if player and ( shouldBeDeleted or userChanged ) then
						updateNametagColor( player )
					end
					-- update permissions
					if userChanged or shouldBeDeleted then
						exports.foro:actualizarPermisosEnForo(user.userID)
					end
				else
					-- remove account from all ACL groups we use
					local allGroups = getAllGroups()
					for key, value in ipairs( allGroups ) do
						if value.aclGroup then
							if safeAclGroupRemoveObject( value.aclGroup, "user." .. accountName ) then
								saveAcl = true
								outputDebugString( "Removed account " .. accountName .. " from " .. value.aclGroup .. " ACL", 3 )
								if player then
									outputChatBox( "No estás conectado como " .. value.displayName .. ".", player, 255, 0, 0 )
								end
							end
						else
							outputDebugString( "Warning: Group " .. tostring(value.groupName) .. " (ID: " .. tostring(value.groupID) .. ") has no aclGroup defined", 1 )
						end
					end
					
					-- remove the account
					if player then
						logOut( player )
					end
					removeAccount( account )
					outputDebugString( "Removed account " .. accountName, 3 )
				end
			end
		end
		
		-- check all players not found by this for whetever they now have an account
		for key, value in ipairs( getElementsByType( "player" ) ) do
			if not checkedPlayers[ value ] then
				local success, needsAclUpdate = aclUpdate( value, false )
				if needsAclUpdate then
					saveAcl = true
				end
			end
		end
	end
	-- if we should save the acl, do it (permissions changed)
	if saveAclIfChanged and saveAcl then
		aclSave( )
	end
	return true, saveAcl
end

-- Función principal (la misma que ya tenés para el comando)
function reloadPermissionsAuto(player)
    -- Crear grupos ACL de facciones de forma segura
    local factionSuccess = pcall(function()
        createFactionACLGroups()
    end)

    if not factionSuccess then
        outputDebugString("❌ Error al crear grupos ACL de facciones", 1)
        if player then
            outputChatBox("⚠️ Advertencia: Error al crear grupos de facciones", player, 255, 200, 0)
        end
    end

    -- Actualizar permisos
    if aclUpdate(nil, true) then
        outputServerLog("Se han reiniciado los permisos automáticamente.")
        if player then
            outputChatBox("✅ Se han reiniciado los permisos automáticamente.", player, 0, 255, 0)
            if factionSuccess then
                outputChatBox("🏛️ Facciones también sincronizadas.", player, 0, 255, 0)
            end
        end
    else
        outputServerLog("❌ Error al reiniciar los permisos automáticamente.")
        if player then
            outputChatBox("❌ Error al reiniciar los permisos automáticamente.", player, 255, 0, 0)
        end
    end
end

-- Comando manual (por si quieres seguir usándolo)
addCommandHandler("reloadpermissions", reloadPermissionsAuto, true)

-- 🔄 Timer automático cada 10 minutos (1800000 ms)
setTimer(function()
    reloadPermissionsAuto(nil)  -- nil porque no es un jugador, se ejecuta solo
end, 600000, 0)


-- Función para crear grupos ACL de facciones si no existen
local function createFactionACLGroups()
	for key, faction in ipairs( factions ) do
		if faction and faction.aclGroup then
			local aclGroup = aclGetGroup( faction.aclGroup )
			if not aclGroup then
				-- El grupo ACL no existe, intentar crearlo
				local success, newGroup = pcall(function()
					return aclCreateGroup( faction.aclGroup )
				end)
				
				if success and newGroup then
					outputDebugString( "🏛️ Creado grupo ACL para facción: " .. faction.aclGroup, 3 )
				else
					outputDebugString( "❌ Error al crear grupo ACL: " .. faction.aclGroup, 1 )
				end
			else
				outputDebugString( "✅ Grupo ACL ya existe: " .. faction.aclGroup, 3 )
			end
		end
	end
end

-- Función para limpiar completamente los ACL de facciones y rehacer desde cero
local function cleanAndRebuildFactionACL()
	outputDebugString( "🧹 Limpiando ACL de facciones...", 3 )
	
	-- Paso 1: Limpiar todos los grupos de facciones
	for key, faction in ipairs( factions ) do
		if faction and faction.aclGroup then
			local aclGroup = aclGetGroup( faction.aclGroup )
			if aclGroup then
				-- Obtener todos los objetos del grupo y removerlos
				local objects = aclGroupListObjects( aclGroup )
				if objects then
					for i, object in ipairs( objects ) do
						if string.find( object, "user." ) then
							aclGroupRemoveObject( aclGroup, object )
							outputDebugString( "🧹 Removido " .. object .. " de " .. faction.aclGroup, 3 )
						end
					end
				end
			end
		end
	end
	
	-- Paso 2: Reconstruir desde la base de datos
	outputDebugString( "🔨 Reconstruyendo ACL de facciones desde BD...", 3 )
	
	local accounts = getAccounts()
	for key, account in ipairs( accounts ) do
		local accountName = getAccountName( account )
		if accountName and accountName ~= "Console" then
			-- Obtener userID de esta cuenta
			local user = exports.sql:query_assoc_single( "SELECT userID FROM wcf1_user WHERE username = '%s'", accountName )
			if user and user.userID then
				-- Obtener grupos de este usuario
				local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. user.userID )
				if groupinfo then
					-- Verificar cada facción
					for fKey, faction in ipairs( factions ) do
						if faction and faction.aclGroup and faction.groupID then
							local hasGroup = false
							
							-- Verificar si el usuario tiene esta facción en la BD
							for gKey, group in ipairs( groupinfo ) do
								if group.groupID == faction.groupID then
									hasGroup = true
									break
								end
							end
							
							-- Si tiene la facción, agregarlo al ACL
							if hasGroup then
								local aclGroup = aclGetGroup( faction.aclGroup )
								if aclGroup then
									if aclGroupAddObject( aclGroup, "user." .. accountName ) then
										outputDebugString( "✅ Agregado " .. accountName .. " a " .. faction.aclGroup, 3 )
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	-- Guardar cambios
	aclSave()
	outputDebugString( "💾 ACL de facciones reconstruido y guardado", 3 )
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		-- Crear grupos ACL de facciones si no existen (de forma segura)
		pcall(function()
			createFactionACLGroups()
		end)
		
		local data = exports.sql:query_assoc( "SELECT groupID, groupName FROM wcf1_group" )
		if data then
			for key, value in ipairs( data ) do
				-- Actualizar grupos de staff
				for key2, value2 in ipairs( groups ) do
					if value.groupName == value2.groupName then
						value2.groupID = value.groupID
					end
				end
				-- Actualizar facciones
				for key2, value2 in ipairs( factions ) do
					if value.groupName == value2.groupName then
						value2.groupID = value.groupID
					end
				end
			end
		end
		
		aclUpdate( nil, true )
	end
)

local function showLoginScreen( player, screenX, screenY, token, ip )	
	if screenX and screenY then
		if screenX < 1024 or screenY < 768 then
			outputChatBox( "ATENCIÓN: intenta utilizar una resolucion de 1024x768 o mayor.", player, 255, 0, 0)
			return
		end
	end
	if isPedInVehicle( player ) then
		removePedFromVehicle( player )
	end
	fadeCamera( player, false, 0 )
	toggleAllControls( player, false, true, false )
	
	
	spawnPlayer( source, 2638.927734375, -23.5126953125, 82.537460327148, 198.10025024414, 0, 0, 1 )
	setElementFrozen( source, true )
	setElementAlpha( source, 0 )
	setCameraInterior( source, 0 )
	setElementDimension( source , 0)

	setCameraMatrix( source, 2638.927734375, -23.5126953125, 82.543014526367, 2546.4130859375, 14.1376953125, 77.696334838867, 0, 70)
	setPlayerNametagColor( source, 127, 127, 127 )
	-- check for ip/serial bans
	if exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE banned = 1 AND ( lastIP = '%s' OR lastSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) ) then
		showChat( player, false )
		setTimer( triggerClientEvent, 300, 1, player, getResourceName( resource ) .. ":loginResult", player, 2 ) -- Banned
		return false
	end
	-- check for ip/serial bans for register
	if exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE banned = 1 AND ( regIP = '%s' OR regSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) ) then
		showChat( player, false )
		setTimer( triggerClientEvent, 300, 1, player, getResourceName( resource ) .. ":loginResult", player, 2 ) -- Banned
		return false
	end
	-- check if an account of that serial is suspended
	if exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE activationCode = 2 AND ( regIP = '%s' OR regSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) ) then
		local info = exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE activationCode = 2 AND ( regIP = '%s' OR regSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) )
		showChat( player, false )
		setElementData(source, "data.userid", tonumber(info.userID))
		setElementData(source, "dcuenta", tostring(info.activationReason))
		--setTimer( triggerClientEvent, 300, 1, player, getResourceName( resource ) .. ":loginResult", player, 6 ) -- Desactivado
		--return false
	end
	triggerClientEvent( player, getResourceName( resource ) .. ":spawnscreen", player )
end

addEvent( getResourceName( resource ) .. ":ready", true )
addEventHandler( getResourceName( resource ) .. ":ready", root,
	function( ... )
		if source == client then
			showLoginScreen( source, ... )
		end
	end
)

--

local loginAttempts = { }
local triedTokenAuth = { }

local function getPlayerHash( player, remoteIP )
	local ip = getPlayerIP( player ) or "255.255.255.0"
	if ip == "127.0.0.1" and remoteIP then -- we don't really care about a provided ip unless we want to connect from localhost
		ip = exports.sql:escape_string( remoteIP )
	end
	return ip:sub(ip:find("%d+%.%d+%.")) .. ( getPlayerSerial( player ) or "R0FLR0FLR0FLR0FLR0FLR0FLR0FLR0FL" ) .. tostring( serverToken )
end

addEvent( getResourceName( resource ) .. ":login", true )
addEventHandler( getResourceName( resource ) .. ":login", root,
	function( username, password )
		if (source == client) or (source and not client) then
			triedTokenAuth[ source ] = true
			if username and password and #username > 0 and #password > 0 then
				local info, error = exports.sql:query_assoc_single( "SELECT CONCAT(SHA1(CONCAT(username, '%s')),SHA1(CONCAT(salt, SHA1(CONCAT('%s',SHA1(CONCAT(salt, SHA1(CONCAT(username, SHA1(password)))))))))) AS token FROM wcf1_user WHERE `username` = '%s' AND password = SHA1(CONCAT(salt, SHA1(CONCAT(salt, '" .. hash("sha1", password) .. "'))))", getPlayerHash( source ), getPlayerHash( source ), username )
				p[ source ] = nil
				if not info then
					triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 1 ) -- Wrong username/password
					loginAttempts[ source ] = ( loginAttempts[ source ] or 0 ) + 1
					if loginAttempts[ source ] >= 30 then
						local serial = getPlayerSerial( source )
						banPlayer( source, true, false, false, root, "Too many login attempts.", 900 )
						if serial then
							addBan( nil, nil, serial, root, "Too many login attempts.", 900 )
						end
					end
				else
					loginAttempts[ source ] = nil
					performLogin( source, info.token, true )
				end
			end
		end
	end
)
-- performLogin( source, token, false, ip )
function performLogin( source, token, isPasswordAuth, ip )
	if source and ( isPasswordAuth or not triedTokenAuth[ source ] ) then
		triedTokenAuth[ source ] = true
		if token then
			if #token == 80 then
				local info = exports.sql:query_assoc_single( "SELECT userID, username, banned, activationCode, activationReason, SUBSTRING(LOWER(SHA1(CONCAT(userName,SHA1(CONCAT(password,salt))))),1,30) AS salts, userOptions FROM wcf1_user WHERE CONCAT(SHA1(CONCAT(username, '%s')),SHA1(CONCAT(salt, SHA1(CONCAT('%s',SHA1(CONCAT(salt, SHA1(CONCAT(username, SHA1(password)))))))))) = '%s' LIMIT 1", getPlayerHash( source, ip ), getPlayerHash( source, ip ), token )
				p[ source ] = nil
				if not info then
					if isPasswordAuth then
						triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 1 ) -- Wrong username/password
					end
					return false
				else
					if info.banned == 1 then
						triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 2 ) -- Banned
						return false
					elseif info.activationCode == 1 then
						if isPasswordAuth then
							triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 3 ) -- Requires activation
						end
						local dat = setElementData(source, "data.userid", tonumber(info.userID))
						return false
					elseif info.activationCode == 2 then
						triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 6 ) -- Cuenta desactivada por un staff.
						setElementData(source, "data.userid", tonumber(info.userID))
						setElementData(source, "dcuenta", tostring(info.activationReason))
						return false	
					else
						-- check if another user is logged in on that account
						for player, data in pairs( p ) do
							if data.userID == info.userID then
								triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 5 ) -- another player with that account found
								return false
							end
						end
						
						local username = info.username
						p[ source ] = { userID = info.userID, username = username, mtasalt = info.salts, options = info.userOptions and fromJSON( info.userOptions ) or { } }
						
						-- check for admin rights
						aclUpdate( source, true )
						
						-- show characters 
						local chars = exports.sql:query_assoc( "SELECT characterID, characterName, genero, edad, CKuIDStaff, lastLogin FROM characters WHERE userID = " .. info.userID .. " ORDER BY lastLogin DESC" )
						if isPasswordAuth then
							triggerClientEvent( source, getResourceName( resource ) .. ":characters", source, chars, true, nil, getPlayerIP( source ) ~= "127.0.0.1" and getPlayerIP( source ) )
						else
							triggerClientEvent( source, getResourceName( resource ) .. ":characters", source, chars, true )
						end
						
						exports.sql:query_free( "UPDATE wcf1_user SET lastIP = '%s', lastSerial = '%s' WHERE userID = " .. tonumber( info.userID ), getPlayerIP( source ), getPlayerSerial( source ) )
						
						return true
					end
				end
			end
		end
	end
	return false
end


local function getWeaponString( player )
	local weapons = { }
	local hasAnyWeapons = false
	for slot = 0, 12 do
		local weapon = getPedWeapon( player, slot )
		if weapon > 0 then
			local ammo = getPedTotalAmmo( player, slot )
			if ammo > 0 then
				weapons[weapon] = ammo
				hasAnyWeapons = true
			end
		end
	end
	if hasAnyWeapons then
		return "'" .. exports.sql:escape_string( toJSON( weapons ):gsub( " ", "" ) ) .. "'"
	else
		return "NULL"
	end
end
 
local function savePlayer( player )
	if not player then
		for key, value in ipairs( getElementsByType( "player" ) ) do
			savePlayer( value )
		end
	else
		if isLoggedIn( player ) then
			-- save character since it's logged in
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			local sed = tonumber(getElementData(player, "sed"))
			local cansancio = tonumber(getElementData(player, "cansancio"))
			local hambre = tonumber(getElementData(player, "hambre"))
			local gordura = tonumber(getElementData(player, "gordura"))
			local musculatura = tonumber(getElementData(player, "musculatura"))
			local tpd = tonumber(getElementData(player, "tpd"))
			-- Evitar valores negativos que provocan errores al guardarse.
			if sed < 0 then sed = 0 end
			if cansancio < 0 then cansancio = 0 end
			if hambre < 0 then hambre = 0 end
			if gordura < 0 then gordura = 0 end
			if musculatura < 0 then musculatura = 0 end
			if tpd < 0 then tpd = 0 end
			local sql, error = exports.sql:query_free( "UPDATE characters SET musculatura = " ..musculatura.. ", gordura = " .. gordura .. ", cansancio = " .. cansancio .. ", sed = " .. sed .. ", hambre = " .. hambre .. ", tpd = " .. tpd .. ", x = " .. x .. ", y = " .. y .. ", z = " .. z .. ", dimension = " .. dimension .. ", interior = " .. interior .. ", rotation = " .. getPedRotation( player ) .. ", health = " .. math.floor( getElementHealth( player ) ) .. ", armor = " .. math.floor( getPedArmor( player ) ) .. ", weapons = " .. getWeaponString( player ) .. ", lastLogin = NOW() WHERE characterID = " .. tonumber( getCharacterID( player ) ) )
		end
	end
end
setTimer( savePlayer, 300000, 0 ) -- Auto-Save every five minutes


addEventHandler( "onResourceStop", resourceRoot,
	function( )
		-- logout all players
		for key, value in ipairs( getElementsByType( "player" ) ) do
			savePlayer( value )
			
			if p[ value ] and p[ value ].charID then
				triggerEvent( "onCharacterLogout", value )
				setPlayerTeam( value, nil )
				takeAllWeapons( value )
			end
			
			if not isGuestAccount( getPlayerAccount( value ) ) then
				logOut( value )
			end
		end
	end
)

addEvent( getResourceName( resource ) .. ":logout", true )
addEventHandler( getResourceName( resource ) .. ":logout", root,
	function( )
		if source == client then
			savePlayer( source )
			if p[ source ] and p[ source ].charID then
				triggerEvent( "onCharacterLogout", source )
				setPlayerTeam( source, nil )
				takeAllWeapons( source )
				local staffd = getOption(source, "staffduty")
				if staffd == true then
					setElementData(source, "account:gmduty", true)
				end
			end
			
			-- Asegurar que el jugador esté en una posición segura antes del logout
			setElementPosition( source, 0, 0, 3 )
			setElementInterior( source, 0 )
			setElementDimension( source, 0 )
			setElementAlpha( source, 0 )  -- Hacer invisible
			setElementFrozen( source, true )  -- Congelar
			
			p[ source ] = nil
			showLoginScreen( source )
			
			if not isGuestAccount( getPlayerAccount( source ) ) then
				logOut( source )
			end
		end
	end
)

addEventHandler( "onPlayerJoin", root,
	function( )
		setPlayerNametagColor( source, 127, 127, 127 )
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		if p[ source ] then
			savePlayer( source )
			if p[ source ].charID then
				triggerEvent( "onCharacterLogout", source )
			end
			p[ source ] = nil
			loginAttempts[ source ] = nil
			triedTokenAuth[ source ] = nil
		end
	end
)

addEvent( getResourceName( resource ) .. ":spawn", true )
addEventHandler( getResourceName( resource ) .. ":spawn", root, 
	function( charID )
		if source == client and ( not isPedDead( source ) or not isLoggedIn( source ) ) then
			local userID = p[ source ] and p[ source ].userID
			if tonumber( userID ) and tonumber( charID ) then
				-- if the player is logged in, save him
				savePlayer( source )
				if p[ source ].charID then
					triggerEvent( "onCharacterLogout", source )
					setPlayerTeam( source, nil )
					takeAllWeapons( source )
					local data = getAllElementData(source)
					for k, v in ipairs(data) do
						removeElementData(source, k)
					end
					local staffd = getOption(source, "staffduty")
					if staffd == true then
						setElementData(source, "account:gmduty", true)
					end
					p[ source ].charID = nil
					p[ source ].money = nil
					p[ source ].job = nil
				end
			 
				local char = exports.sql:query_assoc_single( "SELECT * FROM characters WHERE userID = " .. tonumber( userID ) .. " AND characterID = " .. tonumber( charID ) )
				if char then
					local mtaCharName = char.characterName:gsub( " ", "_" )
					local otherPlayer = getPlayerFromName( mtaCharName )
					if otherPlayer and otherPlayer ~= source then
						kickPlayer( otherPlayer )
					end
					setPlayerName( source, mtaCharName )
					
					-- Defer spawn to mrp_spawn selector; store char for post-spawn setup
					pendingSpawn[source] = { char = char, charID = charID }
					local lastPos = { char.x or 0, char.y or 0, char.z or 3 }
					local rot = char.rotation or 0
					local interior = char.interior or 0
					local dimension = char.dimension or 0
					local skin = char.skin or 0
					if char.nuevo == 1 then
						-- Spawn único para nuevos: settings.initial_spawn
						if settings and settings.initial_spawn then
							local s = settings.initial_spawn
							lastPos = { s.position[1], s.position[2], s.position[3] }
							rot = 0
							interior = s.interior or 0
							dimension = s.dimension or 0
						else
							lastPos = { 1705.6563720703, -2286.40234375, 13.377690315247 }
							rot, interior, dimension = 0, 0, 0
						end
						exports.sql:query_free( "UPDATE characters SET nuevo = 0 WHERE characterID = " .. tonumber( charID ) )
						if char.genero == 2 then
							-- Mujeres
							if char.color == 1 then
								exports.sql:query_free( "UPDATE characters SET skin = 55 WHERE characterID = " .. tonumber( charID ) )
								skin = 55
							else
								exports.sql:query_free( "UPDATE characters SET skin = 69 WHERE characterID = " .. tonumber( charID ) )
								skin = 69
							end
						else
							-- Hombres (genero == 1) - siempre CJ tanto claro como moreno
							exports.sql:query_free( "UPDATE characters SET skin = 0 WHERE characterID = " .. tonumber( charID ) )
							skin = 0
						end
					end
					-- Mostrar selector y una vista de cámara orbitando sobre la última posición
					exports["mrp_spawn"]:SetVisible(source, lastPos, rot, interior, dimension, skin)
					return
					-- toggleAllControls( source, true, true, false )
					-- setElementFrozen( source, false )
					-- setElementAlpha( source, 255 )
					-- 
					-- setElementHealth( source, char.health )
					-- setPedArmor( source, char.armor )
					-- if char.sed then
					-- 	setElementData(source, "sed", char.sed)
					-- else
					-- 	setElementData(source, "sed", 0)
					-- end
					-- if char.hambre then
					-- 	setElementData(source, "hambre", char.hambre)
					-- else
					-- 	setElementData(source, "hambre", 0)
					-- end
					-- if char.cansancio then
					-- 	setElementData(source, "cansancio", char.cansancio)
					-- else
					-- 	setElementData(source, "cansancio", 0)
					-- end
					-- if char.tpd then
					-- 	setElementData(source, "tpd", char.tpd)
					-- else
					-- 	setElementData(source, "tpd", 0)
					-- end
					-- if char.gordura then
					-- 	setElementData(source, "gordura", tonumber(char.gordura))
					-- 	setTimer(setPedStat, 3000, 1, source, 21, tonumber(char.gordura))
					-- else
					-- 	setElementData(source, "gordura", 0)
					-- end
					-- if char.musculatura then
					-- 	setElementData(source, "musculatura", tonumber(char.musculatura))
					-- 	setTimer(setPedStat, 3000, 1, source, 23, tonumber(char.musculatura))
					-- else
					-- 	setElementData(source, "musculatura", 0)
					-- end
					-- 
					-- p[ source ].money = char.money
					-- setPlayerMoney( source, char.money )
					-- setElementData(source, "license.car", char.car_license)
					-- setElementData(source, "license.gun", char.gun_license)
					-- setElementData(source, "license.barco", char.boat_license)
					-- setElementData(source, "license.camion", char.camion_license)
					-- if char.yo then
					-- 	setElementData(source, "yo", tostring(char.yo))
					-- else
					-- 	setElementData(source, "yo", "((Sin /yo asignado))")
					-- end
					-- 
					-- p[ source ].charID = tonumber( charID )
					-- p[ source ].characterName = char.characterName
					-- updateNametag( source )
					-- 
					-- -- restore weapons
					-- if char.weapons then
					-- 	local weapons = fromJSON( char.weapons )
					-- 	if weapons then
					-- 		for weapon, ammo in pairs( weapons ) do
					-- 			giveWeapon( source, weapon, ammo )
					-- 		end
					-- 	end
					-- end
					-- 
					-- p[ source ].job = char.job
					-- 
					-- -- restore the player's languages, remove invalid ones
					-- if not char.languages then
					-- 	-- default is English with full skill
					-- 	p[ source ].languages = { es = { skill = 1000, current = true } }
					-- 	saveLanguages( source, p[ source ].languages )
					-- else
					-- 	p[ source ].languages = fromJSON( char.languages )
					-- 	local changed = false
					-- 	local languages = 0
					-- 	for key, value in pairs( p[ source ].languages ) do
					-- 		if isValidLanguage( "es" ) then
					-- 			changed = true
					-- 			languages = languages + 1
					-- 			if not isValidLanguage( key ) then
					-- 				p[ source ].languages[ key ] = nil
					-- 				languages = languages - 1
					-- 			elseif type( value.skill ) ~= 'number' then
					-- 				value.skill = 0
					-- 			elseif value.skill < 0 then
					-- 				value.skill = 0
					-- 			elseif value.skill > 1000 then
					-- 				value.skill = 1000
					-- 			else
					-- 				changed = false
					-- 			end
					-- 		else
					-- 			languages = languages + 1
					-- 		end
					-- 	end
					-- 
					-- 	if languages == 0 then
					-- 		-- player has no language at all
					-- 		p[ source ].languages = { es = { skill = 1000, current = true } }
					-- 		changed = true
					-- 	end
					-- 
					-- 	if changed then
					-- 		saveLanguages( source, p[ source ].languages )
					-- 	end
					-- end
					-- 
					-- setPlayerTeam( source, team )
					-- triggerClientEvent( source, getResourceName( resource ) .. ":onSpawn", source, p[ source ].languages )
					-- triggerEvent( "onCharacterLogin", source )
					-- 
					-- showCursor( source, false )
					-- 
					-- -- set last login to now
					-- exports.sql:query_free( "UPDATE characters SET lastLogin = NOW() WHERE characterID = " .. tonumber( charID ) )
					-- exports.logsic:addLogMessage("login", char.characterName.. " ha logueado. IP: "..getPlayerIP(source)..". Serial: "..getPlayerSerial(source)..".\n")
					-- if char.condiciones < exports.condiciones:getVersion() then
					-- 	local cons = exports.sql:query_assoc_single("SELECT * FROM `condiciones` ORDER BY `condiciones`.`version` DESC LIMIT 1")
					-- 	triggerClientEvent("onMostrarCondiciones", source, tostring(cons.version), tostring(cons.texto))
					-- end
				end
			end
		end
	end
)

addEventHandler( "onPlayerChangeNick", root,
	function( )
		if isLoggedIn( source ) then
			cancelEvent( )
		end
	end
)

-- mrp_spawn → perform final spawn after selection
addEvent("mrp_spawn:performSpawn", true)
addEventHandler("mrp_spawn:performSpawn", root, function(position, rotation, skin, interior, dimension)
	local player = client or source
	if not isElement(player) or getElementType(player) ~= "player" then return end
	local data = pendingSpawn[player]
	if not data or not data.char then return end
	local char = data.char
	local charID = data.charID
	pendingSpawn[player] = nil

	spawnPlayer( player, position[1], position[2], position[3], rotation or 0, skin or 0, interior or 0, dimension or 0 )
	fadeCamera( player, true )
	setCameraTarget( player, player )
	setCameraInterior( player, interior or 0 )

	-- notify mrp_spawn client to hide selector UI
	local spawnRes = getResourceFromName("mrp_spawn")
	if spawnRes then
		local spawnRoot = getResourceRootElement(spawnRes)
		if spawnRoot then
			triggerClientEvent( player, "mrp_spawn->onSpawn", spawnRoot )
		end
	end

	toggleAllControls( player, true, true, false )
	setElementFrozen( player, false )
	setElementAlpha( player, 255 )

	setElementHealth( player, char.health )
	setPedArmor( player, char.armor )
	if char.sed then setElementData(player, "sed", char.sed) else setElementData(player, "sed", 0) end
	if char.hambre then setElementData(player, "hambre", char.hambre) else setElementData(player, "hambre", 0) end
	if char.cansancio then setElementData(player, "cansancio", char.cansancio) else setElementData(player, "cansancio", 0) end
	if char.tpd then setElementData(player, "tpd", char.tpd) else setElementData(player, "tpd", 0) end
	if char.gordura then setElementData(player, "gordura", tonumber(char.gordura)); setTimer(setPedStat, 3000, 1, player, 21, tonumber(char.gordura)) else setElementData(player, "gordura", 0) end
	if char.musculatura then setElementData(player, "musculatura", tonumber(char.musculatura)); setTimer(setPedStat, 3000, 1, player, 23, tonumber(char.musculatura)) else setElementData(player, "musculatura", 0) end

	p[ player ].money = char.money
	setPlayerMoney( player, char.money )
	setElementData(player, "license.car", char.car_license)
	setElementData(player, "license.gun", char.gun_license)
	setElementData(player, "license.barco", char.boat_license)
	setElementData(player, "license.camion", char.camion_license)
	if char.yo then setElementData(player, "yo", tostring(char.yo)) else setElementData(player, "yo", "((Sin /yo asignado))") end

	p[ player ].charID = tonumber( charID )
	p[ player ].characterName = char.characterName
	updateNametag( player )

	if char.weapons then
		local weapons = fromJSON( char.weapons )
		if weapons then
			for weapon, ammo in pairs( weapons ) do
				giveWeapon( player, weapon, ammo )
			end
		end
	end

	p[ player ].job = char.job

	if not char.languages then
		p[ player ].languages = { es = { skill = 1000, current = true } }
		saveLanguages( player, p[ player ].languages )
	else
		p[ player ].languages = fromJSON( char.languages )
		local changed = false
		local languages = 0
		for key, value in pairs( p[ player ].languages ) do
			if isValidLanguage( "es" ) then
				changed = true
				languages = languages + 1
				if not isValidLanguage( key ) then
					p[ player ].languages[ key ] = nil
					languages = languages - 1
				elseif type( value.skill ) ~= 'number' then
					value.skill = 0
				elseif value.skill < 0 then
					value.skill = 0
				elseif value.skill > 1000 then
					value.skill = 1000
				else
					changed = false
				end
			else
				languages = languages + 1
			end
		end
		if languages == 0 then
			p[ player ].languages = { es = { skill = 1000, current = true } }
			changed = true
		end
		if changed then
			saveLanguages( player, p[ player ].languages )
		end
	end

	setPlayerTeam( player, team )
	triggerClientEvent( player, getResourceName( resource ) .. ":onSpawn", player, p[ player ].languages )
	triggerEvent( "onCharacterLogin", player )
	showCursor( player, false )
	exports.sql:query_free( "UPDATE characters SET lastLogin = NOW() WHERE characterID = " .. tonumber( charID ) )
	exports.logsic:addLogMessage("login", char.characterName.. " ha logueado. IP: "..getPlayerIP(player)..". Serial: "..getPlayerSerial(player)..".\n")
end)

function getCharacterID( player )
	return player and p[ player ] and p[ player ].charID or false
end

function isLoggedIn( player )
	return getCharacterID( player ) and true or false
end

function getUserID( player )
	return player and p[ player ] and p[ player ].userID or false
end

function getUserName( player )
	return player and p[ player ] and p[ player ].username or false
end

function getCharacterName( characterID )
	if type( characterID ) == "number" then
		for player, data in pairs( p ) do
			if data.charID == characterID then
				local name = getPlayerName( player ):gsub( "_", " " )
				return name
			end
		end
		
		local data = exports.sql:query_assoc_single( "SELECT characterName FROM characters WHERE characterID = " .. characterID )
		if data then
			return data.characterName
		end
	end
	return false
end

function setMoney( player, amount )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	amount = tonumber( amount )
	if amount >= 0 and isLoggedIn( player ) then
		if exports.sql:query_free( "UPDATE characters SET money = " .. amount .. " WHERE characterID = " .. p[ player ].charID ) then
			p[ player ].money = amount
			setPlayerMoney( player, amount )
			return true
		end
	end
	return false
end

function giveMoney( player, amount )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	return tonumber(amount) >= 0 and setMoney( player, getMoney( player ) + amount )
end

function takeMoney( player, amount )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	return amount >= 0 and setMoney( player, getMoney( player ) - amount )
end

function getMoney( player, amount )
	return isLoggedIn( player ) and p[ player ].money or 0
end

function updateCharacters( player )
	if player and p[ player ].userID then
		local chars = exports.sql:query_assoc( "SELECT characterID, characterName, genero, edad, lastLogin, CKuIDStaff FROM characters WHERE userID = " .. p[ player ].userID .. " ORDER BY lastLogin DESC" )
		triggerClientEvent( player, getResourceName( resource ) .. ":characters", player, chars, false )
		return true
	end
	return false
end

function createCharacter( player, name, edad, genero, color )
	if player and p[ player ].userID then
		if exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s'", name ) then
			triggerClientEvent( player, "players:characterCreationResult", player, 1 )
		elseif exports.sql:query_free( "INSERT INTO characters (characterName, userID, x, y, z, edad, genero, color, interior, dimension, rotation) VALUES ('%s', " .. p[ player ].userID .. ", 2216.27, 137.76, 26.48, "..tonumber(edad)..", "..tonumber(genero)..", "..tonumber(color)..", 0, 0, 270)", name ) then
			-- Obtener el ID del personaje recién creado
			local newCharData = exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s' AND userID = " .. p[ player ].userID, name )
			if newCharData and newCharData.characterID then
				-- Enviar resultado exitoso con el ID del nuevo personaje
				-- NO llamamos a updateCharacters aquí para evitar mostrar la selección
				triggerClientEvent( player, "players:characterCreationResult", player, 0, newCharData.characterID )
			else
				triggerClientEvent( player, "players:characterCreationResult", player, 0 )
			end
			
			return true
		end
	end
	return false
end

--

function updateNametag( player )
	if player then
		local text = "[" .. getID( player ) .. "] " .. ( p[ player ] and p[ player ].characterName or getPlayerName( player ):gsub( "_", " " ) )
		if getPlayerNametagText( player ) ~= tostring( text ) then
			setPlayerNametagText( player, tostring( text ) )
		end
		updateNametagColor( player )
		return true
	end
	return false
end

addEventHandler( "onPlayerSpawn", root,
	function( )
		updateNametag( source )
	end
)

setTimer(
	function( )
		for player in pairs( p ) do
			updateNametag( player )
		end
	end,
	15000,
	0
)

-- 🌈 SISTEMA RAINBOW VIP ÉPICO 🌈
-- Timer para actualizar el color rainbow cada 100ms (súper suave)
setTimer(
	function()
		updateRainbowColor()
	end,
	100, -- 100ms = transición súper suave
	0    -- infinito
)

-- Timer para aplicar el nuevo color rainbow a todos los VIP cada 100ms
setTimer(
	function()
		updateAllVipColors()
	end,
	100, -- 100ms = actualización súper suave
	0    -- infinito
)

function getJob( player )
	return isLoggedIn( player ) and p[ player ].job or nil
end

function setJob( player, job )
	local charID = getCharacterID( player )
	if charID and exports.sql:query_free( "UPDATE characters SET job = '%s' WHERE characterID = " .. charID, job ) then
		p[ player ].job = job
		return true
	end
	return false
end

function getOption( player, key )
	return player and p[ player ] and p[ player ].options and key and p[ player ].options[ key ] or nil
end

function setOption( player, key, value )
	if player and p[ player ] and p[ player ].options and type( key ) == 'string' then
		local oldValue = p[ player ].options[ key ]
		p[ player ].options[ key ] = value
		
		
		local str = toJSON( p[ player ].options )
		if str then
			if str == toJSON( { } ) then
				local success = exports.sql:query_free( "UPDATE wcf1_user SET userOptions = NULL WHERE userID = " .. getUserID( player ) )
				return success
			elseif exports.sql:query_free( "UPDATE wcf1_user SET userOptions = '%s' WHERE userID = " .. getUserID( player ), str ) then
				return true
			end
		end
		p[ player ].options[ key ] = oldValue
	end
	return false
end

-- Comando de debug para diagnosticar problemas VIP
addCommandHandler( "checkvip",
	function( player )
		outputChatBox( "=== 🌈 DIAGNÓSTICO VIP RAINBOW ===", player, 255, 255, 0 )
		
		if not isLoggedIn( player ) then
			outputChatBox( "❌ No estás logueado", player, 255, 0, 0 )
			return
		end
		
		-- Verificar staff duty
		local staffDuty = getOption( player, "staffduty" )
		outputChatBox( "🔧 Staff Duty: " .. (staffDuty and "SÍ" or "NO"), player, 255, 255, 255 )
		
		-- Verificar VIP duty
		local vipDuty = getOption( player, "vipduty" )
		outputChatBox( "🌈 VIP Duty: " .. (vipDuty and "SÍ" or "NO"), player, 255, 255, 255 )
		
		-- Verificar opción VIP antigua
		local vipOption = getOption( player, "vip" )
		outputChatBox( "👑 Opción VIP: " .. (vipOption and "SÍ" or "NO"), player, 255, 255, 255 )
		
		-- Verificar grupos ACL
		local hasVipGroup = false
		if p[ player ] and p[ player ].username then
			outputChatBox( "👤 Username: " .. p[ player ].username, player, 255, 255, 255 )
			
			-- Verificar cada grupo
			for key, value in ipairs( groups ) do
				local inGroup = isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) )
				if inGroup then
					outputChatBox( "✅ Grupo: " .. value.displayName, player, 0, 255, 0 )
					if value.groupName == "VIP" then
						hasVipGroup = true
					end
				end
			end
			
			if not hasVipGroup and not vipOption then
				outputChatBox( "❌ NO estás en el grupo VIP de ACL ni tienes opción VIP", player, 255, 100, 100 )
			end
		end
		
		-- Verificar color rainbow actual
		outputChatBox( "🌈 Color Rainbow Actual: R:" .. vipRainbowColor[1] .. " G:" .. vipRainbowColor[2] .. " B:" .. vipRainbowColor[3], player, vipRainbowColor[1], vipRainbowColor[2], vipRainbowColor[3] )
		
		-- Diagnóstico final
		outputChatBox( "=== 💡 SOLUCIÓN ===", player, 255, 255, 0 )
		if vipDuty and (hasVipGroup or vipOption) then
			outputChatBox( "✅ Tienes rainbow ACTIVADO correctamente", player, 0, 255, 0 )
			outputChatBox( "🔄 Actualizando tu color ahora...", player, 255, 255, 0 )
			updateNametagColor( player )
		elseif hasVipGroup or vipOption then
			outputChatBox( "⚠️ Eres VIP pero no tienes el rainbow activado", player, 255, 200, 0 )
			outputChatBox( "💡 SOLUCIÓN: Escribe /vip para activar el rainbow", player, 0, 255, 0 )
		else
			outputChatBox( "❌ No eres VIP. Para tener rainbow necesitas:", player, 255, 0, 0 )
			outputChatBox( "   1. Estar en grupo VIP en la base de datos", player, 255, 255, 255 )
			outputChatBox( "   2. O tener la opción VIP activada", player, 255, 255, 255 )
			outputChatBox( "   3. Contacta un admin para que te configure", player, 255, 255, 255 )
		end
	end
)

-- 🌈 Comando /vip para activar/desactivar modo VIP (independiente del staff)
addCommandHandler( "vip",
	function( player )
		if not isLoggedIn( player ) then
			outputChatBox( "Debes estar logueado para usar este comando.", player, 255, 0, 0 )
			return
		end
		
		-- Verificar si es VIP (por ACL o por opción)
		local isVip = false
		local vipMethod = ""
		
		-- Verificar VIP por grupo ACL
		if p[ player ] and p[ player ].username then
			if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( "VIP" ) ) then
				isVip = true
				vipMethod = "grupo ACL"
			end
		end
		
		-- Verificar VIP por opción antigua
		if getOption( player, "vip" ) then
			isVip = true
			vipMethod = "opción VIP"
		end
		
		if not isVip then
			outputChatBox( "❌ No eres VIP. Contacta un administrador.", player, 255, 0, 0 )
			return
		end
		
		-- Alternar VIP duty
		local currentVipDuty = getOption( player, "vipduty" )
		local newVipDuty = not currentVipDuty
		
		if setOption( player, "vipduty", newVipDuty ) then
			updateNametagColor( player )
			
			if newVipDuty then
				outputChatBox( "🌈 COLORES VIP ACTIVADO", player, vipRainbowColor[1], vipRainbowColor[2], vipRainbowColor[3] )
			else
				outputChatBox( "⚪ COLORES VIP DESACTIVADO", player, 255, 255, 255 )
			end
		else
			outputChatBox( "❌ Error al cambiar el modo VIP.", player, 255, 0, 0 )
		end
	end
)

-- ===== FUNCIONES PARA FACCIONES =====

-- Función para verificar si un jugador está en una facción específica
function isPlayerInFaction( player, factionACLGroup )
	if not player or not p[ player ] or not p[ player ].username then
		return false
	end
	local aclGroup = aclGetGroup( factionACLGroup )
	if not aclGroup then
		return false
	end
	return isObjectInACLGroup( "user." .. p[ player ].username, aclGroup )
end

-- Función para agregar un jugador a una facción (por ACL)
function addPlayerToFaction( player, factionACLGroup )
	if not player or not p[ player ] or not p[ player ].username then
		return false
	end
	
	if not factionACLGroup then
		outputDebugString( "Warning: addPlayerToFaction called with nil factionACLGroup", 1 )
		return false
	end
	
	local aclGroup = aclGetGroup( factionACLGroup )
	if aclGroup then
		if aclGroupAddObject( aclGroup, "user." .. p[ player ].username ) then
			aclSave()
			outputDebugString( "Added " .. p[ player ].username .. " to faction " .. factionACLGroup, 3 )
			return true
		end
	else
		outputDebugString( "Warning: ACL group '" .. tostring(factionACLGroup) .. "' does not exist", 1 )
	end
	return false
end

-- Función para remover un jugador de una facción (por ACL)
function removePlayerFromFaction( player, factionACLGroup )
	if not player or not p[ player ] or not p[ player ].username then
		return false
	end
	
	if not factionACLGroup then
		outputDebugString( "Warning: removePlayerFromFaction called with nil factionACLGroup", 1 )
		return false
	end
	
	local aclGroup = aclGetGroup( factionACLGroup )
	if aclGroup then
		if aclGroupRemoveObject( aclGroup, "user." .. p[ player ].username ) then
			aclSave()
			outputDebugString( "Removed " .. p[ player ].username .. " from faction " .. factionACLGroup, 3 )
			return true
		end
	else
		outputDebugString( "Warning: ACL group '" .. tostring(factionACLGroup) .. "' does not exist", 1 )
	end
	return false
end

-- Función para obtener información de una facción por nombre ACL
function getFactionInfo( factionACLGroup )
	for key, faction in ipairs( factions ) do
		if faction.aclGroup == factionACLGroup then
			return faction
		end
	end
	return false
end

-- Función para crear grupos ACL de facciones (exportada)
function createFactionACLGroupsExported()
	return createFactionACLGroups()
end

-- Función para sincronizar facciones (exportada)
function syncFactions()
	createFactionACLGroups()
	cleanAndRebuildFactionACL()
	return true
end

-- Comando de diagnóstico para verificar el sistema
addCommandHandler( "diagfactions",
	function( player )
		outputChatBox( "=== 🔍 DIAGNÓSTICO DEL SISTEMA ===", player, 255, 255, 0 )
		
		-- Verificar si el jugador está logueado
		if not isLoggedIn( player ) then
			outputChatBox( "❌ No estás logueado", player, 255, 0, 0 )
			return
		end
		
		-- Verificar permisos
		local hasDevPerms = false
		if p[ player ] and p[ player ].username then
			hasDevPerms = isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( "Desarrollador" ) )
			outputChatBox( "👤 Usuario: " .. p[ player ].username, player, 255, 255, 255 )
			outputChatBox( "🔑 Permisos Desarrollador: " .. (hasDevPerms and "SÍ" or "NO"), player, hasDevPerms and 0 or 255, hasDevPerms and 255 or 0, 0 )
		else
			outputChatBox( "❌ No se pudo obtener información del usuario", player, 255, 0, 0 )
		end
		
		-- Verificar facciones definidas
		outputChatBox( "📋 Facciones configuradas: " .. #factions, player, 255, 255, 255 )
		for key, faction in ipairs( factions ) do
			outputChatBox( "  " .. faction.displayName .. " (ID: " .. (faction.groupID or "SIN ID") .. ", ACL: " .. faction.aclGroup .. ")", player, 255, 255, 255 )
		end
		
		-- Verificar grupos ACL de facciones
		outputChatBox( "🏛️ Estado de grupos ACL:", player, 255, 255, 255 )
		for key, faction in ipairs( factions ) do
			local aclGroup = aclGetGroup( faction.aclGroup )
			if aclGroup then
				local objects = aclGroupListObjects( aclGroup )
				local userCount = 0
				if objects then
					for i, object in ipairs( objects ) do
						if string.find( object, "user." ) then
							userCount = userCount + 1
						end
					end
				end
				outputChatBox( "  ✅ " .. faction.aclGroup .. " (" .. userCount .. " usuarios)", player, 0, 255, 0 )
			else
				outputChatBox( "  ❌ " .. faction.aclGroup .. " (NO EXISTE)", player, 255, 0, 0 )
			end
		end
		
		-- Verificar base de datos
		outputChatBox( "💾 Verificando conexión a BD...", player, 255, 255, 0 )
		local testQuery = exports.sql:query_assoc( "SELECT COUNT(*) as total FROM wcf1_group LIMIT 1" )
		if testQuery then
			outputChatBox( "✅ Conexión a BD exitosa", player, 0, 255, 0 )
		else
			outputChatBox( "❌ Error de conexión a BD", player, 255, 0, 0 )
		end
	end
)

-- Comando de debug para verificar facciones de un jugador
addCommandHandler( "checkfaction",
	function( player, commandName, targetName )
		if not isObjectInACLGroup( "user." .. (p[ player ] and p[ player ].username or ""), aclGetGroup( "Admin" ) ) then
			outputChatBox( "No tienes permisos para usar este comando.", player, 255, 0, 0 )
			return
		end
		
		local targetPlayer = targetName and getFromName( player, targetName ) or player
		if not targetPlayer then return end
		
		outputChatBox( "=== 🏛️ FACCIONES DE " .. getPlayerName(targetPlayer):gsub("_", " ") .. " ===", player, 255, 255, 0 )
		
		local playerFactions = getFactions( targetPlayer )
		if #playerFactions > 0 then
			for key, faction in ipairs( playerFactions ) do
				outputChatBox( "✅ " .. faction.displayName .. " (ACL: " .. faction.aclGroup .. ")", player, 0, 255, 0 )
			end
		else
			outputChatBox( "❌ No está en ninguna facción", player, 255, 100, 100 )
		end
		
		-- Mostrar también grupos de staff si los tiene
		local playerGroups = getGroups( targetPlayer )
		if #playerGroups > 0 then
			outputChatBox( "--- 👑 GRUPOS STAFF ---", player, 255, 255, 0 )
			for key, group in ipairs( playerGroups ) do
				outputChatBox( "✅ " .. group.displayName .. " (ACL: " .. group.aclGroup .. ")", player, 0, 255, 255 )
			end
		end
	end
)

-- Función para actualizar ACL de facciones (similar a aclUpdate pero solo para facciones)
local function factionACLUpdate( player, saveAclIfChanged )
	local saveAcl = false
	
	if player then
		-- Actualizar facciones de un jugador específico
		local info = p[ player ]
		if info and info.username then
			local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. info.userID )
			if groupinfo then
				-- Verificar cada facción
				for key, faction in ipairs( factions ) do
					local hasGroup = false
					
					-- Verificar si el jugador tiene esta facción en la BD
					for key2, group in ipairs( groupinfo ) do
						if group.groupID == faction.groupID then
							hasGroup = true
							break
						end
					end
					
					-- Si tiene la facción, agregarlo al ACL
					local aclGroup = aclGetGroup( faction.aclGroup )
					if aclGroup then
						if hasGroup then
							if aclGroupAddObject( aclGroup, "user." .. info.username ) then
								outputDebugString( "Added " .. info.username .. " to faction " .. faction.aclGroup, 3 )
								saveAcl = true
								if player then
									outputChatBox( "Te has unido a " .. faction.displayName .. ".", player, 0, 255, 0 )
								end
							end
						else
							-- Si no tiene la facción, removerlo del ACL
							if aclGroupRemoveObject( aclGroup, "user." .. info.username ) then
								outputDebugString( "Removed " .. info.username .. " from faction " .. faction.aclGroup, 3 )
								saveAcl = true
								if player then
									outputChatBox( "Has salido de " .. faction.displayName .. ".", player, 255, 200, 0 )
								end
							end
						end
					else
						outputDebugString( "Warning: ACL group '" .. faction.aclGroup .. "' does not exist", 1 )
					end
				end
			end
		end
	else
		-- Actualizar todas las facciones de todos los jugadores
		local checkedPlayers = { }
		
		-- Obtener todas las cuentas
		local accounts = getAccounts( )
		for key, account in ipairs( accounts ) do
			local accountName = getAccountName( account )
			local accountPlayer = getAccountPlayer( account )
			if accountPlayer then
				checkedPlayers[ accountPlayer ] = true
			end
			
			if accountName ~= "Console" then
				local user = exports.sql:query_assoc_single( "SELECT userID FROM wcf1_user WHERE username = '%s'", accountName )
				if user and user.userID then
					local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. user.userID )
					
					-- Verificar cada facción
					for key, faction in ipairs( factions ) do
						local hasGroup = false
						
						-- Verificar si el usuario tiene esta facción en la BD
						if groupinfo then
							for key2, group in ipairs( groupinfo ) do
								if group.groupID == faction.groupID then
									hasGroup = true
									break
								end
							end
						end
						
						-- Si tiene la facción, agregarlo al ACL
						local aclGroup = aclGetGroup( faction.aclGroup )
						if aclGroup then
							if hasGroup then
								if aclGroupAddObject( aclGroup, "user." .. accountName ) then
									outputDebugString( "Added account " .. accountName .. " to faction " .. faction.aclGroup, 3 )
									saveAcl = true
									if accountPlayer then
										outputChatBox( "Te has unido a " .. faction.displayName .. ".", accountPlayer, 0, 255, 0 )
									end
								end
							else
								-- Si no tiene la facción, removerlo del ACL
								if aclGroupRemoveObject( aclGroup, "user." .. accountName ) then
									outputDebugString( "Removed account " .. accountName .. " from faction " .. faction.aclGroup, 3 )
									saveAcl = true
									if accountPlayer then
										outputChatBox( "Has salido de " .. faction.displayName .. ".", accountPlayer, 255, 200, 0 )
									end
								end
							end
						else
							outputDebugString( "Warning: ACL group '" .. faction.aclGroup .. "' does not exist", 1 )
						end
					end
				end
			end
		end
		
		-- Verificar jugadores que no fueron encontrados por cuentas
		for key, value in ipairs( getElementsByType( "player" ) ) do
			if not checkedPlayers[ value ] then
				local success, needsAclUpdate = factionACLUpdate( value, false )
				if needsAclUpdate then
					saveAcl = true
				end
			end
		end
	end
	
	-- Guardar ACL si es necesario
	if saveAclIfChanged and saveAcl then
		aclSave( )
	end
	return true, saveAcl
end

-- Comando para sincronizar facciones manualmente
addCommandHandler( "syncfactions",
	function( player )
		outputChatBox( "🔄 Comando /syncfactions ejecutado", player, 255, 255, 0 )
		
		-- Verificar permisos
		if not p[ player ] or not p[ player ].username then
			outputChatBox( "❌ Error: No se pudo obtener información del usuario", player, 255, 0, 0 )
			return
		end
		
		local hasPerms = isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( "Desarrollador" ) )
		outputChatBox( "🔑 Verificando permisos para: " .. p[ player ].username, player, 255, 255, 255 )
		
		if not hasPerms then
			outputChatBox( "❌ No tienes permisos para usar este comando. Necesitas ser Desarrollador.", player, 255, 0, 0 )
			return
		end
		
		outputChatBox( "✅ Permisos verificados. Iniciando sincronización...", player, 0, 255, 0 )
		
		-- Paso 1: Crear grupos ACL de facciones si no existen
		outputChatBox( "🏛️ Creando grupos ACL de facciones...", player, 255, 255, 0 )
		createFactionACLGroups()
		
		-- Paso 2: Recargar IDs de facciones desde la base de datos
		outputChatBox( "📋 Sincronizando IDs de facciones...", player, 255, 255, 0 )
		local data = exports.sql:query_assoc( "SELECT groupID, groupName FROM wcf1_group" )
		if data then
			for key, value in ipairs( data ) do
				for key2, value2 in ipairs( factions ) do
					if value.groupName == value2.groupName then
						value2.groupID = value.groupID
						outputChatBox( "📋 " .. value2.displayName .. " → ID: " .. value.groupID, player, 255, 255, 255 )
					end
				end
			end
		end
		
		-- Paso 3: Limpiar y reconstruir ACL de facciones completamente
		outputChatBox( "🧹 Limpiando y reconstruyendo ACL de facciones...", player, 255, 255, 0 )
		cleanAndRebuildFactionACL()
		
		outputServerLog( "Se han sincronizado las facciones completamente. (Iniciado por " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
		outputChatBox( "✅ Sincronización de facciones completada exitosamente.", player, 0, 255, 0 )
		outputChatBox( "🏛️ Facciones sincronizadas: Policia, Sura, Meca, Ejercito", player, 0, 255, 0 )
		outputChatBox( "🔄 Revisa tu ACL.xml - deberías estar removido de facciones.", player, 0, 255, 0 )
	end,
	true
)

