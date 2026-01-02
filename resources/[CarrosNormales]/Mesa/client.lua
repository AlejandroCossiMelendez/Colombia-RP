function replaceModel() 
  txd = engineLoadTXD("quad.txd", 500 )
  engineImportTXD(txd, 500)
  dff = engineLoadDFF("quad.dff", 500 )
  engineReplaceModel(dff, 500)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )