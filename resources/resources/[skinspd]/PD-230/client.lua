function replaceModel()
txd = engineLoadTXD('lapdm1.txd',280)
engineImportTXD(txd,280)
dff = engineLoadDFF('lapdm1.dff',280)
engineReplaceModel(dff,280)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
