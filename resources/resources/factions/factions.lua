--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

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

local blipF = {{}}
local p = { }
local factions = { }
local factionTypes = { publica = 1, privada = 2, mafia = 3 }
local maxRanks = 20

--

local function loadFaction( factionID, name, type, tag, groupID, presupuesto )
	if not tag or #tag == 0 then
		tag = ""
		-- create a tag from the first letter of each word
		local i = 0
		repeat
			i = i + 1
			local token = gettok( name, i, string.byte( ' ' ) )
			
			if not token then
				break
			else
				tag = tag .. token:sub( 1, 1 )
			end
		until false
	end
	
	-- load all ranks
	local ranks = { }
	local result = exports.sql:query_assoc( "SELECT factionRankName FROM faction_ranks WHERE factionID = " .. factionID .. " ORDER BY factionRankID ASC" )
	if result then
		for key, value in ipairs( result ) do
			table.insert( ranks, value.factionRankName )
		end
	end
	factions[ factionID ] = { name = name, type = type, tag = tag, group = groupID, ranks = ranks, presupuesto = presupuesto, factionID = factionID }
end

local function loadPlayer( player )
    local characterID = exports.players:getCharacterID( player )
    if characterID then
        p[ player ] = { factions = { }, rfactions = { }, types = { } }
        local result = exports.sql:query_assoc( "SELECT factionID, factionLeader, factionRank, factionSueldo FROM character_to_factions WHERE characterID = " .. characterID )
        for key, value in ipairs( result ) do
            local factionID = value.factionID
            if factions[ factionID ] then
                table.insert( p[ player ].factions, factionID )
                p[ player ].rfactions[ factionID ] = { leader = value.factionLeader, id = factionID, sueldo = value.factionSueldo }
                p[ player ].types[ factions[ factionID ].type ] = true
                setElementData( player, "player:FactionD", { name = getFactionName( factionID ) } )
                local x = exports.sql:query_assoc( "SELECT factionRankName FROM faction_ranks WHERE factionID = " .. factionID .. " AND factionRankID = " .. value.factionRank )
                for k, v in ipairs( x ) do
                    setElementData( player, "player:1212121", v.factionRankName )
                end
            else
                outputDebugString( "Faction " .. factionID .. " does not exist, removing players from it." )
            end
        end
    end
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT f.*, g.groupName FROM factions f LEFT JOIN wcf1_group g ON f.groupID = g.groupID" )
		for key, value in ipairs( result ) do
			if value.groupName then
				loadFaction( value.factionID, value.groupName, value.factionType, value.factionTag, value.groupID, value.factionPresupuesto )
			else
				outputDebugString( "Faction " .. value.factionID .. " has no valid group. Ignoring..." )
			end
		end
		
		--
		
		for key, value in ipairs( getElementsByType( "player" ) ) do
			if exports.players:isLoggedIn( value ) then
				loadPlayer( value )
			end
		end
	end
)

addEventHandler( "onCharacterLogin", root,
	function( )
		loadPlayer( source )
	end
)

addEventHandler( "onCharacterLogout", root,
	function( )
		p[ source ] = nil
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
	end
)

--

function getFactionName( factionID )
	return factions[ factionID ] and factions[ factionID ].name
end

function getFactionTag( factionID )
	return factions[ factionID ] and factions[ factionID ].tag
end

function getFactionPresupuesto ( factionID )
	return factions[ factionID ] and factions[ factionID ].presupuesto
end
 
function getFactionOwners ( factionID )
	if factionID then
		local sql = exports.sql:query_assoc("SELECT characterID FROM character_to_factions WHERE factionLeader >= 1 and factionID = "..tostring(factionID))
		return sql
	end   
end

function isFactionOwner ( player, factionID )
	if player and factionID then
		for k, v in ipairs (exports.sql:query_assoc("SELECT characterID FROM character_to_factions WHERE factionLeader >= 1 and factionID = "..tostring(factionID))) do
			if v.characterID == exports.players:getCharacterID(player) then
				return true
			end
		end
	end
end	

function isFactionOwner2 ( userID )
	if userID then
		local sql_characters = exports.sql:query_assoc("SELECT characterID FROM characters WHERE userID = "..tostring(userID))
		for k, v in ipairs (sql_characters) do
			local sql_aux = exports.sql:query_assoc_single("SELECT characterID FROM character_to_factions WHERE factionLeader = 2 and characterID = "..tostring(v.characterID))
			if sql_aux and tonumber(sql_aux.characterID) == tonumber(v.characterID) then
				return true
			end
		end
		return false
	end
end	

function getPlayerSueldo ( player, factionID )
	for key, value in ipairs( getPlayerFactions(player) ) do
		if factions[ factionID ] and value == factionID then
			local sql = exports.sql:query_assoc_single("SELECT factionSueldo FROM character_to_factions WHERE factionID = " .. value .. " AND characterID = " .. exports.players:getCharacterID(player) .. " LIMIT 1")
			return sql.factionSueldo
		end
	end
end

function giveFactionPresupuesto ( factionID, cantidad )
	if factionID and cantidad then
		if exports.sql:query_free( "UPDATE factions SET factionPresupuesto = " .. getFactionPresupuesto (tonumber(factionID)) + tonumber(cantidad) .. " WHERE factionID = " .. tonumber(factionID) ) then
			factions[ factionID ].presupuesto = factions[ factionID ].presupuesto + tonumber(cantidad)
			return true
		else
			return false
		end
	else
		return false
	end
end


function takeFactionPresupuesto ( factionID, cantidad )
	if factionID and cantidad then
		if getFactionPresupuesto(tonumber(factionID))-tonumber(cantidad) < 0 then return false end
		if exports.sql:query_free( "UPDATE factions SET factionPresupuesto = " .. getFactionPresupuesto (tonumber(factionID)) - tonumber(cantidad) .. " WHERE factionID = " .. tonumber(factionID) ) then
			factions[ factionID ].presupuesto = factions[ factionID ].presupuesto - tonumber(cantidad)
			return true
		else
			return false
		end
	else
		return false
	end
