-- Sistema de Autenticación y Registro - Servidor (MySQL)
local db = nil

-- Contador para IDs de jugadores (se incrementa cada vez que un jugador se conecta)
local playerIDCounter = 0

-- ==================== CONFIGURACIÓN MySQL ====================
-- Configura estos valores según tu base de datos MySQL
local MYSQL_HOST = "127.0.0.1"      -- IP o hostname del servidor MySQL
local MYSQL_USER = "mta_user"           -- Usuario de MySQL
local MYSQL_PASS = "15306266_Mta"               -- Contraseña de MySQL
local MYSQL_DB = "mta_login"        -- Nombre de la base de datos
local MYSQL_PORT = 3306             -- Puerto de MySQL (default: 3306)

-- ==================== REGISTRAR EVENTOS PRIMERO ====================
-- Es CRÍTICO registrar los eventos ANTES de cualquier otra cosa
-- Estos eventos DEBEN estar al inicio del archivo para estar disponibles inmediatamente
addEvent("onPlayerRegister", true)
addEvent("onPlayerCustomLogin", true)  -- Renombrado para evitar conflicto con evento nativo onPlayerLogin de MTA
addEvent("onPlayerCreateCharacter", true)
addEvent("onPlayerSelectCharacter", true)
addEvent("onRequestCharacters", true)
addEvent("onPlayerSavePosition", true)
addEvent("onPlayerMoneyChanged", true)
addEvent("onRequestBogotaTime", true)

-- Verificar que los eventos estén registrados (esto se ejecuta cuando el script se carga)
-- Los eventos están disponibles inmediatamente después de addEvent

