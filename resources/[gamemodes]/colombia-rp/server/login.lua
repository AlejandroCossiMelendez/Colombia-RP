-- Sistema de Login y Registro
-- Nota: Los eventos están registrados en server/events.lua que se carga primero

-- Hash de contraseña usando md5 (más seguro que hash() que requiere permisos)
function hashPassword(password)
    -- Usar md5 que no requiere permisos especiales
    -- En producción se recomienda usar bcrypt si está disponible
    return md5(password .. "salt_colombia_rp")
end

function verifyPassword(password, storedHash)
    -- Verificar contraseña comparando hashes
    local testHash = md5(password .. "salt_colombia_rp")
    return testHash == storedHash
end

-- Función para inicializar jugador y mostrar login
function initializePlayerLogin(player)
    if not isElement(player) then
        return
    end
    
    outputServerLog("[LOGIN] Inicializando login para " .. getPlayerName(player))
    
    -- Inicializar datos del jugador
    setElementData(player, "account:loggedIn", false)
    setElementData(player, "account:username", nil)
    setElementData(player, "account:userId", nil)
    setElementData(player, "character:selected", false)
    setElementData(player, "character:id", nil)
    
    -- Prevenir spawn automático
    fadeCamera(player, false)
    setCameraTarget(player, nil)
    
    -- Mostrar GUI de login al cliente después de un pequeño delay
    setTimer(function()
        if isElement(player) then
            outputServerLog("[LOGIN] Enviando GUI de login a " .. getPlayerName(player))
            triggerClientEvent(player, "showLoginGUI", resourceRoot)
        end
    end, 1500, 1)
end

-- Evento cuando el jugador se une al juego
addEventHandler("onPlayerJoin", root, function()
    initializePlayerLogin(source)
end)

-- Si el recurso se inicia después de que los jugadores ya están conectados
addEventHandler("onResourceStart", resourceRoot, function()
    setTimer(function()
        for _, player in ipairs(getElementsByType("player")) do
            local loggedIn = getElementData(player, "account:loggedIn")
            if not loggedIn or loggedIn == false then
                outputServerLog("[LOGIN] Jugador " .. getPlayerName(player) .. " ya estaba conectado, inicializando login...")
                initializePlayerLogin(player)
            end
        end
    end, 2000, 1)
end)

-- Evento de login desde el cliente (usando getRootElement() como en el ejemplo que funciona)
addEventHandler("colombiaRP:playerLogin", getRootElement(), function(username, password)
    outputServerLog("[LOGIN] Evento onPlayerLogin recibido de " .. getPlayerName(source) .. " con usuario: " .. tostring(username))
    
    if not username or not password then
        triggerClientEvent(source, "loginResponse", resourceRoot, false, "Usuario y contraseña requeridos")
        return
    end
    
    -- Buscar usuario en la base de datos
    local query = "SELECT * FROM users WHERE username = ? LIMIT 1"
    local result = queryDatabase(query, username)
    
    if result and #result > 0 then
        local user = result[1]
        
        -- Verificar contraseña
        if verifyPassword(password, user.password) then
            -- Login exitoso
            outputServerLog("[LOGIN] Login exitoso para usuario: " .. username)
            setElementData(source, "account:loggedIn", true)
            setElementData(source, "account:username", user.username)
            setElementData(source, "account:userId", user.id)
            setElementData(source, "account:role", user.role)
            
            outputChatBox("¡Bienvenido, " .. user.username .. "!", source, 0, 255, 0)
            triggerClientEvent(source, "loginResponse", resourceRoot, true, "Login exitoso")
            -- Mostrar panel de personajes inmediatamente después del login
            setTimer(function()
                if isElement(source) then
                    triggerClientEvent(source, "showCharacterGUI", resourceRoot)
                end
            end, 300, 1)
        else
            outputServerLog("[LOGIN] Contraseña incorrecta para usuario: " .. username)
            triggerClientEvent(source, "loginResponse", resourceRoot, false, "Contraseña incorrecta")
        end
    else
        outputServerLog("[LOGIN] Usuario no encontrado: " .. username)
        triggerClientEvent(source, "loginResponse", resourceRoot, false, "Usuario no encontrado")
    end
end)

-- Evento de registro desde el cliente (usando getRootElement() como en el ejemplo que funciona)
addEventHandler("colombiaRP:playerRegister", getRootElement(), function(username, password, email)
    outputServerLog("[LOGIN] Evento onPlayerRegister recibido de " .. getPlayerName(source))
    
    if not username or not password or not email then
        triggerClientEvent(source, "registerResponse", resourceRoot, false, "Todos los campos son requeridos")
        return
    end
    
    -- Validar formato de email
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        triggerClientEvent(source, "registerResponse", resourceRoot, false, "Email inválido")
        return
    end
    
    -- Validar longitud de usuario y contraseña
    if string.len(username) < 3 or string.len(username) > 20 then
        triggerClientEvent(source, "registerResponse", resourceRoot, false, "El usuario debe tener entre 3 y 20 caracteres")
        return
    end
    
    if string.len(password) < 6 then
        triggerClientEvent(source, "registerResponse", resourceRoot, false, "La contraseña debe tener al menos 6 caracteres")
        return
    end
    
    -- Verificar si el usuario ya existe
    local checkQuery = "SELECT id FROM users WHERE username = ? OR email = ? LIMIT 1"
    local checkResult = queryDatabase(checkQuery, username, email)
    
    if checkResult and #checkResult > 0 then
        triggerClientEvent(source, "registerResponse", resourceRoot, false, "El usuario o email ya existe")
        return
    end
    
    -- Crear nuevo usuario
    local hashedPassword = hashPassword(password)
    local registerDate = getRealTime()
    local dateString = string.format("%04d-%02d-%02d %02d:%02d:%02d", 
        registerDate.year + 1900, registerDate.month + 1, registerDate.monthday,
        registerDate.hour, registerDate.minute, registerDate.second)
    
    local insertQuery = "INSERT INTO users (username, password, email, registerDate, role) VALUES (?, ?, ?, ?, ?)"
    local success = executeDatabase(insertQuery, username, hashedPassword, email, dateString, "user")
    
    if success then
        outputServerLog("[LOGIN] Usuario registrado exitosamente: " .. username)
        outputChatBox("¡Registro exitoso! Ahora puedes iniciar sesión.", source, 0, 255, 0)
        triggerClientEvent(source, "registerResponse", resourceRoot, true, "Registro exitoso")
    else
        outputServerLog("[LOGIN] Error al registrar usuario: " .. username)
        triggerClientEvent(source, "registerResponse", resourceRoot, false, "Error al crear la cuenta")
    end
end)

-- Evento cuando el jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    local characterId = getElementData(source, "character:id")
    if characterId then
        -- Guardar última posición y datos del personaje
        local x, y, z = getElementPosition(source)
        local rotation = getPedRotation(source)
        local interior = getElementInterior(source)
        local dimension = getElementDimension(source)
        local health = getElementHealth(source)
        local hunger = getElementData(source, "character:hunger") or Config.Server.defaultHunger
        local thirst = getElementData(source, "character:thirst") or Config.Server.defaultThirst
        
        local updateQuery = "UPDATE characters SET posX = ?, posY = ?, posZ = ?, rotation = ?, interior = ?, dimension = ?, health = ?, hunger = ?, thirst = ?, lastLogin = NOW() WHERE id = ?"
        executeDatabase(updateQuery, x, y, z, rotation, interior, dimension, health, hunger, thirst, characterId)
    end
end)
