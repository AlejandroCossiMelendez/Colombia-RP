-- Panel de Login y Registro Profesional
local screenWidth, screenHeight = guiGetScreenSize()
local loginWindow = nil
local characterWindow = nil
local isLoginMode = true -- true = login, false = registro
local serverReady = false -- Flag para saber si el servidor está listo

-- Colores del tema
local colors = {
    primary = {41, 128, 185, 255},      -- Azul principal
    secondary = {52, 73, 94, 255},      -- Gris oscuro
    success = {46, 204, 113, 255},      -- Verde
    danger = {231, 76, 60, 255},        -- Rojo
    background = {0, 0, 0, 200},        -- Fondo semi-transparente
    text = {236, 240, 241, 255},        -- Texto claro
    input = {44, 62, 80, 255}           -- Fondo de inputs
}

-- Crear la ventana principal
function createLoginWindow()
    if loginWindow then
        destroyElement(loginWindow)
    end
    
    local windowWidth, windowHeight = 450, 550
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    loginWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Colombia RP - Sistema de Autenticación", false)
    guiWindowSetMovable(loginWindow, true)
    guiWindowSetSizable(loginWindow, false)
    guiSetAlpha(loginWindow, 1)
    guiSetVisible(loginWindow, true)
    
    -- Título del panel
    local titleLabel = guiCreateLabel(20, 30, windowWidth - 40, 40, isLoginMode and "INICIAR SESIÓN" or "CREAR CUENTA", false, loginWindow)
    guiSetFont(titleLabel, "default-bold")
    guiLabelSetHorizontalAlign(titleLabel, "center", true)
    guiLabelSetColor(titleLabel, colors.text[1], colors.text[2], colors.text[3])
    
    -- Campo de usuario
    local userLabel = guiCreateLabel(30, 90, 100, 20, "Usuario:", false, loginWindow)
    guiLabelSetColor(userLabel, colors.text[1], colors.text[2], colors.text[3])
    local userEdit = guiCreateEdit(30, 110, windowWidth - 60, 35, "", false, loginWindow)
    guiSetProperty(userEdit, "NormalTextColour", "FF" .. string.format("%02X%02X%02X", colors.text[1], colors.text[2], colors.text[3]))
    
    -- Campo de contraseña
    local passLabel = guiCreateLabel(30, 160, 100, 20, "Contraseña:", false, loginWindow)
    guiLabelSetColor(passLabel, colors.text[1], colors.text[2], colors.text[3])
    local passEdit = guiCreateEdit(30, 180, windowWidth - 60, 35, "", false, loginWindow)
    guiEditSetMasked(passEdit, true)
    guiSetProperty(passEdit, "NormalTextColour", "FF" .. string.format("%02X%02X%02X", colors.text[1], colors.text[2], colors.text[3]))
    
    -- Campo de confirmar contraseña (solo en modo registro)
    local confirmPassLabel = nil
    local confirmPassEdit = nil
    if not isLoginMode then
        confirmPassLabel = guiCreateLabel(30, 230, 150, 20, "Confirmar Contraseña:", false, loginWindow)
        guiLabelSetColor(confirmPassLabel, colors.text[1], colors.text[2], colors.text[3])
        confirmPassEdit = guiCreateEdit(30, 250, windowWidth - 60, 35, "", false, loginWindow)
        guiEditSetMasked(confirmPassEdit, true)
        guiSetProperty(confirmPassEdit, "NormalTextColour", "FF" .. string.format("%02X%02X%02X", colors.text[1], colors.text[2], colors.text[3]))
    end
    
    -- Campo de email (solo en modo registro)
    local emailLabel = nil
    local emailEdit = nil
    if not isLoginMode then
        emailLabel = guiCreateLabel(30, 300, 100, 20, "Email:", false, loginWindow)
        guiLabelSetColor(emailLabel, colors.text[1], colors.text[2], colors.text[3])
        emailEdit = guiCreateEdit(30, 320, windowWidth - 60, 35, "", false, loginWindow)
        guiSetProperty(emailEdit, "NormalTextColour", "FF" .. string.format("%02X%02X%02X", colors.text[1], colors.text[2], colors.text[3]))
    end
    
    -- Botón principal (Login o Registrar)
    local buttonY = isLoginMode and 250 or 380
    local mainButton = guiCreateButton(30, buttonY, windowWidth - 60, 45, isLoginMode and "INICIAR SESIÓN" or "CREAR CUENTA", false, loginWindow)
    guiSetFont(mainButton, "default-bold")
    
    -- Botón para cambiar entre login y registro
    local switchButton = guiCreateButton(30, buttonY + 60, windowWidth - 60, 35, isLoginMode and "¿No tienes cuenta? Regístrate" or "¿Ya tienes cuenta? Inicia sesión", false, loginWindow)
    
    -- Label de mensajes
    local messageLabel = guiCreateLabel(30, buttonY + 105, windowWidth - 60, 30, "", false, loginWindow)
    guiLabelSetHorizontalAlign(messageLabel, "center", true)
    guiLabelSetColor(messageLabel, colors.danger[1], colors.danger[2], colors.danger[3])
    guiSetVisible(messageLabel, false)
    
    -- Guardar referencias en la ventana
    setElementData(loginWindow, "userEdit", userEdit)
    setElementData(loginWindow, "passEdit", passEdit)
    setElementData(loginWindow, "confirmPassEdit", confirmPassEdit)
    setElementData(loginWindow, "emailEdit", emailEdit)
    setElementData(loginWindow, "mainButton", mainButton)
    setElementData(loginWindow, "switchButton", switchButton)
    setElementData(loginWindow, "messageLabel", messageLabel)
    setElementData(loginWindow, "titleLabel", titleLabel)
    
    -- Eventos
    addEventHandler("onClientGUIClick", mainButton, function()
        handleMainButtonClick()
    end, false)
    
    addEventHandler("onClientGUIClick", switchButton, function()
        switchMode()
    end, false)
    
    -- Permitir Enter para enviar
    addEventHandler("onClientGUIAccepted", userEdit, function()
        handleMainButtonClick()
    end)
    
    addEventHandler("onClientGUIAccepted", passEdit, function()
        handleMainButtonClick()
    end)
    
    if confirmPassEdit then
        addEventHandler("onClientGUIAccepted", confirmPassEdit, function()
            handleMainButtonClick()
        end)
    end
    
    if emailEdit then
        addEventHandler("onClientGUIAccepted", emailEdit, function()
            handleMainButtonClick()
        end)
    end
    
    showCursor(true)
    guiSetInputEnabled(true)