end

function limpiarAvisos (player)
	for k, v in ipairs(getElementsByType("blip")) do
		if getElementData(v, "p") and getElementData(v, "p") == getPlayerName(player) then
			destroyElement(v)
		end
	end
	outputChatBox("Se han limpiado los avisos correctamente.", player, 0, 255, 0)
end
addCommandHandler("limpiaravisos", limpiarAvisos)

function getPlayerFactions( player )
	return p[ player ] and p[ player ].factions or false
end
 
function createFactionBlip2( x, y, z, factionID, dimension, tipo )
	if factions[ factionID ] then
		for key, value in pairs( getElementsByType("player") ) do
			if isPlayerInFaction(value, factionID) or getElementData(value, "enc"..tostring(factionID)) then
				if factionID == 1 then
					if not tipo then
						blipID = 58
					elseif tipo == 2 then -- Robo coche
						blipID = 19
					elseif tipo == 3 then -- Robo tienda
						blipID = 20
					end
				elseif factionID == 2 then
					blipID = 59
				else
					blipID = 60
				end
				if dimension and dimension > 0 then
					x, y, z = exports.interiors:getPos(dimension)
				end
				local blip = createBlip( x, y, z, blipID, 2, 0, 0, 255, 255, 0, 99999.0, value )
				setElementData(blip, "p", getPlayerName(value))
				setPlayerHudComponentVisible ( value, "radar", true )
			end
		end
		return true
	end
	return false
end

function createFactionBlip( creador, x, y, z, factionID )
	if factions[ factionID ] then
		if getElementDimension(creador) > 0 then return createFactionBlip2(x, y, z, factionID, getElementDimension(creador)) end
		for key, value in pairs( getElementsByType("player") ) do
			if isPlayerInFaction(value, factionID) or getElementData(value, "enc"..tostring(factionID)) then
				if factionID == 1 then
					blipID = 58
				elseif factionID == 2 then
					blipID = 59
					if isPedDead(creador) then
						blipID = 21
					end
				else
					blipID = 60
				end
				local blip = createBlipAttachedTo(creador, blipID, 2, 0, 0, 255, 255, 0, 99999.0, value )
				setElementData(blip, "p", getPlayerName(value))
				setPlayerHudComponentVisible ( value, "radar", true )
			end
		end
		return true
	end
	return false
end

function sendMessageToFaction( factionID, message, ... )
	if factions[ factionID ] then
		for key, value in pairs( p ) do
			if value.rfactions[ factionID ] then
				outputChatBox( message, key, ...  )
			end
		end
		if tonumber(factionID) == 1 then
			for key2, value2 in ipairs(getElementsByType("player")) do
				if getElementData(value2, "enc1") then
					outputChatBox( message, value2, ...  )
				end
			end
		end
		return true
	end
	return false
end
 
function isPlayerInFaction( player, faction, leader )
	return factions[ faction ] and p[ player ] and p[ player ].rfactions and p[ player ].rfactions[ faction ] and ( type( leader ) ~= "number" or p[ player ].rfactions[ faction ].leader >= leader ) and true or false
end

function isPlayerInFactionType( player, type_ )
	type_ = factionTypes[ type_ ] or type_
	if not type_ then
		return false
	end
	
	local f = p[ player ] and p[ player ].factions
	if f then
		for _, value in pairs( f ) do
			if factions[ value ] and factions[ value ].type == type_ then
				return true, value, factions[ value ].name, factions[ value ].tag
			end
		end
	end
	return false
end

--

addEvent( "faction:show", true )
addEventHandler( "faction:show", root,
	function( fnum )
		if source == client then
			local faction = fnum and fnum < 0 and p[ source ].rfactions[ -fnum ] and p[ source ].rfactions[ -fnum ].id or p[ source ].factions[ fnum or 1 ]
			if faction then
				local result = exports.sql:query_assoc( "SELECT c.characterName, cf.factionLeader, cf.factionRank, cf.factionSueldo, DATEDIFF(NOW(),c.lastLogin) AS days FROM character_to_factions cf LEFT JOIN characters c ON c.characterID = cf.characterID WHERE cf.factionID = " .. faction .. " ORDER BY cf.factionRank DESC, c.characterName ASC" )
				if result then
					local members = { }
					for key, value in ipairs( result ) do
						if value.characterName and tostring(value.characterName) ~= "Ryan Harrish" then
							table.insert( members, { tostring(value.characterName), value.factionLeader, value.factionRank, value.factionSueldo, exports.players:isLoggedIn( getPlayerFromName( value.characterName:gsub( " ", "_" ) ) ) and -1 or value.days } )
						end
					end
					local pr = getFactionPresupuesto ( faction )
					triggerClientEvent( source, "faction:show", source, faction, members, pr, factions[ faction ].name, factions[ faction ].ranks )
				end
			end
		end
	end
)

--

