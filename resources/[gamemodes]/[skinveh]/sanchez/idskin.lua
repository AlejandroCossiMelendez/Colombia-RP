function replaceModel()
  txd = engineLoadTXD("sanchez.txd", 468 )
  engineImportTXD(txd, 468)
  dff = engineLoadDFF("sanchez.dff", 468 )
  engineReplaceModel(dff, 468)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
