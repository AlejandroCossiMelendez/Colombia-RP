local id = 508

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('journey.txd'), 508) 
    engineReplaceModel(engineLoadDFF('journey.dff'), 508)
end)