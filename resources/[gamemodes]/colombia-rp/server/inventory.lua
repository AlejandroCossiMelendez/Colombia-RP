-- Sistema de Inventario
-- Estructura de la tabla inventory:
-- id, character_id, slot, item_id, item_name, quantity, item_data

function getPlayerInventory(player)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return {}
    end
    
    local query = "SELECT * FROM inventory WHERE character_id = ? ORDER BY slot ASC"
    local result = queryDatabase(query, characterId)
    
    return result or {}
end

function getPlayerInventoryBySlot(player, slot)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return nil
    end
    
    local query = "SELECT * FROM inventory WHERE character_id = ? AND slot = ? LIMIT 1"
    local result = queryDatabase(query, characterId, slot)
    
    if result and #result > 0 then
        return result[1]
    end
    
    return nil
end

function getNextAvailableSlot(player)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return nil
    end
    
    -- Buscar el primer slot disponible (asumiendo máximo 50 slots)
    for i = 1, 50 do
        local item = getPlayerInventoryBySlot(player, i)
        if not item then
            return i
        end
    end
    
    return nil -- Inventario lleno
end

function addItemToInventory(player, itemId, itemName, quantity, itemData, slot)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return false, "No tienes un personaje seleccionado"
    end
    
    quantity = quantity or 1
    itemData = itemData or ""
    itemId = itemId or 0
    
    -- Si no se especifica slot, buscar uno disponible
    if not slot then
        slot = getNextAvailableSlot(player)
        if not slot then
            return false, "Inventario lleno"
        end
    end
    
    -- Verificar si el slot está ocupado
    local existingItem = getPlayerInventoryBySlot(player, slot)
    
    if existingItem then
        -- Si es el mismo item, aumentar cantidad
        if existingItem.item_id == itemId and existingItem.item_name == itemName then
            local newQuantity = existingItem.quantity + quantity
            local updateQuery = "UPDATE inventory SET quantity = ? WHERE id = ?"
            local success = executeDatabase(updateQuery, newQuantity, existingItem.id)
            
            if success then
                triggerClientEvent(player, "inventoryUpdated", resourceRoot)
                return true, "Item agregado"
            else
                return false, "Error al actualizar el inventario"
            end
        else
            -- Slot ocupado por otro item
            return false, "El slot está ocupado"
        end
    else
        -- Crear nuevo item en el slot
        local insertQuery = "INSERT INTO inventory (character_id, slot, item_id, item_name, quantity, item_data) VALUES (?, ?, ?, ?, ?, ?)"
        local success = executeDatabase(insertQuery, characterId, slot, itemId, itemName, quantity, itemData)
        
        if success then
            triggerClientEvent(player, "inventoryUpdated", resourceRoot)
            return true, "Item agregado"
        else
            return false, "Error al agregar el item"
        end
    end
end

function removeItemFromInventory(player, slot, quantity)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return false, "No tienes un personaje seleccionado"
    end
    
    quantity = quantity or 1
    
    local item = getPlayerInventoryBySlot(player, slot)
    if not item then
        return false, "No hay item en ese slot"
    end
    
    local currentQuantity = item.quantity
    
    if currentQuantity <= quantity then
        -- Eliminar item completamente
        local deleteQuery = "DELETE FROM inventory WHERE id = ?"
        local success = executeDatabase(deleteQuery, item.id)
        
        if success then
            triggerClientEvent(player, "inventoryUpdated", resourceRoot)
            return true, "Item eliminado"
        else
            return false, "Error al eliminar el item"
        end
    else
        -- Reducir cantidad
        local newQuantity = currentQuantity - quantity
        local updateQuery = "UPDATE inventory SET quantity = ? WHERE id = ?"
        local success = executeDatabase(updateQuery, newQuantity, item.id)
        
        if success then
            triggerClientEvent(player, "inventoryUpdated", resourceRoot)
            return true, "Cantidad reducida"
        else
            return false, "Error al actualizar el inventario"
        end
    end
