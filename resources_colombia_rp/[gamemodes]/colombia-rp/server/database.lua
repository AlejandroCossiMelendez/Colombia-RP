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

-- Función para escapar strings SQL (similar a exports.sql:escape_string)
function escapeString(str)
    if not str then
        return ""
    end
    str = tostring(str)
    -- Escapar comillas simples y barras invertidas
    str = string.gsub(str, "\\", "\\\\")
    str = string.gsub(str, "'", "\\'")
    return str
end

-- Función para insertar y obtener el ID (similar a exports.sql:query_insertid)
function queryInsertId(query, ...)
    if not dbConnection then
        outputServerLog("[DATABASE] ERROR: No hay conexión a la base de datos")
        return nil, "No hay conexión"
    end
    
    -- Ejecutar la consulta
    local result = dbExec(dbConnection, query, ...)
    if result then
        -- Obtener el último ID insertado
        local lastId = dbQuery(dbConnection, "SELECT LAST_INSERT_ID() as id")
        if lastId then
            local rows = dbPoll(lastId, -1)
            if rows and rows[1] then
                return tonumber(rows[1].id), nil
            end
        end
        return nil, "No se pudo obtener el ID"
    end
    return nil, "Error al ejecutar la consulta"
end

-- Función para obtener un solo resultado (similar a exports.sql:query_assoc_single)
function queryAssocSingle(query, ...)
    if not dbConnection then
        outputServerLog("[DATABASE] ERROR: No hay conexión a la base de datos")
        return nil
    end
    
    local result = dbQuery(dbConnection, query, ...)
    if result then
        local rows = dbPoll(result, -1)
        if rows and rows[1] then
            return rows[1]
        end
    end
    return nil
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

