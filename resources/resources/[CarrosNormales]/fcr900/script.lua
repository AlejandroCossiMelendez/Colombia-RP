local id = 521

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('skin.txd'), id) 
    engineReplaceModel(engineLoadDFF('skin.dff'), id)
end)