-- Evento para confirmar al cliente que el servidor está listo
addEvent("onLoginServerReady", true)

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
    
    -- Crear tabla de usuarios si no existe (con campo de rol)
    local query1 = dbQuery(db, [[
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(20) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            role VARCHAR(20) NOT NULL DEFAULT 'user',
            registerDate DATETIME NOT NULL,
            INDEX idx_username (username),
            INDEX idx_email (email),
            INDEX idx_role (role)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    if query1 then
        dbPoll(query1, -1)
        outputServerLog("[Login] Tabla 'users' verificada/creada")
        
        -- Verificar si la columna 'role' existe y agregarla si no existe
        -- MySQL no soporta IF NOT EXISTS en ALTER TABLE, así que verificamos primero
        local checkQuery = dbQuery(db, "SHOW COLUMNS FROM users LIKE 'role'")
        local checkResult = dbPoll(checkQuery, -1)
        
        if not checkResult or #checkResult == 0 then
            -- La columna no existe, agregarla
            dbExec(db, "ALTER TABLE users ADD COLUMN role VARCHAR(20) NOT NULL DEFAULT 'user'")
            outputServerLog("[Login] Columna 'role' agregada a la tabla 'users'")
            
            -- Agregar índice
            local indexQuery = dbQuery(db, "SHOW INDEX FROM users WHERE Key_name = 'idx_role'")
            local indexResult = dbPoll(indexQuery, -1)
            if not indexResult or #indexResult == 0 then
                dbExec(db, "ALTER TABLE users ADD INDEX idx_role (role)")
            end
        else
            outputServerLog("[Login] Columna 'role' ya existe en la tabla 'users'")
        end
        
        -- Actualizar usuarios existentes sin rol
        dbExec(db, "UPDATE users SET role = 'user' WHERE role IS NULL OR role = ''")
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
            hunger INT NOT NULL DEFAULT 100,
            thirst INT NOT NULL DEFAULT 100,
            health FLOAT DEFAULT 100.0,
            INDEX idx_username (username),
            INDEX idx_char_id (id),
            FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    if query2 then
        dbPoll(query2, -1)
        outputServerLog("[Login] Tabla 'characters' verificada/creada")
        
        -- Agregar columna de salud si no existe (para tablas existentes)
        local checkHealth = dbQuery(db, "SHOW COLUMNS FROM characters LIKE 'health'")
        local healthResult = dbPoll(checkHealth, -1)
        if not healthResult or #healthResult == 0 then
            dbExec(db, "ALTER TABLE characters ADD COLUMN health FLOAT DEFAULT 100.0")
            outputServerLog("[Login] Columna 'health' agregada a la tabla 'characters'")
        end
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
                    hunger INT NOT NULL DEFAULT 100,
                    thirst INT NOT NULL DEFAULT 100,
                    health FLOAT DEFAULT 100.0,
                    INDEX idx_username (username),
                    INDEX idx_char_id (id)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ]])
            if query3 then
                dbPoll(query3, -1)
                outputServerLog("[Login] Tabla 'characters' creada sin foreign key")
                
                -- Agregar columna de salud si no existe (por si acaso)
                local checkHealth2 = dbQuery(db, "SHOW COLUMNS FROM characters LIKE 'health'")
                local healthResult2 = dbPoll(checkHealth2, -1)
                if not healthResult2 or #healthResult2 == 0 then
                    dbExec(db, "ALTER TABLE characters ADD COLUMN health FLOAT DEFAULT 100.0")
                    outputServerLog("[Login] Columna 'health' agregada a la tabla 'characters' (fallback)")
                end
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
    
    -- Crear nuevo usuario (siempre como 'user' por defecto)
    local hashedPassword = hashPassword(password)
    local time = getRealTime()
    local registerDate = string.format("%04d-%02d-%02d %02d:%02d:%02d", 
        time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
    
    -- Todos los usuarios registrados son 'user' por defecto
    local defaultRole = "user"
    
    -- Usar dbQuery y dbPoll para obtener mejor información de errores
    local query = dbQuery(db, "INSERT INTO users (username, password, email, role, registerDate) VALUES (?, ?, ?, ?, ?)", 
        username, hashedPassword, email, defaultRole, registerDate)
    
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

-- Bloquear el comando de login nativo de MTA para forzar uso del panel personalizado
addCommandHandler("login", function(player, cmd, username, password)
    -- Cancelar el login nativo
    cancelEvent()
    
    -- Informar al jugador que debe usar el panel
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    outputChatBox("El comando /login está DESHABILITADO", player, 255, 0, 0)
    outputChatBox("Por favor usa el PANEL DE LOGIN que aparece en pantalla", player, 255, 255, 0)
    outputChatBox("Si no ves el panel, presiona F8 y escribe: /restart login", player, 255, 255, 0)
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    
    -- Asegurar que el panel esté visible
    triggerClientEvent(player, "onPlayerMustLogin", player)
end, true, false) -- true = bloquear, false = no restringir

-- Bloquear también el evento nativo de login de MTA
addEventHandler("onPlayerLogin", getRootElement(), function(previousAccount, currentAccount)
    -- Si el jugador no ha usado nuestro sistema personalizado, cancelar
    if not getElementData(source, "loggedIn") then
        cancelEvent()
        outputChatBox("Debes usar el panel de login personalizado, no el sistema nativo", source, 255, 0, 0)
        triggerClientEvent(source, "onPlayerMustLogin", source)
    end
end, true, "high")

-- Evento de login personalizado (del panel)
addEventHandler("onPlayerCustomLogin", root, function(username, password)
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
    
    -- Guardar rol del usuario (user, staff, admin)
    local userRole = userData.role or "user"
    setElementData(client, "userRole", userRole)
    
    outputServerLog("[Login] Usuario conectado: " .. userData.username .. " (Rol: " .. userRole .. ")")
    
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
        INSERT INTO characters (username, name, surname, age, gender, skin, money, created, posX, posY, posZ, rotation, interior, dimension, hunger, thirst) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], username, name, surname or "", age, tonumber(gender) or 0, tonumber(skin) or 0, 5000, createdDate,
        defaultX, defaultY, defaultZ, 0.0, 0, 0, 100, 100)
    
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
    setElementData(client, "characterHunger", tonumber(selectedChar.hunger) or 100)
    setElementData(client, "characterThirst", tonumber(selectedChar.thirst) or 100)
    setElementData(client, "characterSelected", true)
    
    -- Guardar el nombre original del jugador si no está guardado
    if not getElementData(client, "originalPlayerName") then
        setElementData(client, "originalPlayerName", getPlayerName(client))
    end
    
    -- Cambiar el nombre del jugador al nombre del personaje para que aparezca en el scoreboard (TAB)
    local characterFullName = selectedChar.name .. " " .. selectedChar.surname
    -- Limitar a 22 caracteres (límite de MTA para nombres de jugador)
    if string.len(characterFullName) > 22 then
        characterFullName = string.sub(characterFullName, 1, 22)
    end
    -- Reemplazar espacios con guiones bajos porque MTA no permite espacios en nombres
    characterFullName = string.gsub(characterFullName, " ", "_")
    setPlayerName(client, characterFullName)
    
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
    
    -- Obtener salud guardada
    local savedHealth = tonumber(selectedChar.health) or 100.0
    if savedHealth < 1 then savedHealth = 1 end  -- Mínimo 1 de salud
    if savedHealth > 100 then savedHealth = 100 end  -- Máximo 100 de salud
    
    -- Debug: verificar que la salud se está cargando correctamente
    outputServerLog("[Login] Cargando salud del personaje " .. selectedChar.name .. " " .. selectedChar.surname .. ": " .. tostring(savedHealth) .. " (raw: " .. tostring(selectedChar.health) .. ")")
    
    -- Spawnear al jugador en su última posición
    -- Primero desactivar cámara, luego spawnear
    fadeCamera(client, false, 0)
    spawnPlayer(client, posX, posY, posZ, rotation, tonumber(selectedChar.skin))
    setElementInterior(client, interior)
    setElementDimension(client, dimension)
    
    -- Restaurar salud guardada después de spawnear
    setTimer(function()
        if isElement(client) then
            setElementHealth(client, savedHealth)
            setElementData(client, "characterHealth", savedHealth)
        end
    end, 100, 1)
    
    -- Activar cámara después de un pequeño delay
    setTimer(function()
        if isElement(client) then
            setCameraTarget(client, client)
            fadeCamera(client, true, 1.0)
        end
    end, 500, 1)
    
    triggerClientEvent(client, "onCharacterSelectResult", client, true, "Personaje seleccionado: " .. selectedChar.name .. " " .. selectedChar.surname)
    
    -- Dar dinero al jugador
    setPlayerMoney(client, tonumber(selectedChar.money))
    
    -- Desactivar jetpack si lo tiene (solo para usuarios normales, admins pueden usarlo)
    if not isPlayerAdmin(client) then
        removePedJetPack(client)
    end
    
    -- Enviar el rol del jugador al cliente para que configure los controles apropiadamente
    local userRole = getPlayerRole(client)
    triggerClientEvent(client, "onPlayerRoleSet", client, userRole)
    
    -- Notificar al jugador sobre el cambio de nombre
    outputChatBox("Tu nombre ahora es: " .. selectedChar.name .. " " .. selectedChar.surname, client, 0, 255, 0)
    outputChatBox("Este nombre aparecerá en el scoreboard (TAB)", client, 255, 255, 255)
    
    -- Informar sobre permisos de vuelo
    if userRole == "admin" then
        outputChatBox("Tienes permisos de administrador - Puedes usar jetpack", client, 0, 255, 0)
    else
        outputChatBox("Vuelo deshabilitado - Solo administradores pueden volar", client, 255, 200, 0)
    end
end)

-- ==================== SISTEMA DE ROLES ====================
-- Funciones para verificar roles
function isPlayerAdmin(player)
    local role = getElementData(player, "userRole")
    return role == "admin"
end

function isPlayerStaff(player)
    local role = getElementData(player, "userRole")
    return role == "staff" or role == "admin"
end

function getPlayerRole(player)
    return getElementData(player, "userRole") or "user"
end

