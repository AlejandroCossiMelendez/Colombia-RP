local id = 267

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('skin.txd'), id) 
    engineReplaceModel(engineLoadDFF('skin.dff'), id)
end)