-- Sistema de Inventario Visual - Tecla I
-- Diseño moderno y exótico con drag & drop - Versión Mejorada

local inventoryVisible = false
local playerInventory = {}
local inventorySlots = 50 -- 5 filas x 10 columnas
local slotSize = 70 -- Aumentado para mejor visualización
local slotSpacing = 8 -- Más espaciado
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

-- Colores y estilos mejorados
local colors = {
    background = tocolor(10, 10, 20, 250),
    backgroundGradient = tocolor(20, 25, 35, 240),
    slotEmpty = tocolor(30, 35, 50, 180),
    slotEmptyGlow = tocolor(50, 60, 80, 100),
    slotFilled = tocolor(45, 65, 100, 240),
    slotFilledGlow = tocolor(70, 100, 150, 180),
    slotHover = tocolor(70, 110, 170, 255),
    slotHoverGlow = tocolor(100, 150, 220, 200),
    slotSelected = tocolor(110, 160, 210, 255),
    slotSelectedGlow = tocolor(140, 190, 240, 220),
    border = tocolor(80, 130, 200, 255),
    borderGlow = tocolor(120, 180, 255, 180),
    borderInner = tocolor(200, 220, 255, 100),
    text = tocolor(255, 255, 255, 255),
    textGlow = tocolor(200, 220, 255, 255),
    textShadow = tocolor(0, 0, 0, 220),
    quantity = tocolor(255, 220, 100, 255),
    quantityGlow = tocolor(255, 240, 150, 255),
    title = tocolor(150, 200, 255, 255),
    titleGlow = tocolor(200, 230, 255, 255),
    accent = tocolor(100, 150, 255, 255)
}

