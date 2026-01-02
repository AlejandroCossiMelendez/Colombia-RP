function replaceModel()
txd = engineLoadTXD('buffalo.txd',471)
engineImportTXD(txd,471)
dff = engineLoadDFF('buffalo.dff',471)
engineReplaceModel(dff,471)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
