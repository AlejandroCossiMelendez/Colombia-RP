local id = 289

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('skin.txd'), id) 
    engineReplaceModel(engineLoadDFF('skin.dff'), id)
end)