end

function moveItemInInventory(player, fromSlot, toSlot)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return false, "No tienes un personaje seleccionado"
    end
    
    local fromItem = getPlayerInventoryBySlot(player, fromSlot)
    if not fromItem then
        return false, "No hay item en el slot de origen"
    end
    
    local toItem = getPlayerInventoryBySlot(player, toSlot)
    
    if toItem then
        -- Si el slot destino tiene el mismo item, combinar
        if toItem.item_id == fromItem.item_id and toItem.item_name == fromItem.item_name then
            local newQuantity = toItem.quantity + fromItem.quantity
            local updateQuery = "UPDATE inventory SET quantity = ? WHERE id = ?"
            executeDatabase(updateQuery, newQuantity, toItem.id)
            removeItemFromInventory(player, fromSlot, fromItem.quantity)
            triggerClientEvent(player, "inventoryUpdated", resourceRoot)
            return true, "Items combinados"
        else
            -- Intercambiar items
            local updateFromQuery = "UPDATE inventory SET slot = ? WHERE id = ?"
            local updateToQuery = "UPDATE inventory SET slot = ? WHERE id = ?"
            
            -- Usar un slot temporal para el intercambio
            executeDatabase("UPDATE inventory SET slot = 999 WHERE id = ?", fromItem.id)
            executeDatabase(updateToQuery, fromSlot, toItem.id)
            executeDatabase("UPDATE inventory SET slot = ? WHERE id = ?", toSlot, fromItem.id)
            
            triggerClientEvent(player, "inventoryUpdated", resourceRoot)
            return true, "Items intercambiados"
        end
    else
        -- Mover item a slot vacío
        local updateQuery = "UPDATE inventory SET slot = ? WHERE id = ?"
        local success = executeDatabase(updateQuery, toSlot, fromItem.id)
        
        if success then
            triggerClientEvent(player, "inventoryUpdated", resourceRoot)
            return true, "Item movido"
        else
            return false, "Error al mover el item"
        end
    end
end

function hasItem(player, itemName, quantity)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return false
    end
    
    quantity = quantity or 1
    
    local query = "SELECT SUM(quantity) as total FROM inventory WHERE character_id = ? AND item_name = ?"
    local result = queryDatabase(query, characterId, itemName)
    
    if result and #result > 0 and result[1].total then
        return tonumber(result[1].total) >= quantity
    end
    
    return false
end

function getItemQuantity(player, itemName)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return 0
    end
    
    local query = "SELECT SUM(quantity) as total FROM inventory WHERE character_id = ? AND item_name = ?"
    local result = queryDatabase(query, characterId, itemName)
    
    if result and #result > 0 and result[1].total then
        return tonumber(result[1].total) or 0
    end
    
    return 0
end

function getItemBySlot(player, slot)
    return getPlayerInventoryBySlot(player, slot)
end

-- Eventos para el cliente
addEvent("requestInventory", true)
addEventHandler("requestInventory", root, function()
    local inventory = getPlayerInventory(source)
    triggerClientEvent(source, "receiveInventory", resourceRoot, inventory)
end)

addEvent("useItem", true)
addEventHandler("useItem", root, function(slot)
    local characterId = getElementData(source, "character:id")
    if not characterId then
        return
    end
    
    local item = getPlayerInventoryBySlot(source, slot)
    if not item then
        outputChatBox("No hay ningún item en ese slot", source, 255, 0, 0)
        return
    end
    
    -- Aquí puedes agregar lógica para usar items específicos
    -- Por ejemplo: comida, bebida, armas, etc.
    outputChatBox("Usaste: " .. item.item_name .. " (x" .. item.quantity .. ")", source, 0, 255, 0)
    
    -- Ejemplo: si es comida, aumentar hambre
    if string.find(string.lower(item.item_name), "comida") or string.find(string.lower(item.item_name), "food") then
        -- Llamar a la función feedPlayer del sistema de necesidades
        if feedPlayer then
            feedPlayer(source, 30)
            removeItemFromInventory(source, slot, 1)
        end
    -- Ejemplo: si es bebida, aumentar sed
    elseif string.find(string.lower(item.item_name), "bebida") or string.find(string.lower(item.item_name), "agua") or string.find(string.lower(item.item_name), "water") or string.find(string.lower(item.item_name), "drink") then
        if hydratePlayer then
            hydratePlayer(source, 30)
            removeItemFromInventory(source, slot, 1)
        end
    end
end)

