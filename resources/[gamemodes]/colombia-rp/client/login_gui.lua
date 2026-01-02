-- GUI de Login Nativa con diseño moderno - Estructura de dos paneles
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

-- Imagen de fondo (pantalla completa)
local backgroundImage = nil

function showLoginGUI()
    -- Si ya existe, no crear otra vez
    if loginWindow then
        if isElement(loginWindow) then
            guiSetVisible(loginWindow, true)
            return
        end
    end
    
    -- Crear ventana de pantalla completa (transparente)
    loginWindow = guiCreateWindow(0, 0, screenWidth, screenHeight, "", false)
    guiWindowSetMovable(loginWindow, false)
    guiWindowSetSizable(loginWindow, false)
    guiSetAlpha(loginWindow, 0) -- Ventana transparente
    
    -- Imagen de fondo a pantalla completa (crear primero para que quede atrás)
    backgroundImage = guiCreateStaticImage(0, 0, screenWidth, screenHeight, ":colombia-rp/colombia-rp-login.png", false, loginWindow)
    
    -- Panel oscuro semi-transparente sobre el fondo
    local overlayPanel = guiCreateLabel(0, 0, screenWidth, screenHeight, "", false, loginWindow)
    guiLabelSetColor(overlayPanel, 0, 0, 0)
    guiSetAlpha(overlayPanel, 0.3) -- Overlay oscuro ligero
    guiBringToFront(overlayPanel) -- Asegurar que esté encima de la imagen
    
    -- Contenedor principal centrado
    local containerWidth = 1000
    local containerHeight = 600
    local containerX = (screenWidth - containerWidth) / 2
    local containerY = (screenHeight - containerHeight) / 2
    
    -- Tabs en la parte superior (traer al frente)
    tabButton = guiCreateButton(containerX, containerY - 50, 200, 45, "Login", false, loginWindow)
    guiSetProperty(tabButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(tabButton, "HoverTextColour", "FF00FFFF")
    guiBringToFront(tabButton)
    
    registerTabButton = guiCreateButton(containerX + 200, containerY - 50, 200, 45, "Register", false, loginWindow)
    guiSetProperty(registerTabButton, "NormalTextColour", "FF888888")
    guiSetProperty(registerTabButton, "HoverTextColour", "FF00FFFF")
    guiBringToFront(registerTabButton)
    
    -- Panel izquierdo - Login
    local loginPanelBg = guiCreateLabel(containerX, containerY, 480, containerHeight, "", false, loginWindow)
    guiLabelSetColor(loginPanelBg, 0, 0, 0)
    guiSetAlpha(loginPanelBg, 0.7) -- Fondo oscuro semi-transparente
    
    -- Título Login (traer al frente)
    local loginTitle = guiCreateLabel(containerX, containerY + 20, 480, 40, "Welcome to COLOMBIA RP", false, loginWindow)
    guiLabelSetColor(loginTitle, 255, 255, 255)
    guiSetFont(loginTitle, "default-bold")
    guiLabelSetHorizontalAlign(loginTitle, "center", true)
    guiBringToFront(loginTitle)
    
    -- Campos Login (traer al frente)
    local usernameLabel = guiCreateLabel(containerX + 50, containerY + 80, 380, 25, "Username:", false, loginWindow)
    guiLabelSetColor(usernameLabel, 255, 255, 255)
    guiSetFont(usernameLabel, "default-bold")
    guiBringToFront(usernameLabel)
    
    usernameEdit = guiCreateEdit(containerX + 50, containerY + 105, 380, 40, "", false, loginWindow)
    guiSetProperty(usernameEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(usernameEdit, "NormalEditboxColour", "FF2A2A2A")
    guiBringToFront(usernameEdit)
    
    local passwordLabel = guiCreateLabel(containerX + 50, containerY + 160, 380, 25, "Password:", false, loginWindow)
    guiLabelSetColor(passwordLabel, 255, 255, 255)
    guiSetFont(passwordLabel, "default-bold")
    guiBringToFront(passwordLabel)
    
    passwordEdit = guiCreateEdit(containerX + 50, containerY + 185, 380, 40, "", false, loginWindow)
    guiEditSetMasked(passwordEdit, true)
    guiSetProperty(passwordEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(passwordEdit, "NormalEditboxColour", "FF2A2A2A")
    guiBringToFront(passwordEdit)
    
    -- Checkbox Remember Me
    local rememberCheckbox = guiCreateCheckBox(containerX + 50, containerY + 240, 200, 25, "Remember Me", false, false, loginWindow)
    guiCheckBoxSetSelected(rememberCheckbox, true)
    guiLabelSetColor(rememberCheckbox, 255, 255, 255)
    guiBringToFront(rememberCheckbox)
    
    -- Botón Login (azul)
    loginButton = guiCreateButton(containerX + 50, containerY + 280, 380, 50, "Login", false, loginWindow)
    guiSetProperty(loginButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(loginButton, "HoverTextColour", "FF00FFFF")
    guiBringToFront(loginButton)
    
    -- Link Forgot Password
    local forgotPasswordLabel = guiCreateLabel(containerX + 50, containerY + 340, 200, 25, "Forgot Password?", false, loginWindow)
    guiLabelSetColor(forgotPasswordLabel, 150, 200, 255)
    guiSetFont(forgotPasswordLabel, "default-small")
    guiBringToFront(forgotPasswordLabel)
    
    -- Panel derecho - Register (crear después para que esté encima)
    local registerPanelBg = guiCreateLabel(containerX + 520, containerY, 480, containerHeight, "", false, loginWindow)
    guiLabelSetColor(registerPanelBg, 0, 0, 0)
    guiSetAlpha(registerPanelBg, 0.7) -- Fondo oscuro semi-transparente
    guiBringToFront(registerPanelBg) -- Traer al frente
    
    -- Título Register (traer al frente)
    local registerTitle = guiCreateLabel(containerX + 520, containerY + 20, 480, 40, "Create a New Account", false, loginWindow)
    guiLabelSetColor(registerTitle, 255, 255, 255)
    guiSetFont(registerTitle, "default-bold")
    guiLabelSetHorizontalAlign(registerTitle, "center", true)
    guiBringToFront(registerTitle)
    
    -- Campos Register (traer al frente)
    local registerUsernameLabel = guiCreateLabel(containerX + 570, containerY + 80, 380, 25, "Username:", false, loginWindow)
    guiLabelSetColor(registerUsernameLabel, 255, 255, 255)
    guiSetFont(registerUsernameLabel, "default-bold")
    guiBringToFront(registerUsernameLabel)
    
    local registerUsernameEdit = guiCreateEdit(containerX + 570, containerY + 105, 380, 40, "", false, loginWindow)
    guiSetProperty(registerUsernameEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerUsernameEdit, "NormalEditboxColour", "FF2A2A2A")
    guiBringToFront(registerUsernameEdit)
    
    local emailLabel = guiCreateLabel(containerX + 570, containerY + 160, 380, 25, "E-Mail:", false, loginWindow)
    guiLabelSetColor(emailLabel, 255, 255, 255)
    guiSetFont(emailLabel, "default-bold")
    guiBringToFront(emailLabel)
    
    emailEdit = guiCreateEdit(containerX + 570, containerY + 185, 380, 40, "", false, loginWindow)
    guiSetProperty(emailEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(emailEdit, "NormalEditboxColour", "FF2A2A2A")
    guiBringToFront(emailEdit)
    
    local registerPasswordLabel = guiCreateLabel(containerX + 570, containerY + 240, 380, 25, "Password:", false, loginWindow)
    guiLabelSetColor(registerPasswordLabel, 255, 255, 255)
    guiSetFont(registerPasswordLabel, "default-bold")
    guiBringToFront(registerPasswordLabel)
    
    local registerPasswordEdit = guiCreateEdit(containerX + 570, containerY + 265, 380, 40, "", false, loginWindow)
    guiEditSetMasked(registerPasswordEdit, true)
    guiSetProperty(registerPasswordEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerPasswordEdit, "NormalEditboxColour", "FF2A2A2A")
    guiBringToFront(registerPasswordEdit)
    
    local confirmPasswordLabel = guiCreateLabel(containerX + 570, containerY + 320, 380, 25, "Confirm Password:", false, loginWindow)
    guiLabelSetColor(confirmPasswordLabel, 255, 255, 255)
    guiSetFont(confirmPasswordLabel, "default-bold")
    guiBringToFront(confirmPasswordLabel)
    
    local confirmPasswordEdit = guiCreateEdit(containerX + 570, containerY + 345, 380, 40, "", false, loginWindow)
    guiEditSetMasked(confirmPasswordEdit, true)
    guiSetProperty(confirmPasswordEdit, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(confirmPasswordEdit, "NormalEditboxColour", "FF2A2A2A")
    guiBringToFront(confirmPasswordEdit)
    
    -- Botón Register (verde)
    registerButton = guiCreateButton(containerX + 570, containerY + 400, 380, 50, "Register", false, loginWindow)
    guiSetProperty(registerButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerButton, "HoverTextColour", "FF00FF00")
    guiBringToFront(registerButton)
    
    -- Botones inferiores (traer al frente)
    local settingsButton = guiCreateButton(containerX, containerY + containerHeight + 20, 200, 40, "Settings", false, loginWindow)
    guiSetProperty(settingsButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(settingsButton, "HoverTextColour", "FF00FFFF")
    guiBringToFront(settingsButton)
    
    local aboutButton = guiCreateButton(containerX + 400, containerY + containerHeight + 20, 200, 40, "About", false, loginWindow)
    guiSetProperty(aboutButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(aboutButton, "HoverTextColour", "FF00FFFF")
    guiBringToFront(aboutButton)
    
    local quitButton = guiCreateButton(containerX + 800, containerY + containerHeight + 20, 200, 40, "Quit", false, loginWindow)
    guiSetProperty(quitButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(quitButton, "HoverTextColour", "FFFF0000")
    guiBringToFront(quitButton)
    
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
        loginPanelBg = loginPanelBg,
        registerPanelBg = registerPanelBg,
        registerUsernameEdit = registerUsernameEdit,
        registerPasswordEdit = registerPasswordEdit,
        confirmPasswordEdit = confirmPasswordEdit,
        rememberCheckbox = rememberCheckbox,
        forgotPasswordLabel = forgotPasswordLabel
    }
    
    -- Inicializar en modo Login
    switchToLoginMode()
end

function switchToLoginMode()
    isRegisterMode = false
    
    -- Activar tab Login
    guiSetProperty(tabButton, "NormalTextColour", "FFFFFFFF")
    guiSetProperty(registerTabButton, "NormalTextColour", "FF888888")
    
    -- Mostrar panel Login, ocultar Register
    if loginWindowElements then
        guiSetVisible(loginWindowElements.loginPanelBg, true)
        guiSetVisible(loginWindowElements.registerPanelBg, false)
    end
end

function switchToRegisterMode()
    isRegisterMode = true
    
    -- Activar tab Register
    guiSetProperty(tabButton, "NormalTextColour", "FF888888")
    guiSetProperty(registerTabButton, "NormalTextColour", "FFFFFFFF")
    
    -- Mostrar panel Register, ocultar Login
    if loginWindowElements then
        guiSetVisible(loginWindowElements.loginPanelBg, false)
        guiSetVisible(loginWindowElements.registerPanelBg, true)
    end
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
