--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local mysql = {
	database_game = false,
	host = '127.0.0.1',
	dbName = 'mta',
	userName = 'root',
	dbPassword = '',
}

addEventHandler('onResourceStart', resourceRoot, function()
	mysql['database_game'] = dbConnect('mysql', 'dbname='..mysql['dbName']..';host='..mysql['host']..';charset=utf8;', mysql['userName'], mysql['dbPassword'], 'share=1')
	if mysql['database_game'] then
		outputDebugString('[GAME] Baza danych pomyślnie podłączona.')
	else
		outputDebugString('[GAME] Brak połączenia z bazą danych.')
	end
end)

function query(...)
	if not ... or ... and string.len(...) < 1 then return end
	if not mysql['database_game'] then return end

	local q = dbQuery(mysql['database_game'], ...)
	if q then
		local r = {dbPoll(q, -1)}
		return unpack(r)
	end
	return false
end