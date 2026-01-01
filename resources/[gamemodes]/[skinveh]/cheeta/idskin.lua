function replaceModel()
  txd = engineLoadTXD("cheeta.txd", 415 )
  engineImportTXD(txd, 415)
  dff = engineLoadDFF("cheeta.dff", 415 )
  engineReplaceModel(dff, 415)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
