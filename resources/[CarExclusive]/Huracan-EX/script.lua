local id = 503

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('car.txd'), id) 
    engineReplaceModel(engineLoadDFF('car.dff'), id)
end)