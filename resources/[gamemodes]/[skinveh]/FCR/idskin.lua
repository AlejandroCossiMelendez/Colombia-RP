function replaceModel()
  txd = engineLoadTXD("fcr.txd", 521 )
  engineImportTXD(txd, 521)
  dff = engineLoadDFF("fcr.dff", 521 )
  engineReplaceModel(dff, 521)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
