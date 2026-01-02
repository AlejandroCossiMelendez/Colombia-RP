function replaceModel()
txd = engineLoadTXD('rancher lure.txd',505)
engineImportTXD(txd,505)
dff = engineLoadDFF('rancher lure.dff',505)
engineReplaceModel(dff,505)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
