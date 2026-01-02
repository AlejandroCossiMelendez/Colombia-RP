-- Sistema de Inventario Visual - Tecla I
-- Diseño moderno y exótico con drag & drop

local inventoryVisible = false
local playerInventory = {}
local inventorySlots = 50 -- 5 filas x 10 columnas
local slotSize = 60
local slotSpacing = 5
local inventoryRows = 5
local inventoryCols = 10

-- Variables para drag & drop
local draggedItem = nil
local draggedSlot = nil
local dragStartX, dragStartY = 0, 0

-- Variables para hover y animaciones
local hoveredSlot = nil
local selectedSlot = nil
local animationTime = 0
local pulseAlpha = 0
local pulseDirection = 1

-- Colores y estilos
local colors = {
    background = tocolor(15, 15, 25, 245),
    slotEmpty = tocolor(35, 35, 50, 200),
    slotFilled = tocolor(50, 70, 110, 230),
    slotHover = tocolor(80, 120, 180, 255),
    slotSelected = tocolor(120, 170, 220, 255),
    border = tocolor(100, 150, 255, 255),
    borderGlow = tocolor(150, 200, 255, 150),
    text = tocolor(255, 255, 255, 255),
    textShadow = tocolor(0, 0, 0, 200),
    quantity = tocolor(255, 255, 0, 255),
    title = tocolor(150, 200, 255, 255)
}

-- Función para obtener posición del slot en pantalla
function getSlotPosition(slot)
    local screenW, screenH = guiGetScreenSize()
    local inventoryWidth = (inventoryCols * slotSize) + ((inventoryCols - 1) * slotSpacing) + 40
    local inventoryHeight = (inventoryRows * slotSize) + ((inventoryRows - 1) * slotSpacing) + 80
    
    local startX = (screenW - inventoryWidth) / 2
    local startY = (screenH - inventoryHeight) / 2
    
    local row = math.floor((slot - 1) / inventoryCols)
    local col = (slot - 1) % inventoryCols
    
    local x = startX + 20 + (col * (slotSize + slotSpacing))
    local y = startY + 60 + (row * (slotSize + slotSpacing))
    
    return x, y, slotSize, slotSize
end

-- Función para obtener slot desde posición del mouse
function getSlotFromPosition(x, y)
    for slot = 1, inventorySlots do
        local sx, sy, sw, sh = getSlotPosition(slot)
        if x >= sx and x <= sx + sw and y >= sy and y <= sy + sh then
            return slot
        end
    end
    return nil
end

-- Función para obtener item en un slot
function getItemInSlot(slot)
    for _, item in ipairs(playerInventory) do
        if item.slot == slot then
            return item
        end
    end
    return nil
end