end

-- Cambiar entre modo login y registro
function switchMode()
    isLoginMode = not isLoginMode
    createLoginWindow()
end

-- Manejar el clic del botón principal
function handleMainButtonClick()
    local userEdit = getElementData(loginWindow, "userEdit")
    local passEdit = getElementData(loginWindow, "passEdit")
    local confirmPassEdit = getElementData(loginWindow, "confirmPassEdit")
    local emailEdit = getElementData(loginWindow, "emailEdit")
    local messageLabel = getElementData(loginWindow, "messageLabel")
    
    local username = guiGetText(userEdit)
    local password = guiGetText(passEdit)
    
    -- Validaciones básicas
    if string.len(username) < 3 then
        showMessage("El usuario debe tener al menos 3 caracteres", true)
        return
    end
    
    if string.len(password) < 4 then
        showMessage("La contraseña debe tener al menos 4 caracteres", true)
        return
    end
    
    if isLoginMode then
        -- Login - Verificar que el servidor esté listo
        if not serverReady then
            showMessage("El servidor aún no está listo. Por favor espera un momento...", true)
            -- Reintentar después de un segundo
            setTimer(function()
                if serverReady then
                    handleMainButtonClick() -- Reintentar
                else
                    showMessage("Error: El servidor no responde. Intenta reconectarte.", true)
                end
            end, 1000, 1)
            return
        end
        
        -- Verificar que el recurso esté corriendo
        local loginResource = getResourceFromName("login")
        if not loginResource or getResourceState(loginResource) ~= "running" then
            showMessage("El sistema de login no está disponible. Por favor espera un momento.", true)
            return
        end
        
        -- Activar el evento directamente ya que el servidor está listo
        triggerServerEvent("onPlayerCustomLogin", localPlayer, username, password)
    else
        -- Registro
        local confirmPassword = guiGetText(confirmPassEdit)
        local email = guiGetText(emailEdit)
        
        if password ~= confirmPassword then
            showMessage("Las contraseñas no coinciden", true)
            return
        end
        
        if string.len(email) < 5 or not string.find(email, "@") then
            showMessage("Por favor ingresa un email válido", true)
            return
        end
        
        -- Verificar que el recurso esté listo
        if not getResourceFromName("login") or getResourceState(getResourceFromName("login")) ~= "running" then
            showMessage("El sistema de registro no está disponible. Por favor espera un momento.", true)
            return
        end
        triggerServerEvent("onPlayerRegister", localPlayer, username, password, email)
    end
