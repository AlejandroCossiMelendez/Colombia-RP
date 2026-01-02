--- Creado por DavidxD814 ---
function replaceModel() 
  txd = engineLoadTXD("523.txd", 523 )
  engineImportTXD(txd, 523)
  dff = engineLoadDFF("523.dff", 523)
  engineReplaceModel(dff, 523)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)