-- Sistema de Autenticación y Registro - Servidor
local usersFile = "users.xml"
local charactersFile = "characters.xml"
local usersData = {}
local charactersData = {} -- Estructura: charactersData[usernameLower] = {char1, char2, ...}

-- ==================== REGISTRAR EVENTOS PRIMERO ====================
-- Es importante registrar todos los eventos al inicio para que estén disponibles
addEvent("onPlayerRegister", true)
addEvent("onPlayerLogin", true)
addEvent("onPlayerCreateCharacter", true)
addEvent("onPlayerSelectCharacter", true)
addEvent("onRequestCharacters", true)

-- Cargar usuarios desde el archivo XML
function loadUsers()
    local xmlFile = xmlLoadFile(usersFile)
    if not xmlFile then
        -- Crear archivo si no existe
        xmlFile = xmlCreateFile(usersFile, "users")
        xmlSaveFile(xmlFile)
    end
    
    usersData = {}
    local usersNode = xmlFindChild(xmlFile, "user", 0)
    local index = 0
    
    while usersNode do
        local username = xmlNodeGetAttribute(usersNode, "username")
        local password = xmlNodeGetAttribute(usersNode, "password")
        local email = xmlNodeGetAttribute(usersNode, "email")
        local registerDate = xmlNodeGetAttribute(usersNode, "registerDate")
        
        if username and password then
            usersData[username:lower()] = {
                username = username,
                password = password,
                email = email or "",
                registerDate = registerDate or getRealTime().year .. "-" .. getRealTime().month .. "-" .. getRealTime().monthday
            }
        end
        
        index = index + 1
        usersNode = xmlFindChild(xmlFile, "user", index)
    end
    
    xmlUnloadFile(xmlFile)
    local count = 0
    for _ in pairs(usersData) do
        count = count + 1
    end
    outputServerLog("[Login] Usuarios cargados: " .. count)
end

-- Cargar personajes desde el archivo XML
function loadCharacters()
    local xmlFile = xmlLoadFile(charactersFile)
    if not xmlFile then
        xmlFile = xmlCreateFile(charactersFile, "characters")
        xmlSaveFile(xmlFile)
    end
    
    charactersData = {}
    local charNode = xmlFindChild(xmlFile, "character", 0)
    local index = 0
    
    while charNode do
        local username = xmlNodeGetAttribute(charNode, "username")
        local charName = xmlNodeGetAttribute(charNode, "name")
        local charSurname = xmlNodeGetAttribute(charNode, "surname")
        local charAge = xmlNodeGetAttribute(charNode, "age")
        local charGender = xmlNodeGetAttribute(charNode, "gender")
        local charSkin = xmlNodeGetAttribute(charNode, "skin")
        local charMoney = xmlNodeGetAttribute(charNode, "money")
        local charCreated = xmlNodeGetAttribute(charNode, "created")
        local charId = xmlNodeGetAttribute(charNode, "id")
        
        if username and charName then
            local usernameLower = string.lower(username)
            if not charactersData[usernameLower] then
                charactersData[usernameLower] = {}
            end
            
            table.insert(charactersData[usernameLower], {
                id = charId or #charactersData[usernameLower] + 1,
                name = charName,
                surname = charSurname or "",
                age = tonumber(charAge) or 18,
                gender = tonumber(charGender) or 0, -- 0 = masculino, 1 = femenino
                skin = tonumber(charSkin) or 0,
                money = tonumber(charMoney) or 0,
                created = charCreated or ""
            })
        end
        
        index = index + 1
        charNode = xmlFindChild(xmlFile, "character", index)
    end
    
    xmlUnloadFile(xmlFile)
    local totalChars = 0
    for _, chars in pairs(charactersData) do
        totalChars = totalChars + #chars
    end
    outputServerLog("[Login] Personajes cargados: " .. totalChars)
end

-- Guardar personajes en el archivo XML
function saveCharacters()
    local xmlFile = xmlLoadFile(charactersFile)
    if not xmlFile then
        xmlFile = xmlCreateFile(charactersFile, "characters")
    end
    
    -- Limpiar personajes existentes
    local charNode = xmlFindChild(xmlFile, "character", 0)
    while charNode do
        xmlDestroyNode(charNode)
        charNode = xmlFindChild(xmlFile, "character", 0)
    end
    
    -- Guardar todos los personajes
    for username, chars in pairs(charactersData) do
        for _, charData in ipairs(chars) do
            local charNode = xmlCreateChild(xmlFile, "character")
            xmlNodeSetAttribute(charNode, "username", username)
            xmlNodeSetAttribute(charNode, "id", tostring(charData.id))
            xmlNodeSetAttribute(charNode, "name", charData.name)
            xmlNodeSetAttribute(charNode, "surname", charData.surname)
            xmlNodeSetAttribute(charNode, "age", tostring(charData.age))
            xmlNodeSetAttribute(charNode, "gender", tostring(charData.gender))
            xmlNodeSetAttribute(charNode, "skin", tostring(charData.skin))
            xmlNodeSetAttribute(charNode, "money", tostring(charData.money))
            xmlNodeSetAttribute(charNode, "created", charData.created)
        end
    end
    
    xmlSaveFile(xmlFile)
    xmlUnloadFile(xmlFile)