end

-- Mostrar mensaje
function showMessage(message, isError)
    local messageLabel = getElementData(loginWindow, "messageLabel")
    if messageLabel then
        guiSetText(messageLabel, message)
        guiSetVisible(messageLabel, true)
        if isError then
            guiLabelSetColor(messageLabel, colors.danger[1], colors.danger[2], colors.danger[3])
        else
            guiLabelSetColor(messageLabel, colors.success[1], colors.success[2], colors.success[3])
        end
        setTimer(function()
            guiSetVisible(messageLabel, false)
        end, 5000, 1)
    end
end

-- Eventos del servidor
addEvent("onLoginResult", true)
addEventHandler("onLoginResult", root, function(success, message, characters)
    if success then
        showMessage(message or "¡Bienvenido!", false)
        setTimer(function()
            destroyLoginWindow()
            -- Mostrar panel de selección de personajes
            if characters then
                showCharacterSelection(characters)
            else
                showCharacterSelection({})
            end
        end, 1500, 1)
    else
        showMessage(message or "Error al iniciar sesión", true)
    end
end)

addEvent("onRegisterResult", true)
addEventHandler("onRegisterResult", root, function(success, message)
    if success then
        showMessage("¡Cuenta creada exitosamente! Ahora puedes iniciar sesión.", false)
        setTimer(function()
            -- Cambiar a modo login y mostrar el panel
            isLoginMode = true
            createLoginWindow()
            outputChatBox("Por favor inicia sesión con tu nueva cuenta", 0, 255, 0)
        end, 2000, 1)
    else
        showMessage(message or "Error al crear la cuenta", true)
    end
end)

-- Cerrar ventana
function destroyLoginWindow()
    if loginWindow then
        destroyElement(loginWindow)
        loginWindow = nil
        showCursor(false)
        guiSetInputEnabled(false)
    end
end

-- Evento del servidor para confirmar que está listo
addEvent("onLoginServerReady", true)
addEventHandler("onLoginServerReady", root, function()
    serverReady = true
    -- No mostrar mensaje para no molestar, solo activar el flag
end)

-- Evento del servidor para forzar login
addEvent("onPlayerMustLogin", true)
addEventHandler("onPlayerMustLogin", root, function()
    -- Asegurar que la cámara esté desactivada
    fadeCamera(false, 0)
    setCameraTarget(localPlayer, nil)
    
    -- Prevenir cualquier movimiento o acción
    toggleControl("forwards", false)
    toggleControl("backwards", false)
    toggleControl("left", false)
    toggleControl("right", false)
    toggleControl("fire", false)
    toggleControl("action", false)
    
    -- Mostrar login
    if not loginWindow or not guiGetVisible(loginWindow) then
        createLoginWindow()
    end
end)

