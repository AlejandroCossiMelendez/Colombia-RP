-- Cargar modelo JBL en el cliente
-- Este script carga el DFF y TXD del JBL personalizado

local jblModel = 2226
local jblTXD = nil
local jblDFF = nil
local modelLoaded = false

-- Función para cargar el modelo JBL
function loadJBLModel()
    if modelLoaded then
        return true
    end
    
    -- Rutas del modelo JBL personalizado
    local txdPath = "jbl/ModelJBL/jbl.txd"
    local dffPath = "jbl/ModelJBL/jbl.dff"
    
    -- Intentar cargar desde el recurso ModelJBL si existe como recurso separado
    local modelJBLResource = getResourceFromName("ModelJBL")
    if modelJBLResource and getResourceState(modelJBLResource) == "running" then
        txdPath = ":ModelJBL/jbl.txd"
        dffPath = ":ModelJBL/jbl.dff"
    end
    
    -- Cargar TXD
    jblTXD = engineLoadTXD(txdPath)
    if jblTXD then
        engineImportTXD(jblTXD, jblModel)
        outputDebugString("[JBL] TXD cargado correctamente para modelo " .. jblModel .. " desde: " .. txdPath)
    else
        outputDebugString("[JBL] ERROR: No se pudo cargar el TXD del JBL desde: " .. txdPath)
        return false
    end
    
    -- Cargar DFF
    jblDFF = engineLoadDFF(dffPath)
    if jblDFF then
        engineReplaceModel(jblDFF, jblModel)
        outputDebugString("[JBL] DFF cargado correctamente para modelo " .. jblModel .. " desde: " .. dffPath)
        modelLoaded = true
        return true
    else
        outputDebugString("[JBL] ERROR: No se pudo cargar el DFF del JBL desde: " .. dffPath)
        return false
    end
end

-- Cargar el modelo cuando el recurso inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Intentar cargar inmediatamente
    loadJBLModel()
    
    -- También intentar después de un delay por si hay problemas de carga
    setTimer(function()
        if not modelLoaded then
            loadJBLModel()
        end
    end, 1000, 1)
    
    -- Último intento después de más tiempo
    setTimer(function()
        if not modelLoaded then
            loadJBLModel()
        end
    end, 3000, 1)
end)

-- También intentar cargar si ModelJBL se inicia después como recurso separado
addEventHandler("onClientResourceStart", root, function(resource)
    local resourceName = getResourceName(resource)
    if resourceName == "ModelJBL" or string.find(string.lower(resourceName), "jbl", 1, true) then
        setTimer(function()
            if not modelLoaded then
                loadJBLModel()
            end
        end, 500, 1)
    end
end)