-- Función para obtener posición del slot en pantalla
function getSlotPosition(slot)
    local screenW, screenH = guiGetScreenSize()
    local inventoryWidth = (inventoryCols * slotSize) + ((inventoryCols - 1) * slotSpacing) + 60
    local inventoryHeight = (inventoryRows * slotSize) + ((inventoryRows - 1) * slotSpacing) + 140
    
    local startX = (screenW - inventoryWidth) / 2
    local startY = (screenH - inventoryHeight) / 2
    
    local row = math.floor((slot - 1) / inventoryCols)
    local col = (slot - 1) % inventoryCols
    
    local x = startX + 30 + (col * (slotSize + slotSpacing))
    local y = startY + 80 + (row * (slotSize + slotSpacing))
    
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
    local inventoryWidth = (inventoryCols * slotSize) + ((inventoryCols - 1) * slotSpacing) + 60
    local inventoryHeight = (inventoryRows * slotSize) + ((inventoryRows - 1) * slotSpacing) + 140
    
    local startX = (screenW - inventoryWidth) / 2
    local startY = (screenH - inventoryHeight) / 2
    
    -- Sombra exterior múltiple para efecto de profundidad
    for i = 1, 5 do
        local shadowAlpha = 30 - (i * 5)
        dxDrawRectangle(startX - i, startY - i, inventoryWidth + (i * 2), inventoryHeight + (i * 2), tocolor(0, 0, 0, shadowAlpha), false)
    end
    
    -- Fondo principal con gradiente simulado
    dxDrawRectangle(startX, startY, inventoryWidth, inventoryHeight, colors.background, false)
    -- Capa de gradiente superior
    dxDrawRectangle(startX, startY, inventoryWidth, 80, colors.backgroundGradient, false)
    
    -- Borde decorativo con efecto glow animado
    local glowAlpha = math.floor(120 + math.sin(animationTime * 2) * 60)
    local glowColor = tocolor(100, 150, 255, glowAlpha)
    local innerGlow = tocolor(150, 200, 255, math.floor(80 + math.sin(animationTime * 3) * 40))
    
    -- Sombra del borde
    dxDrawRectangle(startX - 2, startY - 2, inventoryWidth + 4, 6, tocolor(0, 0, 0, 100), false)
    dxDrawRectangle(startX - 2, startY + inventoryHeight - 4, inventoryWidth + 4, 6, tocolor(0, 0, 0, 100), false)
    dxDrawRectangle(startX - 2, startY - 2, 6, inventoryHeight + 4, tocolor(0, 0, 0, 100), false)
    dxDrawRectangle(startX + inventoryWidth - 4, startY - 2, 6, inventoryHeight + 4, tocolor(0, 0, 0, 100), false)
    
    -- Bordes principales con grosor
    dxDrawRectangle(startX, startY, inventoryWidth, 5, colors.border, false)
    dxDrawRectangle(startX, startY + inventoryHeight - 5, inventoryWidth, 5, colors.border, false)
    dxDrawRectangle(startX, startY, 5, inventoryHeight, colors.border, false)
    dxDrawRectangle(startX + inventoryWidth - 5, startY, 5, inventoryHeight, colors.border, false)
    
    -- Borde interno brillante
    dxDrawRectangle(startX + 5, startY + 5, inventoryWidth - 10, 2, colors.borderInner, false)
    dxDrawRectangle(startX + 5, startY + inventoryHeight - 7, inventoryWidth - 10, 2, colors.borderInner, false)
    dxDrawRectangle(startX + 5, startY + 5, 2, inventoryHeight - 10, colors.borderInner, false)
    dxDrawRectangle(startX + inventoryWidth - 7, startY + 5, 2, inventoryHeight - 10, colors.borderInner, false)
    
    -- Efecto glow exterior animado
    dxDrawRectangle(startX - 3, startY - 3, inventoryWidth + 6, 3, glowColor, false)
    dxDrawRectangle(startX - 3, startY + inventoryHeight, inventoryWidth + 6, 3, glowColor, false)
    dxDrawRectangle(startX - 3, startY - 3, 3, inventoryHeight + 6, glowColor, false)
    dxDrawRectangle(startX + inventoryWidth, startY - 3, 3, inventoryHeight + 6, glowColor, false)
    
    -- Título mejorado con múltiples efectos
    local titleY = startY + 15
    local titlePulse = math.sin(animationTime * 3) * 0.1
    local titleScale = 1.4 + titlePulse
    
    -- Sombra del título (múltiples capas)
    for i = 1, 3 do
        dxDrawText("INVENTARIO", startX + inventoryWidth / 2 + (i * 2), titleY + (i * 2), startX + inventoryWidth / 2 + (i * 2), titleY + 30 + (i * 2), tocolor(0, 0, 0, 100 - (i * 30)), titleScale, "default-bold", "center", "center", false, false, false, false, false)
    end
    
    -- Título principal con glow
    local titleGlow = tocolor(150, 200, 255, math.floor(200 + math.sin(animationTime * 3) * 55))
    dxDrawText("INVENTARIO", startX + inventoryWidth / 2, titleY, startX + inventoryWidth / 2, titleY + 30, titleGlow, titleScale, "default-bold", "center", "center", false, false, false, false, false)
    
    -- Línea decorativa bajo el título
    local lineY = titleY + 35
    dxDrawRectangle(startX + 30, lineY, inventoryWidth - 60, 2, colors.border, false)
    dxDrawRectangle(startX + 30, lineY, inventoryWidth - 60, 1, innerGlow, false)
    
    -- Dibujar slots con mejor diseño
    for slot = 1, inventorySlots do
        local x, y, w, h = getSlotPosition(slot)
        local item = getItemInSlot(slot)
        
        -- Efecto de animación para slots con hover (más suave)
        local animOffset = 0
        local scale = 1.0
        if hoveredSlot == slot then
            animOffset = math.sin(animationTime * 6) * 1.5
            scale = 1.05
            w = w * scale
            h = h * scale
            x = x - (w * (scale - 1)) / 2
            y = y - (h * (scale - 1)) / 2
        end
        
        -- Color del slot según estado (con gradiente simulado)
        local slotColor = colors.slotEmpty
        local slotGlow = colors.slotEmptyGlow
        if item then
            slotColor = colors.slotFilled
            slotGlow = colors.slotFilledGlow
        end
        if hoveredSlot == slot then
            slotColor = colors.slotHover
            slotGlow = colors.slotHoverGlow
            -- Efecto de brillo exterior más pronunciado
            for i = 1, 4 do
                local glowAlpha = 60 - (i * 10)
                dxDrawRectangle(x - i, y - i, w + (i * 2), h + (i * 2), tocolor(100, 150, 255, glowAlpha), false)
            end
        end
        if selectedSlot == slot then
            slotColor = colors.slotSelected
            slotGlow = colors.slotSelectedGlow
        end
        
        -- Sombra del slot (múltiples capas)
        for i = 1, 3 do
            dxDrawRectangle(x + i + 2, y + i + 2, w, h, tocolor(0, 0, 0, 80 - (i * 20)), false)
        end
        
        -- Fondo del slot con efecto de profundidad
        dxDrawRectangle(x + 3, y + 3, w, h, tocolor(0, 0, 0, 120), false)
        
        -- Gradiente simulado en el slot (parte superior más clara)
        dxDrawRectangle(x + animOffset, y + animOffset, w, h * 0.3, slotGlow, false)
        dxDrawRectangle(x + animOffset, y + animOffset, w, h, slotColor, false)
        
        -- Borde del slot con efecto mejorado
        local borderColor = colors.border
        local borderGlow = colors.borderGlow
        local borderInner = colors.borderInner
        
        if hoveredSlot == slot or selectedSlot == slot then
            borderColor = tocolor(150, 200, 255, 255)
            borderGlow = tocolor(200, 230, 255, 220)
            borderInner = tocolor(220, 240, 255, 180)
            
            -- Efecto de pulso en el borde (más visible)
            local pulseSize = 2 + math.sin(animationTime * 5) * 1.5
            local pulseAlpha = math.floor(150 + math.sin(animationTime * 4) * 100)
            
            -- Glow exterior animado
            dxDrawRectangle(x - pulseSize, y - pulseSize, w + pulseSize * 2, 3 + pulseSize * 2, tocolor(100, 150, 255, pulseAlpha), false)
            dxDrawRectangle(x - pulseSize, y + h - 3 - pulseSize, w + pulseSize * 2, 3 + pulseSize * 2, tocolor(100, 150, 255, pulseAlpha), false)
            dxDrawRectangle(x - pulseSize, y - pulseSize, 3 + pulseSize * 2, h + pulseSize * 2, tocolor(100, 150, 255, pulseAlpha), false)
            dxDrawRectangle(x + w - 3 - pulseSize, y - pulseSize, 3 + pulseSize * 2, h + pulseSize * 2, tocolor(100, 150, 255, pulseAlpha), false)
        end
        
        -- Bordes principales (más gruesos)
        dxDrawRectangle(x, y, w, 3, borderColor, false)
        dxDrawRectangle(x, y + h - 3, w, 3, borderColor, false)
        dxDrawRectangle(x, y, 3, h, borderColor, false)
        dxDrawRectangle(x + w - 3, y, 3, h, borderColor, false)
        
        -- Borde interno brillante
        dxDrawRectangle(x + 3, y + 3, w - 6, 1, borderInner, false)
        dxDrawRectangle(x + 3, y + h - 4, w - 6, 1, borderInner, false)
        dxDrawRectangle(x + 3, y + 3, 1, h - 6, borderInner, false)
        dxDrawRectangle(x + w - 4, y + 3, 1, h - 6, borderInner, false)
        
        -- Dibujar item si existe
        if item then
            -- Efecto de brillo mejorado para items
            if hoveredSlot == slot then
                -- Brillo interior animado
                local shineAlpha = math.floor(40 + math.sin(animationTime * 4) * 20)
                dxDrawRectangle(x + 6, y + 6, w - 12, h - 12, tocolor(255, 255, 255, shineAlpha), false)
                -- Efecto de resplandor
                for i = 1, 2 do
                    dxDrawRectangle(x + 5 + i, y + 5 + i, w - 10 - (i * 2), h - 10 - (i * 2), tocolor(150, 200, 255, 30 - (i * 10)), false)
                end
            end
            
            -- Nombre del item (centrado con múltiples sombras y glow)
            local itemName = item.item_name or "Item"
            local textY = y + h - 18
            
            -- Sombra del texto (múltiples capas para efecto 3D)
            for i = 1, 3 do
                dxDrawText(itemName, x + 4 + i, textY + 1 + i, x + w - 2, y + h, tocolor(0, 0, 0, 120 - (i * 30)), 0.75, "default-bold", "center", "bottom", false, false, false, true, false)
            end
            
            -- Texto principal con glow
            local textGlow = colors.textGlow
            if hoveredSlot == slot then
                textGlow = tocolor(255, 255, 255, 255)
            end
            dxDrawText(itemName, x + 2, textY, x + w - 2, y + h - 2, textGlow, 0.75, "default-bold", "center", "bottom", false, false, false, true, false)
            
            -- Cantidad (esquina inferior derecha con mejor diseño)
            if item.quantity and item.quantity > 1 then
                local qtyText = "x" .. item.quantity
                -- Fondo para la cantidad
                local qtyWidth = dxGetTextWidth(qtyText, 0.9, "default-bold") + 8
                local qtyX = x + w - qtyWidth - 4
                local qtyY = y + h - 18
                dxDrawRectangle(qtyX - 2, qtyY - 2, qtyWidth, 14, tocolor(0, 0, 0, 180), false)
                dxDrawRectangle(qtyX, qtyY, qtyWidth - 4, 12, tocolor(255, 200, 50, 200), false)
                
                -- Sombra del texto de cantidad
                dxDrawText(qtyText, qtyX + 1, qtyY + 1, qtyX + qtyWidth - 2, qtyY + 12, tocolor(0, 0, 0, 200), 0.9, "default-bold", "center", "center", false, false, false, false, false)
                -- Texto de cantidad
                dxDrawText(qtyText, qtyX, qtyY, qtyX + qtyWidth - 4, qtyY + 12, colors.quantity, 0.9, "default-bold", "center", "center", false, false, false, false, false)
            end
            
            -- Número de slot (esquina superior izquierda, más elegante)
            local slotText = tostring(slot)
            -- Fondo pequeño para el número
            dxDrawRectangle(x + 4, y + 4, 18, 14, tocolor(0, 0, 0, 150), false)
            dxDrawRectangle(x + 5, y + 5, 16, 12, tocolor(50, 70, 100, 180), false)
            -- Sombra del número
            dxDrawText(slotText, x + 6, y + 6, x + 20, y + 18, tocolor(0, 0, 0, 150), 0.65, "default-bold", "center", "center", false, false, false, false, false)
            -- Número
            dxDrawText(slotText, x + 5, y + 5, x + 19, y + 17, tocolor(200, 220, 255, 200), 0.65, "default-bold", "center", "center", false, false, false, false, false)
        else
            -- Número de slot vacío con efecto más elegante
            local slotAlpha = 60 + math.sin(animationTime * 2 + slot * 0.5) * 25
            local slotText = tostring(slot)
            -- Fondo sutil para slots vacíos
            dxDrawRectangle(x + w / 2 - 12, y + h / 2 - 8, 24, 16, tocolor(0, 0, 0, 80), false)
            -- Sombra del número
            dxDrawText(slotText, x + w / 2 + 1, y + h / 2 + 1, x + w / 2 + 1, y + h / 2 + 1, tocolor(0, 0, 0, 100), 0.75, "default", "center", "center", false, false, false, false, false)
            -- Número con efecto de pulso
            dxDrawText(slotText, x + w / 2, y + h / 2, x + w / 2, y + h / 2, tocolor(100, 120, 150, slotAlpha), 0.75, "default", "center", "center", false, false, false, false, false)
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
    
    -- Línea decorativa sobre las instrucciones
    local lineY = startY + inventoryHeight - 35
    dxDrawRectangle(startX + 30, lineY, inventoryWidth - 60, 2, colors.border, false)
    dxDrawRectangle(startX + 30, lineY, inventoryWidth - 60, 1, innerGlow, false)
    
    -- Instrucciones mejoradas
    local instructionsY = startY + inventoryHeight - 25
    local instructionsText = "Click izquierdo: Usar | Click derecho: Arrastrar | I: Cerrar"
    -- Sombra de las instrucciones
    dxDrawText(instructionsText, startX + inventoryWidth / 2 + 1, instructionsY + 1, startX + inventoryWidth / 2 + 1, instructionsY + 1, tocolor(0, 0, 0, 150), 0.75, "default", "center", "center", false, false, false, false, false)
    -- Texto de las instrucciones
    dxDrawText(instructionsText, startX + inventoryWidth / 2, instructionsY, startX + inventoryWidth / 2, instructionsY, tocolor(180, 200, 220, 220), 0.75, "default", "center", "center", false, false, false, false, false)
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
    -- No solicitar inventario de la tabla inventory, ya que usamos el sistema de items
    -- Los items se cargan automáticamente con syncItems
    -- triggerServerEvent("requestInventory", localPlayer)
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