-- Mostrar ventana cuando el jugador se conecta o cuando el recurso inicia
-- SIEMPRE mostrar login primero, sin importar si hay datos guardados
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Asegurar que la cámara esté desactivada
    fadeCamera(false)
    setCameraTarget(localPlayer, nil)
    
    -- Esperar un poco para asegurar que el servidor esté listo
    setTimer(function()
        -- Siempre mostrar login, el servidor verificará si ya está logueado
        if not loginWindow or not guiGetVisible(loginWindow) then
            createLoginWindow()
        end
    end, 1500, 1)
end)

-- También mostrar cuando el jugador se une al juego
addEventHandler("onClientPlayerJoin", root, function()
    if source == localPlayer then
        -- Desactivar cámara inmediatamente
        fadeCamera(false, 0)
        setCameraTarget(localPlayer, nil)
        
        -- Prevenir controles
        toggleControl("forwards", false)
        toggleControl("backwards", false)
        toggleControl("left", false)
        toggleControl("right", false)
        toggleControl("fire", false)
        toggleControl("action", false)
        
        setTimer(function()
            -- Siempre mostrar login primero
            if not loginWindow or not guiGetVisible(loginWindow) then
                createLoginWindow()
            end
        end, 500, 1) -- Reducido a 500ms para mostrar más rápido
    end
end)

-- Asegurar que el login se muestre al conectar
addEventHandler("onClientResourceStart", getRootElement(), function(resource)
    if resource == getThisResource() then
        setTimer(function()
            if not loginWindow or not guiGetVisible(loginWindow) then
                createLoginWindow()
            end
        end, 2000, 1)
    end
end)

-- ==================== PANEL DE SELECCIÓN DE PERSONAJES ====================

