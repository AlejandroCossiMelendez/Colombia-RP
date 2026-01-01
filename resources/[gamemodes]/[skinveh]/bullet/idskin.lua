function replaceModel()
  txd = engineLoadTXD("bullet.txd", 541 )
  engineImportTXD(txd, 541)
  dff = engineLoadDFF("bullet.dff", 541 )
  engineReplaceModel(dff, 541)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
