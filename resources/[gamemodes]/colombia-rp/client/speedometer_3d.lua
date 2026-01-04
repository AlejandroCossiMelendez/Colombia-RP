-- Sistema de Velocímetro 3D (Modelo AK47)
-- Carga el modelo DFF/TXD y lo muestra cuando el jugador está en un vehículo

local speedometerModel = 355  -- ID del modelo AK47 (weapon ID 30 = AK47)
local speedometerObject = nil
local speedometerLoaded = false
local screenW, screenH = guiGetScreenSize()

-- Cargar el modelo del velocímetro
function loadSpeedometerModel()
    local txdPath = "ByAngelAK47fire/Ak47.txd"
    local dffPath = "ByAngelAK47fire/ak47.dff"
    
    -- Cargar TXD
    local txd = engineLoadTXD(txdPath, speedometerModel)
    if txd then
        engineImportTXD(txd, speedometerModel)
        outputDebugString("[SPEEDOMETER 3D] TXD cargado correctamente desde: " .. txdPath)
    else
        outputDebugString("[SPEEDOMETER 3D] ERROR: No se pudo cargar el TXD desde: " .. txdPath)
        return false
    end
    
    -- Cargar DFF
    local dff = engineLoadDFF(dffPath, speedometerModel)
    if dff then
        engineReplaceModel(dff, speedometerModel)
        outputDebugString("[SPEEDOMETER 3D] DFF cargado correctamente desde: " .. dffPath)
        speedometerLoaded = true
        return true
    else
        outputDebugString("[SPEEDOMETER 3D] ERROR: No se pudo cargar el DFF desde: " .. dffPath)
        return false
    end
end

-- Crear objeto del velocímetro cuando el jugador se monta en un vehículo
function createSpeedometerObject(vehicle)
    if not vehicle or not isElement(vehicle) then
        return false
    end
    
    -- Destruir objeto anterior si existe
    if speedometerObject and isElement(speedometerObject) then
        destroyElement(speedometerObject)
        speedometerObject = nil
    end
    
    -- Obtener posición del vehículo
    local vx, vy, vz = getElementPosition(vehicle)
    
    -- Crear objeto del velocímetro
    -- Posicionarlo a la derecha del vehículo (0.5 unidades a la derecha, 0.3 arriba)
    speedometerObject = createObject(speedometerModel, vx, vy, vz, 0, 0, 0)
    
    if not speedometerObject then
        outputDebugString("[SPEEDOMETER 3D] ERROR: No se pudo crear el objeto del velocímetro")
        return false
    end
    
    -- Configurar el objeto
    setElementDimension(speedometerObject, getElementDimension(vehicle))
    setElementInterior(speedometerObject, getElementInterior(vehicle))
    setElementCollisionsEnabled(speedometerObject, false)
    setObjectScale(speedometerObject, 0.2)  -- Hacerlo más pequeño para que se vea como velocímetro
    
    -- Adjuntar al vehículo - a la derecha (0.5) y arriba (0.3)
    attachElements(speedometerObject, vehicle, 0.5, 0, 0.3, 0, 0, 0)
    
    outputDebugString("[SPEEDOMETER 3D] Objeto del velocímetro creado y adjuntado al vehículo")
    return true
end

-- Destruir objeto del velocímetro
function destroySpeedometerObject()
    if speedometerObject and isElement(speedometerObject) then
        destroyElement(speedometerObject)
        speedometerObject = nil
    end
end

-- Verificar si el jugador está en un vehículo y crear/destruir el objeto
addEventHandler("onClientRender", root, function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if vehicle and getPedOccupiedVehicleSeat(localPlayer) == 0 then
        -- Jugador está conduciendo
        if not speedometerObject or not isElement(speedometerObject) then
            if speedometerLoaded then
                createSpeedometerObject(vehicle)
            end
        end
    else
        -- Jugador no está en un vehículo
        if speedometerObject and isElement(speedometerObject) then
            destroySpeedometerObject()
        end
    end
end)

-- Cargar el modelo cuando el recurso inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    loadSpeedometerModel()
end)

-- Limpiar cuando el recurso se detiene
addEventHandler("onClientResourceStop", resourceRoot, function()
    destroySpeedometerObject()
end)

