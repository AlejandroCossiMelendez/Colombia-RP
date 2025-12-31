-- Sistema de Inventario para Colombia RP
local screenWidth, screenHeight = guiGetScreenSize()
local inventoryWindow = nil
local inventoryOpen = false

-- Colores del tema (consistentes con el resto del sistema)
local colors = {
    primary = {41, 128, 185, 255},      -- Azul principal
    secondary = {52, 73, 94, 255},      -- Gris oscuro
    success = {46, 204, 113, 255},      -- Verde
    danger = {231, 76, 60, 255},        -- Rojo
    background = {0, 0, 0, 200},        -- Fondo semi-transparente
    text = {236, 240, 241, 255},        -- Texto claro
    input = {44, 62, 80, 255},          -- Fondo de inputs
    slotBg = {30, 30, 40, 255},         -- Fondo de slots
    slotBorder = {60, 60, 80, 255}      -- Borde de slots
}

-- Configuración del inventario
local INVENTORY_COLS = 6  -- Columnas
local INVENTORY_ROWS = 5  -- Filas
local TOTAL_SLOTS = INVENTORY_COLS * INVENTORY_ROWS  -- 30 slots
local SLOT_SIZE = 60  -- Tamaño de cada slot en píxeles
local SLOT_SPACING = 5  -- Espacio entre slots

-- Datos del inventario
local inventoryItems = {}  -- Tabla de items: {slot = {id, name, quantity, icon}}

-- Función para crear/abrir el inventario
function openInventory(items)
    if inventoryOpen then
        closeInventory()
        return
    end
    
    if not getElementData(localPlayer, "characterSelected") then
        outputChatBox("Debes estar logueado para usar el inventario", 255, 0, 0)
        return
    end
    
    -- Actualizar items
    if items then
        inventoryItems = items or {}
    end
    
    -- Calcular tamaño de la ventana
    local windowWidth = (INVENTORY_COLS * SLOT_SIZE) + (INVENTORY_COLS * SLOT_SPACING) + 100
    local windowHeight = (INVENTORY_ROWS * SLOT_SIZE) + (INVENTORY_ROWS * SLOT_SPACING) + 180
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    -- Crear ventana
    inventoryWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Colombia RP - Inventario", false)
    guiWindowSetMovable(inventoryWindow, true)
    guiWindowSetSizable(inventoryWindow, false)
    guiSetAlpha(inventoryWindow, 0.95)
    guiSetVisible(inventoryWindow, true)
    
    -- Título
    local titleLabel = guiCreateLabel(20, 30, windowWidth - 40, 35, "INVENTARIO", false, inventoryWindow)
    guiSetFont(titleLabel, "default-bold")
    guiLabelSetHorizontalAlign(titleLabel, "center", true)
    guiLabelSetColor(titleLabel, colors.text[1], colors.text[2], colors.text[3])
    
    -- Información de slots usados
    local usedSlots = 0
    for k, v in pairs(inventoryItems) do
        usedSlots = usedSlots + 1
    end
    local infoLabel = guiCreateLabel(20, windowHeight - 80, windowWidth - 40, 20, 
        "Slots: " .. usedSlots .. "/" .. TOTAL_SLOTS, false, inventoryWindow)
    guiLabelSetHorizontalAlign(infoLabel, "center", true)
    guiLabelSetColor(infoLabel, colors.text[1], colors.text[2], colors.text[3])
    
    -- Crear grid de slots (invisibles, solo para detectar clics)
    local startX = 40
    local startY = 75
    local slots = {}
    
    for row = 0, INVENTORY_ROWS - 1 do
        for col = 0, INVENTORY_COLS - 1 do
            local slotIndex = (row * INVENTORY_COLS) + col + 1
            local slotX = startX + (col * (SLOT_SIZE + SLOT_SPACING))
            local slotY = startY + (row * (SLOT_SIZE + SLOT_SPACING))
            
            -- Crear slot invisible para detectar clics
            local slot = guiCreateLabel(slotX, slotY, SLOT_SIZE, SLOT_SIZE, "", false, inventoryWindow)
            guiSetProperty(slot, "AlwaysOnTop", "True")
            guiSetAlpha(slot, 0)  -- Invisible pero clickeable
            setElementData(slot, "slotIndex", slotIndex)
            slots[slotIndex] = slot
            
            -- Agregar evento de clic
            addEventHandler("onClientGUIClick", slot, function(button, state)
                if button == "left" and state == "up" then
                    local slotIdx = getElementData(source, "slotIndex")
                    if inventoryItems[slotIdx] then
                        local item = inventoryItems[slotIdx]
                        outputChatBox("Item: " .. item.name .. " x" .. item.quantity, 0, 255, 0)
                    end
                end
            end, false)
        end
    end
    
    -- Botón de cerrar
    local closeButton = guiCreateButton((windowWidth - 200) / 2, windowHeight - 50, 200, 35, "Cerrar (I)", false, inventoryWindow)
    guiSetProperty(closeButton, "NormalTextColour", "FF" .. string.format("%02X%02X%02X", colors.text[1], colors.text[2], colors.text[3]))
    
    -- Evento para cerrar
    addEventHandler("onClientGUIClick", closeButton, function()
        closeInventory()
    end, false)
    
    -- Mostrar cursor
    showCursor(true)
    guiSetInputEnabled(true)
    inventoryOpen = true
end

-- Función para cerrar el inventario
function closeInventory()
    if inventoryWindow then
        destroyElement(inventoryWindow)
        inventoryWindow = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
    inventoryOpen = false
end

