local id = 546

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('skin.txd'), id) 
    engineReplaceModel(engineLoadDFF('skin.dff'), id)
end)