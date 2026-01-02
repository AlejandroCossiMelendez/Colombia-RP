function replaceModel()
  txd = engineLoadTXD("sentinel.txd", 405 )
  engineImportTXD(txd, 405)
  dff = engineLoadDFF("sentinel.dff", 405 )
  engineReplaceModel(dff, 405)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
