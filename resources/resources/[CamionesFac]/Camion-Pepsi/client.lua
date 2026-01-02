function replaceModel()
txd = engineLoadTXD('benson.txd',499)
engineImportTXD(txd,499)
dff = engineLoadDFF('benson.dff',499)
engineReplaceModel(dff,499)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
