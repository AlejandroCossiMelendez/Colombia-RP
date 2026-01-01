-- Sistema de Inventario para Colombia RP
local screenWidth, screenHeight = guiGetScreenSize()
local inventoryWindow = nil
local inventoryOpen = false

-- ID del modelo personalizado para la botella vacía
local CUSTOM_BOTTLE_MODEL_ID = 20000

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

-- Variable para detectar si S está presionada
local isSPressed = false

-- Detectar tecla S (funciona incluso con GUI abierto)
bindKey("s", "both", function(key, keyState)
    if keyState == "down" then
        isSPressed = true
    else
        isSPressed = false
    end
end)

-- Cargar imágenes de items
local waterFullImage = nil
local waterEmptyImage = nil
local hamburgerImage = nil

-- Items consumibles (debe coincidir con el servidor)
local consumableItems = {
    ["Agua Llena"] = true,
    ["Agua"] = true,
    ["Hamburguesa"] = true,
    ["Comida"] = true
}

-- Cargar imágenes y modelos al iniciar
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Cargar imágenes
    waterFullImage = dxCreateTexture("images/agua-lleno.png", "argb", true, "clamp")
    waterEmptyImage = dxCreateTexture("images/agua-vacio.png", "argb", true, "clamp")
    hamburgerImage = dxCreateTexture("images/bollo-de-hamburguesa.png", "argb", true, "clamp")
    
    if not waterFullImage then
        outputChatBox("⚠ No se pudo cargar la imagen agua-lleno.png", 255, 165, 0)
    end
    if not waterEmptyImage then
        outputChatBox("⚠ No se pudo cargar la imagen agua-vacio.png", 255, 165, 0)
    end
    if not hamburgerImage then
        outputChatBox("⚠ No se pudo cargar la imagen bollo-de-hamburguesa.png", 255, 165, 0)
    end
    
    -- Cargar modelo personalizado de botella
    local bottleTxd = engineLoadTXD("images/bottle.txd")
    if bottleTxd then
        engineImportTXD(bottleTxd, CUSTOM_BOTTLE_MODEL_ID)
        outputChatBox("✓ Texturas de botella cargadas", 0, 255, 0)
    else
        outputChatBox("⚠ No se pudo cargar bottle.txd", 255, 165, 0)
    end
    
    local bottleDff = engineLoadDFF("images/bottle.dff", CUSTOM_BOTTLE_MODEL_ID)
    if bottleDff then
        engineReplaceModel(bottleDff, CUSTOM_BOTTLE_MODEL_ID)
        outputChatBox("✓ Modelo de botella cargado", 0, 255, 0)
    else
        outputChatBox("⚠ No se pudo cargar bottle.dff", 255, 165, 0)
    end
end)

-- Función para obtener la imagen de un item
function getItemImage(itemName, itemId)
    if itemName == "Agua Llena" or itemName == "Agua" or itemId == 2000 then
        return waterFullImage
    elseif itemName == "Agua Vacía" or itemName == "Botella Vacía" or itemId == 2001 then
        return waterEmptyImage
    elseif itemName == "Hamburguesa" or itemName == "Comida" or itemId == 3000 then
        return hamburgerImage
    end
    return nil