-- Recibir inventario del servidor (tabla inventory)
-- NOTA: Este evento se usa para el sistema de inventory, pero nosotros usamos el sistema de items
-- Por lo tanto, solo actualizamos si no hay items ya cargados desde syncItems
addEvent("receiveInventory", true)
addEventHandler("receiveInventory", resourceRoot, function(inventory)
    -- Solo actualizar si no hay items ya cargados desde syncItems
    if not playerInventory or #playerInventory == 0 then
        playerInventory = inventory or {}
    end
end)

-- Recibir items del sistema de items (tabla items) y convertirlos al formato del inventario visual
addEvent("syncItems", true)
addEventHandler("syncItems", root, function(...)
    -- El evento syncItems se envía como: triggerClientEvent(player, "syncItems", player, items)
    -- Puede recibir 1 o 2 parámetros dependiendo de cómo se envíe
    local args = {...}
    local player = args[1]
    local items = args[2]
    
    -- Si solo hay un parámetro, es la tabla de items (compatibilidad con items_c.lua)
    if not items and type(player) == "table" then
        items = player
        player = source
    end
    
    -- Verificar si es el jugador local
    if player == localPlayer then
        -- Convertir items del sistema items al formato del inventario visual
        playerInventory = {}
        if items and type(items) == "table" then
            for slot, item in ipairs(items) do
                if item and item.item then
                    -- Obtener el nombre del item
                    local itemName = item.name or "Item " .. item.item
                    -- Si name es NULL o vacío, usar getName
                    if (not itemName or itemName == "NULL" or itemName == "") and getName and type(getName) == "function" then
                        local nameResult = getName(item.item)
                        if nameResult and nameResult ~= " " and nameResult ~= "" then
                            itemName = nameResult
                        end
                    end
                    
                    table.insert(playerInventory, {
                        id = item.index or slot,
                        slot = slot,
                        item_id = item.item,
                        item_name = itemName,
                        quantity = tonumber(item.value) or 1,
                        item_data = item.value2 or ""
                    })
                end
            end
        end
    end
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

