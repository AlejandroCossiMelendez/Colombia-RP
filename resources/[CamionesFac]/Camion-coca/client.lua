function replaceModel()
txd = engineLoadTXD('byxeyz77.txd',414)
engineImportTXD(txd,414)
dff = engineLoadDFF('byxeyz77.dff',414)
engineReplaceModel(dff,414)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
