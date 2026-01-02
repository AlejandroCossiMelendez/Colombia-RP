-- Integración del sistema de items con el gamemode
-- Funciones para obtener lista de items y dar items

-- Función auxiliar para obtener getName
local function getItemNameFunc()
    -- Las funciones están incluidas directamente en el gamemode
    -- Usar la función global getName directamente (de items_list.lua)
    if type(getName) == "function" then
        return getName
    end
    -- Si no está disponible, intentar exports como fallback
    local success, result = pcall(function() return exports.items:getName(1) end)
    if success then
        return function(id) 
            local s, r = pcall(function() return exports.items:getName(id) end)
            return s and r or nil
        end
    end
    return nil
end

-- Función auxiliar para obtener give
local function getItemGiveFunc()
    -- Las funciones están incluidas directamente en el gamemode
    -- Usar la función global give directamente (de items.lua)
    if type(give) == "function" then
        return give
    end
    -- Si no está disponible, intentar exports como fallback
    local success = pcall(function() return exports.items:give end)
    if success then
        return function(element, item, val, name) 
            local s, r = pcall(function() return exports.items:give(element, item, val, name) end)
            return s and r or false
        end
    end
    return nil
end

-- Función para obtener la lista de todos los items disponibles
function getAllItemsList()
    local itemsList = {}
    
    -- Las funciones de items están incluidas directamente en el gamemode
    -- Usar la función global getName directamente (de items_list.lua)
    local getNameFunc = getItemNameFunc()
    
    if not getNameFunc then
        outputServerLog("[ITEMS] ERROR: No se pueden acceder a las funciones del sistema de items.")
        outputServerLog("[ITEMS] INFO: Asegúrate de que items_list.lua esté incluido en meta.xml")
        return itemsList
    end
    
    -- Obtener la lista de items
    for i = 1, 102 do -- Basado en item_list que tiene 102 items
        local itemName = getNameFunc(i)
        
        if itemName and itemName ~= " " and itemName ~= "" then
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
    
    local giveFunc = getItemGiveFunc()
    if not giveFunc then
        return false, "El sistema de items no está disponible. Asegúrate de que los scripts de items estén incluidos en meta.xml."
    end
    
    quantity = quantity or 1
    value = value or 1
    
    local successCount = 0
    local errorMsg = nil
    
    -- Dar el item la cantidad de veces especificada
    for i = 1, quantity do
        local result = giveFunc(targetPlayer, itemId, value, name)
        
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
    end
    
    if successCount > 0 then
        return true, "Se dieron " .. successCount .. " item(s) correctamente"
    else
        return false, errorMsg or "No se pudo dar el item"
    end
end

-- Intentar iniciar el recurso items si no está disponible
local function ensureItemsResource()
    local itemsResource = getResourceFromName("items")
    if not itemsResource then
        -- Intentar buscar en la ruta relativa dentro del gamemode
        itemsResource = getResourceFromName("colombia-rp/items")
    end
    if not itemsResource then
        -- Intentar buscar todos los recursos y encontrar items
        local allResources = getResources()
        for _, res in ipairs(allResources) do
            local resName = getResourceName(res)
            if resName == "items" or string.find(resName, "items") then
                itemsResource = res
                break
            end
        end
    end
    
    if itemsResource then
        local itemsState = getResourceState(itemsResource)
        if itemsState == "loaded" or itemsState == "stopped" then
            startResource(itemsResource)
            -- Esperar un momento para que el recurso se inicie
            setTimer(function()
                outputServerLog("[ITEMS] Recurso 'items' iniciado automáticamente")
            end, 500, 1)
        end
    end
end

-- Intentar iniciar items cuando se inicia este recurso
addEventHandler("onResourceStart", resourceRoot, function()
    ensureItemsResource()
end)

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
    
    -- Intentar iniciar items si no está disponible
    ensureItemsResource()
    
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
                local getNameFunc = getItemNameFunc()
                if getNameFunc then
                    local nameResult = getNameFunc(itemId)
                    if nameResult and nameResult ~= " " and nameResult ~= "" then
                        itemName = nameResult
                    end
                end
                table.insert(messages, "✓ " .. itemName .. " x" .. quantity)
            else
                failCount = failCount + 1
                local itemName = "Item " .. itemId
                local getNameFunc = getItemNameFunc()
                if getNameFunc then
                    local nameResult = getNameFunc(itemId)
                    if nameResult and nameResult ~= " " and nameResult ~= "" then
                        itemName = nameResult
                    end
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

