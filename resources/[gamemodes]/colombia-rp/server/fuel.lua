-- Sistema de Gasolina para Vehículos
local vehicleFuel = {} -- Tabla para almacenar la gasolina de cada vehículo

-- Configuración de gasolina
local ConfigFuel = {
    defaultFuel = 100, -- Gasolina inicial (100%)
    consumptionRate = 0.05, -- Consumo por segundo cuando el motor está encendido
    refuelRate = 1, -- Cantidad de gasolina que se agrega por segundo al repostar
    updateInterval = 1000 -- Actualizar cada segundo
}

-- Inicializar gasolina cuando se crea un vehículo
function initializeVehicleFuel(vehicle)
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return
    end
    
    -- Si el vehículo no tiene gasolina asignada, asignarle la por defecto
    if not vehicleFuel[vehicle] then
        vehicleFuel[vehicle] = ConfigFuel.defaultFuel
        setElementData(vehicle, "vehicle:fuel", ConfigFuel.defaultFuel)
    end
end

-- Consumir gasolina
function consumeVehicleFuel(vehicle)
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return
    end
    
    local fuel = vehicleFuel[vehicle] or ConfigFuel.defaultFuel
    
    -- Solo consumir si el motor está encendido
    if isVehicleEngineOn(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)
        local speed = math.floor((vx^2 + vy^2 + vz^2) ^ 0.49 * 100 * 1.609344) -- Velocidad en km/h
        
        -- Consumir más gasolina si va más rápido
        local consumption = ConfigFuel.consumptionRate
        if speed > 80 then
            consumption = consumption * 1.5
        elseif speed > 120 then
            consumption = consumption * 2
        end
        
        fuel = math.max(0, fuel - consumption)
        vehicleFuel[vehicle] = fuel
        setElementData(vehicle, "vehicle:fuel", fuel)
        
        -- Si se queda sin gasolina, apagar el motor
        if fuel <= 0 then
            setVehicleEngineState(vehicle, false)
            for _, player in ipairs(getVehicleOccupants(vehicle)) do
                if getElementType(player) == "player" then
                    outputChatBox("¡El vehículo se quedó sin gasolina!", player, 255, 0, 0)
                end
            end
        end
    end
end


-- Inicializar gasolina para todos los vehículos existentes
addEventHandler("onResourceStart", resourceRoot, function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        initializeVehicleFuel(vehicle)
    end
end)

-- Inicializar gasolina cuando se crea un vehículo
addEventHandler("onVehicleCreate", root, function()
    initializeVehicleFuel(source)
end)

-- Consumir gasolina periódicamente
setTimer(function()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElement(vehicle) then
            consumeVehicleFuel(vehicle)
        end
    end
end, ConfigFuel.updateInterval, 0)

-- Comando para repostar (solo en gasolineras o con jerrycan)
addCommandHandler("repostar", function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then
        outputChatBox("Debes estar en un vehículo para repostar.", player, 255, 0, 0)
        return
    end
    
    -- Verificar si está cerca de una gasolinera (aquí puedes agregar coordenadas de gasolineras)
    local x, y, z = getElementPosition(vehicle)
    -- Por ahora, permitir repostar en cualquier lugar (puedes agregar verificación de coordenadas)
    
    local currentFuel = vehicleFuel[vehicle] or 0
    if currentFuel >= 100 then
        outputChatBox("El tanque ya está lleno.", player, 255, 255, 0)
        return
    end
    
    -- Repostar (simulado - en un sistema real necesitarías dinero y tiempo)
    vehicleFuel[vehicle] = 100
    setElementData(vehicle, "vehicle:fuel", 100)
    outputChatBox("Has repostado el vehículo. Gasolina: 100%", player, 0, 255, 0)
end)

-- Limpiar datos cuando se destruye un vehículo
addEventHandler("onVehicleDestroy", root, function()
    if vehicleFuel[source] then
        vehicleFuel[source] = nil
    end
end)