end

-- Guardar usuarios en el archivo XML
function saveUsers()
    local xmlFile = xmlLoadFile(usersFile)
    if not xmlFile then
        xmlFile = xmlCreateFile(usersFile, "users")
    end
    
    -- Limpiar usuarios existentes
    local usersNode = xmlFindChild(xmlFile, "user", 0)
    while usersNode do
        xmlDestroyNode(usersNode)
        usersNode = xmlFindChild(xmlFile, "user", 0)
    end
    
    -- Guardar todos los usuarios
    for username, userData in pairs(usersData) do
        local userNode = xmlCreateChild(xmlFile, "user")
        xmlNodeSetAttribute(userNode, "username", userData.username)
        xmlNodeSetAttribute(userNode, "password", userData.password)
        xmlNodeSetAttribute(userNode, "email", userData.email)
        xmlNodeSetAttribute(userNode, "registerDate", tostring(userData.registerDate))
    end
    
    xmlSaveFile(xmlFile)
    xmlUnloadFile(xmlFile)
end

-- Función para hashear contraseña (simple, para producción usar SHA256 o mejor)
function hashPassword(password)
    -- En producción, usar una función de hash real como SHA256
    -- Por ahora, usamos una función simple
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
    
    -- Solo letras, números y guiones bajos
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
    local usernameLower = string.lower(username)
    if usersData[usernameLower] then
        triggerClientEvent(client, "onRegisterResult", client, false, "Este usuario ya está registrado")
        return
    end
    
    -- Verificar si el email ya está en uso
    for _, userData in pairs(usersData) do
        if userData.email and string.lower(userData.email) == string.lower(email) then
            triggerClientEvent(client, "onRegisterResult", client, false, "Este email ya está registrado")
            return
        end
    end
    
    -- Crear nuevo usuario
    local hashedPassword = hashPassword(password)
    local time = getRealTime()
    local registerDate = time.year .. "-" .. (time.month + 1) .. "-" .. time.monthday .. " " .. time.hour .. ":" .. time.minute
    
    usersData[usernameLower] = {
        username = username,
        password = hashedPassword,
        email = email,
        registerDate = registerDate
    }
    
    saveUsers()
    
    outputServerLog("[Login] Nuevo usuario registrado: " .. username .. " (" .. email .. ")")
    triggerClientEvent(client, "onRegisterResult", client, true, "¡Cuenta creada exitosamente! Ahora puedes iniciar sesión.")
end)

-- Evento de login
addEventHandler("onPlayerLogin", root, function(username, password)
    if not client then return end
    
    if not username or not password then
        triggerClientEvent(client, "onLoginResult", client, false, "Por favor completa todos los campos")
        return
    end
    
    local usernameLower = string.lower(username)
    local userData = usersData[usernameLower]
    
    if not userData then
        triggerClientEvent(client, "onLoginResult", client, false, "Usuario o contraseña incorrectos")
        return
    end
    
    local hashedPassword = hashPassword(password)
    if userData.password ~= hashedPassword then
        triggerClientEvent(client, "onLoginResult", client, false, "Usuario o contraseña incorrectos")
        return
    end
    
    -- Login exitoso
    setElementData(client, "loggedIn", true)
    setElementData(client, "username", userData.username)
    setElementData(client, "userEmail", userData.email)
    
    outputServerLog("[Login] Usuario conectado: " .. userData.username .. " (" .. getPlayerName(client) .. ")")
    
    -- Obtener personajes del usuario
    local usernameLower = string.lower(userData.username)
    local userCharacters = charactersData[usernameLower] or {}
    
    -- Enviar personajes al cliente para mostrar el panel de selección
    triggerClientEvent(client, "onLoginResult", client, true, "Login exitoso", userCharacters)
end)

-- Verificar si el jugador está logueado
function isPlayerLoggedIn(player)
    return getElementData(player, "loggedIn") == true
end

