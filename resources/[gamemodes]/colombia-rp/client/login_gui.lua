-- GUI de Login Clásico (sin navegador)
local loginWindow = nil
local usernameEdit = nil
local passwordEdit = nil
local emailEdit = nil
local loginButton = nil
local registerButton = nil
local tabButton = nil
local isRegisterMode = false
local screenWidth, screenHeight = guiGetScreenSize()

function showLoginGUI()
    -- Si ya existe, no crear otra vez
    if loginWindow then
        return
    end
    
    outputChatBox("Mostrando GUI de login...", 255, 255, 0)
    
    -- Calcular posición centrada
    local windowWidth = 400
    local windowHeight = 300
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    -- Crear ventana
    loginWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Colombia RP - Login", false)
    guiWindowSetMovable(loginWindow, true)
    guiWindowSetSizable(loginWindow, false)
    guiSetAlpha(loginWindow, 0.95)
    
    -- Tabs
    tabButton = guiCreateButton(10, 30, 180, 30, "Iniciar Sesión", false, loginWindow)
    local registerTabButton = guiCreateButton(200, 30, 180, 30, "Registrarse", false, loginWindow)
    
    -- Labels y campos para Login
    local usernameLabel = guiCreateLabel(20, 70, 100, 20, "Usuario:", false, loginWindow)
    guiLabelSetColor(usernameLabel, 255, 255, 255)
    usernameEdit = guiCreateEdit(20, 90, 350, 30, "", false, loginWindow)
    
    local passwordLabel = guiCreateLabel(20, 130, 100, 20, "Contraseña:", false, loginWindow)
    guiLabelSetColor(passwordLabel, 255, 255, 255)
    passwordEdit = guiCreateEdit(20, 150, 350, 30, "", false, loginWindow)
    guiEditSetMasked(passwordEdit, true)
    
    -- Campos para Registro (ocultos inicialmente)
    local emailLabel = guiCreateLabel(20, 190, 100, 20, "Email:", false, loginWindow)
    guiLabelSetColor(emailLabel, 255, 255, 255)
    guiSetVisible(emailLabel, false)
    emailEdit = guiCreateEdit(20, 210, 350, 30, "", false, loginWindow)
    guiSetVisible(emailEdit, false)
    
    -- Botones
    loginButton = guiCreateButton(20, 200, 170, 40, "Iniciar Sesión", false, loginWindow)
    registerButton = guiCreateButton(200, 200, 170, 40, "Registrarse", false, loginWindow)
    guiSetVisible(registerButton, false)
    
    -- Mostrar cursor y habilitar input
    showCursor(true)
    guiSetInputEnabled(true)
    
    -- Eventos
    addEventHandler("onClientGUIClick", tabButton, function()
        switchToLoginMode()
    end, false)
    
    addEventHandler("onClientGUIClick", registerTabButton, function()
        switchToRegisterMode()
    end, false)
    
    addEventHandler("onClientGUIClick", loginButton, function()
        performLogin()
    end, false)
    
    addEventHandler("onClientGUIClick", registerButton, function()
        performRegister()
    end, false)
    
    -- Permitir Enter para enviar
    addEventHandler("onClientGUIChanged", usernameEdit, function()
        -- Permitir Enter
    end, false)
    
    addEventHandler("onClientGUIChanged", passwordEdit, function()
        -- Permitir Enter
    end, false)
    
    addEventHandler("onClientGUIChanged", emailEdit, function()
        -- Permitir Enter
    end, false)
    
    -- Enter key handler
    bindKey("enter", "down", function()
        if loginWindow and guiGetVisible(loginWindow) then
            if isRegisterMode then
                performRegister()
            else
                performLogin()
            end
        end
    end)
end

function switchToLoginMode()
    isRegisterMode = false
    guiSetVisible(emailEdit, false)
    guiSetVisible(loginButton, true)
    guiSetVisible(registerButton, false)
    guiSetText(tabButton, "Iniciar Sesión [ACTIVO]")
end

function switchToRegisterMode()
    isRegisterMode = true
    guiSetVisible(emailEdit, true)
    guiSetVisible(loginButton, false)
    guiSetVisible(registerButton, true)
    guiSetText(tabButton, "Iniciar Sesión")
end

function performLogin()
    local username = guiGetText(usernameEdit)
    local password = guiGetText(passwordEdit)
    
    if username == "" or password == "" then
        outputChatBox("Por favor completa todos los campos", 255, 0, 0)
        return
    end
    
    if string.len(username) < 3 then
        outputChatBox("El usuario debe tener al menos 3 caracteres", 255, 0, 0)
        return
    end
    
    -- Activar evento del servidor (usando getLocalPlayer() como en el ejemplo que funciona)
    outputChatBox("[DEBUG] Enviando evento onPlayerLogin con usuario: " .. username, 255, 255, 0)
    triggerServerEvent("onPlayerLogin", getLocalPlayer(), username, password)
end

function performRegister()
    local username = guiGetText(usernameEdit)
    local password = guiGetText(passwordEdit)
    local email = guiGetText(emailEdit)
    
    if username == "" or password == "" or email == "" then
        outputChatBox("Por favor completa todos los campos", 255, 0, 0)
        return
    end
    
    if string.len(username) < 3 or string.len(username) > 20 then
        outputChatBox("El usuario debe tener entre 3 y 20 caracteres", 255, 0, 0)
        return
    end
    
    if string.len(password) < 6 then
        outputChatBox("La contraseña debe tener al menos 6 caracteres", 255, 0, 0)
        return
    end
    
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        outputChatBox("Email inválido", 255, 0, 0)
        return
    end
    
    -- Activar evento del servidor (usando getLocalPlayer() como en el ejemplo que funciona)
    outputChatBox("[DEBUG] Enviando evento onPlayerRegister", 255, 255, 0)
    triggerServerEvent("onPlayerRegister", getLocalPlayer(), username, password, email)
end

function hideLoginGUI()
    if loginWindow then
        destroyElement(loginWindow)
        loginWindow = nil
        usernameEdit = nil
        passwordEdit = nil
        emailEdit = nil
        loginButton = nil
        registerButton = nil
        tabButton = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
    unbindKey("enter", "down")
end

-- Eventos del servidor
addEvent("showLoginGUI", true)
addEventHandler("showLoginGUI", resourceRoot, function()
    showLoginGUI()
end)

addEvent("loginResponse", true)
addEventHandler("loginResponse", resourceRoot, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
        hideLoginGUI()
    else
        outputChatBox("Error: " .. message, 255, 0, 0)
    end
end)

addEvent("registerResponse", true)
addEventHandler("registerResponse", resourceRoot, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
        -- Cambiar a modo login después de registro exitoso
        switchToLoginMode()
        guiSetText(usernameEdit, "")
        guiSetText(passwordEdit, "")
        guiSetText(emailEdit, "")
    else
        outputChatBox("Error: " .. message, 255, 0, 0)
    end
end)

-- Mostrar login cuando el recurso se inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        local loggedIn = getElementData(localPlayer, "account:loggedIn")
        if loggedIn ~= true then
            showLoginGUI()
        end
    end, 2000, 1)
end)
