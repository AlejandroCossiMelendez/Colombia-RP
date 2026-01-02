function replaceModel() 
  txd = engineLoadTXD("168.txd", 168 )
  engineImportTXD(txd, 168)
  dff = engineLoadDFF("168.dff", 168 )
  engineReplaceModel(dff, 168)
end 
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)