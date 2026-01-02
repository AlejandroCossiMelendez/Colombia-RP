function replaceModel()
  txd = engineLoadTXD("sunrise.txd", 603 )
  engineImportTXD(txd, 603)
  dff = engineLoadDFF("sunrise.dff", 603 )
  engineReplaceModel(dff, 603)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)