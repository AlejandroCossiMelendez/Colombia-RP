-- Skin ByelzinSUG2 para modelo 0 (CJ - personaje masculino por defecto)
-- NOTA: El archivo skin58.dff tiene errores y causa crashes, solo cargamos el TXD

addEventHandler('onClientResourceStart', root, function(resource)
    -- Solo ejecutar si es el gamemode colombia-rp
    if getResourceName(resource) ~= "colombia-rp" then
        return
    end
    
    -- Usar ruta completa relativa al gamemode
    local txdPath = "skins/ByelzinSUG2/skin58.txd"
    
    -- Cargar solo el TXD (textura) ya que el DFF está causando crashes
    local txd = engineLoadTXD(txdPath) 
    if txd then
        engineImportTXD(txd, 0) 
        outputChatBox("✓ Skin ByelzinSUG2 cargada (TXD) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar TXD: " .. txdPath, 255, 0, 0)
    end
    
    -- DFF deshabilitado temporalmente debido a errores que causan crashes
    -- El archivo skin58.dff contiene errores según los logs del servidor
    -- local dffPath = "skins/ByelzinSUG2/skin58.dff"
    -- local dff = engineLoadDFF(dffPath, 0) 
    -- if dff then
    --     engineReplaceModel(dff, 0)
    --     outputChatBox("✓ Skin ByelzinSUG2 cargada (DFF) para modelo 0", 0, 255, 0)
    -- else
    --     outputChatBox("Error al cargar DFF: " .. dffPath, 255, 0, 0)
    -- end
end)