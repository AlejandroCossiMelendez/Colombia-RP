local id = 555

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('car.txd'), id) 
    engineReplaceModel(engineLoadDFF('car.dff'), id)
end)