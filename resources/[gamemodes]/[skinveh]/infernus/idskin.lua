function replaceModel()
  txd = engineLoadTXD("infernus.txd", 411 )
  engineImportTXD(txd, 411)
  dff = engineLoadDFF("infernus.dff", 411 )
  engineReplaceModel(dff, 411)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