-- Obtener personajes de un usuario
function getUserCharacters(username)
    local usernameLower = string.lower(username)
    return charactersData[usernameLower] or {}
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
    
    local usernameLower = string.lower(username)
    
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
    if not charactersData[usernameLower] then
        charactersData[usernameLower] = {}
    end
    
    if #charactersData[usernameLower] >= 3 then
        triggerClientEvent(client, "onCharacterCreateResult", client, false, "Ya tienes el máximo de personajes (3)")
        return
    end
    
    -- Verificar si el nombre ya existe para este usuario
    for _, char in ipairs(charactersData[usernameLower]) do
        if string.lower(char.name) == string.lower(name) and string.lower(char.surname) == string.lower(surname or "") then
            triggerClientEvent(client, "onCharacterCreateResult", client, false, "Ya tienes un personaje con ese nombre y apellido")
            return
        end
    end
    
    -- Crear nuevo personaje
    local time = getRealTime()
    local createdDate = time.year .. "-" .. (time.month + 1) .. "-" .. time.monthday
    
    local newChar = {
        id = #charactersData[usernameLower] + 1,
        name = name,
        surname = surname or "",
        age = age,
        gender = tonumber(gender) or 0,
        skin = tonumber(skin) or 0,
        money = 5000, -- Dinero inicial
        created = createdDate
    }
    
    table.insert(charactersData[usernameLower], newChar)
    saveCharacters()
    
    outputServerLog("[Login] Nuevo personaje creado: " .. name .. " " .. (surname or "") .. " para " .. username)
    triggerClientEvent(client, "onCharacterCreateResult", client, true, "Personaje creado exitosamente", newChar)
    
    -- Enviar lista actualizada de personajes
    triggerClientEvent(client, "onCharactersUpdated", client, charactersData[usernameLower])
end)

-- Seleccionar personaje
addEventHandler("onPlayerSelectCharacter", root, function(charId)
    if not client then return end
    
    if not isPlayerLoggedIn(client) then
        return
    end
    
    local username = getElementData(client, "username")
    if not username then return end
    
    local usernameLower = string.lower(username)
    local userCharacters = charactersData[usernameLower] or {}
    
    -- Buscar el personaje
    local selectedChar = nil
    for _, char in ipairs(userCharacters) do
        if tostring(char.id) == tostring(charId) then
            selectedChar = char
            break
        end
    end
    
    if not selectedChar then
        triggerClientEvent(client, "onCharacterSelectResult", client, false, "Personaje no encontrado")
        return
    end
    
    -- Guardar datos del personaje seleccionado
    setElementData(client, "characterId", selectedChar.id)
    setElementData(client, "characterName", selectedChar.name)
    setElementData(client, "characterSurname", selectedChar.surname)
    setElementData(client, "characterAge", selectedChar.age)
    setElementData(client, "characterGender", selectedChar.gender)
    setElementData(client, "characterMoney", selectedChar.money)
    setElementData(client, "characterSelected", true)
    
    outputServerLog("[Login] Personaje seleccionado: " .. selectedChar.name .. " " .. selectedChar.surname .. " por " .. username)
    
    -- Spawnear al jugador (puedes personalizar esto)
    spawnPlayer(client, 1959.55, -1714.46, 10, 0, selectedChar.skin)
    setCameraTarget(client, client)
    fadeCamera(client, true)
    
    triggerClientEvent(client, "onCharacterSelectResult", client, true, "Personaje seleccionado: " .. selectedChar.name .. " " .. selectedChar.surname)
    
    -- Aquí puedes agregar más lógica: dar dinero, items, etc.
    setPlayerMoney(client, selectedChar.money)
end)

-- Evento para solicitar personajes
addEventHandler("onRequestCharacters", root, function()
    if not client then return end
    
    if not isPlayerLoggedIn(client) then
        return
    end
    
    local username = getElementData(client, "username")
    if not username then return end
    
    local usernameLower = string.lower(username)
    local userCharacters = charactersData[usernameLower] or {}
    
    triggerClientEvent(client, "onCharactersUpdated", client, userCharacters)
end)

-- Comando changechar
addCommandHandler("changechar", function(player)
    if not isPlayerLoggedIn(player) then
        outputChatBox("Debes estar logueado para usar este comando", player, 255, 0, 0)
        return
    end
    
    local username = getElementData(player, "username")
    if not username then return end
    
    local usernameLower = string.lower(username)
    local userCharacters = charactersData[usernameLower] or {}
    
    -- Enviar personajes al cliente para mostrar el panel
    triggerClientEvent(player, "onShowCharacterSelection", player, userCharacters)
end)

-- Cargar usuarios al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    loadUsers()
    loadCharacters()
    outputServerLog("[Login] Sistema de autenticación iniciado")
end)

-- Guardar usuarios al detener el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    saveUsers()
    saveCharacters()
    outputServerLog("[Login] Sistema de autenticación detenido")
end)

-- Comando de administrador para ver usuarios
addCommandHandler("listusers", function(player)
    if not hasObjectPermissionTo(player, "command.kick", false) then
        outputChatBox("No tienes permisos para usar este comando", player)
        return
    end
    
    local count = 0
    for _ in pairs(usersData) do
        count = count + 1
    end
    
    outputChatBox("=== USUARIOS REGISTRADOS ===", player, 255, 255, 0)
    outputChatBox("Total: " .. count, player, 255, 255, 0)
    
    for username, userData in pairs(usersData) do
        outputChatBox("- " .. userData.username .. " (" .. userData.email .. ")", player)
    end
end)

