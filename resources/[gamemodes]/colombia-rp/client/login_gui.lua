-- GUI de Login Nativa con diseño moderno
local loginWindow = nil
local usernameEdit = nil
local passwordEdit = nil
local emailEdit = nil
local loginButton = nil
local registerButton = nil
local tabButton = nil
local registerTabButton = nil
local isRegisterMode = false
local screenWidth, screenHeight = guiGetScreenSize()

-- Imagen de fondo
local backgroundImage = nil

function showLoginGUI()
    -- Si ya existe, no crear otra vez
    if loginWindow then
        if isElement(loginWindow) then
            guiSetVisible(loginWindow, true)
            return
        end
    end
    
    -- Calcular posición centrada
    local windowWidth = 500
    local windowHeight = 600
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    -- Crear ventana (transparente para mostrar el fondo)
    loginWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "", false)
    guiWindowSetMovable(loginWindow, false)
    guiWindowSetSizable(loginWindow, false)
    guiSetAlpha(loginWindow, 0) -- Ventana transparente, solo usamos los elementos internos
    
    -- Cargar imagen de fondo
    backgroundImage = guiCreateStaticImage(0, 0, windowWidth, windowHeight, ":colombia-rp/colombia-rp-login.png", false, loginWindow)
    
    -- Panel principal (semi-transparente sobre el fondo)
    local mainPanel = guiCreateLabel(0, 0, windowWidth, windowHeight, "", false, loginWindow)
    guiLabelSetColor(mainPanel, 0, 0, 0)
    guiSetAlpha(mainPanel, 0.7) -- Fondo oscuro semi-transparente
    
    -- Título
    local titleLabel = guiCreateLabel(0, 30, windowWidth, 50, "COLOMBIA RP", false, loginWindow)
    guiLabelSetColor(titleLabel, 255, 255, 255)
    guiSetFont(titleLabel, "default-bold")
    guiLabelSetHorizontalAlign(titleLabel, "center", true)
    
    -- Subtítulo
    local subtitleLabel = guiCreateLabel(0, 75, windowWidth, 25, "Sistema de Acceso", false, loginWindow)
    guiLabelSetColor(subtitleLabel, 200, 200, 200)
    guiSetFont(subtitleLabel, "default")
    guiLabelSetHorizontalAlign(subtitleLabel, "center", true)
    
    -- Tabs
    tabButton = guiCreateButton(50, 120, 200, 40, "Iniciar Sesión", false, loginWindow)
    guiSetProperty(tabButton, "NormalTextColour", "FF00FFFF") -- Cyan
    registerTabButton = guiCreateButton(250, 120, 200, 40, "Registrarse", false, loginWindow)
    guiSetProperty(registerTabButton, "NormalTextColour", "FFFFFFFF") -- Blanco
    
    -- Panel de Login (visible inicialmente)
    local loginPanel = guiCreateLabel(50, 180, 400, 350, "", false, loginWindow)
    guiLabelSetColor(loginPanel, 0, 0, 0)
    guiSetAlpha(loginPanel, 0.5)
    
    -- Labels y campos para Login
    local usernameLabel = guiCreateLabel(70, 200, 100, 20, "Usuario:", false, loginWindow)
    guiLabelSetColor(usernameLabel, 255, 255, 255)
    guiSetFont(usernameLabel, "default-bold")
    usernameEdit = guiCreateEdit(70, 225, 360, 35, "", false, loginWindow)
    guiSetProperty(usernameEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(usernameEdit, "NormalEditboxColour", "AA000000")
    
    local passwordLabel = guiCreateLabel(70, 275, 100, 20, "Contraseña:", false, loginWindow)
    guiLabelSetColor(passwordLabel, 255, 255, 255)
    guiSetFont(passwordLabel, "default-bold")
    passwordEdit = guiCreateEdit(70, 300, 360, 35, "", false, loginWindow)
    guiEditSetMasked(passwordEdit, true)
    guiSetProperty(passwordEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(passwordEdit, "NormalEditboxColour", "AA000000")
    
    -- Checkbox "Remember Me"
    local rememberCheckbox = guiCreateCheckBox(70, 350, 200, 20, "Recordar sesión", false, false, loginWindow)
    guiCheckBoxSetSelected(rememberCheckbox, true)
    guiLabelSetColor(rememberCheckbox, 255, 255, 255)
    
    -- Botón Login
    loginButton = guiCreateButton(70, 390, 360, 45, "Iniciar Sesión", false, loginWindow)
    guiSetProperty(loginButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(loginButton, "HoverTextColour", "FF00FFFF")
    
    -- Link "Forgot Password?"
    local forgotPasswordLabel = guiCreateLabel(70, 445, 200, 20, "¿Olvidaste tu contraseña?", false, loginWindow)
    guiLabelSetColor(forgotPasswordLabel, 0, 150, 255)
    guiSetFont(forgotPasswordLabel, "default-small")
    
    -- Panel de Registro (oculto inicialmente)
    local registerPanel = guiCreateLabel(50, 180, 400, 400, "", false, loginWindow)
    guiLabelSetColor(registerPanel, 0, 0, 0)
    guiSetAlpha(registerPanel, 0.5)
    guiSetVisible(registerPanel, false)
    
    -- Labels y campos para Registro
    local registerUsernameLabel = guiCreateLabel(70, 200, 100, 20, "Usuario:", false, loginWindow)
    guiLabelSetColor(registerUsernameLabel, 255, 255, 255)
    guiSetFont(registerUsernameLabel, "default-bold")
    guiSetVisible(registerUsernameLabel, false)
    
    local registerUsernameEdit = guiCreateEdit(70, 225, 360, 35, "", false, loginWindow)
    guiSetProperty(registerUsernameEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerUsernameEdit, "NormalEditboxColour", "AA000000")
    guiSetVisible(registerUsernameEdit, false)
    
    local registerEmailLabel = guiCreateLabel(70, 325, 100, 20, "Email:", false, loginWindow)
    guiLabelSetColor(registerEmailLabel, 255, 255, 255)
    guiSetFont(registerEmailLabel, "default-bold")
    guiSetVisible(registerEmailLabel, false)
    emailEdit = guiCreateEdit(70, 350, 360, 35, "", false, loginWindow)
    guiSetProperty(emailEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(emailEdit, "NormalEditboxColour", "AA000000")
    guiSetVisible(emailEdit, false)
    
    local registerPasswordLabel = guiCreateLabel(70, 400, 150, 20, "Contraseña:", false, loginWindow)
    guiLabelSetColor(registerPasswordLabel, 255, 255, 255)
    guiSetFont(registerPasswordLabel, "default-bold")
    guiSetVisible(registerPasswordLabel, false)
    
    local registerPasswordEdit = guiCreateEdit(70, 425, 360, 35, "", false, loginWindow)
    guiEditSetMasked(registerPasswordEdit, true)
    guiSetProperty(registerPasswordEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerPasswordEdit, "NormalEditboxColour", "AA000000")
    guiSetVisible(registerPasswordEdit, false)
    
    local confirmPasswordLabel = guiCreateLabel(70, 475, 200, 20, "Confirmar Contraseña:", false, loginWindow)
    guiLabelSetColor(confirmPasswordLabel, 255, 255, 255)
    guiSetFont(confirmPasswordLabel, "default-bold")
    guiSetVisible(confirmPasswordLabel, false)
    
    local confirmPasswordEdit = guiCreateEdit(70, 500, 360, 35, "", false, loginWindow)
    guiEditSetMasked(confirmPasswordEdit, true)
    guiSetProperty(confirmPasswordEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(confirmPasswordEdit, "NormalEditboxColour", "AA000000")
    guiSetVisible(confirmPasswordEdit, false)
    
    -- Botón Register
    registerButton = guiCreateButton(70, 550, 360, 45, "Registrarse", false, loginWindow)
    guiSetProperty(registerButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerButton, "HoverTextColour", "FF00FF00")
    guiSetVisible(registerButton, false)
    
    -- Botones inferiores
    local settingsButton = guiCreateButton(50, 550, 120, 30, "Configuración", false, loginWindow)
    guiSetProperty(settingsButton, "NormalTextColour", "FFFFFFFF")
    
    local aboutButton = guiCreateButton(190, 550, 120, 30, "Acerca de", false, loginWindow)
    guiSetProperty(aboutButton, "NormalTextColour", "FFFFFFFF")
    
    local quitButton = guiCreateButton(330, 550, 120, 30, "Salir", false, loginWindow)
    guiSetProperty(quitButton, "NormalTextColour", "FFFFFFFF")
    
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
    
    addEventHandler("onClientGUIClick", quitButton, function()
        triggerServerEvent("onPlayerQuit", localPlayer)
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
    
    -- Guardar referencias para uso posterior
    loginWindowElements = {
        loginPanel = loginPanel,
        registerPanel = registerPanel,
        registerUsernameLabel = registerUsernameLabel,
        registerUsernameEdit = registerUsernameEdit,
        emailLabel = registerEmailLabel,
        registerPasswordLabel = registerPasswordLabel,
        registerPasswordEdit = registerPasswordEdit,
        confirmPasswordLabel = confirmPasswordLabel,
        confirmPasswordEdit = confirmPasswordEdit,
        rememberCheckbox = rememberCheckbox,
        forgotPasswordLabel = forgotPasswordLabel
    }
end

function switchToLoginMode()
    isRegisterMode = false
    guiSetProperty(tabButton, "NormalTextColour", "FF00FFFF") -- Cyan activo
    guiSetProperty(registerTabButton, "NormalTextColour", "FFFFFFFF") -- Blanco inactivo
    
    -- Ocultar elementos de registro
    if loginWindowElements then
        guiSetVisible(loginWindowElements.registerPanel, false)
        guiSetVisible(loginWindowElements.registerUsernameLabel, false)
        guiSetVisible(loginWindowElements.registerUsernameEdit, false)
        guiSetVisible(emailLabel, false)
        guiSetVisible(emailEdit, false)
        guiSetVisible(loginWindowElements.registerPasswordLabel, false)
        guiSetVisible(loginWindowElements.registerPasswordEdit, false)
        guiSetVisible(loginWindowElements.confirmPasswordLabel, false)
        guiSetVisible(loginWindowElements.confirmPasswordEdit, false)
        guiSetVisible(registerButton, false)
    end
    
    -- Mostrar elementos de login
    if loginWindowElements then
        guiSetVisible(loginWindowElements.loginPanel, true)
        guiSetVisible(loginWindowElements.rememberCheckbox, true)
        guiSetVisible(loginWindowElements.forgotPasswordLabel, true)
    end
    guiSetVisible(loginButton, true)
end

function switchToRegisterMode()
    isRegisterMode = true
    guiSetProperty(tabButton, "NormalTextColour", "FFFFFFFF") -- Blanco inactivo
    guiSetProperty(registerTabButton, "NormalTextColour", "FF00FFFF") -- Cyan activo
    
    -- Ocultar elementos de login
    if loginWindowElements then
        guiSetVisible(loginWindowElements.loginPanel, false)
        guiSetVisible(loginWindowElements.rememberCheckbox, false)
        guiSetVisible(loginWindowElements.forgotPasswordLabel, false)
    end
    guiSetVisible(loginButton, false)
    
    -- Mostrar elementos de registro
    if loginWindowElements then
        guiSetVisible(loginWindowElements.registerPanel, true)
        guiSetVisible(loginWindowElements.registerUsernameLabel, true)
        guiSetVisible(loginWindowElements.registerUsernameEdit, true)
        guiSetVisible(loginWindowElements.emailLabel, true)
        guiSetVisible(emailEdit, true)
        guiSetVisible(loginWindowElements.registerPasswordLabel, true)
        guiSetVisible(loginWindowElements.registerPasswordEdit, true)
        guiSetVisible(loginWindowElements.confirmPasswordLabel, true)
        guiSetVisible(loginWindowElements.confirmPasswordEdit, true)
    end
    guiSetVisible(registerButton, true)
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
    
    -- Activar evento del servidor
    triggerServerEvent("colombiaRP:playerLogin", localPlayer, username, password)
end

function performRegister()
    local username = guiGetText(loginWindowElements.registerUsernameEdit)
    local password = guiGetText(loginWindowElements.registerPasswordEdit)
    local confirmPassword = guiGetText(loginWindowElements.confirmPasswordEdit)
    local email = guiGetText(emailEdit)
    
    if username == "" or password == "" or email == "" or confirmPassword == "" then
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
    
    if password ~= confirmPassword then
        outputChatBox("Las contraseñas no coinciden", 255, 0, 0)
        return
    end
    
    if not string.match(email, "^[%w%.%-_]+@[%w%.%-_]+%.%w+$") then
        outputChatBox("Email inválido", 255, 0, 0)
        return
    end
    
    -- Activar evento del servidor
    triggerServerEvent("colombiaRP:playerRegister", localPlayer, username, password, email)
end

function hideLoginGUI()
    if loginWindow then
        if isElement(loginWindow) then
            destroyElement(loginWindow)
        end
        loginWindow = nil
        usernameEdit = nil
        passwordEdit = nil
        emailEdit = nil
        loginButton = nil
        registerButton = nil
        tabButton = nil
        registerTabButton = nil
        loginWindowElements = nil
        backgroundImage = nil
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
        hideLoginGUI()
        -- El panel de personajes se mostrará automáticamente desde el servidor
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
        if loginWindowElements then
            guiSetText(usernameEdit, "")
            guiSetText(passwordEdit, "")
            guiSetText(loginWindowElements.registerUsernameEdit, "")
            guiSetText(emailEdit, "")
            guiSetText(loginWindowElements.registerPasswordEdit, "")
            guiSetText(loginWindowElements.confirmPasswordEdit, "")
        end
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
