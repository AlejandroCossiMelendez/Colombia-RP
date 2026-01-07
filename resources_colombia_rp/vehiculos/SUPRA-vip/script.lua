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
        setVehicleHandling(v, "mass", 1450)            -- 🔥 un poco más estable
        setVehicleHandling(v, "turnMass", 3200)
        setVehicleHandling(v, "centerOfMass", { 0, 0, -0.45 })
        setVehicleHandling(v, "percentSubmerged", 70)

        -- Aerodinámica
        setVehicleHandling(v, "dragCoeff", 2.2)        -- 🔥 más estabilidad en alta

        -- Tracción (RWD controlado)
        setVehicleHandling(v, "tractionMultiplier", 1.45)  -- 🔥 más agarre
        setVehicleHandling(v, "tractionLoss", 0.75)        -- 🔥 pierde grip más lento
        setVehicleHandling(v, "tractionBias", 0.53)        -- 🔥 más carga atrás

        -- Motor
        setVehicleHandling(v, "numberOfGears", 6)
        setVehicleHandling(v, "maxVelocity", 270)
        setVehicleHandling(v, "engineAcceleration", 30)    -- 🔥 menos par inicial
        setVehicleHandling(v, "engineInertia", 16)         -- 🔥 sube RPM más suave
        setVehicleHandling(v, "driveType", "rwd")
        setVehicleHandling(v, "engineType", "petrol")

        -- Frenos
        setVehicleHandling(v, "brakeDeceleration", 13)
        setVehicleHandling(v, "brakeBias", 0.58)
        setVehicleHandling(v, "ABS", true)

        -- Dirección
        setVehicleHandling(v, "steeringLock", 30)       -- 🔥 más estable en recta

        -- Suspensión (street estable)
        setVehicleHandling(v, "suspensionForceLevel", 1.6)
        setVehicleHandling(v, "suspensionDamping", 0.18)
        setVehicleHandling(v, "suspensionHighSpeedDamping", 0.45)
        setVehicleHandling(v, "suspensionUpperLimit", 0.22)
        setVehicleHandling(v, "suspensionLowerLimit", -0.12)

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