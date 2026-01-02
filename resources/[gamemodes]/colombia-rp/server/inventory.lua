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
addEventHandler("useItem", root, function(slot, itemId, itemIndex)
    local characterId = getElementData(source, "character:id")
    if not characterId then
        return
    end
    
    -- Obtener item del sistema de items (tabla items) en lugar de inventory
    local items = get(source)
    if not items or type(items) ~= "table" then
        outputChatBox("No se pudo cargar tu inventario", source, 255, 0, 0)
        return
    end
    
    -- Buscar el item por itemIndex (index de la BD) o por itemId
    local item = nil
    if itemIndex then
        -- Buscar por index de la BD
        for _, it in ipairs(items) do
            if tonumber(it.index) == tonumber(itemIndex) then
                item = it
                break
            end
        end
    end
    
    -- Si no se encontró por index, buscar por item_id y slot visual
    if not item and itemId then
        -- Buscar el item que coincida con el item_id y esté en la posición del slot
        local slotNum = tonumber(slot)
        if slotNum and items[slotNum] and tonumber(items[slotNum].item) == tonumber(itemId) then
            item = items[slotNum]
        else
            -- Buscar en toda la tabla
            for _, it in ipairs(items) do
                if tonumber(it.item) == tonumber(itemId) then
                    item = it
                    break
                end
            end
        end
    end
    
    -- Si aún no se encontró, usar el slot directamente
    if not item and slot then
        item = items[tonumber(slot)]
    end
    
    if not item then
        outputChatBox("No hay ningún item en ese slot", source, 255, 0, 0)
        return
    end
    
    local itemId = tonumber(item.item)
    local itemName = item.name or "Item"
    
    -- Chaleco Antibalas (ID: 46) - Equipar y poner defensa según el valor del item
    if itemId == 46 then
        -- El valor del item es el porcentaje de defensa del chaleco
        local armorValue = tonumber(item.value) or 100
        if armorValue < 0 then armorValue = 0 end
        if armorValue > 100 then armorValue = 100 end
        
        setPedArmor(source, armorValue)
        outputChatBox("Has equipado un Chaleco Antibalas. Tu defensa está al " .. armorValue .. "%.", source, 0, 150, 255)
        
        -- Marcar que el jugador tiene chaleco equipado (para mostrar icono)
        setElementData(source, "has:vest", true)
        setElementData(source, "vest:armor", armorValue) -- Guardar el porcentaje de defensa del chaleco
        setElementData(source, "vest:itemIndex", item.index) -- Guardar el índice de la BD del chaleco equipado
        
        -- Remover el item del inventario usando el sistema de items
        if take then
            local result = take(source, tonumber(slot))
            if result then
                -- Recargar items para actualizar el inventario
                if load then
                    load(source, true)
                end
            end
        end
        return
    end
    
    -- Verificar si las funciones de necesidades están disponibles
    if not feedPlayer or not hydratePlayer then
        outputChatBox("El sistema de necesidades no está disponible", source, 255, 0, 0)
        return
    end
    
    -- Mapeo de items y sus efectos
    local itemEffects = {
        -- Items que restauran hambre
        [3] = { type = "hunger", amount = 50, name = "Comida" }, -- Comida
        [56] = { type = "hunger", amount = 40, name = "Pescado chico" }, -- Pescado chico
        [94] = { type = "hunger", amount = 50, name = "Bandeja Paisa" }, -- Bandeja Paisa
        [95] = { type = "hunger", amount = 30, name = "Salchipapa" }, -- Salchipapa
        [97] = { type = "hunger", amount = 40, name = "Carne Con Oro" }, -- Carne Con Oro
        [99] = { type = "hunger", amount = 30, name = "Hamburguesa" }, -- Hamburguesa
        [100] = { type = "hunger", amount = 20, name = "Arepa" }, -- Arepa
        
        -- Items que restauran sed
        [4] = { type = "thirst", amount = 35, name = "Bebida sin alcohol" }, -- Bebida sin alcohol
        [71] = { type = "thirst", amount = 30, name = "Cafe" }, -- Café
        [72] = { type = "thirst", amount = 30, name = "Pony Malta" }, -- Pony Malta
        [93] = { type = "thirst", amount = 40, name = "Amper" }, -- Amper
        [98] = { type = "thirst", amount = 30, name = "Jugo Hit" }, -- Jugo Hit
    }
    
    -- Buscar efecto del item
    local effect = itemEffects[itemId]
    
    if effect then
        if effect.type == "hunger" then
            feedPlayer(source, effect.amount)
            outputChatBox("Has consumido " .. effect.name .. ". Hambre restaurada: +" .. effect.amount .. "%", source, 0, 255, 0)
        elseif effect.type == "thirst" then
            hydratePlayer(source, effect.amount)
            outputChatBox("Has consumido " .. effect.name .. ". Sed restaurada: +" .. effect.amount .. "%", source, 0, 255, 0)
        end
        
        -- Remover el item del inventario usando el sistema de items
        -- La función take() usa el slot (posición en la tabla), no el index de la BD
        if take then
            local result = take(source, tonumber(slot))
            if result then
                -- Recargar items para actualizar el inventario
                if load then
                    load(source, true)
                end
            end
        end
    else
        outputChatBox("Este item no se puede consumir", source, 255, 255, 0)
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

-- Evento para quitarse el chaleco
addEvent("unequipVest", true)
addEventHandler("unequipVest", root, function()
    local hasVest = getElementData(source, "has:vest")
    if not hasVest then
        outputChatBox("No tienes un chaleco equipado", source, 255, 0, 0)
        return
    end
    
    -- Obtener el porcentaje de defensa actual
    local currentArmor = math.floor(getPedArmor(source))
    if currentArmor < 0 then currentArmor = 0 end
    if currentArmor > 100 then currentArmor = 100 end
    
    -- Si el armor es 0, no devolver el chaleco al inventario
    if currentArmor <= 0 then
        setPedArmor(source, 0)
        removeElementData(source, "has:vest")
        removeElementData(source, "vest:armor")
        removeElementData(source, "vest:itemIndex")
        outputChatBox("El chaleco se ha destruido (0% de defensa restante).", source, 255, 165, 0)
        return
    end
    
    -- Quitar el chaleco (poner defensa a 0)
    setPedArmor(source, 0)
    
    -- Remover los datos del chaleco
    removeElementData(source, "has:vest")
    removeElementData(source, "vest:armor")
    removeElementData(source, "vest:itemIndex")
    
    -- Devolver el chaleco al inventario con el porcentaje de defensa restante
    if give then
        -- Usar el sistema de items para dar el chaleco
        -- El valor del item será el porcentaje de defensa restante
        local result = give(source, 46, currentArmor, "Chaleco Antibalas") -- 46 es el ID del chaleco antibalas
        if result then
            outputChatBox("Te has quitado el Chaleco Antibalas. Defensa restante: " .. currentArmor .. "%", source, 0, 150, 255)
            -- Recargar items para actualizar el inventario
            if load then
                load(source, true)
            end
        else
            outputChatBox("Error al devolver el chaleco al inventario", source, 255, 0, 0)
        end
    else
        outputChatBox("Error: Sistema de items no disponible", source, 255, 0, 0)
    end
end)