-- ==================== PREVENIR JETPACK Y VUELO TIPO SUPERMAN ====================
-- Monitorear y remover jetpack constantemente (solo para usuarios normales)
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) and getElementData(player, "characterSelected") then
            -- Solo prevenir vuelo si NO es admin
            if not isPlayerAdmin(player) then
                -- Remover jetpack si lo tiene
                if doesPedHaveJetPack(player) then
                    removePedJetPack(player)
                    outputChatBox("Jetpack desactivado - Solo disponible para administradores", player, 255, 0, 0)
                end
                
                -- Prevenir vuelo tipo superman (solo si está volando hacia arriba, NO interferir con caídas)
                if not isPedInVehicle(player) then
                    -- NO interferir si el jugador está en el agua (nadando)
                    if isElementInWater(player) then
                        -- Continuar al siguiente jugador sin hacer nada
                    else
                        local x, y, z = getElementPosition(player)
                        local velocityX, velocityY, velocityZ = getElementVelocity(player)
                        
                        -- Solo prevenir si está MUY alto (más de 15 unidades) Y está subiendo o flotando
                        -- NO interferir si está cayendo (velocityZ negativo = cayendo normalmente)
                        if z > 15.0 then
                            -- Solo prevenir si está subiendo (velocidad positiva) o flotando (velocidad casi 0)
                            -- Si está cayendo (velocityZ negativo), NO interferir para evitar daño extra
                            if velocityZ > 0.2 then
                                -- Está subiendo a gran altura = vuelo, forzar caída suave
                                setElementVelocity(player, velocityX, velocityY, 0) -- Detener ascenso, dejar que caiga naturalmente
                            elseif velocityZ > -0.1 and velocityZ < 0.1 and z > 20.0 then
                                -- Flotando a gran altura, iniciar caída suave
                                setElementVelocity(player, velocityX, velocityY, -0.1)
                            end
                            
                            -- Si está extremadamente alto, teletransportar hacia abajo
                            if z > 50.0 then
                                setElementPosition(player, x, y, z - 30.0)
                                outputChatBox("Vuelo deshabilitado - Solo administradores pueden volar", player, 255, 0, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end, 200, 0) -- Verificar cada 200ms (más frecuente para prevenir mejor)

-- Prevenir que los jugadores normales obtengan jetpack mediante comandos
addEventHandler("onPlayerCommand", root, function(command)
    if command == "jetpack" then
        if not isPlayerAdmin(source) then
            cancelEvent()
            outputChatBox("El comando /jetpack solo está disponible para administradores", source, 255, 0, 0)
            removePedJetPack(source) -- Asegurar que se quite inmediatamente
        end
    end
end)

-- Prevenir jetpack del gamemode freeroam (doble Shift)
addEventHandler("onPlayerWeaponSwitch", root, function(previousWeapon, currentWeapon)
    if not isPlayerAdmin(source) then
        if doesPedHaveJetPack(source) then
            removePedJetPack(source)
        end
    end
end)

-- Evento del cliente para verificar jetpack
addEvent("onClientCheckJetpack", true)
addEventHandler("onClientCheckJetpack", root, function()
    if not isPlayerAdmin(source) then
        if doesPedHaveJetPack(source) then
            removePedJetPack(source)
            outputChatBox("Jetpack desactivado - Solo disponible para administradores", source, 255, 0, 0)
        end
    end
end)

-- Nota: La restauración de skin y nombre se maneja en el handler de onPlayerSpawn con alta prioridad más abajo

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
    local playerMoney = getPlayerMoney(client)
    local playerHunger = getElementData(client, "characterHunger") or 100
    local playerThirst = getElementData(client, "characterThirst") or 100
    local playerHealth = getElementHealth(client)
    
    -- Debug: verificar que la salud se está obteniendo correctamente
    outputServerLog("[Login] Guardando salud del jugador " .. getPlayerName(client) .. ": " .. tostring(playerHealth))
    
    local success = dbExec(db, [[
        UPDATE characters 
        SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, money = ?, hunger = ?, thirst = ?, health = ? 
        WHERE id = ?
    ]], x, y, z, rotation, interior, dimension, playerMoney, playerHunger, playerThirst, playerHealth, charId)
    
    if not success then
        local errorMsg = dbError(db)
        outputServerLog("[Login] ERROR al guardar salud: " .. tostring(errorMsg))
    end
end)

-- Guardar dinero cuando cambia
addEventHandler("onPlayerMoneyChanged", root, function(newAmount)
    if not client then return end
    
    if not isPlayerLoggedIn(client) or not getElementData(client, "characterSelected") then
        return
    end
    
    local charId = getElementData(client, "characterId")
    if not charId then return end
    
    -- Guardar dinero en la base de datos
    dbExec(db, "UPDATE characters SET money = ? WHERE id = ?", newAmount, charId)
    
    -- Actualizar elementData
    setElementData(client, "characterMoney", newAmount)
end)

-- Guardar posición y dinero al desconectarse
addEventHandler("onPlayerQuit", root, function()
    -- Restaurar nombre original antes de desconectarse
    local originalName = getElementData(source, "originalPlayerName")
    if originalName then
        setPlayerName(source, originalName)
    end
    
    if isPlayerLoggedIn(source) and getElementData(source, "characterSelected") then
        local charId = getElementData(source, "characterId")
        if charId then
            local x, y, z = getElementPosition(source)
            local rotation = getPedRotation(source)
            local interior = getElementInterior(source)
            local dimension = getElementDimension(source)
            local playerMoney = getPlayerMoney(source)
            local playerHunger = getElementData(source, "characterHunger") or 100
            local playerThirst = getElementData(source, "characterThirst") or 100
            local playerHealth = getElementHealth(source)
            
            dbExec(db, [[
                UPDATE characters 
                SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, money = ?, hunger = ?, thirst = ?, health = ? 
                WHERE id = ?
            ]], x, y, z, rotation, interior, dimension, playerMoney, playerHunger, playerThirst, playerHealth, charId)
        end
    end
end)

