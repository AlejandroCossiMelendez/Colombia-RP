-- Sistema de base de datos MySQL
local dbConnection = nil

function connectDatabase()
    local db = dbConnect("mysql", 
        "dbname=" .. Config.Database.database .. 
        ";host=" .. Config.Database.host .. 
        ";port=" .. Config.Database.port .. 
        ";charset=" .. Config.Database.charset,
        Config.Database.username,
        Config.Database.password
    )
    
    if db then
        dbConnection = db
        outputServerLog("[DATABASE] Conexión a MySQL establecida correctamente")
        return true
    else
        outputServerLog("[DATABASE] ERROR: No se pudo conectar a MySQL")
        return false
    end
end

function getDatabase()
    return dbConnection
end

function queryDatabase(query, ...)
    if not dbConnection then
        outputServerLog("[DATABASE] ERROR: No hay conexión a la base de datos")
        return false
    end
    
    local result = dbQuery(dbConnection, query, ...)
    if result then
        local rows = dbPoll(result, -1)
        return rows
    end
    return false
end

function executeDatabase(query, ...)
    if not dbConnection then
        outputServerLog("[DATABASE] ERROR: No hay conexión a la base de datos")
        return false
    end
    
    local result = dbExec(dbConnection, query, ...)
    return result
end

-- Conectar al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    connectDatabase()
end)

-- Desconectar al detener el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    if dbConnection then
        -- En MTA, las conexiones se cierran automáticamente al detener el recurso
        -- No hay necesidad de dbDestroy, la conexión se libera automáticamente
        dbConnection = nil
        outputServerLog("[DATABASE] Desconectado de MySQL")
    end
end)

