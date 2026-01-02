function replaceModel() 
  txd = engineLoadTXD("490.txd", 490 )
  engineImportTXD(txd, 490)
  dff = engineLoadDFF("490.dff", 490 )
  engineReplaceModel(dff, 490)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )