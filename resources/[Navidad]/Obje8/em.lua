function replaceModel()
  txd = engineLoadTXD("em.txd", 1769 )
  engineImportTXD(txd, 1769)
  dff = engineLoadDFF("em.dff", 1769 )
  engineReplaceModel(dff, 1769)
  col= engineLoadCOL ( "em.col" )
  engineReplaceCOL ( col, 1769 )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)