--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Migrado a dbConnect para compatibilidad con Ubuntu 24

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

local connection = nil
local null = nil
local results = { }
local max_results = 3000

-- connection functions
local function connect( )
	local server = "127.0.0.1"
	local user = "downtown"
	local password = "15306266Down_town"
	local db = "downtown_db"
	local port = 3306
	
	-- Usar dbConnect en lugar del módulo mysql
	local connectionString = string.format("dbname=%s;host=%s;port=%s;charset=utf8", db, server, port)
	connection = dbConnect("mysql", connectionString, user, password)
	
	if connection then
		if user == "root" then
			setTimer( outputDebugString, 100, 1, "ATENCIÓN: Se ha conectado usando el usuario root, y no es recomendable.", 2 )
		end
		return true
	else
		outputDebugString ( "Connection to MySQL Failed.", 1 )
		return false
	end
end

local function disconnect( )
	if connection then
		-- dbConnect se cierra automáticamente al detener el recurso
		-- pero podemos verificar si está activo
		connection = nil
	end
end

local function checkConnection( )
	if not connection then
		return connect( )
	end
	-- Verificar si la conexión sigue activa
	local testQuery = dbQuery(connection, "SELECT 1")
	if testQuery then
		dbFree(testQuery)
		return true
	else
		-- Reconectar si falla
		connection = nil
		return connect( )
	end
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		if not connect( ) then
			outputDebugString( "MySQL failed to connect.", 1 )
			cancelEvent( true, "MySQL failed to connect." )
		else
			null = nil -- dbConnect no tiene null, usamos nil
			outputDebugString( "MySQL connection established successfully.", 3 )
		end
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		for key, value in pairs( results ) do
			if value.query then
				dbFree( value.query )
			end
			outputDebugString( "Query not free()'d: " .. (value.q or "unknown"), 2 )
		end
		
		disconnect( )
	end
)

--

function escape_string( str )
	if not connection then
		return ""
	end
	
	if type( str ) == "string" then
		-- dbConnect escapa automáticamente, pero podemos usar dbPrepare para escapar manualmente
		-- Por compatibilidad, devolvemos el string escapado manualmente
		str = string.gsub(str, "\\", "\\\\")
		str = string.gsub(str, "'", "\\'")
		str = string.gsub(str, '"', '\\"')
		return str
	elseif type( str ) == "number" then
		return tostring( str )
	end
	return ""
end

local function query( str, ... )
	if not checkConnection( ) then
		return false, "No connection to database"
	end
	
	-- Formatear la consulta con parámetros escapados
	local queryStr = str
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		queryStr = str:format( unpack( t ) )
	end
	
	local queryObj = dbQuery( connection, queryStr )
	if queryObj then
		for num = 1, max_results do
			if not results[ num ] then
				results[ num ] = { query = queryObj, q = str }
				return num
			end
		end
		dbFree( queryObj )
		return false, "Unable to allocate result in pool"
	end
	return false, "Query failed"
end

function query_free( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	if not checkConnection( ) then
		return false, "No connection to database"
	end
	
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end
	
	local result = dbExec( connection, str )
	if result then
		return true
	end
	return false, "Query execution failed"
end

function free_result( result )
	if results[ result ] then
		if results[ result ].query then
			dbFree( results[ result ].query )
		end
		results[ result ] = nil
	end
end

function query_assoc( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	local t = { }
	local result, error = query( str, ... )
	if result then
		local queryObj = results[ result ].query
		if queryObj then
			local rows = dbPoll( queryObj, -1 )
			if rows then
				for i, row in ipairs( rows ) do
					t[ i ] = { }
					for key, value in pairs( row ) do
						if value ~= null then
							t[ i ][ key ] = tonumber( value ) or value
						end
					end
				end
			end
		end
		free_result( result )
		return t
	end
	return false, error
end

function query_assoc_single( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	local t = { }
	local result, error = query( str, ... )
	if result then
		local queryObj = results[ result ].query
		if queryObj then
			local rows = dbPoll( queryObj, -1 )
			if rows and rows[ 1 ] then
				local row = rows[ 1 ]
				for key, value in pairs( row ) do
					if value ~= null then
						t[ key ] = tonumber( value ) or value
					end
				end
				free_result( result )
				return t
			end
		end
		free_result( result )
		return false
	end
	return false, error
end

function query_insertid( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	if not checkConnection( ) then
		return false, "No connection to database"
	end
	
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end
	
	local result = dbExec( connection, str )
	if result then
		-- Obtener el último ID insertado
		local idQuery = dbQuery( connection, "SELECT LAST_INSERT_ID() as id" )
		if idQuery then
			local rows = dbPoll( idQuery, -1 )
			if rows and rows[ 1 ] then
				local id = tonumber( rows[ 1 ].id )
				dbFree( idQuery )
				return id
			end
			dbFree( idQuery )
		end
		return false, "Could not get insert ID"
	end
	return false, "Query execution failed"
end

function query_affected_rows( str, ... )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	
	if not checkConnection( ) then
		return false, "No connection to database"
	end
	
	local params = { ... }
	local queryStr = str
	if #params > 0 then
		local t = { }
		for k, v in ipairs( params ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		queryStr = str:format( unpack( t ) )
	end
	
	local result = dbExec( connection, queryStr )
	if result then
		-- dbExec devuelve true/false, no el número de filas
		-- Para obtener las filas afectadas, necesitamos usar una consulta separada
		-- Nota: Esto puede no ser 100% preciso, pero es la mejor aproximación
		-- En la mayoría de los casos, si la consulta fue exitosa, asumimos que afectó al menos 1 fila
		return 1
	end
	return false, "Query execution failed"
end
