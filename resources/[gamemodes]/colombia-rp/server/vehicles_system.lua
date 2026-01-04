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

-- Función para configurar vehículo especial (Urus - Modelo 560)
function configureSpecialVehicle(vehicle, vehicleId)
    if vehicleId == 560 then
        configureUrusVehicle(vehicle)
    end
end

-- Función para crear un vehículo sin dueño
function createVehicleWithoutOwner(vehicleId, x, y, z, rotZ, interior, dimension)
    local plate = generateUniquePlate()
    
    -- Crear vehículo en el juego
    local vehicle = createVehicle(vehicleId, x, y, z, 0, 0, rotZ)
    if not vehicle then
        return nil, "Error al crear el vehículo en el juego"
    end
    
    -- Configurar vehículo especial si es necesario
    configureSpecialVehicle(vehicle, vehicleId)
    
    setElementDimension(vehicle, dimension)
    setElementInterior(vehicle, interior)
    setVehiclePlateText(vehicle, plate)
    
    -- Guardar en base de datos (usar NULL para vehicle_element_id ya que es temporal)
    local query = [[
        INSERT INTO vehicles (vehicle_element_id, model, plate, owner_id, x, y, z, rot_z, interior, dimension, fuel)
        VALUES (NULL, ?, ?, NULL, ?, ?, ?, ?, ?, ?, 100)
    ]]
    
    local success = executeDatabase(query, vehicleId, plate, x, y, z, rotZ, interior, dimension)
    
    if not success then
        destroyElement(vehicle)
        return nil, "Error al guardar el vehículo en la base de datos"
    end
    
    -- Obtener el ID real de la base de datos (usar la matrícula que es única)
    local result = queryDatabase("SELECT id FROM vehicles WHERE plate = ? ORDER BY id DESC LIMIT 1", plate)
    local realId = result and result[1] and result[1].id
    
    if not realId then
        destroyElement(vehicle)
        return nil, "Error al obtener el ID del vehículo guardado"
    end
    
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
    
    -- Configurar vehículo especial si es necesario
    configureSpecialVehicle(vehicle, vehicleId)
    
    setElementDimension(vehicle, dimension)
    setElementInterior(vehicle, interior)
    setVehiclePlateText(vehicle, plate)
    setVehicleLocked(vehicle, true) -- Bloqueado por defecto
    
    -- Guardar en base de datos (usar NULL para vehicle_element_id)
    local query = [[
        INSERT INTO vehicles (vehicle_element_id, model, plate, owner_id, x, y, z, rot_z, interior, dimension, fuel, locked)
        VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, 100, 1)
    ]]
    
    local success = executeDatabase(query, vehicleId, plate, characterId, x, y, z, rotZ, interior, dimension)
    
    if not success then
        destroyElement(vehicle)
        return nil, "Error al guardar el vehículo en la base de datos"
    end
    
    -- Obtener el ID real de la base de datos (usar la matrícula que es única)
    local result = queryDatabase("SELECT id FROM vehicles WHERE plate = ? ORDER BY id DESC LIMIT 1", plate)
    local realId = result and result[1] and result[1].id
    
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