-- Guardar posición y dinero cada 30 segundos para jugadores activos
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if isPlayerLoggedIn(player) and getElementData(player, "characterSelected") then
            local charId = getElementData(player, "characterId")
            if charId then
                local x, y, z = getElementPosition(player)
                local rotation = getPedRotation(player)
                local interior = getElementInterior(player)
                local dimension = getElementDimension(player)
                local playerMoney = getPlayerMoney(player)
                local playerHunger = getElementData(player, "characterHunger") or 100
                local playerThirst = getElementData(player, "characterThirst") or 100
                local playerHealth = getElementHealth(player)
                
                dbExec(db, [[
                    UPDATE characters 
                    SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, money = ?, hunger = ?, thirst = ?, health = ? 
                    WHERE id = ?
                ]], x, y, z, rotation, interior, dimension, playerMoney, playerHunger, playerThirst, playerHealth, charId)
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
        
        -- Restaurar nombre original antes de cambiar de personaje
        local originalName = getElementData(player, "originalPlayerName")
        if originalName then
            setPlayerName(player, originalName)
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
    -- Asegurar que el jugador no esté logueado al conectarse
    setElementData(source, "loggedIn", false)
    setElementData(source, "characterSelected", false)
    
    -- Guardar ID del jugador (usando un contador incremental)
    playerIDCounter = playerIDCounter + 1
    setElementData(source, "playerID", playerIDCounter)
    
    -- Desactivar cámara inmediatamente
    fadeCamera(source, false, 0)
    setCameraTarget(source, nil)
    
    -- Ocultar el mensaje de "has joined the game" enviando un mensaje vacío
    -- Esto sobrescribe el mensaje del sistema
    setTimer(function()
        if isElement(source) then
            -- Enviar mensaje personalizado en lugar del mensaje del sistema
            outputChatBox(" ", source, 0, 0, 0, true) -- Mensaje invisible
            outputChatBox("═══════════════════════════════════════", source, 0, 150, 255)
            outputChatBox("Bienvenido a Colombia RP", source, 0, 150, 255)
            outputChatBox("Por favor inicia sesión para continuar", source, 255, 255, 255)
            outputChatBox("═══════════════════════════════════════", source, 0, 150, 255)
        end
    end, 100, 1)
    
    -- Notificar al cliente que el servidor está listo (si la BD está inicializada)
    if db then
        triggerClientEvent(source, "onLoginServerReady", source)
    end
    
    -- Prevenir cualquier spawn automático
    setTimer(function()
        -- Verificar si el jugador spawneó sin autorización
        if isElement(source) and not getElementData(source, "characterSelected") then
            -- Si el jugador está spawneado, eliminarlo
            if isPedDead(source) == false then
                killPed(source)
            end
            fadeCamera(source, false, 0)
            setCameraTarget(source, nil)
        end
        
        -- Enviar evento al cliente para mostrar login
        if isElement(source) then
            triggerClientEvent(source, "onPlayerMustLogin", source)
        end
    end, 100, 1) -- Ejecutar muy rápido para interceptar el spawn
end)

-- Prevenir spawn automático del gamemode - usar alta prioridad
addEventHandler("onPlayerSpawn", root, function(spawnpoint)
    -- Si el jugador no ha seleccionado un personaje, cancelar el spawn
    if not getElementData(source, "characterSelected") then
        outputServerLog("[Login] Spawn bloqueado para " .. getPlayerName(source) .. " - debe hacer login primero")
        
        -- Cancelar el spawn
        cancelEvent()
        
        -- Asegurar que la cámara esté desactivada
        fadeCamera(source, false, 0)
        setCameraTarget(source, nil)
        
        -- Eliminar al jugador si ya spawneó
        setTimer(function()
            if isElement(source) and not getElementData(source, "characterSelected") then
                if isPedDead(source) == false then
                    killPed(source)
                end
                fadeCamera(source, false, 0)
                setCameraTarget(source, nil)
            end
        end, 50, 1)
        return
    end
    
    -- Si el jugador tiene un personaje seleccionado, restaurar skin y nombre
    -- (Este código se ejecuta después de verificar que tiene personaje)
    local charId = getElementData(source, "characterId")
    if charId then
        -- Restaurar skin y salud del personaje desde la base de datos
        local query = dbQuery(db, "SELECT skin, health FROM characters WHERE id = ?", charId)
        local result = dbPoll(query, -1)
        if result and #result > 0 then
            local skin = tonumber(result[1].skin) or 0
            local savedHealth = tonumber(result[1].health) or 100.0
            if savedHealth < 1 then savedHealth = 1 end
            if savedHealth > 100 then savedHealth = 100 end
            
            setTimer(function()
                if isElement(source) then
                    setElementModel(source, skin)
                    setElementHealth(source, savedHealth)
                    setElementData(source, "characterHealth", savedHealth)
                end
            end, 100, 1)
        end
        
        -- Restaurar nombre del personaje en el scoreboard (TAB)
        local characterName = getElementData(source, "characterName")
        local characterSurname = getElementData(source, "characterSurname")
        if characterName and characterSurname then
            local characterFullName = characterName .. " " .. characterSurname
            -- Limitar a 22 caracteres (límite de MTA para nombres de jugador)
            if string.len(characterFullName) > 22 then
                characterFullName = string.sub(characterFullName, 1, 22)
            end
            -- Reemplazar espacios con guiones bajos porque MTA no permite espacios en nombres
            characterFullName = string.gsub(characterFullName, " ", "_")
            setPlayerName(source, characterFullName)
        end
        
        -- Remover jetpack si no es admin
        setTimer(function()
            if isElement(source) and not isPlayerAdmin(source) then
                removePedJetPack(source)
            end
        end, 100, 1)
    end
end, true, "high") -- Alta prioridad para ejecutar antes que otros handlers

-- ==================== SISTEMA DE RESPAWN AL MORIR ====================
addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
    -- Solo procesar si el jugador tiene un personaje seleccionado
    if not getElementData(source, "characterSelected") then
        return
    end
    
    local charId = getElementData(source, "characterId")
    if not charId then return end
    
    -- Obtener posición guardada del personaje
    local query = dbQuery(db, "SELECT posX, posY, posZ, rotation, interior, dimension, skin, health FROM characters WHERE id = ?", charId)
    local result = dbPoll(query, -1)
    
    if result and #result > 0 then
        local char = result[1]
        local posX = tonumber(char.posX) or 1959.55
        local posY = tonumber(char.posY) or -1714.46
        local posZ = tonumber(char.posZ) or 10.0
        local rotation = tonumber(char.rotation) or 0.0
        local interior = tonumber(char.interior) or 0
        local dimension = tonumber(char.dimension) or 0
        local skin = tonumber(char.skin) or 0
        local savedHealth = tonumber(char.health) or 100.0
        if savedHealth < 1 then savedHealth = 1 end
        if savedHealth > 100 then savedHealth = 100 end
        
        -- Si la posición guardada está bajo el agua (z < 0.5), usar posición por defecto
        if posZ < 0.5 then
            posX = 1959.55
            posY = -1714.46
            posZ = 10.0
            rotation = 0.0
            outputChatBox("⚠ Has respawneado en una posición segura (tu última posición estaba bajo el agua)", source, 255, 165, 0)
        end
        
        -- Respawnear después de un pequeño delay
        setTimer(function()
            if isElement(source) and getElementData(source, "characterSelected") then
                -- Desactivar cámara de muerte primero
                fadeCamera(source, false, 0)
                setCameraTarget(source, nil)
                
                -- Usar spawnPlayer para revivir al jugador correctamente
                spawnPlayer(source, posX, posY, posZ, rotation, skin)
                setElementInterior(source, interior)
                setElementDimension(source, dimension)
                
                -- Restaurar datos después de spawnear
                setTimer(function()
                    if isElement(source) and getElementData(source, "characterSelected") then
                        -- Restaurar salud
                        setElementHealth(source, savedHealth)
                        setElementData(source, "characterHealth", savedHealth)
                        
                        -- Restaurar nombre del personaje
                        local characterName = getElementData(source, "characterName")
                        local characterSurname = getElementData(source, "characterSurname")
                        if characterName and characterSurname then
                            local characterFullName = characterName .. " " .. characterSurname
                            if string.len(characterFullName) > 22 then
                                characterFullName = string.sub(characterFullName, 1, 22)
                            end
                            characterFullName = string.gsub(characterFullName, " ", "_")
                            setPlayerName(source, characterFullName)
                        end
                        
                        -- Activar cámara correctamente
                        setTimer(function()
                            if isElement(source) then
                                setCameraTarget(source, source)
                                fadeCamera(source, true, 1.5)
                            end
                        end, 100, 1)
                    end
                end, 500, 1)
            end
        end, 2000, 1) -- Esperar 2 segundos antes de respawnear
    end
