-- Cargar modelo JBL en el cliente
-- Este script carga el DFF y TXD del JBL antes de usarlo

local jblModel = 2226
local jblTXD = nil
local jblDFF = nil
local modelLoaded = false

-- Función para cargar el modelo JBL
function loadJBLModel()
    if modelLoaded then
        return true
    end
    
    -- Intentar cargar desde diferentes rutas posibles
    local txdPath = nil
    local dffPath = nil
    
    -- Primero intentar desde el recurso ModelJBL si existe
    local modelJBLResource = getResourceFromName("ModelJBL")
    if modelJBLResource and getResourceState(modelJBLResource) == "running" then
        txdPath = ":ModelJBL/jbl.txd"
        dffPath = ":ModelJBL/jbl.dff"
    else
        -- Intentar desde la ruta relativa dentro del gamemode
        txdPath = "jbl/ModelJBL/jbl.txd"
        dffPath = "jbl/ModelJBL/jbl.dff"
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
    
    -- También intentar después de un delay por si el recurso ModelJBL se carga después
    setTimer(function()
        if not modelLoaded then
            loadJBLModel()
        end
    end, 2000, 1)
end)

-- También intentar cargar si ModelJBL se inicia después
addEventHandler("onClientResourceStart", root, function(resource)
    local resourceName = getResourceName(resource)
    if resourceName == "ModelJBL" or string.find(resourceName, "jbl", 1, true) then
        setTimer(function()
            loadJBLModel()
        end, 500, 1)
    end
end)

