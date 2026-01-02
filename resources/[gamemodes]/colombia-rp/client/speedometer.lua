-- Sistema de Velocímetro Personalizado y Gasolina
-- Deshabilita el velocímetro nativo y crea uno personalizado con HTML/CSS/JS

local speedometerBrowser = nil
local isInVehicle = false
local currentVehicle = nil
local fuelLevel = 100 -- Nivel de gasolina (0-100)

-- Deshabilitar el velocímetro nativo del juego
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Deshabilitar el componente de nombre de vehículo (velocímetro nativo)
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("area_name", false)
    
    -- Crear el navegador para el velocímetro
    createSpeedometerBrowser()
end)

-- Función para cargar el HTML del velocímetro
function loadSpeedometerBrowser()
    if source and isElement(source) then
        local browser = guiGetBrowser(source)
        if browser then
            loadBrowserURL(browser, "http://mta/local/html/speedometer.html")
            outputChatBox("[DEBUG] Velocímetro: URL cargada", 0, 255, 0)
        end
    end
end

-- Función cuando el documento está listo
function whenSpeedometerBrowserReady()
    outputChatBox("[DEBUG] Velocímetro: Documento listo", 0, 255, 0)
    local browser = guiGetBrowser(speedometerBrowser)
    if browser and isElement(browser) then
        -- Verificar que las funciones estén disponibles
        setTimer(function()
            if isElement(browser) then
                executeBrowserJavascript(browser, 
                    "console.log('Verificando funciones...'); " ..
                    "console.log('window.showSpeedometer:', typeof window.showSpeedometer); " ..
                    "console.log('window.updateSpeedometer:', typeof window.updateSpeedometer);"
                )
                -- Si estamos en un vehículo, mostrar el velocímetro
                if isInVehicle and currentVehicle then
                    setTimer(function()
                        if isElement(browser) then
                            executeBrowserJavascript(browser, 
                                "try { " ..
                                "if(typeof window.showSpeedometer === 'function') { " ..
                                "window.showSpeedometer(); " ..
                                "console.log('Velocímetro mostrado desde documentReady'); " ..
                                "} " ..
                                "} catch(e) { console.log('Error: ' + e); }"
                            )
                        end
                    end, 300, 1)
                end
            end
        end, 500, 1)
    end
end

