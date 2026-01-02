local id = 409

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('stretch.txd'), id) 
    engineReplaceModel(engineLoadDFF('stretch.dff'), id)
end)