-- Sistema de configuración de vehículos personalizados
-- Configurar velocidad máxima del vehículo 400 (Landstalker) a 380 km/h

-- Función para configurar la velocidad del vehículo 400
function configureVehicle400(vehicle)
    if not isElement(vehicle) then return end
    
    -- Configurar velocidad máxima a 380 km/h
    -- La velocidad en MTA se mide en unidades por segundo
    -- 380 km/h = 380 * 1000 / 3600 = 105.56 m/s aproximadamente
    -- Pero MTA usa un sistema diferente, así que usamos setVehicleHandling
    
    -- Obtener el handling actual
    local maxVelocity = 380.0  -- km/h
    local acceleration = 1.0
    local engineAcceleration = 30.0  -- Aceleración del motor
    
    -- Configurar handling del vehículo
    setVehicleHandling(vehicle, "maxVelocity", maxVelocity)
    setVehicleHandling(vehicle, "engineAcceleration", engineAcceleration)
    setVehicleHandling(vehicle, "engineInertia", 50.0)  -- Inercia del motor
    setVehicleHandling(vehicle, "driveType", "awd")  -- Tracción en las 4 ruedas para mejor control
    
    -- Mejorar el manejo general y estabilidad
    setVehicleHandling(vehicle, "tractionMultiplier", 1.5)  -- Aumentado para más tracción
    setVehicleHandling(vehicle, "tractionLoss", 0.6)  -- Reducido para menos pérdida de tracción
    setVehicleHandling(vehicle, "tractionBias", 0.5)
    
    -- Mejorar estabilidad
    setVehicleHandling(vehicle, "mass", 2000.0)  -- Masa del vehículo
    setVehicleHandling(vehicle, "turnMass", 4000.0)  -- Masa de giro (mayor = más estable)
    setVehicleHandling(vehicle, "dragCoeff", 0.3)  -- Coeficiente de arrastre
    
    -- Suspensión mejorada para más estabilidad
    setVehicleHandling(vehicle, "suspensionForceLevel", 2.0)  -- Fuerza de suspensión
    setVehicleHandling(vehicle, "suspensionDamping", 0.3)  -- Amortiguación
    setVehicleHandling(vehicle, "suspensionHighSpeedDamping", 0.0)
    setVehicleHandling(vehicle, "suspensionUpperLimit", 0.3)
    setVehicleHandling(vehicle, "suspensionLowerLimit", -0.1)
    setVehicleHandling(vehicle, "suspensionFrontRearBias", 0.5)
    setVehicleHandling(vehicle, "suspensionAntiDiveMultiplier", 0.3)
    
    -- Centro de masa más bajo para mejor estabilidad
    setVehicleHandling(vehicle, "centerOfMassX", 0.0)
    setVehicleHandling(vehicle, "centerOfMassY", 0.0)
    setVehicleHandling(vehicle, "centerOfMassZ", -0.3)  -- Más bajo = más estable
    
    -- Mejorar frenos
    setVehicleHandling(vehicle, "brakeDeceleration", 8.0)
    setVehicleHandling(vehicle, "brakeBias", 0.5)
    
    -- Configurar transmisión
    setVehicleHandling(vehicle, "numberOfGears", 5)
    setVehicleHandling(vehicle, "maxVelocity", maxVelocity)
    
    -- Reducir derrape
    setVehicleHandling(vehicle, "steeringLock", 35.0)  -- Bloqueo de dirección
end

-- Aplicar configuración cuando se crea un vehículo 400
addEventHandler("onVehicleCreate", root, function()
    if getElementModel(source) == 400 then
        setTimer(function()
            if isElement(source) then
                configureVehicle400(source)
            end
        end, 100, 1)
    end
end)

-- Aplicar configuración a vehículos existentes cuando el recurso inicia
addEventHandler("onResourceStart", resourceRoot, function()
    setTimer(function()
        for _, vehicle in ipairs(getElementsByType("vehicle")) do
            if isElement(vehicle) and getElementModel(vehicle) == 400 then
                configureVehicle400(vehicle)
            end
        end
    end, 1000, 1)  -- Esperar 1 segundo para asegurar que los vehículos estén cargados
end)

-- Aplicar configuración cuando un jugador entra a un vehículo 400
addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat)
    if getElementModel(vehicle) == 400 and seat == 0 then  -- Solo para el conductor
        configureVehicle400(vehicle)
    end
end)

