-- Script para crear las tablas necesarias para el sistema de items y mochilas
-- Se ejecuta automáticamente al iniciar el gamemode

addEventHandler("onResourceStart", resourceRoot, function()
    -- Esperar un momento para asegurar que la conexión a la base de datos esté lista
    setTimer(function()
        createItemsTables()
    end, 1000, 1)
end)

function createItemsTables()
    outputServerLog("[TABLES] Verificando y creando tablas necesarias para el sistema de items...")
    
    -- Tabla: items (items de los jugadores)
    local itemsTableSQL = [[
        CREATE TABLE IF NOT EXISTS `items` (
            `index` INT AUTO_INCREMENT PRIMARY KEY,
            `owner` INT NOT NULL,
            `item` INT NOT NULL,
            `value` TEXT,
            `value2` INT DEFAULT NULL,
            `name` VARCHAR(255) DEFAULT NULL,
            INDEX `idx_owner` (`owner`),
            INDEX `idx_item` (`item`),
            INDEX `idx_value2` (`value2`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
    
    local success = executeDatabase(itemsTableSQL)
    if success then
        outputServerLog("[TABLES] ✓ Tabla 'items' creada o ya existe")
    else
        outputServerLog("[TABLES] ✗ ERROR al crear tabla 'items'")
    end
    
    -- Tabla: items_mochilas (items dentro de mochilas)
    local itemsMochilasTableSQL = [[
        CREATE TABLE IF NOT EXISTS `items_mochilas` (
            `index` INT AUTO_INCREMENT PRIMARY KEY,
            `mochilaID` INT NOT NULL,
            `item` INT NOT NULL,
            `value` TEXT,
            `value2` INT DEFAULT NULL,
            `name` VARCHAR(255) DEFAULT NULL,
            INDEX `idx_mochilaID` (`mochilaID`),
            INDEX `idx_item` (`item`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
    
    success = executeDatabase(itemsMochilasTableSQL)
    if success then
        outputServerLog("[TABLES] ✓ Tabla 'items_mochilas' creada o ya existe")
    else
        outputServerLog("[TABLES] ✗ ERROR al crear tabla 'items_mochilas'")
    end
    
    -- Tabla: mochilas_suelo (mochilas tiradas en el suelo)
    local mochilasSueloTableSQL = [[
        CREATE TABLE IF NOT EXISTS `mochilas_suelo` (
            `mochilaID` INT AUTO_INCREMENT PRIMARY KEY,
            `model` INT NOT NULL,
            `x` FLOAT NOT NULL,
            `y` FLOAT NOT NULL,
            `z` FLOAT NOT NULL,
            `interior` INT NOT NULL DEFAULT 0,
            `dimension` INT NOT NULL DEFAULT 0,
            `characterID` INT DEFAULT NULL,
            INDEX `idx_characterID` (`characterID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
    
    success = executeDatabase(mochilasSueloTableSQL)
    if success then
        outputServerLog("[TABLES] ✓ Tabla 'mochilas_suelo' creada o ya existe")
    else
        outputServerLog("[TABLES] ✗ ERROR al crear tabla 'mochilas_suelo'")
    end
    
    -- Tabla: tlf_data (datos de teléfonos)
    local tlfDataTableSQL = [[
        CREATE TABLE IF NOT EXISTS `tlf_data` (
            `registro_ID` INT AUTO_INCREMENT PRIMARY KEY,
            `numero` VARCHAR(20) NOT NULL,
            `imei` VARCHAR(50) DEFAULT NULL,
            `titular` INT NOT NULL,
            `estado` INT NOT NULL DEFAULT 0,
            `apagado` INT NOT NULL DEFAULT 0,
            `agenda` TEXT DEFAULT NULL,
            UNIQUE KEY `unique_numero` (`numero`),
            INDEX `idx_titular` (`titular`),
            INDEX `idx_imei` (`imei`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
    
    success = executeDatabase(tlfDataTableSQL)
    if success then
        outputServerLog("[TABLES] ✓ Tabla 'tlf_data' creada o ya existe")
    else
        outputServerLog("[TABLES] ✗ ERROR al crear tabla 'tlf_data'")
    end
    
    -- Tabla: phone_contacts (contactos de teléfonos)
    local phoneContactsTableSQL = [[
        CREATE TABLE IF NOT EXISTS `phone_contacts` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `character_id` INT NOT NULL,
            `contact_name` VARCHAR(100) NOT NULL,
            `contact_number` VARCHAR(20) NOT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX `idx_character_id` (`character_id`),
            INDEX `idx_contact_number` (`contact_number`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
    
    success = executeDatabase(phoneContactsTableSQL)
    if success then
        outputServerLog("[TABLES] ✓ Tabla 'phone_contacts' creada o ya existe")
    else
        outputServerLog("[TABLES] ✗ ERROR al crear tabla 'phone_contacts'")
    end
    
    -- Tabla: maleteros (items en maleteros de vehículos)
    local maleterosTableSQL = [[
        CREATE TABLE IF NOT EXISTS `maleteros` (
            `index` INT AUTO_INCREMENT PRIMARY KEY,
            `vehicleID` INT NOT NULL,
            `item` INT NOT NULL,
            `value` TEXT,
            `name` VARCHAR(255) DEFAULT NULL,
            INDEX `idx_vehicleID` (`vehicleID`),
            INDEX `idx_item` (`item`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
    
    success = executeDatabase(maleterosTableSQL)
    if success then
        outputServerLog("[TABLES] ✓ Tabla 'maleteros' creada o ya existe")
    else
        outputServerLog("[TABLES] ✗ ERROR al crear tabla 'maleteros'")
    end
    
    outputServerLog("[TABLES] Verificación de tablas completada")
end

