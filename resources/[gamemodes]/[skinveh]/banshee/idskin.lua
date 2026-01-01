function replaceModel()
  txd = engineLoadTXD("banshee.txd", 429 )
  engineImportTXD(txd, 429)
  dff = engineLoadDFF("banshee.dff", 429 )
  engineReplaceModel(dff, 429)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