end

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
            
            -- Agregar evento de clic (doble clic para consumir, S+clic o clic derecho para botar)
            local lastClickTime = {}
            addEventHandler("onClientGUIClick", slot, function(button, state)
                if button == "left" and state == "up" then
                    local slotIdx = getElementData(source, "slotIndex")
                    if inventoryItems[slotIdx] then
                        local item = inventoryItems[slotIdx]
                        
                        -- Verificar si S está presionada (verificar en el momento del clic)
                        local sKeyPressed = getKeyState("s")
                        
                        -- Si se presiona S + clic, botar el item
                        if sKeyPressed or isSPressed then
                            outputChatBox("Botando item: " .. item.name, 0, 255, 0)
                            triggerServerEvent("onInventoryItemDrop", localPlayer, slotIdx)
                            return
                        end
                        
                        local currentTime = getTickCount()
                        
                        -- Verificar si es un doble clic (dentro de 500ms)
                        if lastClickTime[slotIdx] and (currentTime - lastClickTime[slotIdx]) < 500 then
                            -- Doble clic - consumir item si es consumible
                            if consumableItems[item.name] then
                                triggerServerEvent("onInventoryItemUse", localPlayer, slotIdx)
                            else
                                outputChatBox("Este item no se puede consumir", 255, 165, 0)
                            end
                            lastClickTime[slotIdx] = nil
                        else
                            -- Clic simple - mostrar información
                            outputChatBox("Item: " .. item.name .. " x" .. item.quantity .. " (Doble clic: consumir | S+Clic o Clic derecho: botar)", 0, 255, 0)
                            lastClickTime[slotIdx] = currentTime
                        end
                    end
                elseif button == "right" and state == "up" then
                    local slotIdx = getElementData(source, "slotIndex")
                    if inventoryItems[slotIdx] then
                        local item = inventoryItems[slotIdx]
                        
                        -- Clic derecho = botar item directamente (más fácil que S+clic)
                        outputChatBox("Botando item: " .. item.name, 0, 255, 0)
                        triggerServerEvent("onInventoryItemDrop", localPlayer, slotIdx)
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
                
                -- Obtener imagen del item si existe
                local itemImage = getItemImage(item.name, item.id)
                
                if itemImage then
                    -- Dibujar imagen del item
                    dxDrawImage(slotX + 5, slotY + 5, SLOT_SIZE - 10, SLOT_SIZE - 10, itemImage, 0, 0, 0,
                        tocolor(255, 255, 255, 255), true)
                else
                    -- Fondo del item con efecto de brillo (si no hay imagen)
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
                end
                
                -- Cantidad (siempre visible, incluso con imagen)
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
                
                -- Indicador de consumible (pequeño icono o texto)
                if consumableItems[item.name] then
                    dxDrawText("⚡", slotX + SLOT_SIZE - 18, slotY + 3, slotX + SLOT_SIZE - 3, slotY + 18,
                        tocolor(colors.success[1], colors.success[2], colors.success[3], 255),
                        0.6, "default", "right", "top", false, false, true)
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

-- ==================== SISTEMA DE RECOGER ITEMS DEL SUELO ====================

-- Renderizar marcadores sobre items botados
addEventHandler("onClientRender", root, function()
    -- Dibujar inventario si está abierto
    if inventoryOpen then
        drawInventory()
    end
    
    -- Buscar objetos botados cerca del jugador
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    local objects = getElementsByType("object")
    
    for _, obj in ipairs(objects) do
        if getElementData(obj, "droppedItem") then
            local objX, objY, objZ = getElementPosition(obj)
            local dx, dy, dz = objX - playerX, objY - playerY, objZ - playerZ
            local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
            
            -- Si está a menos de 5 metros, mostrar información
            if distance < 5.0 then
                local itemName = getElementData(obj, "itemName") or "Item"
                local itemQuantity = getElementData(obj, "itemQuantity") or 1
                
                -- Calcular posición en pantalla
                local screenX, screenY = getScreenFromWorldPosition(objX, objY, objZ + 0.5)
                
                if screenX and screenY then
                    -- Fondo del texto
                    local text = itemName .. " x" .. itemQuantity
                    local textWidth = dxGetTextWidth(text, 0.8, "default-bold")
                    dxDrawRectangle(screenX - textWidth/2 - 5, screenY - 15, textWidth + 10, 20, 
                        tocolor(0, 0, 0, 150), true)
                    
                    -- Texto del item
                    dxDrawText(text, screenX, screenY - 10, screenX, screenY + 10,
                        tocolor(255, 255, 255, 255), 0.8, "default-bold", "center", "center", false, false, true)
                    
                    -- Texto de instrucción si está cerca
                    if distance < 2.0 then
                        local instruction = "Presiona F para recoger"
                        local instWidth = dxGetTextWidth(instruction, 0.6, "default")
                        dxDrawRectangle(screenX - instWidth/2 - 5, screenY + 10, instWidth + 10, 18, 
                            tocolor(0, 150, 0, 150), true)
                        dxDrawText(instruction, screenX, screenY + 19, screenX, screenY + 28,
                            tocolor(255, 255, 255, 255), 0.6, "default", "center", "center", false, false, true)
                    end
                end
            end
        end
    end
end)

-- Función para recoger item del suelo
function pickupDroppedItem(object)
    if not object or not getElementData(object, "droppedItem") then
        return false
    end
    
    local itemName = getElementData(object, "itemName")
    local itemId = getElementData(object, "itemId")
    local itemQuantity = getElementData(object, "itemQuantity")
    
    -- Enviar al servidor para recoger
    triggerServerEvent("onInventoryItemPickup", localPlayer, object)
    
    return true
end

-- Detectar cuando el jugador presiona F cerca de un objeto
bindKey("f", "down", function()
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    local objects = getElementsByType("object")
    
    for _, obj in ipairs(objects) do
        if getElementData(obj, "droppedItem") then
            local objX, objY, objZ = getElementPosition(obj)
            local dx, dy, dz = objX - playerX, objY - playerY, objZ - playerZ
            local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
            
            if distance < 2.0 then
                pickupDroppedItem(obj)
                break
            end
        end
    end
end)

-- Cerrar inventario al desconectar
addEventHandler("onClientResourceStop", resourceRoot, function()
    closeInventory()
end)