end)

-- ==================== SISTEMA PARA SALIR DEL AGUA ====================
-- Comando para teletransportarse fuera del agua si está atrapado
addCommandHandler("salir", function(player)
    if not getElementData(player, "characterSelected") then
        return
    end
    
    local x, y, z = getElementPosition(player)
    local isUnderwater = isElementInWater(player) or (z < 0.5)
    
    if isUnderwater then
        -- Buscar la posición guardada del personaje
        local charId = getElementData(player, "characterId")
        if charId then
            local query = dbQuery(db, "SELECT posX, posY, posZ, rotation, interior, dimension FROM characters WHERE id = ?", charId)
            local result = dbPoll(query, -1)
            
            if result and #result > 0 then
                local char = result[1]
                local posX = tonumber(char.posX) or 1959.55
                local posY = tonumber(char.posY) or -1714.46
                local posZ = tonumber(char.posZ) or 10.0
                local rotation = tonumber(char.rotation) or 0.0
                local interior = tonumber(char.interior) or 0
                local dimension = tonumber(char.dimension) or 0
                
                -- Si la posición guardada también está bajo el agua, usar posición por defecto
                if posZ < 0.5 then
                    posX = 1959.55
                    posY = -1714.46
                    posZ = 10.0
                    rotation = 0.0
                end
                
                -- Teletransportar al jugador
                setElementPosition(player, posX, posY, posZ)
                setElementRotation(player, 0, 0, rotation)
                setElementInterior(player, interior)
                setElementDimension(player, dimension)
                
                outputChatBox("✓ Te has teletransportado fuera del agua", player, 0, 255, 0)
            else
                -- Si no hay posición guardada, usar posición por defecto
                setElementPosition(player, 1959.55, -1714.46, 10.0)
                setElementRotation(player, 0, 0, 0)
                outputChatBox("✓ Te has teletransportado a una posición segura", player, 0, 255, 0)
            end
        else
            -- Si no hay charId, usar posición por defecto
            setElementPosition(player, 1959.55, -1714.46, 10.0)
            setElementRotation(player, 0, 0, 0)
            outputChatBox("✓ Te has teletransportado a una posición segura", player, 0, 255, 0)
        end
    else
        outputChatBox("No estás bajo el agua. Usa /salir solo si estás atrapado en el agua.", player, 255, 165, 0)
    end
end)

-- ==================== SISTEMA DE TIEMPO DEL JUEGO (BOGOTÁ, COLOMBIA) ====================
-- Función para obtener hora de Bogotá (UTC-5) correctamente
function getBogotaTime()
    local time = getRealTime()
    
    -- getRealTime() devuelve la hora local del servidor
    -- Para obtener UTC, necesitamos saber el offset del servidor
    -- Como no lo sabemos directamente, vamos a usar un método que funcione
    
    -- Método 1: Intentar usar os.time() y os.date() para obtener UTC
    local success, utcTime = pcall(function()
        local timestamp = os.time()
        return os.date("!*t", timestamp)  -- ! significa UTC
    end)
    
    local utcHour, utcMinute, utcSecond
    if success and utcTime then
        utcHour = utcTime.hour
        utcMinute = utcTime.min
        utcSecond = utcTime.sec
    else
        -- Método 2: Si os.date no funciona, asumir que getRealTime() devuelve UTC
        -- (común en servidores Linux configurados en UTC)
        utcHour = time.hour
        utcMinute = time.minute
        utcSecond = time.second
        
        -- Si esto muestra hora incorrecta, el servidor NO está en UTC
        -- En ese caso, necesitamos ajustar manualmente
        -- Si el servidor muestra 9:56 y Colombia es 14:57, entonces:
        -- - El servidor está 5 horas atrás de Colombia
        -- - Si Colombia es UTC-5, entonces el servidor está en UTC-10 o similar
        -- - O el servidor está en otra zona horaria
        
        -- Por ahora, asumimos UTC y convertimos a Bogotá
    end
    
    -- Convertir UTC a hora de Bogotá (UTC-5)
    local bogotaHour = utcHour - 5
    if bogotaHour < 0 then
        bogotaHour = bogotaHour + 24
    end
    
    return bogotaHour, utcMinute, utcSecond, time.monthday, time.month + 1, time.year + 1900
end

-- Función para sincronizar el tiempo del juego con la hora de Bogotá
function syncGameTime()
    local hour, minute = getBogotaTime()
    setTime(hour, minute)
    setMinuteDuration(60000)  -- 1 minuto real = 1 minuto en el juego (tiempo real)
end

-- Evento para enviar hora de Bogotá a los clientes
addEvent("onRequestBogotaTime", true)
addEventHandler("onRequestBogotaTime", root, function()
    if not client then return end
    local hour, minute, second, day, month, year = getBogotaTime()
    triggerClientEvent(client, "onBogotaTimeReceived", client, hour, minute, second, day, month, year)
end)