-- Función para dibujar el inventario
function drawInventory()
    if not inventoryVisible then
        return
    end
    
    -- Actualizar animaciones
    animationTime = animationTime + 0.02
    pulseAlpha = pulseAlpha + (pulseDirection * 2)
    if pulseAlpha >= 100 then
        pulseDirection = -1
    elseif pulseAlpha <= 0 then
        pulseDirection = 1
    end
    
    local screenW, screenH = guiGetScreenSize()
    local inventoryWidth = (inventoryCols * slotSize) + ((inventoryCols - 1) * slotSpacing) + 40
    local inventoryHeight = (inventoryRows * slotSize) + ((inventoryRows - 1) * slotSpacing) + 100
    
    local startX = (screenW - inventoryWidth) / 2
    local startY = (screenH - inventoryHeight) / 2
    
    -- Fondo principal con sombra
    dxDrawRectangle(startX - 2, startY - 2, inventoryWidth + 4, inventoryHeight + 4, tocolor(0, 0, 0, 150), false)
    dxDrawRectangle(startX, startY, inventoryWidth, inventoryHeight, colors.background, false)
    
    -- Borde decorativo con efecto glow
    local glowAlpha = math.floor(100 + math.sin(animationTime * 2) * 50)
    local glowColor = tocolor(100, 150, 255, glowAlpha)
    
    -- Bordes principales
    dxDrawRectangle(startX, startY, inventoryWidth, 4, colors.border, false)
    dxDrawRectangle(startX, startY + inventoryHeight - 4, inventoryWidth, 4, colors.border, false)
    dxDrawRectangle(startX, startY, 4, inventoryHeight, colors.border, false)
    dxDrawRectangle(startX + inventoryWidth - 4, startY, 4, inventoryHeight, colors.border, false)
    
    -- Efecto glow en los bordes
    dxDrawRectangle(startX - 1, startY - 1, inventoryWidth + 2, 2, glowColor, false)
    dxDrawRectangle(startX - 1, startY + inventoryHeight - 1, inventoryWidth + 2, 2, glowColor, false)
    dxDrawRectangle(startX - 1, startY - 1, 2, inventoryHeight + 2, glowColor, false)
    dxDrawRectangle(startX + inventoryWidth - 1, startY - 1, 2, inventoryHeight + 2, glowColor, false)
    
    -- Título con efecto
    local titleGlow = tocolor(150, 200, 255, math.floor(150 + math.sin(animationTime * 3) * 50))
    dxDrawText("INVENTARIO", startX + inventoryWidth / 2 + 2, startY + 12, startX + inventoryWidth / 2 + 2, startY + 37, tocolor(0, 0, 0, 150), 1.3, "default-bold", "center", "center", false, false, false, false, false)
    dxDrawText("INVENTARIO", startX + inventoryWidth / 2, startY + 10, startX + inventoryWidth / 2, startY + 35, titleGlow, 1.3, "default-bold", "center", "center", false, false, false, false, false)
    
    -- Dibujar slots
    for slot = 1, inventorySlots do
        local x, y, w, h = getSlotPosition(slot)
        local item = getItemInSlot(slot)
        
        -- Efecto de animación para slots con hover
        local animOffset = 0
        if hoveredSlot == slot then
            animOffset = math.sin(animationTime * 5) * 2
        end
        
        -- Color del slot según estado
        local slotColor = colors.slotEmpty
        if item then
            slotColor = colors.slotFilled
        end
        if hoveredSlot == slot then
            slotColor = colors.slotHover
            -- Efecto de brillo al hacer hover
            local glowSize = 3
            dxDrawRectangle(x - glowSize, y - glowSize, w + glowSize * 2, h + glowSize * 2, tocolor(100, 150, 255, 50), false)
        end
        if selectedSlot == slot then
            slotColor = colors.slotSelected
        end
        
        -- Fondo del slot con sombra
        dxDrawRectangle(x + 2, y + 2, w, h, tocolor(0, 0, 0, 100), false)
        dxDrawRectangle(x + animOffset, y + animOffset, w, h, slotColor, false)
        
        -- Borde del slot con efecto
        local borderColor = colors.border
        local borderGlow = colors.borderGlow
        if hoveredSlot == slot or selectedSlot == slot then
            borderColor = tocolor(150, 200, 255, 255)
            borderGlow = tocolor(200, 230, 255, 200)
            -- Efecto de pulso en el borde
            local pulseSize = 1 + math.sin(animationTime * 4) * 0.5
            dxDrawRectangle(x - pulseSize, y - pulseSize, w + pulseSize * 2, 2 + pulseSize * 2, borderGlow, false)
            dxDrawRectangle(x - pulseSize, y + h - 2 - pulseSize, w + pulseSize * 2, 2 + pulseSize * 2, borderGlow, false)
            dxDrawRectangle(x - pulseSize, y - pulseSize, 2 + pulseSize * 2, h + pulseSize * 2, borderGlow, false)
            dxDrawRectangle(x + w - 2 - pulseSize, y - pulseSize, 2 + pulseSize * 2, h + pulseSize * 2, borderGlow, false)
        end
        
        -- Bordes principales
        dxDrawRectangle(x, y, w, 2, borderColor, false)
        dxDrawRectangle(x, y + h - 2, w, 2, borderColor, false)
        dxDrawRectangle(x, y, 2, h, borderColor, false)
        dxDrawRectangle(x + w - 2, y, 2, h, borderColor, false)
        
        -- Dibujar item si existe
        if item then
            -- Efecto de brillo para items
            if hoveredSlot == slot then
                dxDrawRectangle(x + 5, y + 5, w - 10, h - 10, tocolor(255, 255, 255, 20), false)
            end
            
            -- Nombre del item (centrado con sombra)
            local itemName = item.item_name or "Item"
            local textY = y + h - 15
            dxDrawText(itemName, x + 3, textY + 1, x + w - 1, y + h, tocolor(0, 0, 0, 150), 0.7, "default", "center", "bottom", false, false, false, true, false)
            dxDrawText(itemName, x + 2, textY, x + w - 2, y + h - 2, colors.text, 0.7, "default", "center", "bottom", false, false, false, true, false)
            
            -- Cantidad (esquina inferior derecha con sombra)
            if item.quantity and item.quantity > 1 then
                dxDrawText("x" .. item.quantity, x + w - 4, y + h - 4, x + w - 4, y + h - 4, tocolor(0, 0, 0, 200), 0.85, "default-bold", "right", "bottom", false, false, false, false, false)
                dxDrawText("x" .. item.quantity, x + w - 5, y + h - 5, x + w - 5, y + h - 5, colors.quantity, 0.8, "default-bold", "right", "bottom", false, false, false, false, false)
            end
            
            -- Número de slot (esquina superior izquierda, pequeño)
            dxDrawText(tostring(slot), x + 4, y + 4, x + 4, y + 4, tocolor(0, 0, 0, 100), 0.65, "default", "left", "top", false, false, false, false, false)
            dxDrawText(tostring(slot), x + 3, y + 3, x + 3, y + 3, tocolor(200, 200, 200, 150), 0.6, "default", "left", "top", false, false, false, false, false)
        else
            -- Número de slot vacío con efecto sutil
            local slotAlpha = 80 + math.sin(animationTime + slot) * 20
            dxDrawText(tostring(slot), x + w / 2, y + h / 2, x + w / 2, y + h / 2, tocolor(100, 100, 100, slotAlpha), 0.7, "default", "center", "center", false, false, false, false, false)
        end
    end
    
    -- Dibujar item arrastrado
    if draggedItem then
        local cursorX, cursorY = getCursorPosition()
        if cursorX and cursorY then
            local screenW, screenH = guiGetScreenSize()
            local absX = cursorX * screenW
            local absY = cursorY * screenH
            
            -- Dibujar item en la posición del cursor
            dxDrawRectangle(absX - slotSize / 2, absY - slotSize / 2, slotSize, slotSize, colors.slotFilled, false)
            dxDrawRectangle(absX - slotSize / 2, absY - slotSize / 2, slotSize, 2, colors.border, false)
            dxDrawRectangle(absX - slotSize / 2, absY + slotSize / 2 - 2, slotSize, 2, colors.border, false)
            dxDrawRectangle(absX - slotSize / 2, absY - slotSize / 2, 2, slotSize, colors.border, false)
            dxDrawRectangle(absX + slotSize / 2 - 2, absY - slotSize / 2, 2, slotSize, colors.border, false)
            
            local itemName = draggedItem.item_name or "Item"
            dxDrawText(itemName, absX - slotSize / 2 + 2, absY + slotSize / 2 - 15, absX + slotSize / 2 - 2, absY + slotSize / 2 - 2, colors.text, 0.7, "default", "center", "bottom", false, false, false, true, false)
            
            if draggedItem.quantity and draggedItem.quantity > 1 then
                dxDrawText("x" .. draggedItem.quantity, absX + slotSize / 2 - 5, absY + slotSize / 2 - 5, absX + slotSize / 2 - 5, absY + slotSize / 2 - 5, colors.quantity, 0.8, "default-bold", "right", "bottom", false, false, false, false, false)
            end
        end
    end
    
    -- Tooltip al hacer hover
    if hoveredSlot then
        local item = getItemInSlot(hoveredSlot)
        if item then
            local cursorX, cursorY = getCursorPosition()
            if cursorX and cursorY then
                local screenW, screenH = guiGetScreenSize()
                local absX = cursorX * screenW
                local absY = cursorY * screenH
                
                local tooltipText = item.item_name or "Item"
                if item.quantity then
                    tooltipText = tooltipText .. "\nCantidad: " .. item.quantity
                end
                if item.item_data and item.item_data ~= "" then
                    tooltipText = tooltipText .. "\n" .. item.item_data
                end
                
                -- Fondo del tooltip
                local textWidth = dxGetTextWidth(tooltipText, 0.8, "default") + 20
                local textHeight = 60
                dxDrawRectangle(absX + 15, absY + 15, textWidth, textHeight, tocolor(0, 0, 0, 220), false)
                dxDrawRectangle(absX + 15, absY + 15, textWidth, 2, colors.border, false)
                dxDrawRectangle(absX + 15, absY + 15 + textHeight - 2, textWidth, 2, colors.border, false)
                dxDrawRectangle(absX + 15, absY + 15, 2, textHeight, colors.border, false)
                dxDrawRectangle(absX + 15 + textWidth - 2, absY + 15, 2, textHeight, colors.border, false)
                
                -- Texto del tooltip
                dxDrawText(tooltipText, absX + 25, absY + 25, absX + 25 + textWidth - 10, absY + 25 + textHeight - 10, colors.text, 0.8, "default", "left", "top", false, false, false, false, false)
            end
        end
    end
    
    -- Instrucciones
    local instructionsY = startY + inventoryHeight - 25
    dxDrawText("Click izquierdo: Usar | Click derecho: Arrastrar | I: Cerrar", startX + inventoryWidth / 2, instructionsY, startX + inventoryWidth / 2, instructionsY, tocolor(200, 200, 200, 200), 0.7, "default", "center", "center", false, false, false, false, false)
end

-- Renderizar inventario
addEventHandler("onClientRender", root, drawInventory)

-- Manejar tecla I
bindKey("i", "down", function()
    if not getElementData(localPlayer, "character:selected") then
        outputChatBox("Debes tener un personaje seleccionado.", 255, 0, 0)
        return
    end
    
    if inventoryVisible then
        closeInventory()
    else
        openInventory()
    end
end)

-- Función para abrir inventario
function openInventory()
    if inventoryVisible then
        return
    end
    
    inventoryVisible = true
    showCursor(true)
    triggerServerEvent("requestInventory", localPlayer)
end

-- Función para cerrar inventario
function closeInventory()
    if not inventoryVisible then
        return
    end
    
    inventoryVisible = false
    showCursor(false)
    selectedSlot = nil
    hoveredSlot = nil
    draggedItem = nil
    draggedSlot = nil
end

-- Recibir inventario del servidor
addEvent("receiveInventory", true)
addEventHandler("receiveInventory", resourceRoot, function(inventory)
    playerInventory = inventory or {}
end)

-- Actualizar inventario
addEvent("inventoryUpdated", true)
addEventHandler("inventoryUpdated", resourceRoot, function()
    triggerServerEvent("requestInventory", localPlayer)
end)

-- Manejar clicks del mouse
addEventHandler("onClientClick", root, function(button, state, absX, absY, worldX, worldY, worldZ, clickedElement)
    if not inventoryVisible then
        return
    end
    
    if button == "left" and state == "down" then
        local slot = getSlotFromPosition(absX, absY)
        if slot then
            local item = getItemInSlot(slot)
            if item then
                -- Usar item
                triggerServerEvent("useItem", localPlayer, slot)
                selectedSlot = slot
            end
        end
    elseif button == "right" and state == "down" then
        local slot = getSlotFromPosition(absX, absY)
        if slot then
            local item = getItemInSlot(slot)
            if item then
                -- Iniciar drag
                draggedItem = item
                draggedSlot = slot
                dragStartX = absX
                dragStartY = absY
            end
        end
    elseif button == "right" and state == "up" then
        if draggedItem and draggedSlot then
            local slot = getSlotFromPosition(absX, absY)
            if slot and slot ~= draggedSlot then
                -- Mover item
                triggerServerEvent("moveInventoryItem", localPlayer, draggedSlot, slot)
            end
            draggedItem = nil
            draggedSlot = nil
        end
    end
end)

-- Detectar hover sobre slots
addEventHandler("onClientCursorMove", root, function(relX, relY, absX, absY)
    if not inventoryVisible then
        hoveredSlot = nil
        return
    end
    
    hoveredSlot = getSlotFromPosition(absX, absY)
end)

-- Cerrar inventario con ESC
addEventHandler("onClientKey", root, function(key, press)
    if key == "escape" and press and inventoryVisible then
        closeInventory()
    end
end)