local function joinFaction( inviter, player, faction )
	if exports.players:isLoggedIn( player ) and p[ player ] then
		if not p[ player ].rfactions[ faction ] then
			-- let's add him into the faction
			-- Comprobación nivel 2 y dar objetivo.
			local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
			if nivel < 2 then outputChatBox( "No puedes invitar a este jugador porque necesita al menos nivel 2", inviter, 255, 0, 0) return end
			if nivel == 2 and not exports.objetivos:isObjetivoCompletado(12, exports.players:getCharacterID(player)) then
				exports.objetivos:addObjetivo(12, exports.players:getCharacterID(player), player)
			end
			-- Fin comprobación nivel 2 y dar objetivo.
			-- Fix
			if exports.sql:query_free( "INSERT INTO character_to_factions (characterID, factionID) VALUES (" .. exports.players:getCharacterID( player ) .. ", " .. faction .. ")" ) then
				-- if he is the first user of this char, set him to the usergroup
				local result = exports.sql:query_assoc_single( "SELECT COUNT(*) AS number FROM character_to_factions cf LEFT JOIN characters c ON c.characterID = cf.characterID WHERE cf.factionID = " .. faction .. " AND c.userID = " .. exports.players:getUserID( player ) )
				if result.number == 1 then
					if not exports.sql:query_free( "INSERT INTO wcf1_user_to_groups (userID, groupID) VALUES (" .. exports.players:getUserID( player ) .. ", " .. factions[ faction ].group .. ")" ) then
						exports.sql:query_free( "DELETE FROM wcf1_user_to_groups WHERE userID = " .. exports.players:getUserID( player ) .. " AND groupID = " .. factions[ faction ].group )
						
						exports.sql:query_free( "DELETE FROM character_to_factions WHERE characterID = " .. exports.players:getCharacterID( player ) .. " AND factionID = " .. faction .. " LIMIT 1" )
						
						outputChatBox( "Se ha producido un error, inténtalo de nuevo.", inviter, 255, 0, 0 )
						
						return false
					end
				end
				-- Recargamos permisos en foro
				exports.foro:actualizarPermisosEnForo(exports.players:getUserID(player))
				-- successful
				table.insert( p[ player ].factions, faction )
				p[ player ].rfactions[ faction ] = { leader = 0, id = faction, sueldo = 0 }
				p[ player ].types[ factions[ faction ].type ] = true
				return true
			end
		else
			outputChatBox( "(( " .. getPlayerName( player ):gsub( "_", " " ) .. " ya está en dicha facción. ))", inviter, 255, 0, 0 )
		end
	end
	return false
end

addEvent( "faction:join", true )
addEventHandler( "faction:join", root,
	function( faction )
		-- check for faction leader
		if client and client ~= source and p[ client ] and p[ client ].rfactions[ faction ] and p[ client ].rfactions[ faction ].leader >= 1 or client and getElementData(client, "account:gmduty") == true and client ~= source then
			if joinFaction( client, source, faction ) then
				outputChatBox( "(( " .. getPlayerName( client ):gsub( "_", " " ) .. " te asigno a la faccion " .. factions[ faction ].name .. ". ))", source, 0, 255, 0 )
				outputChatBox( "(( Asignaste a " .. getPlayerName( source ):gsub( "_", " " ) .. " a la faccion " .. factions[ faction ].name .. ". ))", client, 0, 255, 0 )
			end
		end
	end
)

addCommandHandler( "setfaction",
	function( player, commandName, other, faction )
		local faction = tonumber( faction )
		if other and faction then
			if factions[ faction ] then
				local other, name = exports.players:getFromName( player, other )
				if other then
					if joinFaction( player, other, faction ) then
						outputChatBox( "(( " .. getPlayerName( player ):gsub( "_", " " ) .. " te asignó a la facción " .. factions[ faction ].name .. ". ))", other, 0, 255, 153 )
						if player ~= other then
							outputChatBox( "(( Asignaste a " .. getPlayerName( other ):gsub( "_", " " ) .. " a la facción " .. factions[ faction ].name .. ". ))", player, 0, 255, 153 )
						end
					end
				end
			else
				outputChatBox( "Esta facción no existe.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [faction]", player, 255, 255, 255 )
		end
	end,
	true
)

--

addEvent( "faction:leave", true )
addEventHandler( "faction:leave", root,
	function( faction )
		if source == client then
			if factions[ faction ] and p[ source ].rfactions[ faction ] then
				if not hasObjectPermissionTo(source, 'command.modchat', false) then
					outputChatBox("No puedes dejar la empresa por tu cuenta. Pide tu despido al jefe.", source, 255, 0, 0)
				else	
					if exports.sql:query_free( "DELETE FROM character_to_factions WHERE characterID = " .. exports.players:getCharacterID( source ) .. " AND factionID = " .. faction .. " LIMIT 1" ) then
						sendMessageToFaction( faction, "(( " .. getPlayerName( source ):gsub( "_", " " ) .. " abandonó la faccion " .. factions[ faction ].name .. ". ))", 255, 127, 0 )
						
						-- remove him from the tables
						p[ source ].types = { }
						for i = #p[ source ].factions, 1, -1 do
							if p[ source ].factions[ i ] == faction then
								table.remove( p[ source ].factions, i )
							else
								p[ source ].types[ factions[ i ].type ] = true
							end
						end
						p[ source ].rfactions[ faction ] = nil
						
						-- count other chars of this player in the same faction
						local result = exports.sql:query_assoc_single( "SELECT COUNT(*) AS number FROM character_to_factions cf LEFT JOIN characters c ON c.characterID = cf.characterID WHERE cf.factionID = " .. faction .. " AND c.userID = " .. exports.players:getUserID( source ) )
						if result.number == 0 then
							-- delete from the usergroup
							exports.sql:query_free( "DELETE FROM wcf1_user_to_groups WHERE userID = " .. exports.players:getUserID( source ) .. " AND groupID = " .. factions[ faction ].group )
						end
						-- Recargamos permisos en foro
						exports.foro:actualizarPermisosEnForo(exports.players:getUserID(source))
					end
				end
			end
		end
	end
)

--

local rightNames = { "Lider", "Directivo" }