-- Enviar hora a todos los clientes cada segundo
setTimer(function()
    local hour, minute, second, day, month, year = getBogotaTime()
    -- Asegurar que los valores sean válidos
    hour = tonumber(hour) or 0
    minute = tonumber(minute) or 0
    second = tonumber(second) or 0
    day = tonumber(day) or 1
    month = tonumber(month) or 1
    year = tonumber(year) or 2024
    
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) then
            triggerClientEvent(player, "onBogotaTimeReceived", player, hour, minute, second, day, month, year)
        end
    end
end, 1000, 0)  -- Cada segundo

-- Sincronizar tiempo cada minuto
setTimer(function()
    syncGameTime()
end, 60000, 0)  -- Cada 60 segundos (1 minuto)

-- Sincronizar tiempo al iniciar el recurso
syncGameTime()

-- ==================== SISTEMA DE HAMBRE Y SED ====================
-- Decrementar hambre y sed cada minuto para jugadores activos
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if isPlayerLoggedIn(player) and getElementData(player, "characterSelected") then
            local currentHunger = getElementData(player, "characterHunger") or 100
            local currentThirst = getElementData(player, "characterThirst") or 100
            
            -- Decrementar hambre (1 punto por minuto, mínimo 0)
            local newHunger = math.max(0, currentHunger - 1)
            setElementData(player, "characterHunger", newHunger)
            
            -- Decrementar sed (1.5 puntos por minuto, mínimo 0) - la sed baja más rápido
            local newThirst = math.max(0, currentThirst - 1.5)
            setElementData(player, "characterThirst", math.floor(newThirst))
            
            -- Si hambre o sed están muy bajos, reducir salud gradualmente
            if newHunger <= 0 or newThirst <= 0 then
                local currentHealth = getElementHealth(player)
                if currentHealth > 0 then
                    -- Reducir 1 punto de salud cada 10 segundos si está sin comida/agua
                    setElementHealth(player, math.max(1, currentHealth - 1))
                end
            end
            
            -- Si hambre o sed están bajos (menos de 20), mostrar advertencia
            if newHunger < 20 or newThirst < 20 then
                if newHunger < 20 then
                    outputChatBox("⚠ Tienes hambre - Busca comida", player, 255, 165, 0)
                end
                if newThirst < 20 then
                    outputChatBox("⚠ Tienes sed - Busca agua", player, 0, 150, 255)
                end
            end
        end
    end
end, 60000, 0)  -- Cada 60 segundos (1 minuto)

-- Cargar base de datos al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    -- IMPORTANTE: Los eventos ya están registrados al inicio del archivo (líneas 15-20)
    -- Por lo tanto están disponibles inmediatamente cuando el recurso inicia
    
    outputServerLog("[Login] Recurso iniciado - eventos disponibles inmediatamente")
    
    -- Sincronizar tiempo del juego con Bogotá
    syncGameTime()
    outputServerLog("[Login] Tiempo del juego sincronizado con hora de Bogotá, Colombia (UTC-5)")
    
    if initDatabase() then
        outputServerLog("[Login] Sistema de autenticación iniciado (MySQL)")
        
        -- Notificar a todos los clientes que el servidor está listo
        setTimer(function()
            for _, player in ipairs(getElementsByType("player")) do
                -- Confirmar que el servidor está listo
                triggerClientEvent(player, "onLoginServerReady", player)
                
                if not getElementData(player, "characterSelected") then
                    fadeCamera(player, false)
                    setCameraTarget(player, nil)
                    triggerClientEvent(player, "onPlayerMustLogin", player)
                end
            end
        end, 100, 1) -- Delay muy corto para notificar rápidamente
    else
        outputServerLog("[Login] ERROR: No se pudo inicializar la base de datos")
    end
end)

