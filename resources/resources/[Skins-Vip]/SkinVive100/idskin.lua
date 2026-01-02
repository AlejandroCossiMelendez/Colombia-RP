function replaceModel() 
  txd = engineLoadTXD("40.txd", 40 )
  engineImportTXD(txd, 40)
  dff = engineLoadDFF("40.dff", 60 )
  engineReplaceModel(dff, 40)
end 
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)