function replaceModel()
txd = engineLoadTXD('byxeyz77.txd',440)
engineImportTXD(txd,440)
dff = engineLoadDFF('byxeyz77.dff',440)
engineReplaceModel(dff,440)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
