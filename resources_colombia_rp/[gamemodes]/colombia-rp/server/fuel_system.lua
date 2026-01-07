-- Sistema de Gasolina para Vehículos
-- Maneja el consumo de gasolina y la persistencia en la base de datos

-- Configuración
local FUEL_CONSUMPTION_RATE = 0.05 -- Porcentaje de gasolina consumida por segundo cuando el motor está encendido
local FUEL_IDLE_CONSUMPTION = 0.01 -- Consumo cuando está en ralentí
local FUEL_REFILL_AMOUNT = 100 -- Cantidad de gasolina al repostar

-- Tabla para almacenar el nivel de gasolina de cada vehículo
local vehicleFuel = {}

-- Función para obtener el nivel de gasolina de un vehículo
function getVehicleFuel(vehicle)
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return 100
    end
    
    local vehicleID = getElementData(vehicle, "vehicle:id") or getElementID(vehicle)
    
    -- Si no hay ID, usar el elemento como clave
    if not vehicleID then
        vehicleID = tostring(vehicle)
    end
    
    -- Si no existe en la tabla, inicializar con 100%
    if not vehicleFuel[vehicleID] then
        vehicleFuel[vehicleID] = 100
        -- Intentar cargar desde la base de datos
        loadVehicleFuelFromDB(vehicle, vehicleID)
    end
    
    return vehicleFuel[vehicleID] or 100
end

-- Función para establecer el nivel de gasolina
function setVehicleFuel(vehicle, fuel)
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return false
    end
    
    local vehicleID = getElementData(vehicle, "vehicle:id") or getElementID(vehicle)
    
    if not vehicleID then
        vehicleID = tostring(vehicle)
    end
    
    -- Limitar entre 0 y 100
    fuel = math.max(0, math.min(100, fuel))
    vehicleFuel[vehicleID] = fuel
    
    -- Actualizar elementData para el cliente
    setElementData(vehicle, "vehicle:fuel", fuel)
    
    -- Si el vehículo se queda sin gasolina, apagar el motor
    if fuel <= 0 then
        setVehicleEngineState(vehicle, false)
    end
    
    return true
end

-- Función para cargar gasolina desde la base de datos
function loadVehicleFuelFromDB(vehicle, vehicleID)
    -- Aquí puedes implementar la carga desde la base de datos
    -- Por ahora, usamos valores por defecto
    -- TODO: Implementar carga desde tabla de vehículos en la BD
end

-- Función para guardar gasolina en la base de datos
function saveVehicleFuelToDB(vehicle, vehicleID, fuel)
    -- Aquí puedes implementar el guardado en la base de datos
    -- Por ahora, solo mantenemos en memoria
    -- TODO: Implementar guardado en tabla de vehículos en la BD
end

-- Evento cuando un jugador entra a un vehículo
addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat)
    if seat == 0 then -- Solo el conductor
        local fuel = getVehicleFuel(vehicle)
        triggerClientEvent(source, "speedometer:receiveFuel", source, fuel)
    end
end)

-- Evento para obtener el nivel de gasolina (solicitado por el cliente)
addEvent("speedometer:getFuel", true)
addEventHandler("speedometer:getFuel", root, function(vehicle)
    if not vehicle or not isElement(vehicle) then
        return
    end
    
    local fuel = getVehicleFuel(vehicle)
    triggerClientEvent(source, "speedometer:receiveFuel", source, fuel)
end)

-- Sistema de consumo de gasolina
setTimer(function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElement(vehicle) then
            local driver = getVehicleController(vehicle)
            
            if driver then
                local engineState = getVehicleEngineState(vehicle)
                -- Calcular velocidad en km/h
                local vx, vy, vz = getElementVelocity(vehicle)
                local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180
                
                if engineState then
                    local currentFuel = getVehicleFuel(vehicle)
                    
                    if currentFuel > 0 then
                        -- Calcular consumo basado en la velocidad
                        local consumption = FUEL_IDLE_CONSUMPTION
                        
                        if speed > 0.1 then
                            -- Consumo proporcional a la velocidad
                            consumption = FUEL_CONSUMPTION_RATE * (1 + speed / 100)
                        end
                        
                        local newFuel = currentFuel - consumption
                        setVehicleFuel(vehicle, newFuel)
                        
                        -- Notificar al conductor
                        if driver and isElement(driver) then
                            triggerClientEvent(driver, "speedometer:updateFuel", driver, newFuel)
                        end
                    else
                        -- Sin gasolina, apagar motor
                        setVehicleEngineState(vehicle, false)
                    end
                end
            end
        end
    end
end, 1000, 0) -- Ejecutar cada segundo

-- Evento para repostar gasolina (puede ser llamado desde un comando o item)
addEvent("fuel:refill", true)
addEventHandler("fuel:refill", root, function(vehicle)
    if not vehicle or not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        outputChatBox("Vehículo inválido.", source, 255, 0, 0)
        return
    end
    
    local playerX, playerY, playerZ = getElementPosition(source)
    local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
    local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, vehicleX, vehicleY, vehicleZ)
    
    -- Verificar que el jugador esté cerca del vehículo (5 metros)
    if distance > 5 then
        outputChatBox("Debes estar cerca del vehículo para repostar.", source, 255, 255, 0)
        return
    end
    
    -- Repostar
    setVehicleFuel(vehicle, FUEL_REFILL_AMOUNT)
    outputChatBox("✓ Vehículo repostado correctamente.", source, 0, 255, 0)
    triggerClientEvent(source, "speedometer:updateFuel", source, FUEL_REFILL_AMOUNT)
end)

-- Comando para repostar (temporal, puede ser reemplazado por un item o NPC)
addCommandHandler("repostar", function(player)
    local vehicle = getPedOccupiedVehicle(player)
    
    if not vehicle then
        vehicle = getPedContactElement(player)
        if not vehicle or getElementType(vehicle) ~= "vehicle" then
            outputChatBox("Debes estar cerca de un vehículo o dentro de él.", player, 255, 255, 0)
            return
        end
    end
    
    triggerEvent("fuel:refill", player, vehicle)
end)

outputServerLog("[FUEL] Sistema de gasolina iniciado correctamente")

