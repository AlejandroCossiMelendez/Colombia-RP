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
    
    -- Cargar TXD (usando la misma sintaxis que replace.lua)
    jblTXD = engineLoadTXD(txdPath, jblModel)
    if jblTXD then
        engineImportTXD(jblTXD, jblModel)
        outputDebugString("[JBL] TXD cargado correctamente para modelo " .. jblModel .. " desde: " .. txdPath)
    else
        outputDebugString("[JBL] ERROR: No se pudo cargar el TXD del JBL desde: " .. txdPath)
        -- Intentar sin el segundo parámetro
        jblTXD = engineLoadTXD(txdPath)
        if jblTXD then
            engineImportTXD(jblTXD, jblModel)
            outputDebugString("[JBL] TXD cargado correctamente (método alternativo)")
        else
            return false
        end
    end
    
    -- Cargar DFF (usando la misma sintaxis que replace.lua)
    jblDFF = engineLoadDFF(dffPath, jblModel)
    if jblDFF then
        engineReplaceModel(jblDFF, jblModel)
        outputDebugString("[JBL] DFF cargado correctamente para modelo " .. jblModel .. " desde: " .. dffPath)
        modelLoaded = true
        return true
    else
        outputDebugString("[JBL] ERROR: No se pudo cargar el DFF del JBL desde: " .. dffPath)
        -- Intentar sin el segundo parámetro
        jblDFF = engineLoadDFF(dffPath)
        if jblDFF then
            engineReplaceModel(jblDFF, jblModel)
            outputDebugString("[JBL] DFF cargado correctamente (método alternativo)")
            modelLoaded = true
            return true
        else
            return false
        end
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

-- Función para forzar recarga del modelo (exportable)
function forceReloadJBLModel()
    modelLoaded = false
    if jblTXD then
        destroyElement(jblTXD)
        jblTXD = nil
    end
    if jblDFF then
        destroyElement(jblDFF)
        jblDFF = nil
    end
    return loadJBLModel()
end

-- Evento para asegurar que el modelo esté cargado antes de crear el objeto
addEvent("jbl:ensureModelLoaded", true)
addEventHandler("jbl:ensureModelLoaded", resourceRoot, function()
    if not modelLoaded then
        loadJBLModel()
    end
    -- Forzar recarga para asegurar que esté actualizado
    forceReloadJBLModel()
end)

-- Evento para refrescar el modelo de un objeto específico
addEvent("jbl:refreshModel", true)
addEventHandler("jbl:refreshModel", resourceRoot, function(obj)
    if obj and isElement(obj) then
        -- Asegurar que el modelo esté cargado
        if not modelLoaded then
            loadJBLModel()
        end
        -- Forzar actualización del modelo
        local model = getElementModel(obj)
        if model == jblModel then
            -- El modelo ya debería estar reemplazado, pero forzamos recarga
            forceReloadJBLModel()
        end
    end
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

