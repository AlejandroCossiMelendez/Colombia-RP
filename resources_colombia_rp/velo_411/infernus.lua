function loadHandling(v) 
    if getElementModel(v) == 411 then       -------------------/ ID DEL INFERNUS
        setVehicleHandling(v, "mass", 1600)
        setVehicleHandling(v, "turnMass", 3000)
        setVehicleHandling(v, "dragCoeff", 0.85)
        setVehicleHandling(v, "centerOfMass", { 0, -0.1, -0.25 } )
        setVehicleHandling(v, "percentSubmerged", 75)
        setVehicleHandling(v, "tractionMultiplier", 1.2)
        setVehicleHandling(v, "tractionLoss", 1.0)
        setVehicleHandling(v, "tractionBias", 0.5)
        setVehicleHandling(v, "numberOfGears", 5)
        setVehicleHandling(v, "maxVelocity", 500)       -------------------/ VELOCIDAD MÁXIMA (500 KM/H)
        setVehicleHandling(v, "engineAcceleration", 55) -------------------/ FORÇA DE ACELERACIÓN
        setVehicleHandling(v, "engineInertia", 20)
        setVehicleHandling(v, "driveType", "awd")       -------------------/ TIPO DE TRACCIÓN
        setVehicleHandling(v, "engineType", "petrol")
        setVehicleHandling(v, "brakeDeceleration", 30)
        setVehicleHandling(v, "ABS", true)
        setVehicleHandling(v, "steeringLock", 35)
        setVehicleHandling(v, "headLight", 0)
        setVehicleHandling(v, "tailLight", 1)
        setVehicleHandling(v, "animGroup", 0)
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