addEvent("moveInventoryItem", true)
addEventHandler("moveInventoryItem", root, function(fromSlot, toSlot)
    local success, message = moveItemInInventory(source, fromSlot, toSlot)
    if success then
        outputChatBox(message, source, 0, 255, 0)
    else
        outputChatBox(message, source, 255, 0, 0)
    end
end)

addEvent("dropInventoryItem", true)
addEventHandler("dropInventoryItem", root, function(slot, quantity)
    quantity = quantity or 1
    local success, message = removeItemFromInventory(source, slot, quantity)
    if success then
        outputChatBox(message, source, 0, 255, 0)
        -- Aquí podrías crear un objeto en el mundo con el item
    else
        outputChatBox(message, source, 255, 0, 0)
    end
end)

-- Comandos de prueba
addCommandHandler("inventario", function(player)
    local inventory = getPlayerInventory(player)
    outputChatBox("=== Tu Inventario ===", player, 255, 255, 0)
    
    if #inventory == 0 then
        outputChatBox("Tu inventario está vacío", player, 255, 255, 255)
    else
        for _, item in ipairs(inventory) do
            outputChatBox("Slot " .. item.slot .. ": " .. item.item_name .. " x" .. item.quantity, player, 255, 255, 255)
        end
    end
end)

addCommandHandler("daritem", function(player, cmd, targetName, itemName, quantity)
    if not targetName or not itemName then
        outputChatBox("Uso: /daritem [jugador] [item] [cantidad]", player, 255, 0, 0)
        return
    end
    
    quantity = tonumber(quantity) or 1
    
    local target = getPlayerFromName(targetName)
    if not target then
        outputChatBox("Jugador no encontrado", player, 255, 0, 0)
        return
    end
    
    -- Verificar que el jugador tenga el item
    if hasItem(player, itemName, quantity) then
        -- Remover del inventario del jugador
        -- Nota: esto removerá del primer slot que encuentre con ese item
        local inventory = getPlayerInventory(player)
        local removed = false
        
        for _, item in ipairs(inventory) do
            if item.item_name == itemName and item.quantity >= quantity then
                removeItemFromInventory(player, item.slot, quantity)
                addItemToInventory(target, item.item_id, item.item_name, quantity, item.item_data)
                outputChatBox("Le diste " .. quantity .. "x " .. itemName .. " a " .. getPlayerName(target), player, 0, 255, 0)
                outputChatBox(getPlayerName(player) .. " te dio " .. quantity .. "x " .. itemName, target, 0, 255, 0)
                removed = true
                break
            end
        end
        
        if not removed then
            outputChatBox("No tienes suficiente cantidad de ese item", player, 255, 0, 0)
        end
    else
        outputChatBox("No tienes ese item", player, 255, 0, 0)
    end
end)

-- Función helper para agregar items de prueba
addCommandHandler("darme", function(player, cmd, itemName, quantity)
    quantity = tonumber(quantity) or 1
    local success, message = addItemToInventory(player, 0, itemName, quantity, "")
    if success then
        outputChatBox("Recibiste: " .. itemName .. " x" .. quantity, player, 0, 255, 0)
    else
        outputChatBox(message, player, 255, 0, 0)
    end
end)
