local id = 498

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('boxville.txd'), id) 
    engineReplaceModel(engineLoadDFF('boxville.dff'), id)
end)