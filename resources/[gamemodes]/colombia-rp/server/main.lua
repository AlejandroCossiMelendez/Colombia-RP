-- Archivo principal del servidor
addEventHandler("onResourceStart", resourceRoot, function()
    outputServerLog("========================================")
    outputServerLog("Colombia RP - Gamemode iniciado")
    outputServerLog("========================================")
    
    -- Verificar conexión a base de datos
    if not getDatabase() then
        outputServerLog("ERROR: No se pudo conectar a la base de datos MySQL")
        outputServerLog("Verifica la configuración en server/config.lua")
        -- No cancelar el recurso, solo advertir
    else
        outputServerLog("Base de datos conectada correctamente")
    end
    
    -- El recurso items está dentro del gamemode, así que no puede iniciarse como recurso separado
    -- Las funciones están disponibles directamente a través de exports
    -- Verificamos si las funciones están disponibles
    local itemsResource = getResourceFromName("items")
    if not itemsResource then
        -- El recurso items está dentro del gamemode, intentar cargar sus funciones directamente
        outputServerLog("[ITEMS] El recurso 'items' está dentro del gamemode. Las funciones estarán disponibles cuando se necesiten.")
    else
        local itemsState = getResourceState(itemsResource)
        if itemsState == "loaded" or itemsState == "stopped" then
            if startResource(itemsResource) then
                outputServerLog("[ITEMS] Recurso 'items' iniciado correctamente")
            else
                outputServerLog("[ITEMS] ERROR: No se pudo iniciar el recurso 'items'")
            end
        elseif itemsState == "running" then
            outputServerLog("[ITEMS] Recurso 'items' ya está en ejecución")
        else
            outputServerLog("[ITEMS] Recurso 'items' en estado: " .. tostring(itemsState))
        end
    end
    
    -- Los mapas se cargan automáticamente por el mapmanager que ya está en el servidor
    outputServerLog("[MAPS] El mapmanager cargará los mapas automáticamente")
end)

addEventHandler("onResourceStop", resourceRoot, function()
    outputServerLog("Colombia RP - Gamemode detenido")
end)

