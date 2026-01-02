local id = 554

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('yosemite.txd'), id) 
    engineReplaceModel(engineLoadDFF('yosemite.dff'), id)
end)