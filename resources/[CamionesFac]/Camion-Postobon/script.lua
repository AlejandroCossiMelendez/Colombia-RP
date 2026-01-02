local id = 534

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('534.txd'), id) 
    engineReplaceModel(engineLoadDFF('534.dff'), id)
end)