-- Función para dibujar el inventario con dxDraw (más profesional)
function drawInventory()
    if not inventoryOpen or not inventoryWindow then return end
    
    local windowX, windowY = guiGetPosition(inventoryWindow, false)
    local windowWidth, windowHeight = guiGetSize(inventoryWindow, false)
    
    local startX = windowX + 40
    local startY = windowY + 75
    
    -- Dibujar slots
    for row = 0, INVENTORY_ROWS - 1 do
        for col = 0, INVENTORY_COLS - 1 do
            local slotIndex = (row * INVENTORY_COLS) + col + 1
            local slotX = startX + (col * (SLOT_SIZE + SLOT_SPACING))
            local slotY = startY + (row * (SLOT_SIZE + SLOT_SPACING))
            
            -- Fondo del slot con borde
            dxDrawRectangle(slotX, slotY, SLOT_SIZE, SLOT_SIZE, 
                tocolor(colors.slotBg[1], colors.slotBg[2], colors.slotBg[3], 200), true)
            
            -- Borde del slot
            dxDrawRectangle(slotX, slotY, SLOT_SIZE, 2, 
                tocolor(colors.slotBorder[1], colors.slotBorder[2], colors.slotBorder[3], 255), true)
            dxDrawRectangle(slotX, slotY + SLOT_SIZE - 2, SLOT_SIZE, 2, 
                tocolor(colors.slotBorder[1], colors.slotBorder[2], colors.slotBorder[3], 255), true)
            dxDrawRectangle(slotX, slotY, 2, SLOT_SIZE, 
                tocolor(colors.slotBorder[1], colors.slotBorder[2], colors.slotBorder[3], 255), true)
            dxDrawRectangle(slotX + SLOT_SIZE - 2, slotY, 2, SLOT_SIZE, 
                tocolor(colors.slotBorder[1], colors.slotBorder[2], colors.slotBorder[3], 255), true)
            
            -- Si hay un item en este slot
            if inventoryItems[slotIndex] then
                local item = inventoryItems[slotIndex]
                
                -- Fondo del item con efecto de brillo
                dxDrawRectangle(slotX + 3, slotY + 3, SLOT_SIZE - 6, SLOT_SIZE - 6, 
                    tocolor(colors.primary[1], colors.primary[2], colors.primary[3], 150), true)
                
                -- Borde interno del item
                dxDrawRectangle(slotX + 3, slotY + 3, SLOT_SIZE - 6, SLOT_SIZE - 6, 
                    tocolor(colors.primary[1] + 30, colors.primary[2] + 30, colors.primary[3] + 30, 100), false, true)
                
                -- Nombre del item (abreviado)
                local itemName = item.name
                if string.len(itemName) > 10 then
                    itemName = string.sub(itemName, 1, 10) .. "..."
                end
                
                -- Sombra del texto
                dxDrawText(itemName, slotX + 6, slotY + 7, slotX + SLOT_SIZE - 6, slotY + SLOT_SIZE - 25,
                    tocolor(0, 0, 0, 200), 0.65, "default-bold", "left", "top", false, false, true)
                
                -- Texto principal
                dxDrawText(itemName, slotX + 5, slotY + 6, slotX + SLOT_SIZE - 5, slotY + SLOT_SIZE - 24,
                    tocolor(colors.text[1], colors.text[2], colors.text[3], 255),
                    0.65, "default-bold", "left", "top", false, false, true)
                
                -- Cantidad
                if item.quantity > 1 then
                    local qtyText = "x" .. item.quantity
                    -- Sombra de la cantidad
                    dxDrawText(qtyText, slotX + 6, slotY + SLOT_SIZE - 20, slotX + SLOT_SIZE - 6, slotY + SLOT_SIZE - 6,
                        tocolor(0, 0, 0, 200), 0.75, "default-bold", "right", "bottom", false, false, true)
                    
                    -- Cantidad principal
                    dxDrawText(qtyText, slotX + 5, slotY + SLOT_SIZE - 21, slotX + SLOT_SIZE - 5, slotY + SLOT_SIZE - 5,
                        tocolor(colors.success[1], colors.success[2], colors.success[3], 255),
                        0.75, "default-bold", "right", "bottom", false, false, true)
                end
            else
                -- Slot vacío - mostrar número del slot en gris claro
                local slotNum = tostring(slotIndex)
                dxDrawText(slotNum, slotX + SLOT_SIZE/2, slotY + SLOT_SIZE/2, 
                    slotX + SLOT_SIZE/2, slotY + SLOT_SIZE/2,
                    tocolor(100, 100, 100, 50), 0.5, "default", "center", "center", false, false, true)
            end
        end
    end
end

-- Bind de tecla para abrir/cerrar inventario
bindKey("i", "down", function()
    if getElementData(localPlayer, "characterSelected") then
        if inventoryOpen then
            closeInventory()
        else
            triggerServerEvent("onRequestInventory", localPlayer)
        end
    end
end)

-- Evento para recibir inventario del servidor
addEvent("onInventoryReceived", true)
addEventHandler("onInventoryReceived", root, function(items)
    openInventory(items)
end)

-- Evento para actualizar inventario
addEvent("onInventoryUpdated", true)
addEventHandler("onInventoryUpdated", root, function(items)
    inventoryItems = items or {}
    -- La visualización se actualiza automáticamente en el render
end)

-- Renderizar inventario cada frame
addEventHandler("onClientRender", root, function()
    if inventoryOpen then
        drawInventory()
    end
end)

-- Cerrar inventario al desconectar
addEventHandler("onClientResourceStop", resourceRoot, function()
    closeInventory()
end)

