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
    
    -- Crear ventana principal (aumentada para más botones)
    local windowWidth = 450
    local windowHeight = 650
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
    
    -- Crear botones según el tipo de usuario (con mejor espaciado)
    local buttonY = 70
    local buttonHeight = 32
    local buttonSpacing = 38
    
    if userType == "admin" then
        -- Botón: Revivir Usuario
        local revivirBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Revivir Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", revivirBtn, function()
            showReviveInput()
        end, false)
        table.insert(adminButtons, revivirBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Ir a Usuario
        local teleportToBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Ir a Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", teleportToBtn, function()
            showTeleportInput("to")
        end, false)
        table.insert(adminButtons, teleportToBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Traer Usuario
        local teleportBringBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Traer Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", teleportBringBtn, function()
            showTeleportInput("bring")
        end, false)
        table.insert(adminButtons, teleportBringBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Dar Dinero
        local darDineroBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Dar Dinero", false, adminWindow)
        addEventHandler("onClientGUIClick", darDineroBtn, function()
            showGiveMoneyInput()
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
        
        -- Botón: Invisibilidad (actualizar texto según estado)
        local isInvisible = getElementData(localPlayer, "admin:invisible") or false
        local invisibleBtnText = isInvisible and "Hacerse Visible" or "Hacerse Invisible"
        local invisibleBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, invisibleBtnText, false, adminWindow)
        addEventHandler("onClientGUIClick", invisibleBtn, function()
            triggerServerEvent("admin:toggleInvisibility", localPlayer)
            -- Cerrar y reabrir el panel para actualizar el texto del botón
            closeAdminPanel()
            setTimer(function()
                createAdminPanel()
            end, 100, 1)
        end, false)
        table.insert(adminButtons, invisibleBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Curar Jugador
        local curarBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Curar Jugador", false, adminWindow)
        addEventHandler("onClientGUIClick", curarBtn, function()
            showHealInput()
        end, false)
        table.insert(adminButtons, curarBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Cambiar Skin
        local cambiarSkinBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Cambiar Skin", false, adminWindow)
        addEventHandler("onClientGUIClick", cambiarSkinBtn, function()
            showChangeSkinInput()
        end, false)
        table.insert(adminButtons, cambiarSkinBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Dar Item
        local darItemBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Dar Item", false, adminWindow)
        addEventHandler("onClientGUIClick", darItemBtn, function()
            showGiveItemsPanel()
        end, false)
        table.insert(adminButtons, darItemBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Freecam
        local freecamEnabled = isFreecamEnabled and isFreecamEnabled() or false
        local freecamBtnText = freecamEnabled and "Desactivar Freecam" or "Activar Freecam"
        local freecamBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, freecamBtnText, false, adminWindow)
        addEventHandler("onClientGUIClick", freecamBtn, function()
            if toggleFreecam then
                toggleFreecam()
                -- Cerrar y reabrir el panel para actualizar el texto del botón
                closeAdminPanel()
                setTimer(function()
                    createAdminPanel()
                end, 100, 1)
            end
        end, false)
        table.insert(adminButtons, freecamBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Vehículos
        local vehiculosBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Vehículos", false, adminWindow)
        addEventHandler("onClientGUIClick", vehiculosBtn, function()
            showVehiclesPanel()
        end, false)
        table.insert(adminButtons, vehiculosBtn)
        buttonY = buttonY + buttonSpacing
    elseif userType == "staff" then
        -- Botón: Revivir Usuario
        local revivirBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Revivir Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", revivirBtn, function()
            showReviveInput()
        end, false)
        table.insert(adminButtons, revivirBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Ir a Usuario
        local teleportToBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Ir a Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", teleportToBtn, function()
            showTeleportInput("to")
        end, false)
        table.insert(adminButtons, teleportToBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Traer Usuario
        local teleportBringBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Traer Usuario", false, adminWindow)
        addEventHandler("onClientGUIClick", teleportBringBtn, function()
            showTeleportInput("bring")
        end, false)
        table.insert(adminButtons, teleportBringBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Ver Coordenadas
        local coordsBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Ver Coordenadas", false, adminWindow)
        addEventHandler("onClientGUIClick", coordsBtn, function()
            triggerServerEvent("admin:getCoords", localPlayer)
        end, false)
        table.insert(adminButtons, coordsBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Invisibilidad
        local isInvisible = getElementData(localPlayer, "admin:invisible") or false
        local invisibleBtnText = isInvisible and "Hacerse Visible" or "Hacerse Invisible"
        local invisibleBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, invisibleBtnText, false, adminWindow)
        addEventHandler("onClientGUIClick", invisibleBtn, function()
            triggerServerEvent("admin:toggleInvisibility", localPlayer)
            closeAdminPanel()
            setTimer(function()
                createAdminPanel()
            end, 100, 1)
        end, false)
        table.insert(adminButtons, invisibleBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Curar Jugador
        local curarBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Curar Jugador", false, adminWindow)
        addEventHandler("onClientGUIClick", curarBtn, function()
            showHealInput()
        end, false)
        table.insert(adminButtons, curarBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Cambiar Skin
        local cambiarSkinBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Cambiar Skin", false, adminWindow)
        addEventHandler("onClientGUIClick", cambiarSkinBtn, function()
            showChangeSkinInput()
        end, false)
        table.insert(adminButtons, cambiarSkinBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Dar Item
        local darItemBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, "Dar Item", false, adminWindow)
        addEventHandler("onClientGUIClick", darItemBtn, function()
            showGiveItemsPanel()
        end, false)
        table.insert(adminButtons, darItemBtn)
        buttonY = buttonY + buttonSpacing
        
        -- Botón: Freecam
        local freecamEnabled = isFreecamEnabled and isFreecamEnabled() or false
        local freecamBtnText = freecamEnabled and "Desactivar Freecam" or "Activar Freecam"
        local freecamBtn = guiCreateButton(20, buttonY, windowWidth - 40, buttonHeight, freecamBtnText, false, adminWindow)
        addEventHandler("onClientGUIClick", freecamBtn, function()
            if toggleFreecam then
                toggleFreecam()
                closeAdminPanel()
                setTimer(function()
                    createAdminPanel()
                end, 100, 1)
            end
        end, false)
        table.insert(adminButtons, freecamBtn)
        buttonY = buttonY + buttonSpacing
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
    
    -- Calcular altura necesaria antes de crear el botón cerrar
    local neededHeight = buttonY + buttonSpacing + 80
    if neededHeight > screenH - 100 then
        neededHeight = screenH - 100
    elseif neededHeight < windowHeight then
        neededHeight = windowHeight
    end
    
    -- Ajustar tamaño de la ventana si es necesario
    if neededHeight ~= windowHeight then
        guiSetSize(adminWindow, windowWidth, neededHeight, false)
        guiSetPosition(adminWindow, (screenW - windowWidth) / 2, (screenH - neededHeight) / 2, false)
    end
    
    -- Botón: Cerrar (siempre al final)
    local closeBtn = guiCreateButton(20, neededHeight - 50, windowWidth - 40, 35, "Cerrar", false, adminWindow)
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

-- Función para mostrar el input de teleportar
function showTeleportInput(mode)
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
    end
    
    currentAction = mode == "bring" and "traer" or "teleportar"
    
    local windowWidth = 350
    local windowHeight = 150
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    local title = mode == "bring" and "Traer Usuario" or "Ir a Usuario"
    local labelText = mode == "bring" and "Ingresa el ID del personaje a traer:" or "Ingresa el ID del personaje al que te quieres teleportar:"
    
    inputWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, title, false)
    guiWindowSetSizable(inputWindow, false)
    
    local label = guiCreateLabel(10, 30, windowWidth - 20, 20, labelText, false, inputWindow)
    
    inputEdit = guiCreateEdit(10, 55, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(inputEdit, 10)
    
    local acceptBtn = guiCreateButton(10, 95, (windowWidth - 30) / 2, 30, mode == "bring" and "Traer" or "Teleportar", false, inputWindow)
    addEventHandler("onClientGUIClick", acceptBtn, function()
        local characterId = guiGetText(inputEdit)
        if characterId and characterId ~= "" then
            local id = tonumber(characterId)
            if id then
                if mode == "bring" then
                    triggerServerEvent("admin:bringPlayer", localPlayer, id)
                else
                    triggerServerEvent("admin:teleportToPlayer", localPlayer, id)
                end
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

-- Evento para recibir respuesta del servidor (revivir)
addEvent("admin:reviveResponse", true)
addEventHandler("admin:reviveResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

-- Evento para recibir respuesta del servidor (teleportar)
addEvent("admin:teleportResponse", true)
addEventHandler("admin:teleportResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

-- Función para mostrar el input de curar
function showHealInput()
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
    end
    
    currentAction = "curar"
    
    local windowWidth = 350
    local windowHeight = 150
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    inputWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Curar Jugador", false)
    guiWindowSetSizable(inputWindow, false)
    
    local label = guiCreateLabel(10, 30, windowWidth - 20, 20, "Ingresa el ID del personaje a curar:", false, inputWindow)
    
    inputEdit = guiCreateEdit(10, 55, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(inputEdit, 10)
    
    local acceptBtn = guiCreateButton(10, 95, (windowWidth - 30) / 2, 30, "Curar", false, inputWindow)
    addEventHandler("onClientGUIClick", acceptBtn, function()
        local characterId = guiGetText(inputEdit)
        if characterId and characterId ~= "" then
            local id = tonumber(characterId)
            if id then
                triggerServerEvent("admin:healPlayer", localPlayer, id)
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

-- Evento para recibir respuesta del servidor (curar)
addEvent("admin:healResponse", true)
addEventHandler("admin:healResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

-- Función para mostrar el input de cambiar skin
function showChangeSkinInput()
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
    end
    
    currentAction = "cambiarSkin"
    
    local windowWidth = 350
    local windowHeight = 180
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    inputWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Cambiar Skin", false)
    guiWindowSetSizable(inputWindow, false)
    
    local label1 = guiCreateLabel(10, 30, windowWidth - 20, 20, "ID del personaje:", false, inputWindow)
    local idEdit = guiCreateEdit(10, 50, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(idEdit, 10)
    
    local label2 = guiCreateLabel(10, 85, windowWidth - 20, 20, "ID del skin (0-311):", false, inputWindow)
    local skinEdit = guiCreateEdit(10, 105, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(skinEdit, 5)
    
    local acceptBtn = guiCreateButton(10, 145, (windowWidth - 30) / 2, 30, "Cambiar Skin", false, inputWindow)
    addEventHandler("onClientGUIClick", acceptBtn, function()
        local characterId = guiGetText(idEdit)
        local skinId = guiGetText(skinEdit)
        if characterId and characterId ~= "" and skinId and skinId ~= "" then
            local id = tonumber(characterId)
            local skin = tonumber(skinId)
            if id and skin and skin >= 0 and skin <= 311 then
                triggerServerEvent("admin:changeSkin", localPlayer, id, skin)
                closeInputWindow()
            else
                outputChatBox("El ID debe ser un número válido y el skin debe estar entre 0 y 311.", 255, 0, 0)
            end
        else
            outputChatBox("Debes ingresar un ID de personaje y un ID de skin.", 255, 0, 0)
        end
    end, false)
    
    local cancelBtn = guiCreateButton((windowWidth - 10) / 2 + 5, 145, (windowWidth - 30) / 2, 30, "Cancelar", false, inputWindow)
    addEventHandler("onClientGUIClick", cancelBtn, function()
        closeInputWindow()
    end, false)
end

-- Evento para recibir respuesta del servidor (cambiar skin)
addEvent("admin:changeSkinResponse", true)
addEventHandler("admin:changeSkinResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

-- Función para mostrar el input de cambiar skin
function showChangeSkinInput()
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
    end
    
    currentAction = "cambiarSkin"
    
    local windowWidth = 350
    local windowHeight = 180
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    inputWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Cambiar Skin", false)
    guiWindowSetSizable(inputWindow, false)
    
    local label1 = guiCreateLabel(10, 30, windowWidth - 20, 20, "ID del personaje:", false, inputWindow)
    local idEdit = guiCreateEdit(10, 50, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(idEdit, 10)
    
    local label2 = guiCreateLabel(10, 85, windowWidth - 20, 20, "ID del skin (0-311):", false, inputWindow)
    local skinEdit = guiCreateEdit(10, 105, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(skinEdit, 5)
    
    local acceptBtn = guiCreateButton(10, 145, (windowWidth - 30) / 2, 30, "Cambiar Skin", false, inputWindow)
    addEventHandler("onClientGUIClick", acceptBtn, function()
        local characterId = guiGetText(idEdit)
        local skinId = guiGetText(skinEdit)
        if characterId and characterId ~= "" and skinId and skinId ~= "" then
            local id = tonumber(characterId)
            local skin = tonumber(skinId)
            if id and skin and skin >= 0 and skin <= 311 then
                triggerServerEvent("admin:changeSkin", localPlayer, id, skin)
                closeInputWindow()
            else
                outputChatBox("El ID debe ser un número válido y el skin debe estar entre 0 y 311.", 255, 0, 0)
            end
        else
            outputChatBox("Debes ingresar un ID de personaje y un ID de skin.", 255, 0, 0)
        end
    end, false)
    
    local cancelBtn = guiCreateButton((windowWidth - 10) / 2 + 5, 145, (windowWidth - 30) / 2, 30, "Cancelar", false, inputWindow)
    addEventHandler("onClientGUIClick", cancelBtn, function()
        closeInputWindow()
    end, false)
end

-- Evento para recibir respuesta del servidor (cambiar skin)
addEvent("admin:changeSkinResponse", true)
addEventHandler("admin:changeSkinResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

-- Función para mostrar el input de dar dinero
function showGiveMoneyInput()
    if inputWindow and isElement(inputWindow) then
        destroyElement(inputWindow)
    end
    
    currentAction = "darDinero"
    
    local windowWidth = 350
    local windowHeight = 180
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    inputWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Dar Dinero", false)
    guiWindowSetSizable(inputWindow, false)
    
    local label1 = guiCreateLabel(10, 30, windowWidth - 20, 20, "ID del personaje:", false, inputWindow)
    local idEdit = guiCreateEdit(10, 50, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(idEdit, 10)
    
    local label2 = guiCreateLabel(10, 85, windowWidth - 20, 20, "Cantidad de dinero:", false, inputWindow)
    local amountEdit = guiCreateEdit(10, 105, windowWidth - 20, 30, "", false, inputWindow)
    guiEditSetMaxLength(amountEdit, 15)
    
    local acceptBtn = guiCreateButton(10, 145, (windowWidth - 30) / 2, 30, "Dar Dinero", false, inputWindow)
    addEventHandler("onClientGUIClick", acceptBtn, function()
        local characterId = guiGetText(idEdit)
        local amount = guiGetText(amountEdit)
        if characterId and characterId ~= "" and amount and amount ~= "" then
            local id = tonumber(characterId)
            local moneyAmount = tonumber(amount)
            if id and moneyAmount and moneyAmount > 0 then
                triggerServerEvent("admin:giveMoney", localPlayer, id, moneyAmount)
                closeInputWindow()
            else
                outputChatBox("El ID y la cantidad deben ser números válidos.", 255, 0, 0)
            end
        else
            outputChatBox("Debes ingresar un ID de personaje y una cantidad.", 255, 0, 0)
        end
    end, false)
    
    local cancelBtn = guiCreateButton((windowWidth - 10) / 2 + 5, 145, (windowWidth - 30) / 2, 30, "Cancelar", false, inputWindow)
    addEventHandler("onClientGUIClick", cancelBtn, function()
        closeInputWindow()
    end, false)
end

-- Evento para recibir respuesta del servidor (dar dinero)
addEvent("admin:giveMoneyResponse", true)
addEventHandler("admin:giveMoneyResponse", root, function(success, message)
    if success then
        outputChatBox(message, 0, 255, 0)
    else
        outputChatBox(message, 255, 0, 0)
    end
end)

-- Evento para actualizar el estado de invisibilidad
addEvent("admin:invisibilityUpdate", true)
addEventHandler("admin:invisibilityUpdate", root, function(isInvisible, message)
    outputChatBox(message, 0, 255, 0)
end)

-- Variables para el panel de dar items
local itemsPanel = nil
local itemsList = {}
local selectedItems = {} -- {itemId = quantity}
local itemsListGrid = nil
local itemsQuantityEdit = nil
local itemsCharacterIdEdit = nil
local itemsQuantityLabel = nil

-- Función para mostrar el panel de dar items
function showGiveItemsPanel()
    if itemsPanel and isElement(itemsPanel) then
        destroyElement(itemsPanel)
    end
    
    selectedItems = {}
    
    local windowWidth = 650
    local windowHeight = 580 -- Aumentado para que quepa el botón Cancelar
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    itemsPanel = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Dar Items a Jugador", false)
    guiWindowSetSizable(itemsPanel, false)
    
    -- Label para ID de personaje
    local labelId = guiCreateLabel(10, 30, 150, 20, "ID del Personaje:", false, itemsPanel)
    itemsCharacterIdEdit = guiCreateEdit(10, 50, 200, 30, "", false, itemsPanel)
    guiEditSetMaxLength(itemsCharacterIdEdit, 10)
    
    -- Label para cantidad (solo si hay 1 item seleccionado)
    itemsQuantityLabel = guiCreateLabel(220, 30, 200, 20, "Cantidad (1 item seleccionado):", false, itemsPanel)
    guiSetVisible(itemsQuantityLabel, false)
    itemsQuantityEdit = guiCreateEdit(220, 50, 100, 30, "1", false, itemsPanel)
    guiSetVisible(itemsQuantityEdit, false)
    guiEditSetMaxLength(itemsQuantityEdit, 5)
    
    -- Grid list para items
    local labelItems = guiCreateLabel(10, 90, 300, 20, "Items Disponibles (Selecciona uno o varios):", false, itemsPanel)
    itemsListGrid = guiCreateGridList(10, 110, 630, 350, false, itemsPanel)
    guiGridListAddColumn(itemsListGrid, "ID", 0.08)
    guiGridListAddColumn(itemsListGrid, "Nombre del Item", 0.9)
    guiGridListSetSelectionMode(itemsListGrid, 2) -- Permite selección múltiple
    
    -- Label para items seleccionados
    local selectedLabel = guiCreateLabel(10, 470, 400, 20, "Items seleccionados: Ninguno", false, itemsPanel)
    guiSetFont(selectedLabel, "default-small")
    
    -- Botones
    local selectBtn = guiCreateButton(10, 500, 120, 30, "Seleccionar", false, itemsPanel)
    local deselectBtn = guiCreateButton(140, 500, 120, 30, "Deseleccionar", false, itemsPanel)
    local clearBtn = guiCreateButton(270, 500, 120, 30, "Limpiar Todo", false, itemsPanel)
    local giveBtn = guiCreateButton(400, 500, 120, 30, "Dar Items", false, itemsPanel)
    local cancelBtn = guiCreateButton(530, 500, 110, 30, "Cancelar", false, itemsPanel)
    
    -- Función para actualizar el label de items seleccionados
    local function updateSelectedLabel()
        local count = 0
        local itemsText = {}
        for itemId, quantity in pairs(selectedItems) do
            count = count + 1
            local itemName = "Item " .. itemId
            for _, item in ipairs(itemsList) do
                if item.id == itemId then
                    itemName = item.name
                    break
                end
            end
            table.insert(itemsText, itemName .. " x" .. quantity)
        end
        
        if count == 0 then
            guiSetText(selectedLabel, "Items seleccionados: Ninguno")
        else
            guiSetText(selectedLabel, "Items seleccionados (" .. count .. "): " .. table.concat(itemsText, ", "))
        end
    end
    
    -- Eventos de botones
    addEventHandler("onClientGUIClick", selectBtn, function()
        local row = guiGridListGetSelectedItem(itemsListGrid)
        if row and row >= 0 then
            local itemId = tonumber(guiGridListGetItemText(itemsListGrid, row, 1))
            if itemId then
                -- Si solo hay 1 item seleccionado, mostrar campo de cantidad
                local currentCount = 0
                for _ in pairs(selectedItems) do
                    currentCount = currentCount + 1
                end
                
                if currentCount == 0 then
                    -- Primer item, mostrar cantidad
                    guiSetVisible(itemsQuantityLabel, true)
                    guiSetVisible(itemsQuantityEdit, true)
                    selectedItems[itemId] = 1
                else
                    -- Ya hay items seleccionados, agregar con cantidad 1
                    selectedItems[itemId] = selectedItems[itemId] or 1
                end
                
                -- Marcar visualmente en el grid
                guiGridListSetItemColor(itemsListGrid, row, 1, 0, 255, 0)
                guiGridListSetItemColor(itemsListGrid, row, 2, 0, 255, 0)
                
                updateSelectedLabel()
            end
        else
            outputChatBox("Selecciona un item de la lista.", 255, 255, 0)
        end
    end, false)
    
    addEventHandler("onClientGUIClick", deselectBtn, function()
        local row = guiGridListGetSelectedItem(itemsListGrid)
        if row and row >= 0 then
            local itemId = tonumber(guiGridListGetItemText(itemsListGrid, row, 1))
            if itemId and selectedItems[itemId] then
                selectedItems[itemId] = nil
                
                -- Restaurar color normal
                guiGridListSetItemColor(itemsListGrid, row, 1, 255, 255, 255)
                guiGridListSetItemColor(itemsListGrid, row, 2, 255, 255, 255)
                
                -- Si no hay items seleccionados, ocultar cantidad
                local count = 0
                for _ in pairs(selectedItems) do
                    count = count + 1
                end
                if count == 0 then
                    guiSetVisible(itemsQuantityLabel, false)
                    guiSetVisible(itemsQuantityEdit, false)
                elseif count == 1 then
                    -- Si queda solo 1, mostrar cantidad
                    guiSetVisible(itemsQuantityLabel, true)
                    guiSetVisible(itemsQuantityEdit, true)
                end
                
                updateSelectedLabel()
            end
        else
            outputChatBox("Selecciona un item de la lista para deseleccionar.", 255, 255, 0)
        end
    end, false)
    
    addEventHandler("onClientGUIClick", clearBtn, function()
        -- Limpiar todas las selecciones
        selectedItems = {}
        guiSetVisible(itemsQuantityLabel, false)
        guiSetVisible(itemsQuantityEdit, false)
        
        -- Restaurar colores de todos los items
        for row = 0, guiGridListGetRowCount(itemsListGrid) - 1 do
            guiGridListSetItemColor(itemsListGrid, row, 1, 255, 255, 255)
            guiGridListSetItemColor(itemsListGrid, row, 2, 255, 255, 255)
        end
        
        updateSelectedLabel()
    end, false)
    
    addEventHandler("onClientGUIClick", giveBtn, function()
        local characterId = tonumber(guiGetText(itemsCharacterIdEdit))
        if not characterId then
            outputChatBox("Ingresa un ID de personaje válido.", 255, 0, 0)
            return
        end
        
        local count = 0
        for _ in pairs(selectedItems) do
            count = count + 1
        end
        
        if count == 0 then
            outputChatBox("Selecciona al menos un item.", 255, 0, 0)
            return
        end
        
        -- Preparar datos de items
        local itemsData = {}
        for itemId, quantity in pairs(selectedItems) do
            -- Si solo hay 1 item seleccionado, usar la cantidad del campo
            if count == 1 then
                local customQuantity = tonumber(guiGetText(itemsQuantityEdit)) or 1
                if customQuantity > 0 then
                    quantity = customQuantity
                end
            end
            
            table.insert(itemsData, {
                itemId = itemId,
                quantity = quantity,
                value = 1, -- Valor por defecto, puede ajustarse
                name = nil
            })
        end
        
        triggerServerEvent("admin:giveItems", localPlayer, characterId, itemsData)
    end, false)
    
    addEventHandler("onClientGUIClick", cancelBtn, function()
        if itemsPanel and isElement(itemsPanel) then
            destroyElement(itemsPanel)
            itemsPanel = nil
            itemsListGrid = nil
            itemsQuantityEdit = nil
            itemsCharacterIdEdit = nil
            itemsQuantityLabel = nil
            selectedItems = {}
        end
    end, false)
    
    -- Solicitar lista de items al servidor
    triggerServerEvent("admin:getItemsList", localPlayer)
end

-- Recibir lista de items del servidor
addEvent("admin:receiveItemsList", true)
addEventHandler("admin:receiveItemsList", resourceRoot, function(items)
    itemsList = items or {}
    
    if itemsListGrid and isElement(itemsListGrid) then
        guiGridListClear(itemsListGrid)
        
        for _, item in ipairs(itemsList) do
            local row = guiGridListAddRow(itemsListGrid)
            guiGridListSetItemText(itemsListGrid, row, 1, tostring(item.id), false, false)
            guiGridListSetItemText(itemsListGrid, row, 2, item.name, false, false)
        end
    end
end)

-- Variables para el panel de vehículos
local vehiclesPanel = nil
local vehiclesListGrid = nil
local selectedVehicleId = nil

-- Variables para el panel de vehículos mejorado
local playerIdInput = nil
local generateForPlayerRadio = nil
local generateWithoutOwnerRadio = nil

-- Función para mostrar el panel de vehículos
function showVehiclesPanel()
    -- Cerrar panel anterior si existe
    if vehiclesPanel and isElement(vehiclesPanel) then
        destroyElement(vehiclesPanel)
    end
    
    local windowWidth = 650
    local windowHeight = 550
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    vehiclesPanel = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Sistema de Vehículos", false)
    guiWindowSetSizable(vehiclesPanel, false)
    
    -- Label informativo
    local labelInfo = guiCreateLabel(10, 30, windowWidth - 20, 20, "Selecciona un vehículo y elige cómo generarlo", false, vehiclesPanel)
    guiLabelSetHorizontalAlign(labelInfo, "center", false)
    
    -- Grid list para vehículos
    vehiclesListGrid = guiCreateGridList(10, 60, windowWidth - 20, 300, false, vehiclesPanel)
    guiGridListAddColumn(vehiclesListGrid, "ID", 0.1)
    guiGridListAddColumn(vehiclesListGrid, "Nombre del Vehículo", 0.85)
    
    -- Cargar todos los vehículos disponibles (IDs 400-611)
    for vehicleId = 400, 611 do
        local vehicleName = getVehicleNameFromModel(vehicleId)
        if vehicleName and vehicleName ~= "" then
            -- Nombre personalizado para vehículos específicos
            if vehicleId == 560 then
                vehicleName = "Lamborghini Urus"
            elseif vehicleId == 410 then
                vehicleName = "Chiva Rumbera"
            elseif vehicleId == 508 then
                vehicleName = "Turbo Juan Valdez"
            elseif vehicleId == 561 then
                vehicleName = "Infiniti FX50"
            end

            
            local row = guiGridListAddRow(vehiclesListGrid)
            guiGridListSetItemText(vehiclesListGrid, row, 1, tostring(vehicleId), false, false)
            guiGridListSetItemText(vehiclesListGrid, row, 2, vehicleName, false, false)
        end
    end
    
    -- Opciones de generación
    local optionsY = 370
    local labelOptions = guiCreateLabel(10, optionsY, windowWidth - 20, 20, "Opciones de generación:", false, vehiclesPanel)
    guiSetFont(labelOptions, "default-bold")
    
    -- Radio buttons
    generateWithoutOwnerRadio = guiCreateRadioButton(10, optionsY + 25, 300, 20, "Generar sin dueño (cualquiera puede manejarlo)", false, vehiclesPanel)
    guiRadioButtonSetSelected(generateWithoutOwnerRadio, true)
    
    generateForPlayerRadio = guiCreateRadioButton(10, optionsY + 50, 300, 20, "Generar para jugador (con matrícula y llaves)", false, vehiclesPanel)
    
    -- Input para ID del jugador
    local labelPlayerId = guiCreateLabel(320, optionsY + 30, 100, 20, "ID del Jugador:", false, vehiclesPanel)
    playerIdInput = guiCreateEdit(320, optionsY + 50, 150, 25, "", false, vehiclesPanel)
    guiEditSetReadOnly(playerIdInput, false)
    
    -- Botones
    local generateBtn = guiCreateButton(10, optionsY + 85, 200, 35, "Generar Vehículo", false, vehiclesPanel)
    local cancelBtn = guiCreateButton(220, optionsY + 85, 200, 35, "Cancelar", false, vehiclesPanel)
    
    -- Eventos
    addEventHandler("onClientGUIClick", generateBtn, function()
        local row = guiGridListGetSelectedItem(vehiclesListGrid)
        if row and row >= 0 then
            local vehicleId = tonumber(guiGridListGetItemText(vehiclesListGrid, row, 1))
            if vehicleId then
                local generateForPlayer = guiRadioButtonGetSelected(generateForPlayerRadio)
                local playerId = nil
                
                if generateForPlayer then
                    local playerIdText = guiGetText(playerIdInput)
                    playerId = tonumber(playerIdText)
                    if not playerId or playerId <= 0 then
                        outputChatBox("Por favor ingresa un ID de jugador válido.", 255, 0, 0)
                        return
                    end
                end
                
                -- Enviar al servidor para crear el vehículo
                triggerServerEvent("admin:createVehicleWithOptions", localPlayer, vehicleId, generateForPlayer, playerId)
                destroyElement(vehiclesPanel)
                vehiclesPanel = nil
                vehiclesListGrid = nil
                playerIdInput = nil
                generateForPlayerRadio = nil
                generateWithoutOwnerRadio = nil
            else
                outputChatBox("Error al obtener el ID del vehículo.", 255, 0, 0)
            end
        else
            outputChatBox("Selecciona un vehículo de la lista.", 255, 255, 0)
        end
    end, false)
    
    addEventHandler("onClientGUIClick", cancelBtn, function()
        destroyElement(vehiclesPanel)
        vehiclesPanel = nil
        vehiclesListGrid = nil
        playerIdInput = nil
        generateForPlayerRadio = nil
        generateWithoutOwnerRadio = nil
    end, false)
end

-- Recibir respuesta de dar items
addEvent("admin:giveItemsResponse", true)
addEventHandler("admin:giveItemsResponse", resourceRoot, function(success, message)
    if success then
        -- Mostrar mensaje multilínea si es necesario
        local lines = {}
        for line in message:gmatch("[^\n]+") do
            table.insert(lines, line)
        end
        for _, line in ipairs(lines) do
            if line:find("✓") then
                outputChatBox(line, 0, 255, 0)
            elseif line:find("✗") then
                outputChatBox(line, 255, 0, 0)
            else
                outputChatBox(line, 255, 255, 0)
            end
        end
    else
        outputChatBox(message, 255, 0, 0)
    end
    
    -- Cerrar el panel después de dar items
    if itemsPanel and isElement(itemsPanel) then
        destroyElement(itemsPanel)
        itemsPanel = nil
        itemsListGrid = nil
        itemsQuantityEdit = nil
        itemsCharacterIdEdit = nil
        itemsQuantityLabel = nil
        selectedItems = {}
    end
end)

