-- Skin ByelzinSUG2 para modelo 58

addEventHandler('onClientResourceStart', resourceRoot, function()
    local txdPath = 'ByByelzin.txd'
    local dffPath = 'ByByelzin.dff'
    local modelId = 58
    
    local txd = engineLoadTXD(txdPath)
    if txd then
        engineImportTXD(txd, modelId)
        outputChatBox("✓ Skin ByelzinSUG2 cargada (TXD) para modelo " .. modelId, 0, 255, 0)
    else
        outputChatBox("Error al cargar TXD: " .. txdPath, 255, 0, 0)
    end
    
    local dff = engineLoadDFF(dffPath, modelId)
    if dff then
        engineReplaceModel(dff, modelId)
        outputChatBox("✓ Skin ByelzinSUG2 cargada (DFF) para modelo " .. modelId, 0, 255, 0)
    else
        outputChatBox("Error al cargar DFF: " .. dffPath, 255, 0, 0)
    end
end)