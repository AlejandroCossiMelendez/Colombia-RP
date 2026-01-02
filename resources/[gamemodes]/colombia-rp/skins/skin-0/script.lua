-- Skin colombiana para modelo 0 (CJ - personaje masculino por defecto)

addEventHandler('onClientResourceStart', resourceRoot, function() 
    local txd = engineLoadTXD('skin-0.txd') 
    if txd then
        engineImportTXD(txd, 0) 
        outputChatBox("✓ Skin colombiana cargada (TXD) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar TXD: skin-0.txd", 255, 0, 0)
    end
    
    local dff = engineLoadDFF('skin-0.dff', 0) 
    if dff then
        engineReplaceModel(dff, 0)
        outputChatBox("✓ Skin colombiana cargada (DFF) para modelo 0", 0, 255, 0)
    else
        outputChatBox("Error al cargar DFF: skin-0.dff", 255, 0, 0)
    end
end)
