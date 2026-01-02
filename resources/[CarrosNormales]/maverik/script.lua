local id = 487

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('polmav.txd'), id) 
    engineReplaceModel(engineLoadDFF('polmav.dff'), id)
end)