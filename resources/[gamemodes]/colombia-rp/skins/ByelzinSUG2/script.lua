-- Skin ByelzinSUG2 para modelo 0 (CJ - personaje masculino por defecto)

addEventHandler('onClientResourceStart', root, function(resource)
    -- Solo ejecutar si es el gamemode colombia-rp
    if getResourceName(resource) ~= "colombia-rp" then
        return
    end
    
    -- Usar ruta completa relativa al gamemode
    local txdPath = "skins/ByelzinSUG2/skin58.txd"
    local dffPath = "skins/ByelzinSUG2/skin58.dff"
    
    local txd = engineLoadTXD(txdPath) 
    if txd then
        engineImportTXD(txd, 0) 
        outputChatBox("✓ Skin ByelzinSUG2 cargada (TXD) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar TXD: " .. txdPath, 255, 0, 0)
    end
    
    local dff = engineLoadDFF(dffPath, 0) 
    if dff then
        engineReplaceModel(dff, 0)
        outputChatBox("✓ Skin ByelzinSUG2 cargada (DFF) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar DFF: " .. dffPath, 255, 0, 0)
    end
end)