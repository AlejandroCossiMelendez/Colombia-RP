-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'car.txd' ) 
engineImportTXD( txd, 419 ) 
dff = engineLoadDFF('car.dff', 419) 
engineReplaceModel( dff, 419 )
end)

-- Configuración de Handling para Supra GT86 (Modelo 419)
function loadHandling(v)
    if getElementModel(v) == 419 then  -- SUPRA GT86
        
        -- Peso y balance
        setVehicleHandling(v, "mass", 1400)
        setVehicleHandling(v, "turnMass", 3000)
        setVehicleHandling(v, "centerOfMass", { 0, 0, -0.4 })
        setVehicleHandling(v, "percentSubmerged", 70)

        -- Aerodinámica
        setVehicleHandling(v, "dragCoeff", 1.8)

        -- Tracción (RWD deportivo)
        setVehicleHandling(v, "tractionMultiplier", 1.25)
        setVehicleHandling(v, "tractionLoss", 0.9)
        setVehicleHandling(v, "tractionBias", 0.48)

        -- Motor
        setVehicleHandling(v, "numberOfGears", 6)
        setVehicleHandling(v, "maxVelocity", 275)         -- Velocidad final
        setVehicleHandling(v, "engineAcceleration", 38)   -- Aceleración deportiva
        setVehicleHandling(v, "engineInertia", 12)
        setVehicleHandling(v, "driveType", "rwd")
        setVehicleHandling(v, "engineType", "petrol")

        -- Frenos
        setVehicleHandling(v, "brakeDeceleration", 14)
        setVehicleHandling(v, "brakeBias", 0.55)
        setVehicleHandling(v, "ABS", true)

        -- Dirección
        setVehicleHandling(v, "steeringLock", 35)

        -- Suspensión (street racing)
        setVehicleHandling(v, "suspensionForceLevel", 1.4)
        setVehicleHandling(v, "suspensionDamping", 0.12)
        setVehicleHandling(v, "suspensionHighSpeedDamping", 0.3)
        setVehicleHandling(v, "suspensionUpperLimit", 0.25)
        setVehicleHandling(v, "suspensionLowerLimit", -0.15)

        -- Luces
        setVehicleHandling(v, "headLight", 1)
        setVehicleHandling(v, "tailLight", 1)
        setVehicleHandling(v, "animGroup", 0)
    end
end

-- Aplicar handling a todos los vehículos existentes cuando se inicia el recurso
function loadHandlings()
    for k, v in ipairs(getElementsByType("vehicle")) do
        loadHandling(v)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadHandlings)

-- Aplicar handling cuando se crea un vehículo
function vehicleCreate()
    loadHandling(source)
end
addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then
        loadHandling(source)
    end
end)

-- Aplicar handling cuando alguien entra al vehículo
function vehicleEnter()
    loadHandling(source)
end
addEventHandler("onVehicleEnter", root, vehicleEnter)