-- ==================== SISTEMA DE LISTA DE VEHÍCULOS ====================
-- Función para obtener el nombre del modelo del vehículo
function getVehicleNameFromModel(model)
    local vehicleNames = {
        [400] = "Landstalker", [401] = "Bravura", [402] = "Buffalo", [403] = "Linerunner",
        [404] = "Perennial", [405] = "Sentinel", [406] = "Dumper", [407] = "Firetruck",
        [408] = "Trashmaster", [409] = "Stretch", [410] = "Manana", [411] = "Infernus",
        [412] = "Voodoo", [413] = "Pony", [414] = "Mule", [415] = "Cheetah",
        [416] = "Ambulance", [417] = "Leviathan", [418] = "Moonbeam", [419] = "Esperanto",
        [420] = "Taxi", [421] = "Washington", [422] = "Bobcat", [423] = "Mr Whoopee",
        [424] = "BF Injection", [425] = "Hunter", [426] = "Premier", [427] = "Enforcer",
        [428] = "Securicar", [429] = "Banshee", [430] = "Predator", [431] = "Bus",
        [432] = "Rhino", [433] = "Barracks", [434] = "Hotknife", [435] = "Trailer",
        [436] = "Previon", [437] = "Coach", [438] = "Cabbie", [439] = "Stallion",
        [440] = "Rumpo", [441] = "RC Bandit", [442] = "Romero", [443] = "Packer",
        [444] = "Monster", [445] = "Admiral", [446] = "Squalo", [447] = "Seasparrow",
        [448] = "Pizzaboy", [449] = "Tram", [450] = "Trailer", [451] = "Turismo",
        [452] = "Speeder", [453] = "Reefer", [454] = "Tropic", [455] = "Flatbed",
        [456] = "Yankee", [457] = "Caddy", [458] = "Solair", [459] = "Berkley's RC Van",
        [460] = "Skimmer", [461] = "PCJ-600", [462] = "Faggio", [463] = "Freeway",
        [464] = "RC Baron", [465] = "RC Raider", [466] = "Glendale", [467] = "Oceanic",
        [468] = "Sanchez", [469] = "Sparrow", [470] = "Patriot", [471] = "Quad",
        [472] = "Coastguard", [473] = "Dinghy", [474] = "Hermes", [475] = "Sabre",
        [476] = "Rustler", [477] = "ZR-350", [478] = "Walton", [479] = "Regina",
        [480] = "Comet", [481] = "BMX", [482] = "Burrito", [483] = "Camper",
        [484] = "Marquis", [485] = "Baggage", [486] = "Dozer", [487] = "Maverick",
        [488] = "News Chopper", [489] = "Rancher", [490] = "FBI Rancher", [491] = "Virgo",
        [492] = "Greenwood", [493] = "Jetmax", [494] = "Hotring", [495] = "Sandking",
        [496] = "Blista Compact", [497] = "Police Maverick", [498] = "Boxville", [499] = "Benson",
        [500] = "Mesa", [501] = "RC Goblin", [502] = "Hotring Racer A", [503] = "Hotring Racer B",
        [504] = "Bloodring Banger", [505] = "Rancher", [506] = "Super GT", [507] = "Elegant",
        [508] = "Journey", [509] = "Bike", [510] = "Mountain Bike", [511] = "Beagle",
        [512] = "Cropduster", [513] = "Stunt", [514] = "Tanker", [515] = "Roadtrain",
        [516] = "Nebula", [517] = "Majestic", [518] = "Buccaneer", [519] = "Shamal",
        [520] = "Hydra", [521] = "FCR-900", [522] = "NRG-500", [523] = "HPV1000",
        [524] = "Cement Truck", [525] = "Tow Truck", [526] = "Fortune", [527] = "Cadrona",
        [528] = "FBI Truck", [529] = "Willard", [530] = "Forklift", [531] = "Tractor",
        [532] = "Combine", [533] = "Feltzer", [534] = "Remington", [535] = "Slamvan",
        [536] = "Blade", [537] = "Freight", [538] = "Streak", [539] = "Vortex",
        [540] = "Vincent", [541] = "Bullet", [542] = "Clover", [543] = "Sadler",
        [544] = "Firetruck LA", [545] = "Hustler", [546] = "Intruder", [547] = "Primo",
        [548] = "Cargobob", [549] = "Tampa", [550] = "Sunrise", [551] = "Merit",
        [552] = "Utility", [553] = "Nevada", [554] = "Yosemite", [555] = "Windsor",
        [556] = "Monster A", [557] = "Monster B", [558] = "Uranus", [559] = "Jester",
        [560] = "Sultan", [561] = "Stratum", [562] = "Elegy", [563] = "Raindance",
        [564] = "RC Tiger", [565] = "Flash", [566] = "Tahoma", [567] = "Savanna",
        [568] = "Bandito", [569] = "Freight Flat", [570] = "Streak Car", [571] = "Kart",
        [572] = "Mower", [573] = "Dune", [574] = "Sweeper", [575] = "Broadway",
        [576] = "Tornado", [577] = "AT-400", [578] = "DFT-30", [579] = "Huntley",
        [580] = "Stafford", [581] = "BF-400", [582] = "News Van", [583] = "Tug",
        [584] = "Petrol Trailer", [585] = "Emperor", [586] = "Wayfarer", [587] = "Euros",
        [588] = "Hotdog", [589] = "Club", [590] = "Freight Box", [591] = "Article Trailer",
        [592] = "Andromada", [593] = "Dodo", [594] = "RC Cam", [595] = "Launch",
        [596] = "Police Car (LSPD)", [597] = "Police Car (SFPD)", [598] = "Police Car (LVPD)",
        [599] = "Police Ranger", [600] = "Picador", [601] = "SWAT Tank", [602] = "Alpha",
        [603] = "Phoenix", [604] = "Glendale", [605] = "Sadler", [606] = "Luggage Trailer A",
        [607] = "Luggage Trailer B", [608] = "Stair Trailer", [609] = "Boxville", [610] = "Farm Plow",
        [611] = "Utility Trailer"
    }
    return vehicleNames[model] or "Vehículo " .. model
end

-- Evento para solicitar lista de vehículos (solo para admins)
addEvent("onRequestVehicleList", true)
addEventHandler("onRequestVehicleList", root, function()
    if not client then return end
    
    if not isPlayerLoggedIn(client) or not getElementData(client, "characterSelected") then
        outputChatBox("Debes estar logueado para usar este comando", client, 255, 0, 0)
        return
    end
    
    -- Verificar si es administrador
    if not isPlayerAdmin(client) then
        outputChatBox("Este comando solo está disponible para administradores", client, 255, 0, 0)
        return
    end
    
    -- Enviar confirmación al cliente para abrir el panel (el cliente generará la lista de modelos)
    triggerClientEvent(client, "onVehicleListReceived", client)
    outputChatBox("Panel de creación de vehículos abierto", client, 0, 255, 0)
end)

-- Evento para generar vehículo (solo para admins)
addEvent("onRequestSpawnVehicle", true)
addEventHandler("onRequestSpawnVehicle", root, function(vehicleModel)
    if not client then return end
    
    if not isPlayerLoggedIn(client) or not getElementData(client, "characterSelected") then
        triggerClientEvent(client, "onVehicleSpawned", client, false, "Debes estar logueado para usar este comando")
        return
    end
    
    -- Verificar si es administrador
    if not isPlayerAdmin(client) then
        triggerClientEvent(client, "onVehicleSpawned", client, false, "Este comando solo está disponible para administradores")
        return
    end
    
    -- Validar modelo de vehículo
    vehicleModel = tonumber(vehicleModel)
    if not vehicleModel or vehicleModel < 400 or vehicleModel > 611 then
        triggerClientEvent(client, "onVehicleSpawned", client, false, "Modelo de vehículo inválido")
        return
    end
    
    -- Obtener posición del jugador
    local x, y, z = getElementPosition(client)
    local rotation = getPedRotation(client)
    
    -- Calcular posición delante del jugador (a 3 metros de distancia)
    local distance = 3.0
    local radians = math.rad(rotation)
    local spawnX = x + (math.sin(radians) * distance)
    local spawnY = y - (math.cos(radians) * distance)
    local spawnZ = z
    
    -- Obtener altura del suelo en la posición de spawn usando processLineOfSight
    local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(spawnX, spawnY, spawnZ + 10, spawnX, spawnY, spawnZ - 50)
    if hit and hitZ then
        spawnZ = hitZ + 0.5
    else
        -- Si no se detecta suelo, usar la posición Z del jugador con un pequeño offset
        spawnZ = z + 0.5
    end
    
    -- Crear el vehículo
    local vehicle = createVehicle(vehicleModel, spawnX, spawnY, spawnZ, 0, 0, rotation)
    
    if vehicle then
        local vehicleName = getVehicleNameFromModel(vehicleModel)
        setElementFrozen(vehicle, false)
        setVehicleEngineState(vehicle, false)
        
        -- Guardar información del vehículo en elementData
        setElementData(vehicle, "spawnedBy", getPlayerName(client))
        local time = getRealTime()
        local timestamp = time.year + 1900 .. "-" .. (time.month + 1) .. "-" .. time.monthday .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second
        setElementData(vehicle, "spawnTime", timestamp)
        
        triggerClientEvent(client, "onVehicleSpawned", client, true, "Vehículo " .. vehicleName .. " (Modelo: " .. vehicleModel .. ") generado exitosamente")
        outputChatBox("Vehículo " .. vehicleName .. " generado a tu lado", client, 0, 255, 0)
    else
        triggerClientEvent(client, "onVehicleSpawned", client, false, "Error al crear el vehículo")
    end
end)

