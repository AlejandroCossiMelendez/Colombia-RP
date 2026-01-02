-- SERVER.LUA - Sistema de Pólvora y Pirotecnia
-- Integrado con el sistema de dinero e inventario del gamemode

-- Verificar que la función give esté disponible
if not give then
    outputServerLog("[POLVORA] ERROR: La función give() no está disponible. Asegúrate de que items.lua esté cargado.")
end

-- Posición del NPC vendedor
local npcPos = {x = 2040.73865, y = 1543.47925, z = 10.67188, rot = 180}

-- Crear NPC
local npc = createPed(29, npcPos.x, npcPos.y, npcPos.z, npcPos.rot) -- Skin de vendedor
setElementFrozen(npc, true)
setElementData(npc, "esVendedorPolvora", true)
setPedAnimation(npc, "DEALER", "DEALER_IDLE", -1, true, false, false, false)

-- Items de pólvora disponibles (C4 Explosivos)
-- itemId: IDs de los C4 en items_list.lua (103, 104, 105)
local itemsPolvora = {
    {id = 1, nombre = "C4 Explosivo Tipo 1", precio = 500, efecto = "c4_tipo1", desc = "C4 explosivo de alta potencia", itemId = 103},
    {id = 2, nombre = "C4 Explosivo Tipo 2", precio = 750, efecto = "c4_tipo2", desc = "C4 explosivo de potencia media", itemId = 104},
    {id = 3, nombre = "C4 Explosivo Tipo 3", precio = 1000, efecto = "c4_tipo3", desc = "C4 explosivo de máxima potencia", itemId = 105},
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
                -- Agregar item al inventario usando el sistema de items (función give)
                -- La función give está disponible globalmente desde items.lua
                -- give(player, itemId, value, name)
                -- value = 1 (cantidad), name = nombre del item
                outputServerLog("[POLVORA] Intentando dar item " .. itemData.itemId .. " (" .. nombre .. ") a " .. getPlayerName(player))
                
                local success, errorMsg = give(player, itemData.itemId, 1, nombre)
                
                if success then
                    outputChatBox("✓ Has comprado: " .. nombre .. " por $" .. precio .. " - Revisa tu inventario", player, 0, 255, 0)
                    triggerClientEvent(player, "mostrarInfobox", player, "success", "¡" .. nombre .. " comprado!")
                    outputServerLog("[POLVORA] ✓ Item " .. itemData.itemId .. " (" .. nombre .. ") dado correctamente a " .. getPlayerName(player))
                else
                    -- Si falla, devolver el dinero
                    giveCharacterMoney(player, precio)
                    local errorText = errorMsg or "give() retornó false"
                    outputChatBox("Error: No se pudo agregar el item al inventario: " .. errorText, player, 255, 0, 0)
                    outputServerLog("[POLVORA] ✗ ERROR al dar item " .. itemData.itemId .. " a " .. getPlayerName(player) .. " - " .. errorText)
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

-- Crear C4 en el servidor (visible para todos)
addEvent("polvora:crearC4", true)
addEventHandler("polvora:crearC4", root, function(x, y, z, rotZ, itemId, itemName)
    local player = source
    
    -- Crear objeto C4 en el servidor (visible para todos)
    local c4Object = createObject(1252, x, y, z, 0, 0, rotZ)
    
    if not c4Object then
        outputChatBox("Error: No se pudo colocar el C4.", player, 255, 0, 0)
        return
    end
    
    -- Configurar dimensiones e interior del C4
    setElementDimension(c4Object, getElementDimension(player))
    setElementInterior(c4Object, getElementInterior(player))
    
    -- Guardar datos del C4
    setElementData(c4Object, "c4:active", true)
    setElementData(c4Object, "c4:owner", player)
    setElementData(c4Object, "c4:type", itemId)
    
    -- Determinar daño según el tipo de C4
    local damage = 0
    local explosionType = 6 -- Tipo de explosión grande
    if itemId == 103 then
        damage = 20 -- Tipo 1: daño bajo
        explosionType = 5
    elseif itemId == 104 then
        damage = 50 -- Tipo 2: daño medio
        explosionType = 6
    elseif itemId == 105 then
        damage = 100 -- Tipo 3: daño alto
        explosionType = 7
    end
    
    -- Notificar a todos los jugadores cercanos que se colocó un C4
    for _, p in ipairs(getElementsByType("player")) do
        if isElement(p) then
            local px, py, pz = getElementPosition(p)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            if distance < 20 then
                triggerClientEvent(p, "polvora:c4Colocado", p, c4Object, x, y, z)
            end
        end
    end
    
    -- Notificar al jugador que lo colocó
    outputChatBox("✓ Has colocado un " .. itemName .. ". ¡Explotará en 5 segundos!", player, 255, 200, 0)
    
    -- Hacer que explote en 5 segundos
    setTimer(function()
        if isElement(c4Object) then
            local objX, objY, objZ = getElementPosition(c4Object)
            
            -- Crear explosión en el servidor (visible para todos)
            createExplosion(objX, objY, objZ, explosionType, true, 1.0, false)
            
            -- Aplicar daño a todos los jugadores cercanos
            local explosionRadius = 10 -- Radio de la explosión en metros
            
            for _, p in ipairs(getElementsByType("player")) do
                if isElement(p) and getElementType(p) == "player" then
                    local px, py, pz = getElementPosition(p)
                    local distance = getDistanceBetweenPoints3D(objX, objY, objZ, px, py, pz)
                    
                    if distance <= explosionRadius then
                        -- Calcular daño según la distancia (más cerca = más daño)
                        local distanceFactor = 1 - (distance / explosionRadius) -- 1.0 en el centro, 0.0 en el borde
                        local finalDamage = damage * distanceFactor
                        
                        -- Aplicar daño
                        local currentHealth = getElementHealth(p)
                        local newHealth = math.max(0, currentHealth - finalDamage)
                        setElementHealth(p, newHealth)
                        
                        -- Notificar al jugador
                        if finalDamage > 0 then
                            outputChatBox("💥 Has recibido " .. math.floor(finalDamage) .. " de daño por la explosión.", p, 255, 100, 0)
                        end
                        
                        -- Si el jugador muere por la explosión
                        if newHealth <= 0 then
                            killPed(p)
                        end
                    end
                    
                    -- Notificar explosión a todos los jugadores cercanos
                    if distance < 50 then
                        triggerClientEvent(p, "polvora:notificarExplosion", p, objX, objY, objZ, explosionType)
                    end
                end
            end
            
            -- Destruir el objeto
            destroyElement(c4Object)
        end
    end, 5000, 1)
end)

-- Export
function getPlayerFireworks(player)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return {}
    end
    
    -- Obtener inventario del jugador usando el sistema del gamemode
    local inventory = getPlayerInventory(player)
    
    -- Filtrar solo los items de pólvora (C4)
    local polvoraItems = {}
    for _, item in ipairs(inventory) do
        if item.item_id == 103 or item.item_id == 104 or item.item_id == 105 then
            table.insert(polvoraItems, {
                item = item.item_name,
                cantidad = item.quantity,
                item_id = item.item_id
            })
        end
    end
    
    return polvoraItems
end