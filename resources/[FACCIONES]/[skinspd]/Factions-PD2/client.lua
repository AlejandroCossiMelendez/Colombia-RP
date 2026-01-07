function replaceModel()
txd = engineLoadTXD('lapd1.txd',280)
engineImportTXD(txd,280)
dff = engineLoadDFF('lapd1.dff',280)
engineReplaceModel(dff,280)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