addEvent( "faction:demoterights", true )
addEventHandler( "faction:demoterights", root,
	function( faction, name, new )
		-- Sanity Check
		if source == client and faction == factions[ faction ].factionID and p[ source ].rfactions[ faction ] and type( name ) == "string" and (getElementData(client, "account:gmduty") or p[ source ].rfactions[ faction ].leader == 2) then
			local player = getPlayerFromName( name:gsub( " ", "_" ) )
			if (player ~= source) or (player == source and (getElementData(client, "account:gmduty"))) then -- You can't change your own rights.
				if player and p[ player ] and not p[ player ].rfactions[ faction ] then
					-- player exists, but is not a member of the faction
					return
				end
				local user = exports.sql:query_assoc_single("SELECT userID FROM characters WHERE characterName = '%s'", tostring(name))
				if exports.sql:query_affected_rows( "UPDATE character_to_factions cf, characters c SET cf.factionLeader = cf.factionLeader - 1 WHERE c.characterID = cf.characterID AND c.characterName = '%s' AND cf.factionLeader >= 0 AND cf.factionID = "..tostring(faction), name ) == 1 then
					sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " degradó a " .. name .. " a " .. ( rightNames[ new ] or "Miembro" ) .. ". ))", 255, 127, 0 )
					-- Recargamos permisos en foro
					exports.foro:actualizarPermisosEnForo(user.userID)
					if player then
						p[ player ].rfactions[ faction ].leader = p[ player ].rfactions[ faction ].leader - 1
					end
				else
					outputChatBox( "(( MySQL-Error. ))", source, 255, 0, 0 )
				end
			end
		end
	end
)

addEvent( "faction:promoterights", true )
addEventHandler( "faction:promoterights", root,
	function( faction, name, new )
		-- Sanity Check
		if source == client and faction == factions[ faction ].factionID and p[ source ].rfactions[ faction ] and type( name ) == "string" and (getElementData(client, "account:gmduty") or p[ source ].rfactions[ faction ].leader == 2) then
			local player = getPlayerFromName( name:gsub( " ", "_" ) )
			if (player ~= source) or (player == source and (getElementData(client, "account:gmduty"))) then -- You can't change your own rights.
				if player and p[ player ] and not p[ player ].rfactions[ faction ] then
					-- player exists, but is not a member of the faction
					return
				end
				local user = exports.sql:query_assoc_single("SELECT userID FROM characters WHERE characterName = '%s'", tostring(name))
				if exports.sql:query_affected_rows( "UPDATE character_to_factions cf, characters c SET cf.factionLeader = cf.factionLeader + 1 WHERE c.characterID = cf.characterID AND c.characterName = '%s' AND cf.factionLeader < 2 AND cf.factionID = "..tostring(faction), name ) == 1 then
					sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " ascendio a  " .. name .. " a " .. ( rightNames[ new ] or "Member" ) .. ". ))", 255, 127, 0 )
					-- Recargamos permisos en foro
					exports.foro:actualizarPermisosEnForo(user.userID)
					if player then
						p[ player ].rfactions[ faction ].leader = p[ player ].rfactions[ faction ].leader + 1
					end
				else
					outputChatBox( "(( MySQL-Error. ))", source, 255, 0, 0 )
				end
			end
		end
	end
)

addEvent( "faction:demote", true )
addEventHandler( "faction:demote", root,
	function( faction, name, new )
		-- Sanity Check
		if source == client and faction == factions[ faction ].factionID and p[ source ].rfactions[ faction ] and type( name ) == "string" and (getElementData(client, "account:gmduty") or p[ source ].rfactions[ faction ].leader > 0) then
			local player = getPlayerFromName( name:gsub( " ", "_" ) )
			if player and p[ player ] and not p[ player ].rfactions[ faction ] then
				-- player exists, but is not a member of the faction
				return
			end
			
			if factions[ faction ].ranks[ new ] then
				if exports.sql:query_affected_rows( "UPDATE character_to_factions cf, characters c SET cf.factionRank = cf.factionRank - 1 WHERE c.characterID = cf.characterID AND c.characterName = '%s' AND cf.factionRank > 1 AND cf.factionID = "..tostring(faction), name ) == 1 then
					sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " degradó a " .. name .. " a " .. ( factions[ faction ].ranks[ new ] or "?" ) .. ". ))", 255, 127, 0 )
				else
					outputChatBox( "(( MySQL-Error. ))", source, 255, 0, 0 )
				end
			end
		end
	end
)

addEvent( "faction:promote", true )
addEventHandler( "faction:promote", root,
	function( faction, name, new )
		-- Sanity Check
		if source == client and faction == factions[ faction ].factionID and p[ source ].rfactions[ faction ] and type( name ) == "string" and (getElementData(client, "account:gmduty") or p[ source ].rfactions[ faction ].leader > 0) then
			local player = getPlayerFromName( name:gsub( " ", "_" ) )
			if player and p[ player ] and not p[ player ].rfactions[ faction ] then
				-- player exists, but is not a member of the faction
				return
			end
			
			if factions[ faction ].ranks[ new ] then
				if exports.sql:query_affected_rows( "UPDATE character_to_factions cf, characters c SET cf.factionRank = cf.factionRank + 1 WHERE c.characterID = cf.characterID AND c.characterName = '%s' AND cf.factionRank < " .. #factions[ faction ].ranks .. " AND cf.factionID = "..tostring(faction), name ) == 1 then
					sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " ascendió a " .. name .. " a " .. ( factions[ faction ].ranks[ new ] or "?" ) .. ". ))", 255, 127, 0 )
				else
					outputChatBox( "(( MySQL-Error. ))", source, 255, 0, 0 )
				end
			end
		end
	end
)

