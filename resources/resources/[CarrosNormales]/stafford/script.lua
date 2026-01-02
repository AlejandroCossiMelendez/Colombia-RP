local id = 580

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('alpha.txd'), id) 
    engineReplaceModel(engineLoadDFF('alpha.dff'), id)
end)