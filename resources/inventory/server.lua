-- Sistema de Inventario - Servidor
local db = nil

-- ==================== CONFIGURACIÓN MySQL ====================
-- Usar la misma configuración que el sistema de login
local MYSQL_HOST = "127.0.0.1"
local MYSQL_USER = "mta_user"
local MYSQL_PASS = "15306266_Mta"
local MYSQL_DB = "mta_login"
local MYSQL_PORT = 3306

-- ==================== REGISTRAR EVENTOS ====================
addEvent("onRequestInventory", true)
addEvent("onInventoryItemAdd", true)
addEvent("onInventoryItemRemove", true)
addEvent("onInventoryItemUse", true)

-- ==================== BASE DE DATOS ====================
function initInventoryDatabase()
    -- Intentar usar la misma conexión de la base de datos del login
    -- Si no está disponible, crear una nueva conexión
    db = dbConnect("mysql", 
        "dbname=" .. MYSQL_DB .. ";host=" .. MYSQL_HOST .. ";port=" .. MYSQL_PORT,
        MYSQL_USER, 
        MYSQL_PASS
    )
    
    if not db then
        local errorMsg = dbError()
        outputServerLog("[Inventory] ERROR: No se pudo conectar a la base de datos MySQL")
        outputServerLog("[Inventory] Error: " .. tostring(errorMsg))
        return false
    end
    
    outputServerLog("[Inventory] Conexión a MySQL establecida correctamente")
    
    -- Crear tabla de inventario si no existe
    local query = dbQuery(db, [[
        CREATE TABLE IF NOT EXISTS inventory (
            id INT AUTO_INCREMENT PRIMARY KEY,
            character_id INT NOT NULL,
            slot INT NOT NULL,
            item_id INT NOT NULL,
            item_name VARCHAR(100) NOT NULL,
            quantity INT NOT NULL DEFAULT 1,
            item_data TEXT,
            UNIQUE KEY unique_character_slot (character_id, slot),
            INDEX idx_character_id (character_id),
            FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    if query then
        dbPoll(query, -1)
        outputServerLog("[Inventory] Tabla 'inventory' verificada/creada")
    else
        local errorMsg = dbError(db)
        outputServerLog("[Inventory] ERROR al crear tabla inventory: " .. tostring(errorMsg))
        
        -- Intentar crear sin foreign key si falla
        local query2 = dbQuery(db, [[
            CREATE TABLE IF NOT EXISTS inventory (
                id INT AUTO_INCREMENT PRIMARY KEY,
                character_id INT NOT NULL,
                slot INT NOT NULL,
                item_id INT NOT NULL,
                item_name VARCHAR(100) NOT NULL,
                quantity INT NOT NULL DEFAULT 1,
                item_data TEXT,
                UNIQUE KEY unique_character_slot (character_id, slot),
                INDEX idx_character_id (character_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ]])
        
        if query2 then
            dbPoll(query2, -1)
            outputServerLog("[Inventory] Tabla 'inventory' creada sin foreign key")
        end
    end
    
    return true
end

-- ==================== FUNCIONES DE INVENTARIO ====================

-- Obtener inventario de un personaje
function getCharacterInventory(characterId)
    if not db or not characterId then
        return {}
    end
    
    local query = dbQuery(db, "SELECT slot, item_id, item_name, quantity, item_data FROM inventory WHERE character_id = ? ORDER BY slot ASC", characterId)
    local result = dbPoll(query, -1)
    
    if not result then
        return {}
    end
    
    local inventory = {}
    for _, row in ipairs(result) do
        inventory[tonumber(row.slot)] = {
            id = tonumber(row.item_id),
            name = row.item_name,
            quantity = tonumber(row.quantity),
            data = row.item_data or ""
        }
    end
    
    return inventory
end

-- Agregar item al inventario
function addItemToInventory(characterId, slot, itemId, itemName, quantity, itemData)
    if not db or not characterId or not slot or not itemId or not itemName then
        return false
    end
    
    quantity = quantity or 1
    itemData = itemData or ""
    
    -- Verificar si el slot está ocupado
    local checkQuery = dbQuery(db, "SELECT id FROM inventory WHERE character_id = ? AND slot = ?", characterId, slot)
    local checkResult = dbPoll(checkQuery, -1)
    
    if checkResult and #checkResult > 0 then
        -- Slot ocupado, actualizar cantidad
        dbExec(db, "UPDATE inventory SET quantity = quantity + ? WHERE character_id = ? AND slot = ?", 
            quantity, characterId, slot)
    else
        -- Slot vacío, insertar nuevo item
        dbExec(db, "INSERT INTO inventory (character_id, slot, item_id, item_name, quantity, item_data) VALUES (?, ?, ?, ?, ?, ?)",
            characterId, slot, itemId, itemName, quantity, itemData)
    end
    
    return true
end

-- Remover item del inventario
function removeItemFromInventory(characterId, slot, quantity)
    if not db or not characterId or not slot then
        return false
    end
    
    quantity = quantity or 1
    
    -- Obtener cantidad actual
    local query = dbQuery(db, "SELECT quantity FROM inventory WHERE character_id = ? AND slot = ?", characterId, slot)
    local result = dbPoll(query, -1)
    
    if not result or #result == 0 then
        return false
    end
    
    local currentQuantity = tonumber(result[1].quantity)
    
    if currentQuantity <= quantity then
        -- Eliminar el item completamente
        dbExec(db, "DELETE FROM inventory WHERE character_id = ? AND slot = ?", characterId, slot)
    else
        -- Reducir cantidad
        dbExec(db, "UPDATE inventory SET quantity = quantity - ? WHERE character_id = ? AND slot = ?",
            quantity, characterId, slot)
    end
    
    return true
end

-- Encontrar slot vacío
function findEmptySlot(characterId, maxSlots)
    maxSlots = maxSlots or 30
    
    local query = dbQuery(db, "SELECT slot FROM inventory WHERE character_id = ? ORDER BY slot ASC", characterId)
    local result = dbPoll(query, -1)
    
    if not result or #result == 0 then
        return 1  -- Primer slot disponible
    end
    
    local usedSlots = {}
    for _, row in ipairs(result) do
        usedSlots[tonumber(row.slot)] = true
    end
    
    -- Buscar primer slot vacío
    for i = 1, maxSlots do
        if not usedSlots[i] then
            return i
        end
    end
    
    return nil  -- Inventario lleno
end

-- ==================== EVENTOS ====================

-- Solicitar inventario
addEventHandler("onRequestInventory", root, function()
    if not isElement(source) then return end
    
    local characterId = getElementData(source, "characterId")
    if not characterId then
        outputChatBox("No tienes un personaje seleccionado", source, 255, 0, 0)
        return
    end
    
    local inventory = getCharacterInventory(characterId)
    triggerClientEvent(source, "onInventoryReceived", source, inventory)
end)

-- Agregar item (comando de admin para testing)
addCommandHandler("daritem", function(player, cmd, targetPlayer, itemName, quantity)
    -- Verificar si es admin (usar función del login)
    local role = getElementData(player, "userRole") or "user"
    if role ~= "admin" then
        outputChatBox("No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not targetPlayer or not itemName then
        outputChatBox("Uso: /daritem [jugador] [nombre_item] [cantidad]", player, 255, 255, 0)
        return
    end
    
    local target = getPlayerFromName(targetPlayer)
    if not target then
        outputChatBox("Jugador no encontrado", player, 255, 0, 0)
        return
    end
    
    local characterId = getElementData(target, "characterId")
    if not characterId then
        outputChatBox("El jugador no tiene un personaje seleccionado", player, 255, 0, 0)
        return
    end
    
    quantity = tonumber(quantity) or 1
    local emptySlot = findEmptySlot(characterId, 30)
    
    if not emptySlot then
        outputChatBox("El inventario del jugador está lleno", player, 255, 0, 0)
        return
    end
    
    -- Generar un ID único para el item (podrías tener una tabla de items)
    local itemId = math.random(1000, 9999)
    
    if addItemToInventory(characterId, emptySlot, itemId, itemName, quantity, "") then
        outputChatBox("Item '" .. itemName .. "' x" .. quantity .. " agregado al inventario de " .. getPlayerName(target), player, 0, 255, 0)
        outputChatBox("Has recibido: " .. itemName .. " x" .. quantity, target, 0, 255, 0)
        
        -- Actualizar inventario del cliente
        local inventory = getCharacterInventory(characterId)
        triggerClientEvent(target, "onInventoryUpdated", target, inventory)
    else
        outputChatBox("Error al agregar el item", player, 255, 0, 0)
    end
end)

-- Inicializar base de datos al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    setTimer(function()
        if initInventoryDatabase() then
            outputServerLog("[Inventory] Sistema de inventario inicializado correctamente")
        else
            outputServerLog("[Inventory] ERROR: No se pudo inicializar el sistema de inventario")
        end
    end, 1000, 1)  -- Esperar 1 segundo para que el login se conecte primero
end)

