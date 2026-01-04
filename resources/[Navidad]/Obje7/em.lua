function replaceModel()
  txd = engineLoadTXD("em.txd", 1727 )
  engineImportTXD(txd, 1727)
  dff = engineLoadDFF("em.dff", 1727 )
  engineReplaceModel(dff, 1727)
  col= engineLoadCOL ( "em.col" )
  engineReplaceCOL ( col, 1727 )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)