-- Mostrar panel de selección de personajes
function showCharacterSelection(characters)
    if characterWindow then
        destroyElement(characterWindow)
    end
    
    local windowWidth, windowHeight = 700, 500
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    characterWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Colombia RP - Selección de Personaje", false)
    guiWindowSetMovable(characterWindow, true)
    guiWindowSetSizable(characterWindow, false)
    guiSetAlpha(characterWindow, 1)
    guiSetVisible(characterWindow, true)
    
    -- Título
    local titleLabel = guiCreateLabel(20, 30, windowWidth - 40, 40, "SELECCIONA TU PERSONAJE", false, characterWindow)
    guiSetFont(titleLabel, "default-bold")
    guiLabelSetHorizontalAlign(titleLabel, "center", true)
    guiLabelSetColor(titleLabel, colors.text[1], colors.text[2], colors.text[3])
    
    -- Gridlist para mostrar personajes
    local charList = guiCreateGridList(30, 80, windowWidth - 60, 300, false, characterWindow)
    guiGridListAddColumn(charList, "ID", 0.1)
    guiGridListAddColumn(charList, "Nombre", 0.25)
    guiGridListAddColumn(charList, "Apellido", 0.25)
    guiGridListAddColumn(charList, "Edad", 0.1)
    guiGridListAddColumn(charList, "Género", 0.15)
    guiGridListAddColumn(charList, "Dinero", 0.15)
    
    -- Llenar la lista con personajes
    if #characters > 0 then
        for _, char in ipairs(characters) do
            local row = guiGridListAddRow(charList)
            guiGridListSetItemText(charList, row, 1, tostring(char.id), false, false)
            guiGridListSetItemText(charList, row, 2, char.name, false, false)
            guiGridListSetItemText(charList, row, 3, char.surname or "", false, false)
            guiGridListSetItemText(charList, row, 4, tostring(char.age), false, false)
            guiGridListSetItemText(charList, row, 5, char.gender == 0 and "Masculino" or "Femenino", false, false)
            guiGridListSetItemText(charList, row, 6, "$" .. tostring(char.money), false, false)
            guiGridListSetItemData(charList, row, 1, char.id)
        end
    else
        -- Mensaje si no hay personajes
        local row = guiGridListAddRow(charList)
        guiGridListSetItemText(charList, row, 1, "", false, false)
        guiGridListSetItemText(charList, row, 2, "No tienes personajes", false, false)
        guiGridListSetItemText(charList, row, 3, "Crea uno nuevo", false, false)
        guiGridListSetItemText(charList, row, 4, "", false, false)
        guiGridListSetItemText(charList, row, 5, "", false, false)
        guiGridListSetItemText(charList, row, 6, "", false, false)
        guiSetEnabled(selectButton, false)
    end
    
    -- Botones
    local selectButton = guiCreateButton(30, 390, 150, 40, "SELECCIONAR", false, characterWindow)
    guiSetFont(selectButton, "default-bold")
    
    local createButton = guiCreateButton(200, 390, 150, 40, "CREAR PERSONAJE", false, characterWindow)
    guiSetFont(createButton, "default-bold")
    
    local refreshButton = guiCreateButton(370, 390, 150, 40, "ACTUALIZAR", false, characterWindow)
    
    local infoLabel = guiCreateLabel(30, 440, windowWidth - 60, 30, "Máximo 3 personajes por cuenta", false, characterWindow)
    guiLabelSetHorizontalAlign(infoLabel, "center", true)
    guiLabelSetColor(infoLabel, colors.text[1], colors.text[2], colors.text[3])
    
    -- Guardar referencias
    setElementData(characterWindow, "charList", charList)
    setElementData(characterWindow, "selectButton", selectButton)
    setElementData(characterWindow, "createButton", createButton)
    setElementData(characterWindow, "characters", characters)
    
    -- Eventos
    addEventHandler("onClientGUIClick", selectButton, function()
        if #characters == 0 then
            outputChatBox("No tienes personajes. Crea uno primero.", 255, 0, 0)
            return
        end
        
        local selectedRow = guiGridListGetSelectedItem(charList)
        if selectedRow == -1 then
            outputChatBox("Por favor selecciona un personaje", 255, 0, 0)
            return
        end
        
        local charId = guiGridListGetItemData(charList, selectedRow, 1)
        if charId then
            triggerServerEvent("onPlayerSelectCharacter", localPlayer, charId)
        end
    end, false)
    
    addEventHandler("onClientGUIClick", createButton, function()
        showCreateCharacterWindow()
    end, false)
    
    addEventHandler("onClientGUIClick", refreshButton, function()
        -- Recargar personajes desde el servidor
        triggerServerEvent("onRequestCharacters", localPlayer)
    end, false)
    
    showCursor(true)
    guiSetInputEnabled(true)
end

