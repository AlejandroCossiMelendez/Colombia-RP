-- Sistema de Vehículos
-- Gestión de vehículos, matrículas, llaves y controles

-- Función para generar una matrícula única
function generateUniquePlate()
    local plate = ""
    local attempts = 0
    local maxAttempts = 100
    
    repeat
        -- Formato: ABC-1234 (3 letras, guion, 4 números)
        local letters = ""
        for i = 1, 3 do
            letters = letters .. string.char(math.random(65, 90)) -- A-Z
        end
        local numbers = ""
        for i = 1, 4 do
            numbers = numbers .. tostring(math.random(0, 9))
        end
        plate = letters .. "-" .. numbers
        
        -- Verificar si ya existe
        local query = queryDatabase("SELECT id FROM vehicles WHERE plate = ?", plate)
        attempts = attempts + 1
    until (not query or #query == 0) or attempts >= maxAttempts
    
    if attempts >= maxAttempts then
        -- Si no se puede generar única, usar timestamp
        plate = "TMP-" .. tostring(getTickCount())
    end
    
    return plate
end

-- Función para crear un vehículo sin dueño
function createVehicleWithoutOwner(vehicleId, x, y, z, rotZ, interior, dimension)
    local plate = generateUniquePlate()
    
    -- Crear vehículo en el juego
    local vehicle = createVehicle(vehicleId, x, y, z, 0, 0, rotZ)
    if not vehicle then
        return nil, "Error al crear el vehículo en el juego"
    end
    
    setElementDimension(vehicle, dimension)
    setElementInterior(vehicle, interior)
    setVehiclePlateText(vehicle, plate)
    
    -- Guardar en base de datos (usar un ID único generado)
    local vehicleDbId = getTickCount() .. math.random(1000, 9999) -- ID temporal único
    
    local query = [[
        INSERT INTO vehicles (vehicle_element_id, model, plate, owner_id, x, y, z, rot_z, interior, dimension, fuel)
        VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, ?, 100)
    ]]
    
    local success = executeDatabase(query, vehicleDbId, vehicleId, plate, x, y, z, rotZ, interior, dimension)
    
    if not success then
        destroyElement(vehicle)
        return nil, "Error al guardar el vehículo en la base de datos"
    end
    
    -- Obtener el ID real de la base de datos
    local result = queryDatabase("SELECT id FROM vehicles WHERE vehicle_element_id = ?", vehicleDbId)
    local realId = result and result[1] and result[1].id or vehicleDbId
    
    -- Guardar ID del vehículo en elementData
    setElementData(vehicle, "vehicle:id", realId)
    setElementData(vehicle, "vehicle:db_id", realId)
    setElementData(vehicle, "vehicle:plate", plate)
    setElementData(vehicle, "vehicle:owner_id", nil)
    setElementData(vehicle, "vehicle:locked", false)
    setElementData(vehicle, "vehicle:fuel", 100)
    
    return vehicle, plate
end

-- Función para crear un vehículo para un jugador
function createVehicleForPlayer(vehicleId, x, y, z, rotZ, interior, dimension, characterId)
    local plate = generateUniquePlate()
    
    -- Crear vehículo en el juego
    local vehicle = createVehicle(vehicleId, x, y, z, 0, 0, rotZ)
    if not vehicle then
        return nil, "Error al crear el vehículo en el juego"
    end
    
    setElementDimension(vehicle, dimension)
    setElementInterior(vehicle, interior)
    setVehiclePlateText(vehicle, plate)
    setVehicleLocked(vehicle, true) -- Bloqueado por defecto
    
    -- Guardar en base de datos (usar un ID único generado)
    local vehicleDbId = getTickCount() .. math.random(1000, 9999) -- ID temporal único
    
    local query = [[
        INSERT INTO vehicles (vehicle_element_id, model, plate, owner_id, x, y, z, rot_z, interior, dimension, fuel, locked)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 100, 1)
    ]]
    
    local success = executeDatabase(query, vehicleDbId, vehicleId, plate, characterId, x, y, z, rotZ, interior, dimension)
    
    if not success then
        destroyElement(vehicle)
        return nil, "Error al guardar el vehículo en la base de datos"
    end
    
    -- Obtener el ID real de la base de datos
    local result = queryDatabase("SELECT id FROM vehicles WHERE vehicle_element_id = ?", vehicleDbId)
    local realId = result and result[1] and result[1].id or vehicleDbId
    
    -- Guardar datos en elementData
    setElementData(vehicle, "vehicle:id", realId)
    setElementData(vehicle, "vehicle:db_id", realId)
    setElementData(vehicle, "vehicle:plate", plate)
    setElementData(vehicle, "vehicle:owner_id", characterId)
    setElementData(vehicle, "vehicle:locked", true)
    setElementData(vehicle, "vehicle:fuel", 100)
    
    -- Crear llave para el jugador
    local player = getPlayerByCharacterId(characterId)
    if player then
        -- Usar la función give() del sistema de items
        -- item 1 = Llave de Coche, value = matrícula del vehículo
        if give then
            give(player, 1, plate, "Llave: " .. plate)
            outputChatBox("✓ Has recibido las llaves del vehículo con matrícula: " .. plate, player, 0, 255, 0)
        end
    end
    
    return vehicle, plate
end

-- Función para obtener jugador por character_id
function getPlayerByCharacterId(characterId)
    for _, player in ipairs(getElementsByType("player")) do
        local playerCharId = getElementData(player, "character:id")
        if playerCharId and playerCharId == characterId then
            return player
        end
    end
    return nil
end

-- Función para verificar si un jugador tiene las llaves de un vehículo
function playerHasVehicleKey(player, vehicle)
    if not player or not vehicle or not isElement(player) or not isElement(vehicle) then
        return false
    end
    
    -- LOS ADMINS SIEMPRE TIENEN ACCESO A TODOS LOS VEHÍCULOS
    if isPlayerAdmin then
        local isAdmin = isPlayerAdmin(player)
        if isAdmin then
            return true
        end
    end
    
    local plate = getElementData(vehicle, "vehicle:plate")
    if not plate then
        return false
    end
    
    local ownerId = getElementData(vehicle, "vehicle:owner_id")
    local playerCharId = getElementData(player, "character:id")
    
    -- Si no tiene dueño, cualquiera puede usarlo
    if not ownerId then
        return true
    end
    
    -- Si es el dueño, tiene acceso
    if ownerId == playerCharId then
        return true
    end
    
    -- Verificar si tiene la llave en el inventario
    -- Buscar en la tabla items del jugador (item 1 = Llave de Coche)
    if playerCharId then
        local query = queryDatabase("SELECT `index` FROM items WHERE owner = ? AND item = 1 AND value = ?", playerCharId, plate)
        if query and #query > 0 then
            return true
        end
    end
    
    return false
end

