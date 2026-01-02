-- Panel de Administración - F10
-- Panel para Admin, Staff, Legal e Ilegal

local screenW, screenH = guiGetScreenSize()
local panelVisible = false

-- Variables para el panel
local adminWindow = nil
local adminButtons = {}
local inputWindow = nil
local inputEdit = nil
local inputButton = nil
local currentAction = nil

-- Función para obtener el tipo de usuario
function getUserType()
    if not getElementData(localPlayer, "character:selected") then
        return "none"
    end
    
    local role = getElementData(localPlayer, "account:role")
    local job = getElementData(localPlayer, "character:job") or "Desempleado"
    
    -- Verificar si es admin
    if role == "admin" then
        return "admin"
    end
    
    -- Verificar si es staff (puedes expandir esto según tu sistema)
    if role == "staff" or role == "moderator" then
        return "staff"
    end
    
    -- Facciones legales
    local legalJobs = {"Policía", "Médico", "Mecánico", "Periodista", "Gobierno", "Juez"}
    for _, legalJob in ipairs(legalJobs) do
        if job == legalJob then
            return "legal"
        end
    end
    
    -- Facciones ilegales (puedes expandir esto)
    local illegalJobs = {"Gangster", "Mafioso", "Traficante"}
    for _, illegalJob in ipairs(illegalJobs) do
        if job == illegalJob then
            return "ilegal"
        end
    end
    
    return "none"
end

