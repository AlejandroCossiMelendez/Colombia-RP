local id = 445

addEventHandler('onClientResourceStart', resourceRoot, function() 
    engineImportTXD(engineLoadTXD('dft-30.txd'), id) 
    engineReplaceModel(engineLoadDFF('dft-30.dff'), id)
end)