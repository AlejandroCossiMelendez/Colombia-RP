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
    
    -- Los mapas se cargan automáticamente por el mapmanager que ya está en el servidor
    outputServerLog("[MAPS] El mapmanager cargará los mapas automáticamente")
end)

addEventHandler("onResourceStop", resourceRoot, function()
    outputServerLog("Colombia RP - Gamemode detenido")
end)

