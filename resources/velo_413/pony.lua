function loadHandling(v) 
    if getElementModel(v) == 413 then       -------------------/ ID DE LA PONY
        setVehicleHandling(v, "mass", 3500)                 -- Peso sólido para estabilidad
        setVehicleHandling(v, "turnMass", 7000)
        setVehicleHandling(v, "dragCoeff", 0.7)             -- Aerodinámica deportiva (corta el viento)
        setVehicleHandling(v, "centerOfMass", { 0, -0.2, -0.8 } ) -- Centro de gravedad bajo
        setVehicleHandling(v, "percentSubmerged", 75)
        setVehicleHandling(v, "tractionMultiplier", 1.8)    -- Agarre de competición
        setVehicleHandling(v, "tractionLoss", 0.8)
        setVehicleHandling(v, "tractionBias", 0.5)
        setVehicleHandling(v, "numberOfGears", 6)           -- 6 Marchas para llegar a 999 suavemente
        setVehicleHandling(v, "maxVelocity", 300)           -------------------/ VELOCIDAD (999 KM/H)
        setVehicleHandling(v, "engineAcceleration", 120)    -------------------/ ACELERACIÓN (Muy potente)
        setVehicleHandling(v, "engineInertia", 5)           -- Revoluciones rápidas
        setVehicleHandling(v, "driveType", "awd")           -- Tracción en las 4 ruedas
        setVehicleHandling(v, "engineType", "petrol")
        setVehicleHandling(v, "brakeDeceleration", 50)      -- Frenos fuertes para parar desde 999
        setVehicleHandling(v, "ABS", true)
        setVehicleHandling(v, "steeringLock", 30)           -- Dirección equilibrada
        setVehicleHandling(v, "headLight", 0)
        setVehicleHandling(v, "tailLight", 1)
        setVehicleHandling(v, "animGroup", 0)
        
        -- Estabilidad extra
        setVehicleHandling(v, "suspensionForceLevel", 2.0)
        setVehicleHandling(v, "suspensionDamping", 0.2)
        setVehicleHandling(v, "suspensionHighSpeedDamping", 0.5)
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function loadHandlings()
    for k, v in ipairs(getElementsByType("vehicle")) do
        loadHandling(v)
    end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadHandlings)

function vehicleEnter()
    loadHandling(source)
end
addEventHandler("onVehicleEnter", getRootElement(), vehicleEnter)