addEvent( "faction:kick", true )
addEventHandler( "faction:kick", root,
	function( faction, name )
		-- Sanity Check
		if source == client and p[ source ].rfactions[ faction ] and type( name ) == "string" and (p[ source ].rfactions[ faction ].leader >= 1 or getElementData(client, "account:gmduty")) then
			local player = getPlayerFromName( name:gsub( " ", "_" ) )
			if player ~= source then -- You can't change your own rights.
				if player and p[ player ] and not p[ player ].rfactions[ faction ] then
					-- player exists, but is not a member of the faction
					return
				elseif player and p[ source ].rfactions[ faction ].leader < p[ player ].rfactions[ faction ].leader then
					-- we don't have enough rights to kick the player
					return
				end
				local consulta, error = exports.sql:query_assoc_single("SELECT characterID FROM characters WHERE characterName = '" .. tostring(name) .. "'" )
				if error then outputChatBox("Se ha producido un error. Inténtalo de nuevo más tarde.", source, 255, 0, 0) outputDebugString(error) return end
				local characterID = tonumber(consulta.characterID)
				if not characterID then outputChatBox("Se ha producido un error. Inténtalo de nuevo más tarde.", source, 255, 0, 0) return end
				if exports.sql:query_free("DELETE FROM `character_to_factions` WHERE `factionID` = "..faction.." AND `characterID` = "..characterID ) then
				--if exports.sql:query_affected_rows( "DELETE cf FROM character_to_factions cf LEFT JOIN characters c ON c.characterID = cf.characterID WHERE cf.factionID = " .. faction .. " AND c.characterName = '%s' AND cf.factionLeader < " .. p[ source ].rfactions[ faction ].leader, name ) == 1 then
					sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " expulsó a  " .. name .. ". ))", 255, 127, 0 )
					if player then
						-- remove him from the tables
						p[ player ].types = { }
						for i = #p[ player ].factions, 1, -1 do
							if p[ player ].factions[ i ] == faction then
								table.remove( p[ player ].factions, i )
							else
								p[ player ].types[ factions[ i ].type ] = true
							end
						end
						p[ player ].rfactions[ faction ] = nil
					end
					
					-- count other chars of this player in the same faction
					local user = exports.sql:query_assoc_single( "SELECT userID FROM characters WHERE characterName = '%s'", name )
					if user then
						local result = exports.sql:query_assoc_single( "SELECT COUNT(*) AS number FROM character_to_factions cf LEFT JOIN characters c ON c.characterID = cf.characterID WHERE cf.factionID = " .. faction .. " AND c.userID = " .. user.userID )
						if result.number == 0 then
							-- delete from the usergroup
							exports.sql:query_free( "DELETE FROM wcf1_user_to_groups WHERE userID = " .. user.userID .. " AND groupID = " .. factions[ faction ].group )
						end
					end
					-- Recargamos permisos en foro
					exports.foro:actualizarPermisosEnForo(user.userID)
				else
					outputChatBox( "(( MySQL-Error. ))", source, 255, 0, 0 )
				end
			end
		end
	end
)