-- Función para crear el panel de admin
function createAdminPanel()
    if adminWindow and isElement(adminWindow) then
        destroyElement(adminWindow)
    end
    
    local userType = getUserType()
    
    if userType == "none" then
        outputChatBox("No tienes acceso al panel de administración.", 255, 0, 0)
        return
    end
    
    panelVisible = true
    showCursor(true)
    
    -- Crear ventana principal
    local windowWidth = 400
    local windowHeight = 500
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    adminWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Panel de Administración - " .. string.upper(userType), false)
    guiWindowSetSizable(adminWindow, false)
    
    -- Título según el tipo de usuario
    local titleText = ""
    if userType == "admin" then
        titleText = "Panel de Administrador"
    elseif userType == "staff" then
        titleText = "Panel de Staff"
    elseif userType == "legal" then
        titleText = "Panel Legal"
    elseif userType == "ilegal" then
        titleText = "Panel Ilegal"
    end
    
    local titleLabel = guiCreateLabel(10, 30, windowWidth - 20, 30, titleText, false, adminWindow)
    guiLabelSetHorizontalAlign(titleLabel, "center", false)
    guiSetFont(titleLabel, "default-bold")
    
    -- Crear botones según el tipo de usuario
    local buttonY = 70
    local buttonHeight = 35
    local buttonSpacing = 45
    
    if userType == "admin" then
        -- Botón: Revivir Usuario
        local revivirBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Revivir Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", revivirBtn, function()
            showReviveInput()
        end, false)
        table.insert(adminButtons, revivirBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Teleportar a Usuario
        local teleportBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Teleportar a Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", teleportBtn, function()
            outputChatBox("Función en desarrollo...", 255, 255, 0)
        end, false)
        table.insert(adminButtons, teleportBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Dar Dinero
        local darDineroBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Dar Dinero", false, adminWindow)
        addEventHandler("onClientGUIClick", darDineroBtn, function()
            outputChatBox("Función en desarrollo...", 255, 255, 0)
        end, false)
        table.insert(adminButtons, darDineroBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Ver Coordenadas
        local coordsBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Ver Coordenadas", false, adminWindow)
        addEventHandler("onClientGUIClick", coordsBtn, function()
            triggerServerEvent("admin:getCoords", localPlayer)
        end, false)
        table.insert(adminButtons, coordsBtn)
        buttonY = buttonY + buttonSpacing
    elseif userType == "staff" then
        -- Botones para staff (se pueden agregar más adelante)
        local staffBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Funciones de Staff", false, adminWindow)
        addEventHandler("onClientGUIClick", staffBtn, function()
            outputChatBox("Funciones de staff en desarrollo...", 255, 255, 0)
        end, false)
        table.insert(adminButtons, staffBtn)
    elseif userType == "legal" then
        -- Botones para facciones legales
        local legalBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Funciones Legales", false, adminWindow)
        addEventHandler("onClientGUIClick", legalBtn, function()
            outputChatBox("Funciones legales en desarrollo...", 255, 255, 0)
        end, false)
        table.insert(adminButtons, legalBtn)
    elseif userType == "ilegal" then
        -- Botones para facciones ilegales
        local ilegalBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Funciones Ilegales", false, adminWindow)
        addEventHandler("onClientGUIClick", ilegalBtn, function()
            outputChatBox("Funciones ilegales en desarrollo...", 255, 255, 0)
        end, false)
        table.insert(adminButtons, ilegalBtn)
    end
    
    -- Botón: Cerrar
    local closeBtn = guiCreateButton(20, windowHeight - 50, windowWidth - 40, 35, "Cerrar", false, adminWindow)
    addEventHandler("onClientGUIClick", closeBtn, function()
        closeAdminPanel()
    end, false)
end

-- Función para mostrar el input de revivir
function showReviveInput()
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
    end
    
    currentAction = "revivir"
    
    local windowWidth = 350
    local windowHeight = 150
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    inputWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Revivir Usuario", false)
    guiWindowSetSizable(inputWindow, false)
    
    local label = guiCreateLabel(10, 30, windowWidth - 20, 20, "Ingresa el ID del personaje a revivir:", false, inputWindow)
    
    inputEdit = guiCreateEdit(10, 55, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(inputEdit, 10)
    
    local acceptBtn = guiCreateButton(10, 95, (windowWidth - 30) / 2, 30, "Revivir", false, inputWindow)
    addEventHandler("onClientGUIClick", acceptBtn, function()
        local characterId = guiGetText(inputEdit)
        if characterId and characterId ~= "" then
            local id = tonumber(characterId)
            if id then
                triggerServerEvent("admin:revivePlayer", localPlayer, id)
                closeInputWindow()
            else
                outputChatBox("El ID debe ser un número válido.", 255, 0, 0)
            end
        else
            outputChatBox("Debes ingresar un ID de personaje.", 255, 0, 0)
        end
    end, false)
    
    local cancelBtn = guiCreateButton((windowWidth - 10) / 2 + 5, 95, (windowWidth - 30) / 2, 30, "Cancelar", false, inputWindow)
    addEventHandler("onClientGUIClick", cancelBtn, function()
        closeInputWindow()
    end, false)
end

-- Función para cerrar el input window
function closeInputWindow()
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
        inputWindow = nil
        inputEdit = nil
        currentAction = nil
    end
end

-- Función para cerrar el panel
function closeAdminPanel()
    if adminWindow and isElement(adminWindow) then
        destroyElement(adminWindow)
        adminWindow = nil
        adminButtons = {}
    end
    
    closeInputWindow()
    
    panelVisible = false
    showCursor(false)
end

-- Bind F10 para abrir/cerrar el panel
bindKey("F10", "down", function()
    if not getElementData(localPlayer, "character:selected") then
        outputChatBox("Debes tener un personaje seleccionado para usar el panel.", 255, 0, 0)
        return
    end
    
    if panelVisible then
        closeAdminPanel()
    else
        createAdminPanel()
    end
end)

-- Cerrar panel al presionar ESC
addEventHandler("onClientGUIClick", root, function()
    if source and isElement(source) then
        local elementType = getElementType(source)
        if elementType == "gui-window" and source == adminWindow then
            -- Si se hace click fuera de la ventana, no hacer nada
        end
    end
end)

-- Evento para recibir respuesta del servidor
addEvent("admin:reviveResponse", true)
addEventHandler("admin:reviveResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