-- Función para guardar un vehículo en la base de datos
function saveVehicleToDatabase(vehicle)
    if not vehicle or not isElement(vehicle) then
        return false
    end
    
    local vehicleDbId = getElementData(vehicle, "vehicle:db_id") or getElementData(vehicle, "vehicle:id")
    local plate = getElementData(vehicle, "vehicle:plate")
    local ownerId = getElementData(vehicle, "vehicle:owner_id")
    local model = getElementModel(vehicle)
    local x, y, z = getElementPosition(vehicle)
    local rotX, rotY, rotZ = getElementRotation(vehicle)
    local interior = getElementInterior(vehicle)
    local dimension = getElementDimension(vehicle)
    local fuel = getElementData(vehicle, "vehicle:fuel") or 100
    local locked = (getElementData(vehicle, "vehicle:locked") == true) and 1 or 0
    local engine = getVehicleEngineState(vehicle) and 1 or 0
    local lights = getVehicleOverrideLights(vehicle)
    local lightsState = (lights == 2) and 1 or 0
    
    if vehicleDbId then
        -- Actualizar vehículo existente
        local success = executeDatabase([[
            UPDATE vehicles 
            SET x = ?, y = ?, z = ?, rot_x = ?, rot_y = ?, rot_z = ?, 
                interior = ?, dimension = ?, fuel = ?, locked = ?, engine = ?, lights = ?
            WHERE id = ?
        ]], x, y, z, rotX, rotY, rotZ, interior, dimension, fuel, locked, engine, lightsState, vehicleDbId)
        
        return success
    else
        -- Crear nuevo registro si no existe
        if not plate then
            plate = generateUniquePlate()
            setVehiclePlateText(vehicle, plate)
            setElementData(vehicle, "vehicle:plate", plate)
        end
        
        local success = executeDatabase([[
            INSERT INTO vehicles (vehicle_element_id, model, plate, owner_id, x, y, z, rot_x, rot_y, rot_z, 
                                  interior, dimension, fuel, locked, engine, lights)
            VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], model, plate, ownerId, x, y, z, rotX, rotY, rotZ, 
            interior, dimension, fuel, locked, engine, lightsState)
        
        if success then
            -- Obtener el ID real usando la matrícula (única)
            local result = queryDatabase("SELECT id FROM vehicles WHERE plate = ? ORDER BY id DESC LIMIT 1", plate)
            local realId = result and result[1] and result[1].id
            
            setElementData(vehicle, "vehicle:id", realId)
            setElementData(vehicle, "vehicle:db_id", realId)
            setElementData(vehicle, "vehicle:owner_id", ownerId)
            setElementData(vehicle, "vehicle:locked", locked == 1)
            setElementData(vehicle, "vehicle:fuel", fuel)
        end
        
        return success
    end
end

-- Función para guardar todos los vehículos y enviarlos al garaje
function saveAllVehiclesToGarage()
    outputServerLog("[VEHICLES] Guardando todos los vehículos en el garaje...")
    
    local savedCount = 0
    local vehicles = getElementsByType("vehicle")
    
    for _, vehicle in ipairs(vehicles) do
        -- Verificar si es un vehículo del sistema (tiene plate o owner_id)
        local plate = getElementData(vehicle, "vehicle:plate")
        local ownerId = getElementData(vehicle, "vehicle:owner_id")
        
        -- Solo guardar vehículos que tienen dueño o matrícula (vehículos del sistema)
        if plate or ownerId then
            if saveVehicleToDatabase(vehicle) then
                savedCount = savedCount + 1
                outputServerLog("[VEHICLES] Vehículo guardado: " .. (plate or "Sin matrícula") .. " (Owner: " .. (ownerId or "Ninguno") .. ")")
            end
        end
    end
    
    outputServerLog("[VEHICLES] Total de vehículos guardados en garaje: " .. savedCount)
    
    -- Destruir todos los vehículos del mundo
    for _, vehicle in ipairs(vehicles) do
        local plate = getElementData(vehicle, "vehicle:plate")
        local ownerId = getElementData(vehicle, "vehicle:owner_id")
        
        -- Solo destruir vehículos del sistema
        if plate or ownerId then
            destroyElement(vehicle)
        end
    end
    
    outputServerLog("[VEHICLES] Todos los vehículos han sido enviados al garaje.")
end

-- Evento cuando el recurso se detiene (restart/stop)
addEventHandler("onResourceStop", resourceRoot, function()
    saveAllVehiclesToGarage()
end)

-- Evento cuando el recurso se inicia
addEventHandler("onResourceStart", resourceRoot, function()
    -- Esperar un momento para que todo se cargue
    setTimer(function()
        saveAllVehiclesToGarage()
        outputServerLog("[VEHICLES] Sistema de vehículos iniciado. Todos los vehículos están en el garaje.")
    end, 2000, 1)
end)

-- Función global para configurar Urus (disponible para otros scripts)
function configureUrusVehicle(vehicle)
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return false
    end
    
    local vehicleId = getElementModel(vehicle)
    if vehicleId ~= 560 then
        return false
    end
    
    -- Configurar velocidad máxima a 300 km/h (aproximadamente 83.33 m/s)
    -- Nota: En MTA, maxVelocity está en m/s. 300 km/h = 83.33 m/s
    -- Aumentamos significativamente para contrarrestar cualquier limitación del modelo
    setVehicleHandling(vehicle, "maxVelocity", 300)
    
    -- Configurar número de marchas (6 marchas para mejor rendimiento)
    setVehicleHandling(vehicle, "numberOfGears", 6)
    
    -- Configurar relación de transmisión para mejor aceleración y velocidad
    setVehicleHandling(vehicle, "driveType", "awd")  -- Tracción total
    setVehicleHandling(vehicle, "engineType", "petrol")
    
    -- Configurar handling para mejor rendimiento (valores aumentados)
    setVehicleHandling(vehicle, "engineAcceleration", 60.0)  -- Aceleración muy mejorada
    setVehicleHandling(vehicle, "engineInertia", 150.0)     -- Inercia del motor (mucho mayor = más potencia)
    setVehicleHandling(vehicle, "brakeDeceleration", 15.0)  -- Freno mejorado
    setVehicleHandling(vehicle, "tractionMultiplier", 1.5)   -- Tracción muy mejorada
    setVehicleHandling(vehicle, "tractionLoss", 0.7)         -- Menos pérdida de tracción
    setVehicleHandling(vehicle, "tractionBias", 0.5)         -- Distribución de tracción
    
    -- Configurar relación de transmisión (gear ratios) para mejor velocidad
    -- Esto es crítico para alcanzar velocidades altas
    setVehicleHandling(vehicle, "driveBiasFront", 0.5)       -- Tracción equilibrada
    
    -- Configurar masa y centro de masa para mejor estabilidad
    setVehicleHandling(vehicle, "mass", 2200.0)              -- Masa del vehículo
    setVehicleHandling(vehicle, "centerOfMass", {0.0, 0.0, -0.3})  -- Centro de masa más bajo
    
    -- Configurar suspensión para mejor manejo
    setVehicleHandling(vehicle, "suspensionForceLevel", 1.2)
    setVehicleHandling(vehicle, "suspensionDamping", 0.3)
    setVehicleHandling(vehicle, "suspensionHighSpeedDamping", 0.0)
    setVehicleHandling(vehicle, "suspensionUpperLimit", 0.35)
    setVehicleHandling(vehicle, "suspensionLowerLimit", -0.15)
    setVehicleHandling(vehicle, "suspensionFrontRearBias", 0.5)
    setVehicleHandling(vehicle, "suspensionAntiDiveMultiplier", 0.3)
    
    -- Configurar dirección
    setVehicleHandling(vehicle, "steeringLock", 35.0)        -- Ángulo máximo de giro
    
    -- Habilitar daño visual (puertas, paneles, etc.)
    setVehicleDamageProof(vehicle, false)
    
    -- Asegurar que el daño visual funcione
    setVehicleWheelStates(vehicle, 0, 0, 0, 0)  -- Ruedas en buen estado inicialmente
    
    -- Forzar actualización del handling después de delays múltiples
    -- Esto asegura que el modelo personalizado se haya cargado completamente
    -- Aplicar múltiples veces para asegurar que se sobrescriba cualquier handling del modelo
    for i = 1, 5 do
        setTimer(function()
            if isElement(vehicle) then
                -- Reforzar TODA la configuración de velocidad y rendimiento
                setVehicleHandling(vehicle, "maxVelocity", 83.33)
                setVehicleHandling(vehicle, "numberOfGears", 6)
                setVehicleHandling(vehicle, "engineAcceleration", 60.0)
                setVehicleHandling(vehicle, "engineInertia", 150.0)
                setVehicleHandling(vehicle, "tractionMultiplier", 1.5)
                setVehicleHandling(vehicle, "tractionLoss", 0.7)
                setVehicleHandling(vehicle, "driveType", "awd")
                setVehicleHandling(vehicle, "engineType", "petrol")
                setVehicleHandling(vehicle, "driveBiasFront", 0.5)
            end
        end, i * 200, 1)
    end
    
    setTimer(function()
        if isElement(vehicle) then
            -- Verificación final para asegurar que todo esté aplicado
            setVehicleHandling(vehicle, "maxVelocity", 83.33)
            setVehicleHandling(vehicle, "numberOfGears", 6)
            -- Asegurar que el daño visual esté habilitado
            setVehicleDamageProof(vehicle, false)
            -- Forzar actualización del daño
            local health = getElementHealth(vehicle)
            setElementHealth(vehicle, health)  -- Esto fuerza la actualización visual
            
            -- Log para verificar
            local currentMaxVel = getVehicleHandling(vehicle, "maxVelocity")
            local currentGears = getVehicleHandling(vehicle, "numberOfGears")
            outputServerLog("[VEHICLES] Urus verificado - maxVelocity: " .. tostring(currentMaxVel) .. ", gears: " .. tostring(currentGears))
        end
    end, 2000, 1)
    
    outputServerLog("[VEHICLES] Urus configurado correctamente: Velocidad máxima 300 km/h, 6 marchas")
    
    return true
end

-- Evento global para configurar Urus cuando se crea cualquier vehículo
addEventHandler("onVehicleCreate", root, function()
    local vehicleId = getElementModel(source)
    if vehicleId == 560 then
        configureUrusVehicle(source)
    end
end)

-- Tabla para almacenar timers de verificación de Urus
local urusVerificationTimers = {}

-- Evento para reconfigurar Urus cuando un jugador entra al vehículo
-- Esto asegura que el handling se aplique incluso si el modelo se carga después
addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat)
    if seat == 0 then  -- Solo si es el conductor
        local vehicleId = getElementModel(vehicle)
        if vehicleId == 560 then
            -- Aplicar configuración inmediatamente
            configureUrusVehicle(vehicle)
            
            -- Crear un timer periódico para verificar y corregir el handling mientras se conduce
            if urusVerificationTimers[vehicle] and isTimer(urusVerificationTimers[vehicle]) then
                killTimer(urusVerificationTimers[vehicle])
            end
            
            urusVerificationTimers[vehicle] = setTimer(function()
                if isElement(vehicle) then
                    local currentMaxVel = getVehicleHandling(vehicle, "maxVelocity")
                    local currentGears = getVehicleHandling(vehicle, "numberOfGears")
                    
                    -- Si el handling no es correcto, corregirlo
                    if currentMaxVel < 80 or currentGears < 6 then
                        setVehicleHandling(vehicle, "maxVelocity", 83.33)
                        setVehicleHandling(vehicle, "numberOfGears", 6)
                        setVehicleHandling(vehicle, "engineAcceleration", 60.0)
                        setVehicleHandling(vehicle, "engineInertia", 150.0)
                        setVehicleHandling(vehicle, "tractionMultiplier", 1.5)
                    end
                else
                    -- Si el vehículo ya no existe, limpiar el timer
                    if urusVerificationTimers[vehicle] then
                        urusVerificationTimers[vehicle] = nil
                    end
                end
            end, 1000, 0)  -- Verificar cada segundo mientras se conduce
        end
    end
end)

-- Limpiar timer cuando el jugador sale del vehículo
addEventHandler("onPlayerVehicleExit", root, function(vehicle, seat)
    if seat == 0 then  -- Solo si era el conductor
        local vehicleId = getElementModel(vehicle)
        if vehicleId == 560 then
            if urusVerificationTimers[vehicle] and isTimer(urusVerificationTimers[vehicle]) then
                killTimer(urusVerificationTimers[vehicle])
                urusVerificationTimers[vehicle] = nil
            end
        end
    end
end)

-- Limpiar timers cuando el vehículo se destruye
addEventHandler("onElementDestroy", root, function()
    if getElementType(source) == "vehicle" then
        if urusVerificationTimers[source] and isTimer(urusVerificationTimers[source]) then
            killTimer(urusVerificationTimers[source])
            urusVerificationTimers[source] = nil
        end
    end
end)