addEvent( "faction:updateranks", true )
addEventHandler( "faction:updateranks", root,
	function( faction, ranks )
		-- Sanity Check
		if source == client and faction == factions[ faction ].factionID and p[ source ].rfactions[ faction ] and p[ source ].rfactions[ faction ].leader == 2 and type( ranks ) == "table" and #ranks <= maxRanks or source == client and faction == factions[ faction ].factionID and getElementData(client, "account:gmduty") == true and type( ranks ) == "table" and #ranks <= maxRanks then
			-- we enforce 1 rank minimum either way.
			if #ranks > 0 then
				-- check if all names are <= 64 chars (not that it makes remotely sense to have so long names) --- TODO: Check to what to reduce this. See table definition above and client's maxlength field for ranks.
				for i = 1, #ranks do
					if type( ranks[i] ) ~= "string" or #ranks[i] > 64 then
						return
					end
				end
				
				local endCount = #ranks
				if #factions[ faction ].ranks > #ranks then -- too much ranks
					-- delete all ranks that do not exist anymore, set user to the highest existing rank
					exports.sql:query_free( "DELETE FROM faction_ranks WHERE factionID = " .. faction .. " AND factionRankID > " .. #ranks )
					exports.sql:query_free( "UPDATE character_to_factions SET factionRankID = " .. #ranks .. " WHERE factionID = " .. faction .. " AND factionRank > " .. #ranks )
				elseif #factions[ faction ].ranks < #ranks then -- not enough ranks
					-- we only save those ranks we didn't add later
					endCount = #factions[ faction ].ranks
					
					-- fill our new ranks in
					for i = endCount + 1, #ranks do
						exports.sql:query_free( "INSERT INTO faction_ranks (factionID, factionRankID, factionRankName) VALUES (" .. faction .. ", " .. i .. ", '%s')", ranks[i] )
					end
				end
				
				-- update all existing ranks
				for i = 1, endCount do
					if factions[ faction ].ranks[i] ~= ranks[i] then
						exports.sql:query_free( "UPDATE faction_ranks SET factionRankName = '%s' WHERE factionID = " .. faction .. " AND factionRankID = " .. i, ranks[i] )
					end
				end
				
				-- save our ranks
				factions[ faction ].ranks = ranks
				
				-- message
				sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " actualizo los cargos. ))", 255, 127, 0 )
			end
		end
	end
)

addEvent( "faction:cambiarsueldo", true )
addEventHandler( "faction:cambiarsueldo", root,
	function( faction, name, sueldo )
		-- Sanity Check
		if source == client and faction == factions[ faction ].factionID and p[ source ].rfactions[ faction ] and type( name ) == "string" and (getElementData(client, "account:gmduty") or p[ source ].rfactions[ faction ].leader == 2) then
			local player = getPlayerFromName( name:gsub( " ", "_" ) )
				if player and p[ player ] and not p[ player ].rfactions[ faction ] then
					-- player exists, but is not a member of the faction
					return
				end
				local character = exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s'", name )
				if exports.sql:query_free( "UPDATE character_to_factions SET factionSueldo = " .. tonumber(sueldo) .. " WHERE factionID = " .. faction .. " AND characterID = " .. character.characterID ) then
					sendMessageToFaction( faction, "(( " .. factions[ faction ].tag .. " - " .. getPlayerName( source ):gsub( "_", " " ) .. " cambió el sueldo a " .. name .. " a " .. tostring(sueldo) .. ". ))", 255, 127, 0 )
				else
					outputChatBox( "(( MySQL-Error. ))", source, 255, 0, 0 )
				end
		end
	end
)

addCommandHandler( "setfactionrights",
	function( player, commandName, other, faction, level )
		local faction = tonumber( faction )
		local level = math.ceil( tonumber( level ) or -1 )
		if level and level >= 0 and level <= 2 and other and faction then
			if factions[ faction ] then
				local other, name = exports.players:getFromName( player, other )
				if other then
					if p[ other ] and p[ other ].rfactions[ faction ] then
						if exports.sql:query_free( "UPDATE character_to_factions SET factionLeader = " .. level .. " WHERE factionID = " .. faction .. " AND characterID = " .. exports.players:getCharacterID( other ) ) then
							p[ other ].rfactions[ faction ].leader = level
							
							outputChatBox( "(( You set " .. getPlayerName( other ):gsub( "_", " " ) .. " to " .. ( rightNames[ level ] or "Member" ) .. " of " .. factions[ faction ].name .. ". ))", player, 0, 255, 153 )
						else
							outputChatBox( "MySQL-Error.", player, 255, 0, 0 )
						end
					else
						outputChatBox( "Player is not in that faction.", player, 255, 0, 0 )
					end
				end
			else
				outputChatBox( "This faction does not exist.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [faction] [level: 0=member, 1=leader, 2=owner]", player, 255, 255, 255 )
		end
	end,
	true
)
addCommandHandler( "setfactionrank",
	function( player, commandName, other, faction, rank )
		local faction = tonumber( faction )
		local rank = math.ceil( tonumber( rank ) or -1 )
		if rank and rank >= 1 and other and faction then
			if factions[ faction ] then
				local other, name = exports.players:getFromName( player, other )
				if other then
					if p[ other ] and p[ other ].rfactions[ faction ] then
						if rank <= #factions[ faction ].ranks then
							if exports.sql:query_free( "UPDATE character_to_factions SET factionRank = " .. rank .. " WHERE factionID = " .. faction .. " AND characterID = " .. exports.players:getCharacterID( other ) ) then
								outputChatBox( "(( You set " .. getPlayerName( other ):gsub( "_", " " ) .. " to " .. factions[ faction ].ranks[ rank ] .. " of " .. factions[ faction ].name .. ". ))", player, 0, 255, 153 )
							else
								outputChatBox( "MySQL-Error.", player, 255, 0, 0 )
							end
						else
							outputChatBox( "This faction does not have " .. rank .. " ranks.", player, 255, 0, 0 )
						end
					else
						outputChatBox( "Player is not in that faction.", player, 255, 0, 0 )
					end
				end
			else
				outputChatBox( "This faction does not exist.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [faction] [rank]", player, 255, 255, 255 )
		end
	end,
	true
)


--[[function fixUserIDConGroupID ()
	local sqlF = exports.sql:query_assoc("SELECT * FROM `character_to_factions`")
	for k, v in ipairs(sqlF) do
		local sql2 = exports.sql:query_assoc_single("SELECT `userID` FROM `characters` WHERE `characterID` = "..tonumber(v.characterID))
		if sql2 then
			local sql3 = exports.sql:query_assoc_single("SELECT `groupID` FROM `factions` WHERE `factionID` = "..tonumber(v.factionID))
			if sql3 then
				local sql4 = exports.sql:query_assoc_single("SELECT * FROM wcf1_user_to_groups WHERE userID = "..tonumber(sql2.userID).. " AND groupID = "..tonumber(sql3.groupID))
				if not sql4 then
					exports.sql:query_free( "INSERT INTO wcf1_user_to_groups (userID, groupID) VALUES (" .. tonumber(sql2.userID) .. ", " .. tonumber(sql3.groupID) .. ")" )
				end
			else
			outputDebugString("ATENCIÓN: cID "..tostring(v.characterID).." fID "..tostring(v.factionID))
			end
		else
			outputDebugString(tostring(v.characterID))
		end
	end
end
addCommandHandler("fixgu", fixUserIDConGroupID)]]

-- A veces se bugea con el addPedClothes revisar (es un bug leve no tiene mucha prioridad)

function darRopaTrabajo (player, cmd, tip)
	if isElementInWater(player) then outputChatBox("No puedes usar este comando en el agua.", player, 255, 0, 0) return end
	local tipo = tonumber(tip)
	local s = exports.sql:query_assoc_single("SELECT genero, color FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
	if isPlayerInFaction(player, 1) then --IDS: 265, 266, 267, 280-288
		if tonumber(s.genero) == 2 then
			if not tip then
				outputChatBox("Tienes varios uniformes a tu disposición. Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Agente Negra", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Agente Blanco", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 265)
			elseif tipo == 2 then
				setElementModel(player, 9)
			end
		else
			if not tip then 
				outputChatBox("Tienes varios uniformes a tu disposición. Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Goes", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Motociclista", player, 255, 255, 255)
				outputChatBox("[3] Uniforme Oficial", player, 255, 255, 255)
				outputChatBox("[4] Uniforme Dijin", player, 255, 255, 255)
				outputChatBox("[5] Uniforme Director General", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 285)
			elseif tipo == 2 then
				setElementModel(player, 284)
			elseif tipo == 3 then
				setElementModel(player, 282)
			elseif tipo == 4 then
				setElementModel(player, 280)
			elseif tipo == 5 then
				setElementModel(player, 281)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end
----------------------------------------------------------------- SURA ----------------------------------------------------
	elseif isPlayerInFaction(player, 2) then -- IDS: 274 a 279
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Doctora.", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Bombero (Tierra)", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 276)
			elseif tipo == 2 then
				setElementModel(player, 277)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Medicos", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Lideres", player, 255, 255, 255)
				outputChatBox("[3] Uniforme Directivos", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 274)
			elseif tipo == 2 then
				setElementModel(player, 275)
			elseif tipo == 3 then
				setElementModel(player, 278)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------------- GOBIERNO ----------------------------------------------------
	elseif isPlayerInFaction(player, 31) then -- IDS: 274 a 279
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Doctora.", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Bombero (Tierra)", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 276)
			elseif tipo == 2 then
				setElementModel(player, 277)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Empleados", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Lideres", player, 255, 255, 255)
				outputChatBox("[3] Uniforme Directivos", player, 255, 255, 255)
				outputChatBox("[4] Uniforme Campañas", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 147)
			elseif tipo == 2 then
				setElementModel(player, 165)
			elseif tipo == 3 then
				setElementModel(player, 228)
			elseif tipo == 4 then
				setElementModel(player, 153)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- TDA ---------------------------------------------------
	elseif isPlayerInFaction(player, 46) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Guerrillo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 10)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Guerrillo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 10)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- MALDONADO ---------------------------------------------------
	elseif isPlayerInFaction(player, 41) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Gangster", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 41)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Gangster", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 41)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- AVIANCA ---------------------------------------------------
	elseif isPlayerInFaction(player, 35) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa piloto", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 61)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa piloto", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 61)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- CARTEL DE SAPOS ---------------------------------------------------
	elseif isPlayerInFaction(player, 48) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 273)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 273)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 