-- Ventana para crear personaje
function showCreateCharacterWindow()
    if characterWindow then
        guiSetVisible(characterWindow, false)
    end
    
    local windowWidth, windowHeight = 500, 600
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    local createWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Colombia RP - Crear Personaje", false)
    guiWindowSetMovable(createWindow, true)
    guiWindowSetSizable(createWindow, false)
    guiSetAlpha(createWindow, 1)
    guiSetVisible(createWindow, true)
    
    -- Título
    local titleLabel = guiCreateLabel(20, 30, windowWidth - 40, 40, "CREAR NUEVO PERSONAJE", false, createWindow)
    guiSetFont(titleLabel, "default-bold")
    guiLabelSetHorizontalAlign(titleLabel, "center", true)
    guiLabelSetColor(titleLabel, colors.text[1], colors.text[2], colors.text[3])
    
    -- Nombre
    local nameLabel = guiCreateLabel(30, 90, 100, 20, "Nombre:", false, createWindow)
    guiLabelSetColor(nameLabel, colors.text[1], colors.text[2], colors.text[3])
    local nameEdit = guiCreateEdit(30, 110, windowWidth - 60, 35, "", false, createWindow)
    
    -- Apellido
    local surnameLabel = guiCreateLabel(30, 160, 100, 20, "Apellido:", false, createWindow)
    guiLabelSetColor(surnameLabel, colors.text[1], colors.text[2], colors.text[3])
    local surnameEdit = guiCreateEdit(30, 180, windowWidth - 60, 35, "", false, createWindow)
    
    -- Edad
    local ageLabel = guiCreateLabel(30, 230, 100, 20, "Edad:", false, createWindow)
    guiLabelSetColor(ageLabel, colors.text[1], colors.text[2], colors.text[3])
    local ageEdit = guiCreateEdit(30, 250, windowWidth - 60, 35, "18", false, createWindow)
    
    -- Género
    local genderLabel = guiCreateLabel(30, 300, 100, 20, "Género:", false, createWindow)
    guiLabelSetColor(genderLabel, colors.text[1], colors.text[2], colors.text[3])
    local genderCombo = guiCreateComboBox(30, 320, windowWidth - 60, 35, "Masculino", false, createWindow)
    guiComboBoxAddItem(genderCombo, "Masculino")
    guiComboBoxAddItem(genderCombo, "Femenino")
    
    -- Skin
    local skinLabel = guiCreateLabel(30, 370, 100, 20, "Skin ID:", false, createWindow)
    guiLabelSetColor(skinLabel, colors.text[1], colors.text[2], colors.text[3])
    local skinEdit = guiCreateEdit(30, 390, windowWidth - 60, 35, "0", false, createWindow)
    
    -- Botones
    local createButton = guiCreateButton(30, 450, windowWidth - 60, 45, "CREAR PERSONAJE", false, createWindow)
    guiSetFont(createButton, "default-bold")
    
    local cancelButton = guiCreateButton(30, 510, windowWidth - 60, 35, "CANCELAR", false, createWindow)
    
    -- Mensaje
    local messageLabel = guiCreateLabel(30, 555, windowWidth - 60, 30, "", false, createWindow)
    guiLabelSetHorizontalAlign(messageLabel, "center", true)
    guiLabelSetColor(messageLabel, colors.danger[1], colors.danger[2], colors.danger[3])
    guiSetVisible(messageLabel, false)
    
    -- Eventos
    addEventHandler("onClientGUIClick", createButton, function()
        local name = guiGetText(nameEdit)
        local surname = guiGetText(surnameEdit)
        local age = tonumber(guiGetText(ageEdit))
        local genderIndex = guiComboBoxGetSelected(genderCombo)
        local skin = tonumber(guiGetText(skinEdit))
        
        if not name or string.len(name) < 2 then
            showCreateMessage(messageLabel, "El nombre debe tener al menos 2 caracteres", true)
            return
        end
        
        if not age or age < 16 or age > 80 then
            showCreateMessage(messageLabel, "La edad debe estar entre 16 y 80 años", true)
            return
        end
        
        local gender = genderIndex == 1 and 1 or 0
        skin = skin or 0
        
        triggerServerEvent("onPlayerCreateCharacter", localPlayer, name, surname, age, gender, skin)
    end, false)
    
    addEventHandler("onClientGUIClick", cancelButton, function()
        destroyElement(createWindow)
        if characterWindow then
            guiSetVisible(characterWindow, true)
        end
    end, false)
end

function showCreateMessage(label, message, isError)
    if label then
        guiSetText(label, message)
        guiSetVisible(label, true)
        if isError then
            guiLabelSetColor(label, colors.danger[1], colors.danger[2], colors.danger[3])
        else
            guiLabelSetColor(label, colors.success[1], colors.success[2], colors.success[3])
        end
        setTimer(function()
            guiSetVisible(label, false)
        end, 5000, 1)
    end
