function replaceModel()
txd = engineLoadTXD('byxeyz77.txd',403)
engineImportTXD(txd,403)
dff = engineLoadDFF('byxeyz77.dff',403)
engineReplaceModel(dff,403)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
