-- Sistema de carga de skins personalizadas
-- Skin 58 personalizada

-- Cargar la skin cuando el recurso inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Cargar el archivo TXD (texturas)
    local txd = engineLoadTXD("skin58.txd")
    if txd then
        engineImportTXD(txd, 58)  -- 58 es el ID del modelo de skin
        outputChatBox("✓ Skin 58 cargada correctamente", 0, 255, 0)
    else
        outputChatBox("✗ Error al cargar skin58.txd", 255, 0, 0)
    end
    
    -- Cargar el archivo DFF (modelo 3D)
    local dff = engineLoadDFF("skin58.dff", 58)  -- 58 es el ID del modelo
    if dff then
        engineReplaceModel(dff, 58)  -- Reemplazar el modelo 58 con el personalizado
        outputChatBox("✓ Modelo 58 cargado correctamente", 0, 255, 0)
    else
        outputChatBox("✗ Error al cargar skin58.dff", 255, 0, 0)
    end
end)

