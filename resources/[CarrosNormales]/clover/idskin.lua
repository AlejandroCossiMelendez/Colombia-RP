function replaceModel() 
  txd = engineLoadTXD("542.txd", 542 )
  engineImportTXD(txd, 542)
  dff = engineLoadDFF("542.dff", 542 )
  engineReplaceModel(dff, 542)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )