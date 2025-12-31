-- Sistema de Autenticación y Registro - Servidor (MySQL)
local db = nil

-- ==================== CONFIGURACIÓN MySQL ====================
-- Configura estos valores según tu base de datos MySQL
local MYSQL_HOST = "127.0.0.1"      -- IP o hostname del servidor MySQL
local MYSQL_USER = "mta_user"           -- Usuario de MySQL
local MYSQL_PASS = "15306266_Mta"               -- Contraseña de MySQL
local MYSQL_DB = "mta_login"        -- Nombre de la base de datos
local MYSQL_PORT = 3306             -- Puerto de MySQL (default: 3306)

-- ==================== REGISTRAR EVENTOS PRIMERO ====================
-- Es CRÍTICO registrar los eventos ANTES de cualquier otra cosa
addEvent("onPlayerRegister", true)
addEvent("onPlayerLogin", true)
addEvent("onPlayerCreateCharacter", true)
addEvent("onPlayerSelectCharacter", true)
addEvent("onRequestCharacters", true)
addEvent("onPlayerSavePosition", true)

-- Log para verificar que los eventos están registrados
outputServerLog("[Login] Eventos registrados: onPlayerRegister, onPlayerLogin, onPlayerCreateCharacter, onPlayerSelectCharacter, onRequestCharacters, onPlayerSavePosition")

-- ==================== BASE DE DATOS MySQL ====================
function initDatabase()
    -- Conectar a la base de datos MySQL
    outputServerLog("[Login] Intentando conectar a MySQL...")
    outputServerLog("[Login] Host: " .. MYSQL_HOST .. ", DB: " .. MYSQL_DB .. ", User: " .. MYSQL_USER)
    
    db = dbConnect("mysql", 
        "dbname=" .. MYSQL_DB .. ";host=" .. MYSQL_HOST .. ";port=" .. MYSQL_PORT,
        MYSQL_USER, 
        MYSQL_PASS
    )
    
    if not db then
        local errorMsg = dbError()
        outputServerLog("[Login] ERROR: No se pudo conectar a la base de datos MySQL")
        outputServerLog("[Login] Error: " .. tostring(errorMsg))
        outputServerLog("[Login] Verifica la configuración en server.lua (MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB)")
        return false
    end
    
    outputServerLog("[Login] Conexión a MySQL establecida correctamente")
    
    -- Crear base de datos si no existe (solo si tienes permisos)
    -- dbExec(db, "CREATE DATABASE IF NOT EXISTS " .. MYSQL_DB)
    -- dbExec(db, "USE " .. MYSQL_DB)
    
    -- Crear tabla de usuarios si no existe
    local query1 = dbQuery(db, [[
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(20) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            registerDate DATETIME NOT NULL,
            INDEX idx_username (username),
            INDEX idx_email (email)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    if query1 then
        dbPoll(query1, -1)
        outputServerLog("[Login] Tabla 'users' verificada/creada")
    else
        local errorMsg = dbError(db)
        outputServerLog("[Login] ERROR al crear tabla users: " .. tostring(errorMsg))
    end
    
    -- Crear tabla de personajes si no existe (con campos de posición)
    local query2 = dbQuery(db, [[
        CREATE TABLE IF NOT EXISTS characters (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(20) NOT NULL,
            name VARCHAR(20) NOT NULL,
            surname VARCHAR(20) NOT NULL,
            age INT NOT NULL DEFAULT 18,
            gender INT NOT NULL DEFAULT 0,
            skin INT NOT NULL DEFAULT 0,
            money INT NOT NULL DEFAULT 5000,
            created DATETIME NOT NULL,
            posX FLOAT DEFAULT 1959.55,
            posY FLOAT DEFAULT -1714.46,
            posZ FLOAT DEFAULT 10.0,
            rotation FLOAT DEFAULT 0.0,
            interior INT DEFAULT 0,
            dimension INT DEFAULT 0,
            lastLogin DATETIME,
            INDEX idx_username (username),
            INDEX idx_char_id (id),
            FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    if query2 then
        dbPoll(query2, -1)
        outputServerLog("[Login] Tabla 'characters' verificada/creada")
    else
        local errorMsg = dbError(db)
        outputServerLog("[Login] ERROR al crear tabla characters: " .. tostring(errorMsg))
        -- Si falla por la foreign key, intentar sin ella
        if errorMsg and string.find(string.lower(tostring(errorMsg)), "foreign key") then
            outputServerLog("[Login] Intentando crear tabla sin foreign key...")
            local query3 = dbQuery(db, [[
                CREATE TABLE IF NOT EXISTS characters (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    username VARCHAR(20) NOT NULL,
                    name VARCHAR(20) NOT NULL,
                    surname VARCHAR(20) NOT NULL,
                    age INT NOT NULL DEFAULT 18,
                    gender INT NOT NULL DEFAULT 0,
                    skin INT NOT NULL DEFAULT 0,
                    money INT NOT NULL DEFAULT 5000,
                    created DATETIME NOT NULL,
                    posX FLOAT DEFAULT 1959.55,
                    posY FLOAT DEFAULT -1714.46,
                    posZ FLOAT DEFAULT 10.0,
                    rotation FLOAT DEFAULT 0.0,
                    interior INT DEFAULT 0,
                    dimension INT DEFAULT 0,
                    lastLogin DATETIME,
                    INDEX idx_username (username),
                    INDEX idx_char_id (id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ]])
            if query3 then
                dbPoll(query3, -1)
                outputServerLog("[Login] Tabla 'characters' creada sin foreign key")
            end
        end
    end
    
    outputServerLog("[Login] Base de datos MySQL inicializada correctamente")
    return true
end

-- Función para hashear contraseña
function hashPassword(password)
    local hash = 0
    for i = 1, #password do
        hash = hash + string.byte(password, i) * i
    end
    return tostring(hash)
end

-- Validar nombre de usuario
function isValidUsername(username)
    if not username or string.len(username) < 3 or string.len(username) > 20 then
        return false, "El usuario debe tener entre 3 y 20 caracteres"
    end
    
    if not string.match(username, "^[%a%d_]+$") then
        return false, "El usuario solo puede contener letras, números y guiones bajos"
    end
    
    return true
end

-- Validar email
function isValidEmail(email)
    if not email or string.len(email) < 5 then
        return false, "El email debe tener al menos 5 caracteres"
    end
    
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        return false, "Formato de email inválido"
    end
    
    return true
end

-- ==================== MANEJADORES DE EVENTOS ====================
-- Evento de registro
addEventHandler("onPlayerRegister", root, function(username, password, email)
    if not client then return end
    
    -- Validaciones
    local valid, errorMsg = isValidUsername(username)
    if not valid then
        triggerClientEvent(client, "onRegisterResult", client, false, errorMsg)
        return
    end
    
    valid, errorMsg = isValidEmail(email)
    if not valid then
        triggerClientEvent(client, "onRegisterResult", client, false, errorMsg)
        return
    end
    
    if not password or string.len(password) < 4 then
        triggerClientEvent(client, "onRegisterResult", client, false, "La contraseña debe tener al menos 4 caracteres")
        return
    end
    
    -- Verificar si el usuario ya existe
    local query = dbQuery(db, "SELECT * FROM users WHERE LOWER(username) = ?", string.lower(username))
    local result = dbPoll(query, -1)
    
    if result and #result > 0 then
        triggerClientEvent(client, "onRegisterResult", client, false, "Este usuario ya está registrado")
        return
    end
    
    -- Verificar si el email ya está en uso
    query = dbQuery(db, "SELECT * FROM users WHERE LOWER(email) = ?", string.lower(email))
    result = dbPoll(query, -1)
    
    if result and #result > 0 then
        triggerClientEvent(client, "onRegisterResult", client, false, "Este email ya está registrado")
        return
    end
    
    -- Verificar que la conexión a la base de datos esté activa
    if not db then
        outputServerLog("[Login] ERROR: Base de datos no conectada al intentar registrar usuario")
        triggerClientEvent(client, "onRegisterResult", client, false, "Error de conexión con la base de datos. Contacta a un administrador.")
        return
    end
    
    -- Crear nuevo usuario
    local hashedPassword = hashPassword(password)
    local time = getRealTime()
    local registerDate = string.format("%04d-%02d-%02d %02d:%02d:%02d", 
        time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
    
    -- Usar dbQuery y dbPoll para obtener mejor información de errores
    local query = dbQuery(db, "INSERT INTO users (username, password, email, registerDate) VALUES (?, ?, ?, ?)", 
        username, hashedPassword, email, registerDate)
    
    if not query then
        outputServerLog("[Login] ERROR: No se pudo crear la consulta de inserción")
        triggerClientEvent(client, "onRegisterResult", client, false, "Error al crear la consulta. Intenta de nuevo.")
        return
    end
    
    local result = dbPoll(query, -1)
    
    if result then
        outputServerLog("[Login] Nuevo usuario registrado: " .. username .. " (" .. email .. ")")
        triggerClientEvent(client, "onRegisterResult", client, true, "¡Cuenta creada exitosamente! Ahora puedes iniciar sesión.")
    else
        -- Obtener el error de MySQL
        local errorMsg = dbError(db)
        outputServerLog("[Login] ERROR al registrar usuario: " .. tostring(errorMsg))
        outputServerLog("[Login] Usuario: " .. username .. ", Email: " .. email)
        
        -- Mensaje más específico según el error
        if errorMsg and string.find(string.lower(tostring(errorMsg)), "duplicate") then
            triggerClientEvent(client, "onRegisterResult", client, false, "Este usuario o email ya está registrado")
        else
            triggerClientEvent(client, "onRegisterResult", client, false, "Error al crear la cuenta: " .. tostring(errorMsg))
        end
    end
end)

-- Evento de login
addEventHandler("onPlayerLogin", root, function(username, password)
    if not client then 
        outputServerLog("[Login] ERROR: onPlayerLogin llamado sin client")
        return 
    end
    
    -- Verificar que la base de datos esté conectada
    if not db then
        outputServerLog("[Login] ERROR: Base de datos no conectada al intentar login")
        triggerClientEvent(client, "onLoginResult", client, false, "Error de conexión con la base de datos. Contacta a un administrador.")
        return
    end
    
    -- Asegurar que el jugador no esté ya logueado
    if getElementData(client, "loggedIn") then
        outputServerLog("[Login] Usuario " .. getPlayerName(client) .. " ya está logueado")
        return
    end
    
    if not username or not password then
        triggerClientEvent(client, "onLoginResult", client, false, "Por favor completa todos los campos")
        return
    end
    
    local hashedPassword = hashPassword(password)
    local query = dbQuery(db, "SELECT * FROM users WHERE LOWER(username) = ? AND password = ?", 
        string.lower(username), hashedPassword)
    local result = dbPoll(query, -1)
    
    if not result or #result == 0 then
        triggerClientEvent(client, "onLoginResult", client, false, "Usuario o contraseña incorrectos")
        return
    end
    
    local userData = result[1]
    
    -- Login exitoso
    setElementData(client, "loggedIn", true)
    setElementData(client, "username", userData.username)
    setElementData(client, "userEmail", userData.email)
    
    outputServerLog("[Login] Usuario conectado: " .. userData.username .. " (" .. getPlayerName(client) .. ")")
    
    -- Obtener personajes del usuario
    local charQuery = dbQuery(db, "SELECT * FROM characters WHERE LOWER(username) = ? ORDER BY id", 
        string.lower(userData.username))
    local charResult = dbPoll(charQuery, -1)
    
    local userCharacters = {}
    if charResult then
        for _, char in ipairs(charResult) do
            table.insert(userCharacters, {
                id = char.id,
                name = char.name,
                surname = char.surname,
                age = tonumber(char.age),
                gender = tonumber(char.gender),
                skin = tonumber(char.skin),
                money = tonumber(char.money),
                created = char.created,
                posX = tonumber(char.posX) or 1959.55,
                posY = tonumber(char.posY) or -1714.46,
                posZ = tonumber(char.posZ) or 10.0,
                rotation = tonumber(char.rotation) or 0.0,
                interior = tonumber(char.interior) or 0,
                dimension = tonumber(char.dimension) or 0
            })
        end
    end
    
    -- Enviar personajes al cliente para mostrar el panel de selección
    triggerClientEvent(client, "onLoginResult", client, true, "Login exitoso", userCharacters)
end)

-- Verificar si el jugador está logueado
function isPlayerLoggedIn(player)
    return getElementData(player, "loggedIn") == true
end

-- Crear nuevo personaje
addEventHandler("onPlayerCreateCharacter", root, function(name, surname, age, gender, skin)
    if not client then return end
    
    if not isPlayerLoggedIn(client) then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "Debes estar logueado")
        return
    end
    
    local username = getElementData(client, "username")
    if not username then return end
    
    -- Validaciones
    if not name or string.len(name) < 2 or string.len(name) > 20 then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "El nombre debe tener entre 2 y 20 caracteres")
        return
    end
    
    if surname and (string.len(surname) < 2 or string.len(surname) > 20) then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "El apellido debe tener entre 2 y 20 caracteres")
        return
    end
    
    age = tonumber(age) or 18
    if age < 16 or age > 80 then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "La edad debe estar entre 16 y 80 años")
        return
    end
    
    -- Verificar límite de personajes (máximo 3 por usuario)
    local charQuery = dbQuery(db, "SELECT COUNT(*) as count FROM characters WHERE LOWER(username) = ?", 
        string.lower(username))
    local charResult = dbPoll(charQuery, -1)
    
    if charResult and charResult[1] and tonumber(charResult[1].count) >= 3 then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "Ya tienes el máximo de personajes (3)")
        return
    end
    
    -- Verificar si el nombre ya existe para este usuario
    charQuery = dbQuery(db, "SELECT * FROM characters WHERE LOWER(username) = ? AND LOWER(name) = ? AND LOWER(surname) = ?", 
        string.lower(username), string.lower(name), string.lower(surname or ""))
    charResult = dbPoll(charQuery, -1)
    
    if charResult and #charResult > 0 then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "Ya tienes un personaje con ese nombre y apellido")
        return
    end
    
    -- Crear nuevo personaje con posición por defecto
    local time = getRealTime()
    local createdDate = string.format("%04d-%02d-%02d %02d:%02d:%02d", 
        time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
    
    local defaultX, defaultY, defaultZ = 1959.55, -1714.46, 10.0
    
    local success = dbExec(db, [[
        INSERT INTO characters (username, name, surname, age, gender, skin, money, created, posX, posY, posZ, rotation, interior, dimension) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], username, name, surname or "", age, tonumber(gender) or 0, tonumber(skin) or 0, 5000, createdDate,
        defaultX, defaultY, defaultZ, 0.0, 0, 0)
    
    if success then
        outputServerLog("[Login] Nuevo personaje creado: " .. name .. " " .. (surname or "") .. " para " .. username)
        
        -- Obtener el personaje recién creado
        charQuery = dbQuery(db, "SELECT * FROM characters WHERE LOWER(username) = ? AND LOWER(name) = ? AND LOWER(surname) = ? ORDER BY id DESC LIMIT 1", 
            string.lower(username), string.lower(name), string.lower(surname or ""))
        charResult = dbPoll(charQuery, -1)
        
        local newChar = nil
        if charResult and #charResult > 0 then
            local char = charResult[1]
            newChar = {
                id = char.id,
                name = char.name,
                surname = char.surname,
                age = tonumber(char.age),
                gender = tonumber(char.gender),
                skin = tonumber(char.skin),
                money = tonumber(char.money),
                created = char.created,
                posX = tonumber(char.posX) or defaultX,
                posY = tonumber(char.posY) or defaultY,
                posZ = tonumber(char.posZ) or defaultZ,
                rotation = tonumber(char.rotation) or 0.0,
                interior = tonumber(char.interior) or 0,
                dimension = tonumber(char.dimension) or 0
            }
        end
        
        triggerClientEvent(client, "onCharacterCreateResult", client, true, "Personaje creado exitosamente", newChar)
        
        -- Enviar lista actualizada de personajes
        charQuery = dbQuery(db, "SELECT * FROM characters WHERE LOWER(username) = ? ORDER BY id", 
            string.lower(username))
        charResult = dbPoll(charQuery, -1)
        
        local userCharacters = {}
        if charResult then
            for _, char in ipairs(charResult) do
                table.insert(userCharacters, {
                    id = char.id,
                    name = char.name,
                    surname = char.surname,
                    age = tonumber(char.age),
                    gender = tonumber(char.gender),
                    skin = tonumber(char.skin),
                    money = tonumber(char.money),
                    created = char.created,
                    posX = tonumber(char.posX) or defaultX,
                    posY = tonumber(char.posY) or defaultY,
                    posZ = tonumber(char.posZ) or defaultZ,
                    rotation = tonumber(char.rotation) or 0.0,
                    interior = tonumber(char.interior) or 0,
                    dimension = tonumber(char.dimension) or 0
                })
            end
        end
        
        triggerClientEvent(client, "onCharactersUpdated", client, userCharacters)
    else
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "Error al crear el personaje")
    end
end)

-- Seleccionar personaje y spawnear en última posición
addEventHandler("onPlayerSelectCharacter", root, function(charId)
    if not client then return end
    
    if not isPlayerLoggedIn(client) then
        return
    end
    
    local username = getElementData(client, "username")
    if not username then return end
    
    -- Buscar el personaje
    local query = dbQuery(db, "SELECT * FROM characters WHERE id = ? AND LOWER(username) = ?", 
        tonumber(charId), string.lower(username))
    local result = dbPoll(query, -1)
    
    if not result or #result == 0 then
        triggerClientEvent(client, "onCharacterSelectResult", client, false, "Personaje no encontrado")
        return
    end
    
    local selectedChar = result[1]
    
    -- Guardar datos del personaje seleccionado
    setElementData(client, "characterId", selectedChar.id)
    setElementData(client, "characterName", selectedChar.name)
    setElementData(client, "characterSurname", selectedChar.surname)
    setElementData(client, "characterAge", tonumber(selectedChar.age))
    setElementData(client, "characterGender", tonumber(selectedChar.gender))
    setElementData(client, "characterMoney", tonumber(selectedChar.money))
    setElementData(client, "characterSelected", true)
    
    -- Obtener posición guardada
    local posX = tonumber(selectedChar.posX) or 1959.55
    local posY = tonumber(selectedChar.posY) or -1714.46
    local posZ = tonumber(selectedChar.posZ) or 10.0
    local rotation = tonumber(selectedChar.rotation) or 0.0
    local interior = tonumber(selectedChar.interior) or 0
    local dimension = tonumber(selectedChar.dimension) or 0
    
    outputServerLog("[Login] Personaje seleccionado: " .. selectedChar.name .. " " .. selectedChar.surname .. " por " .. username)
    
    -- Actualizar último login
    local time = getRealTime()
    local lastLogin = string.format("%04d-%02d-%02d %02d:%02d:%02d", 
        time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
    dbExec(db, "UPDATE characters SET lastLogin = ? WHERE id = ?", lastLogin, selectedChar.id)
    
    -- Spawnear al jugador en su última posición
    -- Primero desactivar cámara, luego spawnear
    fadeCamera(client, false, 0)
    spawnPlayer(client, posX, posY, posZ, rotation, tonumber(selectedChar.skin))
    setElementInterior(client, interior)
    setElementDimension(client, dimension)
    
    -- Activar cámara después de un pequeño delay
    setTimer(function()
        setCameraTarget(client, client)
        fadeCamera(client, true, 1.0)
    end, 500, 1)
    
    triggerClientEvent(client, "onCharacterSelectResult", client, true, "Personaje seleccionado: " .. selectedChar.name .. " " .. selectedChar.surname)
    
    -- Dar dinero al jugador
    setPlayerMoney(client, tonumber(selectedChar.money))
end)

-- Guardar posición del jugador
addEventHandler("onPlayerSavePosition", root, function()
    if not client then return end
    
    if not isPlayerLoggedIn(client) or not getElementData(client, "characterSelected") then
        return
    end
    
    local charId = getElementData(client, "characterId")
    if not charId then return end
    
    local x, y, z = getElementPosition(client)
    local rotation = getPedRotation(client)
    local interior = getElementInterior(client)
    local dimension = getElementDimension(client)
    
    dbExec(db, [[
        UPDATE characters 
        SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ? 
        WHERE id = ?
    ]], x, y, z, rotation, interior, dimension, charId)
end)

-- Guardar posición periódicamente y al desconectarse
addEventHandler("onPlayerQuit", root, function()
    if isPlayerLoggedIn(source) and getElementData(source, "characterSelected") then
        local charId = getElementData(source, "characterId")
        if charId then
            local x, y, z = getElementPosition(source)
            local rotation = getPedRotation(source)
            local interior = getElementInterior(source)
            local dimension = getElementDimension(source)
            
            dbExec(db, [[
                UPDATE characters 
                SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ? 
                WHERE id = ?
            ]], x, y, z, rotation, interior, dimension, charId)
        end
    end
end)

-- Guardar posición cada 30 segundos para jugadores activos
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if isPlayerLoggedIn(player) and getElementData(player, "characterSelected") then
            local charId = getElementData(player, "characterId")
            if charId then
                local x, y, z = getElementPosition(player)
                local rotation = getPedRotation(player)
                local interior = getElementInterior(player)
                local dimension = getElementDimension(player)
                
                dbExec(db, [[
                    UPDATE characters 
                    SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ? 
                    WHERE id = ?
                ]], x, y, z, rotation, interior, dimension, charId)
            end
        end
    end
end, 30000, 0) -- Cada 30 segundos

-- Evento para solicitar personajes
addEventHandler("onRequestCharacters", root, function()
    if not client then return end
    
    if not isPlayerLoggedIn(client) then
        return
    end
    
    local username = getElementData(client, "username")
    if not username then return end
    
    local query = dbQuery(db, "SELECT * FROM characters WHERE LOWER(username) = ? ORDER BY id", 
        string.lower(username))
    local result = dbPoll(query, -1)
    
    local userCharacters = {}
    if result then
        for _, char in ipairs(result) do
            table.insert(userCharacters, {
                id = char.id,
                name = char.name,
                surname = char.surname,
                age = tonumber(char.age),
                gender = tonumber(char.gender),
                skin = tonumber(char.skin),
                money = tonumber(char.money),
                created = char.created,
                posX = tonumber(char.posX) or 1959.55,
                posY = tonumber(char.posY) or -1714.46,
                posZ = tonumber(char.posZ) or 10.0,
                rotation = tonumber(char.rotation) or 0.0,
                interior = tonumber(char.interior) or 0,
                dimension = tonumber(char.dimension) or 0
            })
        end
    end
    
    triggerClientEvent(client, "onCharactersUpdated", client, userCharacters)
end)

-- Comando changechar
addCommandHandler("changechar", function(player)
    if not isPlayerLoggedIn(player) then
        outputChatBox("Debes estar logueado para usar este comando", player, 255, 0, 0)
        return
    end
    
    -- Guardar posición actual antes de cambiar
    if getElementData(player, "characterSelected") then
        local charId = getElementData(player, "characterId")
        if charId then
            local x, y, z = getElementPosition(player)
            local rotation = getPedRotation(player)
            local interior = getElementInterior(player)
            local dimension = getElementDimension(player)
            
            dbExec(db, [[
                UPDATE characters 
                SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ? 
                WHERE id = ?
            ]], x, y, z, rotation, interior, dimension, charId)
        end
    end
    
    local username = getElementData(player, "username")
    if not username then return end
    
    local query = dbQuery(db, "SELECT * FROM characters WHERE LOWER(username) = ? ORDER BY id", 
        string.lower(username))
    local result = dbPoll(query, -1)
    
    local userCharacters = {}
    if result then
        for _, char in ipairs(result) do
            table.insert(userCharacters, {
                id = char.id,
                name = char.name,
                surname = char.surname,
                age = tonumber(char.age),
                gender = tonumber(char.gender),
                skin = tonumber(char.skin),
                money = tonumber(char.money),
                created = char.created,
                posX = tonumber(char.posX) or 1959.55,
                posY = tonumber(char.posY) or -1714.46,
                posZ = tonumber(char.posZ) or 10.0,
                rotation = tonumber(char.rotation) or 0.0,
                interior = tonumber(char.interior) or 0,
                dimension = tonumber(char.dimension) or 0
            })
        end
    end
    
    -- Enviar personajes al cliente para mostrar el panel
    triggerClientEvent(player, "onShowCharacterSelection", player, userCharacters)
end)

-- ==================== PREVENIR SPAWN ANTES DE LOGIN ====================
-- Cuando un jugador se conecta, asegurar que no spawnee hasta hacer login
addEventHandler("onPlayerJoin", root, function()
    -- Desactivar cámara y spawn automático
    fadeCamera(source, false)
    setCameraTarget(source, nil)
    
    -- Asegurar que el jugador no esté logueado al conectarse
    setElementData(source, "loggedIn", false)
    setElementData(source, "characterSelected", false)
    
    -- Enviar evento al cliente para mostrar login
    triggerClientEvent(source, "onPlayerMustLogin", source)
end)

-- Prevenir spawn automático del gamemode
addEventHandler("onPlayerSpawn", root, function()
    -- Si el jugador no ha seleccionado un personaje, cancelar el spawn
    if not getElementData(source, "characterSelected") then
        outputServerLog("[Login] Spawn cancelado para " .. getPlayerName(source) .. " - debe hacer login primero")
        fadeCamera(source, false)
        setCameraTarget(source, nil)
        -- No hacer nada más, el cliente mostrará el login
    end
end)

-- Cargar base de datos al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    if initDatabase() then
        outputServerLog("[Login] Sistema de autenticación iniciado (MySQL)")
        
        -- Para jugadores ya conectados, asegurar que no estén spawneados sin login
        for _, player in ipairs(getElementsByType("player")) do
            if not getElementData(player, "characterSelected") then
                fadeCamera(player, false)
                setCameraTarget(player, nil)
                triggerClientEvent(player, "onPlayerMustLogin", player)
            end
        end
    else
        outputServerLog("[Login] ERROR: No se pudo inicializar la base de datos")
    end
end)

-- Cerrar conexión al detener el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    -- Guardar posiciones de todos los jugadores antes de cerrar
    for _, player in ipairs(getElementsByType("player")) do
        if isPlayerLoggedIn(player) and getElementData(player, "characterSelected") then
            local charId = getElementData(player, "characterId")
            if charId then
                local x, y, z = getElementPosition(player)
                local rotation = getPedRotation(player)
                local interior = getElementInterior(player)
                local dimension = getElementDimension(player)
                
                dbExec(db, [[
                    UPDATE characters 
                    SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ? 
                    WHERE id = ?
                ]], x, y, z, rotation, interior, dimension, charId)
            end
        end
    end
    
    if db then
        dbClose(db)
        outputServerLog("[Login] Conexión a la base de datos cerrada")
    end
end)

-- Comando de administrador para ver usuarios
addCommandHandler("listusers", function(player)
    if not hasObjectPermissionTo(player, "command.kick", false) then
        outputChatBox("No tienes permisos para usar este comando", player)
        return
    end
    
    local query = dbQuery(db, "SELECT COUNT(*) as count FROM users")
    local result = dbPoll(query, -1)
    local count = result and result[1] and tonumber(result[1].count) or 0
    
    outputChatBox("=== USUARIOS REGISTRADOS ===", player, 255, 255, 0)
    outputChatBox("Total: " .. count, player, 255, 255, 0)
    
    query = dbQuery(db, "SELECT username, email FROM users LIMIT 20")
    result = dbPoll(query, -1)
    
    if result then
        for _, user in ipairs(result) do
            outputChatBox("- " .. user.username .. " (" .. user.email .. ")", player)
        end
    end
end)
