-- Integración del sistema de items con el gamemode
-- Funciones para obtener lista de items y dar items

-- Función para obtener la lista de todos los items disponibles
function getAllItemsList()
    local itemsList = {}
    
    -- Verificar si el recurso items está disponible
    local itemsResource = getResourceFromName("items")
    if not itemsResource or getResourceState(itemsResource) ~= "running" then
        outputServerLog("[ITEMS] El recurso 'items' no está disponible. Asegúrate de que el recurso 'items' esté iniciado.")
        return itemsList
    end
    
    -- Obtener la lista de items usando la función exportada getName
    for i = 1, 102 do -- Basado en item_list que tiene 102 items
        local success, itemName = pcall(function() return exports.items:getName(i) end)
        if success and itemName and itemName ~= " " and itemName ~= "" then
            table.insert(itemsList, {
                id = i,
                name = itemName
            })
        end
    end
    
    return itemsList
end

-- Función para dar un item a un jugador
function giveItemToPlayer(targetPlayer, itemId, value, name, quantity)
    if not isElement(targetPlayer) or getElementType(targetPlayer) ~= "player" then
        return false, "Jugador inválido"
    end
    
    if not getElementData(targetPlayer, "character:selected") then
        return false, "El jugador no tiene un personaje seleccionado"
    end
    
    -- Verificar si el recurso items está disponible
    local itemsResource = getResourceFromName("items")
    if not itemsResource or getResourceState(itemsResource) ~= "running" then
        return false, "El sistema de items no está disponible. Asegúrate de que el recurso 'items' esté iniciado."
    end
    
    quantity = quantity or 1
    value = value or 1
    
    local successCount = 0
    local errorMsg = nil
    
    -- Dar el item la cantidad de veces especificada
    for i = 1, quantity do
        local success, result = pcall(function() 
            return exports.items:give(targetPlayer, itemId, value, name) 
        end)
        
        if success then
            if result == true then
                successCount = successCount + 1
            else
                -- result puede ser false o un string con el error
                if type(result) == "string" then
                    errorMsg = result
                else
                    errorMsg = "Error al dar el item"
                end
            end
        else
            -- Error en pcall
            errorMsg = result or "Error al llamar a la función give"
        end
    end
    
    if successCount > 0 then
        return true, "Se dieron " .. successCount .. " item(s) correctamente"
    else
        return false, errorMsg or "No se pudo dar el item"
    end
end

-- Evento para obtener la lista de items (para el panel)
addEvent("admin:getItemsList", true)
addEventHandler("admin:getItemsList", root, function()
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    -- Verificar permisos
    local role = getElementData(source, "account:role")
    if role ~= "admin" and role ~= "staff" and role ~= "moderator" then
        return
    end
    
    local itemsList = getAllItemsList()
    triggerClientEvent(source, "admin:receiveItemsList", resourceRoot, itemsList)
end)

-- Evento para dar items a un jugador
addEvent("admin:giveItems", true)
addEventHandler("admin:giveItems", root, function(characterId, itemsData)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    -- Verificar permisos
    local role = getElementData(source, "account:role")
    if role ~= "admin" and role ~= "staff" and role ~= "moderator" then
        triggerClientEvent(source, "admin:giveItemsResponse", resourceRoot, false, "No tienes permiso para usar esta función.")
        return
    end
    
    if not characterId or not tonumber(characterId) then
        triggerClientEvent(source, "admin:giveItemsResponse", resourceRoot, false, "ID de personaje inválido.")
        return
    end
    
    if not itemsData or type(itemsData) ~= "table" or #itemsData == 0 then
        triggerClientEvent(source, "admin:giveItemsResponse", resourceRoot, false, "No se seleccionaron items.")
        return
    end
    
    characterId = tonumber(characterId)
    
    -- Buscar jugador con ese ID de personaje
    local target = nil
    for _, p in ipairs(getElementsByType("player")) do
        if getElementData(p, "character:selected") then
            local pCharId = getElementData(p, "character:id")
            if pCharId and tonumber(pCharId) == characterId then
                target = p
                break
            end
        end
    end
    
    if not target then
        triggerClientEvent(source, "admin:giveItemsResponse", resourceRoot, false, "No se encontró ningún jugador con el ID de personaje " .. characterId .. ".")
        return
    end
    
    -- Dar cada item
    local successCount = 0
    local failCount = 0
    local messages = {}
    
    for _, itemData in ipairs(itemsData) do
        local itemId = tonumber(itemData.itemId)
        local quantity = tonumber(itemData.quantity) or 1
        local value = itemData.value or 1
        local name = itemData.name or nil
        
        if itemId then
            local success, errorMsg = giveItemToPlayer(target, itemId, value, name, quantity)
            if success then
                successCount = successCount + 1
                local itemName = "Item " .. itemId
                local success2, nameResult = pcall(function() return exports.items:getName(itemId) end)
                if success2 and nameResult and nameResult ~= " " and nameResult ~= "" then
                    itemName = nameResult
                end
                table.insert(messages, "✓ " .. itemName .. " x" .. quantity)
            else
                failCount = failCount + 1
                local itemName = "Item " .. itemId
                local success2, nameResult = pcall(function() return exports.items:getName(itemId) end)
                if success2 and nameResult and nameResult ~= " " and nameResult ~= "" then
                    itemName = nameResult
                end
                table.insert(messages, "✗ " .. itemName .. ": " .. (errorMsg or "Error"))
            end
        end
    end
    
    local charName = getElementData(target, "character:name")
    local charSurname = getElementData(target, "character:surname")
    local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
    
    local resultMessage = "Items dados a " .. displayName .. " (ID: " .. characterId .. "):\n" .. table.concat(messages, "\n")
    if failCount > 0 then
        resultMessage = resultMessage .. "\n\n" .. successCount .. " exitoso(s), " .. failCount .. " fallido(s)"
    end
    
    triggerClientEvent(source, "admin:giveItemsResponse", resourceRoot, successCount > 0, resultMessage)
    outputServerLog("[ADMIN] " .. getPlayerName(source) .. " dio items a " .. displayName .. " (ID: " .. characterId .. ")")
end)

