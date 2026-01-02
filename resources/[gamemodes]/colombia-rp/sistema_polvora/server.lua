-- SERVER.LUA - Sistema de Pólvora y Pirotecnia
-- Integrado con el sistema de dinero e inventario del gamemode

-- Posición del NPC vendedor
local npcPos = {x = 2040.73865, y = 1543.47925, z = 10.67188, rot = 180}

-- Crear NPC
local npc = createPed(29, npcPos.x, npcPos.y, npcPos.z, npcPos.rot) -- Skin de vendedor
setElementFrozen(npc, true)
setElementData(npc, "esVendedorPolvora", true)
setPedAnimation(npc, "DEALER", "DEALER_IDLE", -1, true, false, false, false)

-- Items de pólvora disponibles
-- itemId: ID del item en items_list.lua (67 = Pólvora)
local itemsPolvora = {
    {id = 1, nombre = "Petardo Pequeño", precio = 50, efecto = "petardo", desc = "Pequeño estallido con chispas", itemId = 67},
    {id = 2, nombre = "Bengala de Mano", precio = 100, efecto = "bengala", desc = "Chispas doradas en la mano", itemId = 67},
    {id = 3, nombre = "Cohete Volador", precio = 250, efecto = "cohete", desc = "Sube y explota en colores", itemId = 67},
    {id = 4, nombre = "Trueno Explosivo", precio = 300, efecto = "trueno", desc = "Gran explosión con sonido fuerte", itemId = 67},
    {id = 5, nombre = "Fuente de Chispas", precio = 400, efecto = "fuente", desc = "Cascada de chispas doradas", itemId = 67},
    {id = 6, nombre = "Bomba de Humo", precio = 200, efecto = "humo", desc = "Nube de humo de colores", itemId = 67},
    {id = 7, nombre = "Pirotecnia Profesional", precio = 800, efecto = "profesional", desc = "Show completo de fuegos artificiales", itemId = 67},
    {id = 8, nombre = "Granada de Destello", precio = 500, efecto = "destello", desc = "Gran destello cegador", itemId = 67},
}

-- Click en el NPC
addEvent("polvora:clickNPC", true)
addEventHandler("polvora:clickNPC", root, function()
    triggerClientEvent(source, "polvora:abrirPanel", source, itemsPolvora)
end)

-- Comprar item
addEvent("polvora:comprarItem", true)
addEventHandler("polvora:comprarItem", root, function(itemID, precio, nombre)
    local player = source
    
    -- Verificar que tenga personaje seleccionado
    local characterId = getElementData(player, "character:id")
    if not characterId then
        outputChatBox("Error: No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    -- Obtener dinero del personaje usando el sistema del gamemode
    local dinero = getCharacterMoney(player)
    
    if dinero >= precio then
        -- Quitar dinero usando el sistema del gamemode
        if takeCharacterMoney(player, precio) then
            -- Buscar el item en la lista para obtener itemId
            local itemData = nil
            for _, item in ipairs(itemsPolvora) do
                if item.id == itemID then
                    itemData = item
                    break
                end
            end
            
            if itemData then
                -- Agregar item al inventario usando el sistema del gamemode
                -- El item_data contiene el tipo de efecto para identificarlo
                local itemDataStr = "polvora:" .. itemData.efecto
                local success, message = addItemToInventory(player, itemData.itemId, nombre, 1, itemDataStr)
                
                if success then
                    outputChatBox("✓ Has comprado: " .. nombre .. " por $" .. precio .. " - Revisa tu inventario", player, 0, 255, 0)
                    triggerClientEvent(player, "mostrarInfobox", player, "success", "¡" .. nombre .. " comprado!")
                else
                    -- Si falla, devolver el dinero
                    giveCharacterMoney(player, precio)
                    outputChatBox("Error: " .. (message or "No se pudo agregar el item al inventario"), player, 255, 0, 0)
                end
            else
                -- Si no se encuentra el item, devolver el dinero
                giveCharacterMoney(player, precio)
                outputChatBox("Error: Item no encontrado.", player, 255, 0, 0)
            end
        else
            outputChatBox("Error: No se pudo procesar el pago.", player, 255, 0, 0)
        end
    else
        outputChatBox("✗ No tienes suficiente dinero", player, 255, 50, 50)
        triggerClientEvent(player, "mostrarInfobox", player, "error", "Necesitas $" .. precio)
    end
end)


-- Usar item de pólvora
addEvent("polvora:usarItem", true)
addEventHandler("polvora:usarItem", root, function(itemNombre, efecto)
    local player = source
    local characterId = getElementData(player, "character:id")
    
    if not characterId then
        outputChatBox("Error: No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    -- Buscar el item en el inventario del jugador
    local inventory = getPlayerInventory(player)
    local itemEncontrado = nil
    
    for _, item in ipairs(inventory) do
        if item.item_name == itemNombre and item.item_data and string.find(item.item_data, "polvora:" .. efecto) then
            itemEncontrado = item
            break
        end
    end
    
    if itemEncontrado and itemEncontrado.quantity > 0 then
        -- Remover 1 unidad del inventario usando el sistema del gamemode
        local success, message = removeItemFromInventory(player, itemEncontrado.slot, 1)
        
        if success then
            -- Obtener posición del jugador
            local x, y, z = getElementPosition(player)
            
            -- Activar efecto para todos los jugadores cercanos
            for _, otherPlayer in ipairs(getElementsByType("player")) do
                local px, py, pz = getElementPosition(otherPlayer)
                local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
                
                if distancia < 100 then
                    triggerClientEvent(otherPlayer, "polvora:activarEfecto", otherPlayer, efecto, x, y, z)
                end
            end
            
            outputChatBox("✓ Has usado: " .. itemNombre, player, 255, 200, 0)
            triggerEvent("polvora:obtenerInventario", player)
        else
            outputChatBox("Error: " .. (message or "No se pudo usar el item"), player, 255, 0, 0)
        end
    else
        outputChatBox("✗ No tienes este item", player, 255, 50, 50)
        triggerClientEvent(player, "mostrarInfobox", player, "error", "No tienes este item")
    end
end)

-- Export
function getPlayerFireworks(player)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return {}
    end
    
    -- Obtener inventario del jugador usando el sistema del gamemode
    local inventory = getPlayerInventory(player)
    
    -- Filtrar solo los items de pólvora
    local polvoraItems = {}
    for _, item in ipairs(inventory) do
        if item.item_data and string.find(item.item_data, "polvora:") then
            local efecto = string.match(item.item_data, "polvora:(.+)")
            table.insert(polvoraItems, {
                item = item.item_name,
                cantidad = item.quantity,
                efecto = efecto
            })
        end
    end
    
    return polvoraItems
end