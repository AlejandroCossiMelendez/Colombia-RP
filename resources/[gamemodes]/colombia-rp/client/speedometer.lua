-- Sistema de Velocímetro Personalizado y Gasolina
-- Deshabilita el velocímetro nativo y crea uno personalizado con HTML/CSS/JS

local speedometerBrowser = nil
local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100 -- Nivel de gasolina (0-100)

-- Deshabilitar el velocímetro nativo del juego
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Deshabilitar el componente de nombre de vehículo (velocímetro nativo)
    showPlayerHudComponent("vehicle_name", false)
    showPlayerHudComponent("area_name", false)
    
    -- Crear el navegador para el velocímetro
    createSpeedometerBrowser()
end)

-- Función para crear el navegador del velocímetro
function createSpeedometerBrowser()
    if speedometerBrowser and isElement(speedometerBrowser) then
        destroyElement(speedometerBrowser)
    end
    
    local screenW, screenH = guiGetScreenSize()
    speedometerBrowser = guiCreateBrowser(0, 0, screenW, screenH, false, false, false)
    
    if speedometerBrowser then
        local browser = guiGetBrowser(speedometerBrowser)
        addEventHandler("onClientBrowserCreated", browser, function()
            loadBrowserURL(browser, "http://mta/local/html/speedometer.html")
        end)
        
        -- Ocultar el cursor del navegador
        guiSetVisible(speedometerBrowser, true)
    end
end

-- Función para obtener la velocidad del vehículo en km/h
function getVehicleSpeedKMH(vehicle)
    if not vehicle or not isElement(vehicle) then
        return 0
    end
    
    local vx, vy, vz = getElementVelocity(vehicle)
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180 -- Convertir a km/h
    return math.floor(speed)
end

-- Función para obtener las RPM del vehículo (simulado)
function getVehicleRPM(vehicle)
    if not vehicle or not isElement(vehicle) then
        return 0
    end
    
    local speed = getVehicleSpeedKMH(vehicle)
    -- RPM simulado basado en la velocidad y el tipo de vehículo
    local model = getElementModel(vehicle)
    local maxSpeed = 200 -- Velocidad máxima por defecto
    
    -- Ajustar velocidad máxima según el tipo de vehículo
    if model >= 400 and model <= 611 then
        -- Vehículos normales: 120-200 km/h
        maxSpeed = 150
    end
    
    local rpm = (speed / maxSpeed) * 8000 -- RPM máximo simulado: 8000
    return math.floor(math.max(0, math.min(8000, rpm)))
end

-- Función para obtener el nombre del vehículo
function getVehicleDisplayName(vehicle)
    if not vehicle or not isElement(vehicle) then
        return ""
    end
    
    local model = getElementModel(vehicle)
    local name = getVehicleNameFromModel(model)
    return name or "Vehículo"
end

-- Actualizar datos del velocímetro
function updateSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle and vehicle ~= currentVehicle then
        -- Jugador entró a un vehículo
        isInVehicle = true
        currentVehicle = vehicle
        
        -- Cargar gasolina del vehículo desde el servidor
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
        
        -- Mostrar el velocímetro
        if speedometerBrowser then
            local browser = guiGetBrowser(speedometerBrowser)
            if browser then
                executeBrowserJavascript(browser, "showSpeedometer();")
            end
        end
    elseif not vehicle and isInVehicle then
        -- Jugador salió del vehículo
        isInVehicle = false
        currentVehicle = nil
        
        -- Ocultar el velocímetro
        if speedometerBrowser then
            local browser = guiGetBrowser(speedometerBrowser)
            if browser then
                executeBrowserJavascript(browser, "hideSpeedometer();")
            end
        end
    end
    
    if isInVehicle and vehicle and speedometerBrowser then
        local browser = guiGetBrowser(speedometerBrowser)
        if browser then
            local speed = getVehicleSpeedKMH(vehicle)
            local rpm = getVehicleRPM(vehicle)
            local vehicleName = getVehicleDisplayName(vehicle)
            local engineState = getVehicleEngineState(vehicle)
            local lightsState = getVehicleOverrideLights(vehicle)
            
            -- Obtener gasolina del elementData del vehículo
            local vehicleFuel = getElementData(vehicle, "vehicle:fuel") or fuelLevel
            
            -- Enviar datos al navegador
            executeBrowserJavascript(browser, string.format(
                "updateSpeedometer(%d, %d, %d, %s, %s, '%s');",
                speed,
                rpm,
                vehicleFuel,
                tostring(engineState),
                tostring(lightsState == 2),
                vehicleName
            ))
        end
    end
end

-- Timer para actualizar el velocímetro
setTimer(updateSpeedometer, 50, 0) -- Actualizar cada 50ms para suavidad

-- Evento cuando el jugador entra/sale de un vehículo
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
    if seat == 0 then -- Solo si es el conductor
        isInVehicle = true
        currentVehicle = vehicle
        triggerServerEvent("speedometer:getFuel", localPlayer, vehicle)
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
    if seat == 0 then
        isInVehicle = false
        currentVehicle = nil
    end
end)

-- Evento para recibir el nivel de gasolina del servidor
addEvent("speedometer:receiveFuel", true)
addEventHandler("speedometer:receiveFuel", root, function(fuel)
    fuelLevel = fuel or 100
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

-- Evento para actualizar la gasolina cuando cambia
addEvent("speedometer:updateFuel", true)
addEventHandler("speedometer:updateFuel", root, function(fuel)
    fuelLevel = fuel or fuelLevel
    if currentVehicle then
        setElementData(currentVehicle, "vehicle:fuel", fuelLevel)
    end
end)

-- Limpiar al detener el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    if speedometerBrowser and isElement(speedometerBrowser) then
        destroyElement(speedometerBrowser)
    end
    -- Restaurar el velocímetro nativo
    showPlayerHudComponent("vehicle_name", true)
    showPlayerHudComponent("area_name", true)
end)