----------------------------------------------------------- MANRRIQUE LA 45 ---------------------------------------------------
	elseif isPlayerInFaction(player, 37) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Guerrillo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 301)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Guerrillo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 301)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- FARC ---------------------------------------------------
	elseif isPlayerInFaction(player, 11) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa trabajo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 109)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa trabajo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 109)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- ORDEN MUNDIAL ---------------------------------------------------
	elseif isPlayerInFaction(player, 26) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Guerrillo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 210)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Guerrillo", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 210)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- TRANSITO ---------------------------------------------------
	elseif isPlayerInFaction(player, 33) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Transito", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 96)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Transito", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 96)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- CJNG ---------------------------------------------------
	elseif isPlayerInFaction(player, 10) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 73)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 73)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- COSANOSTRA ---------------------------------------------------
	elseif isPlayerInFaction(player, 13) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 161)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				outputChatBox("[2] Ropa Jefe", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 161)
			elseif tipo == 2 then
				setElementModel(player, 48)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
		----------------------------------------------- MAFIA TURKA ---------------------------------------------------
	elseif isPlayerInFaction(player, 47) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 39)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 39)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end  
		----------------------------------------------- MAFIA GANISHKA ---------------------------------------------------
	elseif isPlayerInFaction(player, 28) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 142)
			elseif tipo == 2 then
				setElementModel(player, 144)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa Sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 142)
			elseif tipo == 2 then
				setElementModel(player, 144)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- MECA ILEGAL ---------------------------------------------------
	elseif isPlayerInFaction(player, 36) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa mecanico", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 305)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa mecanico", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 305)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- Barrio A ---------------------------------------------------
	elseif isPlayerInFaction(player, 39) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa chimba", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 14)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa chimba", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 14)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- DEA ---------------------------------------------------
	elseif isPlayerInFaction(player, 27) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme DEA 1", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 287)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme DEA 1", player, 255, 255, 255)
				outputChatBox("[2] Uniforme DEA 2", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 113)
			elseif tipo == 2 then
				setElementModel(player, 12)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- ELN ---------------------------------------------------
	elseif isPlayerInFaction(player, 10) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 11)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 11)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
----------------------------------------------------------- PARACOS ---------------------------------------------------
	elseif isPlayerInFaction(player, 44) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 142)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Ropa sicario", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 142)
			else
				outputChatBox("¡Tipo incorrecto!", player, 255, 0, 0)
				return
			end
		end 
-------------------------------------------------------------------------EJN--------------------------------------------------------
	elseif isPlayerInFaction(player, 22) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme EJC 1", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 287)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme EJC 1", player, 255, 255, 255)
				outputChatBox("[2] Uniforme EJC 2", player, 255, 255, 255)
				outputChatBox("[3] Uniforme EJC 3", player, 255, 255, 255)
				outputChatBox("[4] Uniforme EJC 4", player, 255, 255, 255)
				outputChatBox("[5] Uniforme EJC 5", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 287)
			elseif tipo == 2 then
				setElementModel(player, 304)
			elseif tipo == 3 then
				setElementModel(player, 288)
			elseif tipo == 4 then
				setElementModel(player, 286)
			elseif tipo == 5 then
				setElementModel(player, 283)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end 
-------------------------------------------------------------------------------------------------------------------------------------------
elseif isPlayerInFaction(player, 25) then
		if tonumber(s.genero) == 2 then
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Oficial", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 38)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Oficial", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 38)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end 

