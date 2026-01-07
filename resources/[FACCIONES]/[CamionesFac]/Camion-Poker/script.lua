local id = 508

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('journey.txd'), id) 
    engineReplaceModel(engineLoadDFF('journey.dff'), id)
end)