-- Skin colombiana para modelo 0 (CJ - personaje masculino por defecto)

addEventHandler('onClientResourceStart', root, function(resource)
    -- Solo ejecutar si es el gamemode colombia-rp
    if getResourceName(resource) ~= "colombia-rp" then
        return
    end
    
    -- Usar ruta completa relativa al gamemode
    local txdPath = "skins/skin-0/skin-0.txd"
    local dffPath = "skins/skin-0/skin-0.dff"
    
    local txd = engineLoadTXD(txdPath) 
    if txd then
        engineImportTXD(txd, 0) 
        outputChatBox("✓ Skin colombiana cargada (TXD) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar TXD: " .. txdPath, 255, 0, 0)
    end
    
    local dff = engineLoadDFF(dffPath, 0) 
    if dff then
        engineReplaceModel(dff, 0)
        outputChatBox("✓ Skin colombiana cargada (DFF) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar DFF: " .. dffPath, 255, 0, 0)
    end
end)
