function replaceModel() 
  txd = engineLoadTXD("dusterpd.txd", 596 )
  engineImportTXD(txd, 596)
  dff = engineLoadDFF("dusterpd.dff", 596 )
  engineReplaceModel(dff, 596)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( "reloadcar", replaceModel )