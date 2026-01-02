function replaceModel()
  txd = engineLoadTXD("alpha.txd", 418)
  engineImportTXD(txd, 418)
  dff = engineLoadDFF("alpha.dff", 418)
  engineReplaceModel(dff, 418)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