-- Función para crear el navegador del velocímetro
function createSpeedometerBrowser()
    if speedometerBrowser and isElement(speedometerBrowser) then
        -- Remover eventos anteriores
        removeEventHandler("onClientBrowserCreated", speedometerBrowser, loadSpeedometerBrowser)
        removeEventHandler("onClientBrowserDocumentReady", speedometerBrowser, whenSpeedometerBrowserReady)
        destroyElement(speedometerBrowser)
        speedometerBrowser = nil
    end
    
    local screenW, screenH = guiGetScreenSize()
    speedometerBrowser = guiCreateBrowser(0, 0, screenW, screenH, false, false, false)
    
    if speedometerBrowser then
        -- Hacer visible el navegador inmediatamente
        guiSetVisible(speedometerBrowser, true)
        
        -- Registrar eventos en el elemento gui-browser (no en el browser)
        addEventHandler("onClientBrowserCreated", speedometerBrowser, loadSpeedometerBrowser)
        addEventHandler("onClientBrowserDocumentReady", speedometerBrowser, whenSpeedometerBrowserReady)
        
        outputChatBox("[DEBUG] Velocímetro: Navegador creado", 0, 255, 0)
    else
        outputChatBox("[ERROR] No se pudo crear el navegador del velocímetro", 255, 0, 0)
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
        if speedometerBrowser and isElement(speedometerBrowser) then
            local browser = guiGetBrowser(speedometerBrowser)
            if browser and isElement(browser) then
                -- Asegurar que el navegador sea visible
                guiSetVisible(speedometerBrowser, true)
                
                -- Intentar mostrar el velocímetro con múltiples intentos
                local attempts = 0
                local maxAttempts = 10
                local showTimer = setTimer(function()
                    attempts = attempts + 1
                    if isElement(browser) then
                        local url = getBrowserURL(browser)
                        if url and url ~= "" then
                            -- El HTML está cargado, intentar mostrar
                            executeBrowserJavascript(browser, 
                                "try { " ..
                                "if(typeof window.showSpeedometer === 'function') { " ..
                                "window.showSpeedometer(); " ..
                                "console.log('Velocímetro mostrado'); " ..
                                "} else if(typeof showSpeedometer === 'function') { " ..
                                "showSpeedometer(); " ..
                                "console.log('Velocímetro mostrado (sin window)'); " ..
                                "} else { " ..
                                "console.log('showSpeedometer no disponible'); " ..
                                "} " ..
                                "} catch(e) { console.log('Error: ' + e); }"
                            )
                            killTimer(showTimer)
                        elseif attempts >= maxAttempts then
                            -- Si después de varios intentos no se carga, recargar
                            loadBrowserURL(browser, "http://mta/local/html/speedometer.html")
                            killTimer(showTimer)
                        end
                    else
                        killTimer(showTimer)
                    end
                end, 200, maxAttempts)
            else
                outputChatBox("[DEBUG] Velocímetro: Navegador no válido, recreando...", 255, 255, 0)
                createSpeedometerBrowser()
            end
        else
            outputChatBox("[DEBUG] Velocímetro: Creando navegador...", 255, 255, 0)
            createSpeedometerBrowser()
            setTimer(function()
                if speedometerBrowser and isElement(speedometerBrowser) then
                    local newBrowser = guiGetBrowser(speedometerBrowser)
                    if newBrowser and isElement(newBrowser) then
                        guiSetVisible(speedometerBrowser, true)
                        executeBrowserJavascript(newBrowser, 
                            "try { " ..
                            "if(typeof showSpeedometer === 'function') { " ..
                            "showSpeedometer(); " ..
                            "} " ..
                            "} catch(e) { console.log('Error: ' + e); }"
                        )
                    end
                end
            end, 2000, 1)
        end
    elseif not vehicle and isInVehicle then
        -- Jugador salió del vehículo
        isInVehicle = false
        currentVehicle = nil
        
        -- Ocultar el velocímetro
        if speedometerBrowser then
            local browser = guiGetBrowser(speedometerBrowser)
            if browser and isElement(browser) then
                executeBrowserJavascript(browser, "if(typeof hideSpeedometer === 'function') { hideSpeedometer(); }")
            end
        end
    end
    
    if isInVehicle and vehicle and speedometerBrowser then
        local browser = guiGetBrowser(speedometerBrowser)
        if browser and isElement(browser) then
            local speed = getVehicleSpeedKMH(vehicle)
            local rpm = getVehicleRPM(vehicle)
            local vehicleName = getVehicleDisplayName(vehicle)
            local engineState = getVehicleEngineState(vehicle)
            local lightsState = getVehicleOverrideLights(vehicle)
            
            -- Obtener gasolina del elementData del vehículo
            local vehicleFuel = getElementData(vehicle, "vehicle:fuel") or fuelLevel
            
            -- Enviar datos al navegador
            local jsCode = string.format(
                "try { " ..
                "if(typeof updateSpeedometer === 'function') { " ..
                "updateSpeedometer(%d, %d, %d, %s, %s, '%s'); " ..
                "} else { " ..
                "console.log('updateSpeedometer no disponible'); " ..
                "} " ..
                "} catch(e) { console.log('Error actualizando velocímetro: ' + e); }",
                speed,
                rpm,
                vehicleFuel,
                tostring(engineState),
                tostring(lightsState == 2),
                vehicleName
            )
            executeBrowserJavascript(browser, jsCode)
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
    setPlayerHudComponentVisible("vehicle_name", true)
    setPlayerHudComponentVisible("area_name", true)
end)