end

-- Cerrar ventana de personajes
function destroyCharacterWindow()
    if characterWindow then
        destroyElement(characterWindow)
        characterWindow = nil
    end
end

-- Eventos del servidor para personajes
addEvent("onCharacterCreateResult", true)
addEventHandler("onCharacterCreateResult", root, function(success, message, newChar)
    if success then
        outputChatBox(message or "Personaje creado exitosamente", 0, 255, 0)
        -- Cerrar todas las ventanas y actualizar lista
        local windows = getElementsByType("gui-window", resourceRoot)
        for _, window in ipairs(windows) do
            if window ~= characterWindow then
                destroyElement(window)
            end
        end
        -- Actualizar lista de personajes
        setTimer(function()
            triggerServerEvent("onRequestCharacters", localPlayer)
        end, 500, 1)
    else
        outputChatBox(message or "Error al crear el personaje", 255, 0, 0)
    end
end)

-- Variable para almacenar el rol del jugador
local playerRole = "user"

addEvent("onCharacterSelectResult", true)
addEventHandler("onCharacterSelectResult", root, function(success, message)
    if success then
        outputChatBox(message or "Personaje seleccionado", 0, 255, 0)
        destroyCharacterWindow()
        showCursor(false)
        guiSetInputEnabled(false)
        
        -- Reactivar controles
        toggleControl("forwards", true)
        toggleControl("backwards", true)
        toggleControl("left", true)
        toggleControl("right", true)
        toggleControl("fire", true)
        toggleControl("action", true)
        
        -- El control de salto se configurará según el rol cuando se reciba onPlayerRoleSet
        toggleControl("jump", true) -- Permitir saltar normalmente por ahora
        
        -- Asegurar que la cámara esté activada después de seleccionar personaje
        setTimer(function()
            fadeCamera(true, 1.0)
            setCameraTarget(localPlayer, localPlayer)
            
            -- Desactivar jetpack si lo tiene y no es admin
            if doesPedHaveJetPack(localPlayer) and playerRole ~= "admin" then
                removePedJetPack(localPlayer)
            end
        end, 500, 1)
        
        -- Iniciar monitoreo continuo del jetpack y prevención de vuelo (solo si no es admin)
        if playerRole ~= "admin" then
            startJetpackMonitoring()
            startFlightPrevention()
        else
            stopJetpackMonitoring()
            stopFlightPrevention()
        end
    else
        outputChatBox(message or "Error al seleccionar el personaje", 255, 0, 0)
    end
end)

-- Evento para recibir el rol del jugador desde el servidor
addEvent("onPlayerRoleSet", true)
addEventHandler("onPlayerRoleSet", root, function(role)
    playerRole = role or "user"
    
    -- Si no es admin, iniciar prevención de vuelo tipo superman
    if playerRole ~= "admin" then
        -- Iniciar sistema de prevención de vuelo
        startFlightPrevention()
        startJetpackMonitoring()
    else
        -- Si es admin, detener cualquier prevención
        stopFlightPrevention()
        stopJetpackMonitoring()
    end
end)

addEvent("onShowCharacterSelection", true)
addEventHandler("onShowCharacterSelection", root, function(characters)
    showCharacterSelection(characters)
end)

addEvent("onCharactersUpdated", true)
addEventHandler("onCharactersUpdated", root, function(characters)
    if characterWindow then
        destroyCharacterWindow()
    end
    showCharacterSelection(characters or {})
end)

-- Solicitar personajes al servidor
addEvent("onRequestCharacters", true)

-- Cerrar con ESC
addEventHandler("onClientKey", root, function(key, press)
    if key == "escape" and press then
        if loginWindow and guiGetVisible(loginWindow) then
            -- No permitir cerrar con ESC, debe hacer login
            cancelEvent()
        elseif characterWindow and guiGetVisible(characterWindow) then
            -- No permitir cerrar con ESC, debe seleccionar personaje
            cancelEvent()
        end
    end
end)

