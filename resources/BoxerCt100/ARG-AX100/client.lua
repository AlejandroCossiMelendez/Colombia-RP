function replaceModel()
txd = engineLoadTXD('sanchez.txd',468)
engineImportTXD(txd,468)
dff = engineLoadDFF('sanchez.dff',468)
engineReplaceModel(dff,468)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)

