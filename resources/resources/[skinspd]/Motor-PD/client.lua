function replaceModel()
txd = engineLoadTXD('lapdm1.txd',284)
engineImportTXD(txd,284)
dff = engineLoadDFF('lapdm1.dff',284)
engineReplaceModel(dff,284)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
