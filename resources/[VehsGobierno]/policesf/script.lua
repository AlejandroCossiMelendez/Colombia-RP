local id = 596

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('rancher.txd'), id) 
    engineReplaceModel(engineLoadDFF('rancher.dff'), id)
end)