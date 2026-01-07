--- Creado por DavidxD814 ---
function replaceModel() 
  txd = engineLoadTXD("army.txd", 288 )
  engineImportTXD(txd, 288)
  dff = engineLoadDFF("army.dff", 288 )
  engineReplaceModel(dff, 288)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)