-- ==================== PREVENCIÓN DE VUELO TIPO SUPERMAN ====================
local jetpackMonitorTimer = nil
local flightPreventionTimer = nil
local lastPosition = {x = 0, y = 0, z = 0}
local lastGroundZ = 0

function startJetpackMonitoring()
    -- Detener el timer anterior si existe
    if jetpackMonitorTimer then
        killTimer(jetpackMonitorTimer)
    end
    
    -- Monitorear jetpack cada 100ms (solo para usuarios no-admin)
    jetpackMonitorTimer = setTimer(function()
        if playerRole ~= "admin" and doesPedHaveJetPack(localPlayer) then
            -- Verificar con el servidor y quitar jetpack
            triggerServerEvent("onClientCheckJetpack", localPlayer)
        end
    end, 100, 0)
end

function stopJetpackMonitoring()
    if jetpackMonitorTimer then
        killTimer(jetpackMonitorTimer)
        jetpackMonitorTimer = nil
    end
end

function startFlightPrevention()
    -- Detener el timer anterior si existe
    if flightPreventionTimer then
        killTimer(flightPreventionTimer)
    end
    
    -- Monitorear y prevenir vuelo tipo superman (solo si está volando hacia arriba, NO interferir con caídas)
    flightPreventionTimer = setTimer(function()
        if playerRole ~= "admin" then
            -- Solo prevenir si el jugador está en el juego y no está en un vehículo
            if not isPedInVehicle(localPlayer) then
                local x, y, z = getElementPosition(localPlayer)
                local groundZ = getGroundPosition(x, y, z)
                local distanceToGround = z - groundZ
                local velocityX, velocityY, velocityZ = getElementVelocity(localPlayer)
                
                -- Solo prevenir si está MUY alto (más de 15 unidades) Y está subiendo o flotando
                -- NO interferir si está cayendo (velocityZ negativo = cayendo normalmente)
                if distanceToGround > 15.0 then
                    -- Solo prevenir si está subiendo (velocidad positiva) o flotando (velocidad casi 0)
                    -- Si está cayendo (velocityZ negativo), NO interferir para evitar daño extra
                    if velocityZ > 0.3 then
                        -- Está subiendo a gran altura = vuelo, detener ascenso y dejar caer naturalmente
                        setElementVelocity(localPlayer, velocityX, velocityY, 0)
                    elseif velocityZ > -0.1 and velocityZ < 0.1 and distanceToGround > 20.0 then
                        -- Flotando a gran altura, iniciar caída suave
                        setElementVelocity(localPlayer, velocityX, velocityY, -0.1)
                    end
                    -- NO hacer nada si velocityZ es negativo (está cayendo normalmente)
                end
                
                lastPosition = {x = x, y = y, z = z}
                lastGroundZ = groundZ
            end
        end
    end, 150, 0) -- Verificar cada 150ms (menos frecuente para no interferir con caídas normales)
end

function stopFlightPrevention()
    if flightPreventionTimer then
        killTimer(flightPreventionTimer)
        flightPreventionTimer = nil
    end
end

-- Prevenir jetpack si lo tiene (ya no necesitamos prevenir Shift porque el gamemode play está deshabilitado)
addEventHandler("onClientKey", root, function(button, press)
    if playerRole ~= "admin" then
        -- Prevenir jetpack si lo tiene
        if (button == "lshift" or button == "rshift") and press then
            setTimer(function()
                if doesPedHaveJetPack(localPlayer) then
                    triggerServerEvent("onClientCheckJetpack", localPlayer)
                end
            end, 50, 1)
        end
    end
end)

-- Detener monitoreo cuando el jugador se desconecta
addEventHandler("onClientResourceStop", resourceRoot, function()
    stopJetpackMonitoring()
    stopFlightPrevention()
end)

