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
    
    -- Cargar mapas automáticamente (como el gamemode play)
    -- El mapmanager ya está cargado en el servidor, solo necesitamos cargar un mapa
    setTimer(function()
        -- Intentar cargar un mapa por defecto si hay mapas disponibles
        local maps = getResourcesByType("map")
        if maps and #maps > 0 then
            -- Cargar el primer mapa disponible (puedes cambiar esto para cargar un mapa específico)
            outputServerLog("[MAPS] Mapas disponibles: " .. #maps)
            -- Los mapas se cargan automáticamente por el mapmanager
        else
            outputServerLog("[MAPS] No hay mapas disponibles para cargar")
        end
    end, 1000, 1)
end)

addEventHandler("onResourceStop", resourceRoot, function()
    outputServerLog("Colombia RP - Gamemode detenido")
end)

