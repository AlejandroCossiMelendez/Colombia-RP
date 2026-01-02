function replaceModel()
txd = engineLoadTXD('ambulancia.txd',416)
engineImportTXD(txd,416)
dff = engineLoadDFF('ambulancia.dff',416)
engineReplaceModel(dff,416)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