-- Cerrar conexión al detener el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    -- Guardar posiciones y dinero de todos los jugadores antes de cerrar
    for _, player in ipairs(getElementsByType("player")) do
        if isPlayerLoggedIn(player) and getElementData(player, "characterSelected") then
            local charId = getElementData(player, "characterId")
            if charId and db then
                local x, y, z = getElementPosition(player)
                local rotation = getPedRotation(player)
                local interior = getElementInterior(player)
                local dimension = getElementDimension(player)
                local playerMoney = getPlayerMoney(player)
                local playerHunger = getElementData(player, "characterHunger") or 100
                local playerThirst = getElementData(player, "characterThirst") or 100
                local playerHealth = getElementHealth(player)
                
                dbExec(db, [[
                    UPDATE characters 
                    SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, money = ?, hunger = ?, thirst = ?, health = ? 
                    WHERE id = ?
                ]], x, y, z, rotation, interior, dimension, playerMoney, playerHunger, playerThirst, playerHealth, charId)
            end
        end
        
        -- LIMPIAR ESTADO DE LOGIN de todos los jugadores al reiniciar el recurso
        -- Esto permite que puedan volver a iniciar sesión después del restart
        setElementData(player, "loggedIn", false)
        setElementData(player, "characterSelected", false)
        setElementData(player, "username", nil)
        setElementData(player, "characterId", nil)
        setElementData(player, "characterName", nil)
        setElementData(player, "characterSurname", nil)
        
        -- Restaurar nombre original si existe
        local originalName = getElementData(player, "originalPlayerName")
        if originalName then
            setPlayerName(player, originalName)
        end
        
        -- Desactivar cámara y forzar que vuelvan a hacer login
        fadeCamera(player, false, 0)
        setCameraTarget(player, nil)
        
        -- Notificar al cliente que debe volver a iniciar sesión
        triggerClientEvent(player, "onPlayerMustLogin", player)
    end
    
    outputServerLog("[Login] Recurso detenido - Todas las sesiones cerradas")
    
    -- La conexión a la base de datos se cierra automáticamente cuando el recurso se detiene
    -- No es necesario cerrarla manualmente en MTA
end)

-- ==================== COMANDOS DE ADMINISTRACIÓN ====================
-- Comando para asignar roles (solo admins)
addCommandHandler("setrole", function(player, cmd, targetUsername, newRole)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not targetUsername or not newRole then
        outputChatBox("Uso: /setrole [usuario] [user|staff|admin]", player, 255, 255, 0)
        return
    end
    
    -- Validar rol
    newRole = string.lower(newRole)
    if newRole ~= "user" and newRole ~= "staff" and newRole ~= "admin" then
        outputChatBox("Roles válidos: user, staff, admin", player, 255, 0, 0)
        return
    end
    
    -- Actualizar rol en la base de datos
    local query = dbQuery(db, "UPDATE users SET role = ? WHERE LOWER(username) = ?", 
        newRole, string.lower(targetUsername))
    local result = dbPoll(query, -1)
    
    if result then
        outputChatBox("Rol de " .. targetUsername .. " actualizado a: " .. newRole, player, 0, 255, 0)
        
        -- Si el jugador está conectado, actualizar su rol en tiempo real
        for _, p in ipairs(getElementsByType("player")) do
            local username = getElementData(p, "username")
            if username and string.lower(username) == string.lower(targetUsername) then
                setElementData(p, "userRole", newRole)
                outputChatBox("Tu rol ha sido actualizado a: " .. newRole, p, 0, 255, 0)
                
                -- Si cambió a admin, permitir jetpack
                if newRole == "admin" then
                    outputChatBox("Ahora tienes acceso al modo admin (jetpack disponible)", p, 0, 255, 255)
                else
                    -- Si dejó de ser admin, quitar jetpack
                    removePedJetPack(p)
                    outputChatBox("Modo admin desactivado", p, 255, 255, 0)
                end
            end
        end
    else
        outputChatBox("Error al actualizar el rol. Usuario no encontrado.", player, 255, 0, 0)
    end
end)

-- Comando para ver tu rol
addCommandHandler("myrole", function(player)
    local role = getPlayerRole(player)
    local roleColor = {255, 255, 255}
    if role == "admin" then
        roleColor = {255, 0, 0}
    elseif role == "staff" then
        roleColor = {0, 255, 255}
    end
    
    outputChatBox("Tu rol actual: " .. role, player, roleColor[1], roleColor[2], roleColor[3])
end)

-- Comando de administrador para ver usuarios
addCommandHandler("listusers", function(player)
    if not isPlayerStaff(player) then
        outputChatBox("No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    local query = dbQuery(db, "SELECT COUNT(*) as count FROM users")
    local result = dbPoll(query, -1)
    local count = result and result[1] and tonumber(result[1].count) or 0
    
    outputChatBox("=== USUARIOS REGISTRADOS ===", player, 255, 255, 0)
    outputChatBox("Total: " .. count, player, 255, 255, 0)
    
    query = dbQuery(db, "SELECT username, email, role FROM users LIMIT 20")
    result = dbPoll(query, -1)
    
    if result then
        for _, user in ipairs(result) do
            local roleColor = ""
            if user.role == "admin" then
                roleColor = " [ADMIN]"
            elseif user.role == "staff" then
                roleColor = " [STAFF]"
            end
            outputChatBox("- " .. user.username .. " (" .. user.email .. ")" .. roleColor, player)
        end
    end
end)
