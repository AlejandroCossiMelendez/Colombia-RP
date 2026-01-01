function replaceModel()
  txd = engineLoadTXD("random22.txd", 306 )
  engineImportTXD(txd, 306)
  dff = engineLoadDFF("random22.dff", 306 )
  engineReplaceModel(dff, 306)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