---------------------------------------------------------------------------------------------------------------------
	elseif isPlayerInFaction(player, 3) then -- IDS: 305, 309, 268, 50
		if tonumber(s.genero) == 2 then
			setElementModel(player, 69)
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes de trabajo a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Mecanico", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Mecanico Directivos", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 309)
			elseif tipo == 2 then
				setElementModel(player, 50)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end
		
	elseif isPlayerInFaction(player, 43) then -- IDS: 305, 309, 268, 50
		if tonumber(s.genero) == 2 then
			setElementModel(player, 175)
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes de trabajo a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Normal", player, 255, 255, 255)
				outputChatBox("[2] Uniforme Jefe", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 175)
			elseif tipo == 2 then
				setElementModel(player, 174)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end
	elseif isPlayerInFaction(player, 100) then 
		if tonumber(s.genero) == 2 then
			setElementModel(player, 175)
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes de trabajo a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Normal", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 285)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end

	elseif isPlayerInFaction(player, 35) then -- IDS: 305, 309, 268, 50
		if tonumber(s.genero) == 2 then
			setElementModel(player, 175)
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes de trabajo a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Miembros", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 70)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end
	elseif isPlayerInFaction(player, 37) then -- IDS: 305, 309, 268, 50
		if tonumber(s.genero) == 2 then
			setElementModel(player, 175)
		else
			if not tip then 
	 			outputChatBox("Tienes varios uniformes de trabajo a tu disposición.", player, 0, 255, 0)
				outputChatBox("[1] Uniforme Normal", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 240)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end		
		elseif isPlayerInFaction(player, 16) then -- IDS: 305, 309, 268, 50
		if tonumber(s.genero) == 2 then
			setElementModel(player, 69)
		else
			if not tip then 
	 			outputChatBox("Tienes varios monos de trabajo a tu disposición. Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Mono Aplicado a Ropa del PJ. (solo color negro)", player, 255, 255, 255)
				outputChatBox("[2] Mono Mecánico (Latino)", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 11)
				addPedClothes(player, "garageleg", "garagetr", 17)
			elseif tipo == 2 then
				setElementModel(player, 0)
			elseif tipo == 3 then
				--setElementModel(player, 268)
			elseif tipo == 4 then
				setElementModel(player, 0)
			elseif tipo == 5 then
				setElementModel(player, 0)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end
	elseif isPlayerInFaction(player, 7) then -- IDS: 27, 260, 16, 53, 218
		if tonumber(s.genero) == 2 then -- Mujer 53, 218
			if not tip then 
	 			outputChatBox("Tienes varios trajes a tu disposición. Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Mujer Blanca.", player, 255, 255, 255)
				outputChatBox("[2] Mujer Negra", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 53)
			elseif tipo == 2 then
				setElementModel(player, 218)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		else
			if not tip then 
	 			outputChatBox("Tienes varios trajes a tu disposición. Elige uno con /ropatrabajo [número]", player, 0, 255, 0)
				outputChatBox("[1] Hombre Negro", player, 255, 255, 255)
				outputChatBox("[2] Hombre Negro con Orejeras", player, 255, 255, 255)
				outputChatBox("[3] Hombre Blanco", player, 255, 255, 255)
				return
			elseif tipo == 1 then
				setElementModel(player, 260)
			elseif tipo == 2 then
				setElementModel(player, 16)
			elseif tipo == 3 then
				setElementModel(player, 27)
			else
				outputChatBox("¡Tipo incorrecto! Usa /ropatrabajo para ver los tipos disponibles.", player, 255, 0, 0)
				return
			end
		end		
	else
		outputChatBox("Tu facción no tiene ninguna ropa de trabajo asignada.", player, 255, 0, 0)
		outputChatBox("Si deseas comprar la skin, acude al discord.", player, 255, 255, 255)
		return
	end
	if tonumber(s.genero) == 1 and tonumber(s.color) == 1 and getElementModel(player) == 0 then
		triggerClientEvent("onSolicitarRopaBlanco", player)
	end
	exports.chat:me(player, "se pone su ropa de trabajo.")
	outputChatBox("Usa /qrt para quitarte la ropa de trabajo.", player, 0, 255, 0)
end
addCommandHandler("rtrabajo", darRopaTrabajo)

function toggleRopaTortura (player, cmd, tipo)
	if isElementInWater(player) then outputChatBox("No puedes usar este comando en el agua.", player, 255, 0, 0) return end
	local s = exports.sql:query_assoc_single("SELECT genero, color FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
	if tostring(tipo) == "1" then
		if tonumber(s.genero) == 2 then
			setElementModel(player, 178)
		else
			setElementModel(player, 0)
			addPedClothes(player, "gimpleg", "gimpleg", 17)
		end
		outputChatBox("Usa /qrt para quitártelo.", player, 255, 0, 0)
	elseif tostring(tipo) == "2" then
		if tonumber(s.genero) == 2 then
			setElementModel(player, 257)
		else
			setElementModel(player, 0)
			addPedClothes(player, "balaclava", "balaclava", 17)
		end
		outputChatBox("Usa /qrt para quitártelo.", player, 255, 0, 0)
	else
		outputChatBox("Sintaxis: /ropatortura [tipo, 1 o 2]", player, 255, 255, 255)
	end
	if tonumber(s.genero) == 1 and tonumber(s.color) == 1 then
		triggerClientEvent("onSolicitarRopaBlanco", player)
	end
end
addCommandHandler("ropatortura", toggleRopaTortura)	

function quitarRopaTrabajo (player)  --PARCHE YA PARA SOPORTAR SI TENIA SKIN O USABA EL SISTEMA DE ROPA
	if isElementInWater(player) then outputChatBox("No puedes usar este comando en el agua.", player, 255, 0, 0) return end
	local s = exports.sql:query_assoc_single("SELECT genero, color, musculatura, gordura, skin FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
	if getElementModel(player) > 0 then setElementModel(player, 0) end
	removePedClothes(player, 17)
	exports.chat:me(player, "se quita su ropa de trabajo.")
	if tonumber(s.skin) == 0 then
		if tonumber(s.genero) == 1 and tonumber(s.color) == 1 then
			triggerClientEvent("onSolicitarRopaBlanco", player)
		end
		setPedStat(player,23,tostring(s.musculatura))
		setPedStat(player,21,tostring(s.gordura))
	else
		setElementModel(player, tonumber(s.skin))
	end
end
addCommandHandler("qrt", quitarRopaTrabajo)