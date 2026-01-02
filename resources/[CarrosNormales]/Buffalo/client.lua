function replaceModel()
txd = engineLoadTXD('buffalo.txd',402)
engineImportTXD(txd,402)
dff = engineLoadDFF('buffalo.dff',402)
engineReplaceModel(dff,402)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )
