function replaceModel()
  txd = engineLoadTXD("458.txd", 458 )
  engineImportTXD(txd, 458)
  dff = engineLoadDFF("458.dff", 458 )
  engineReplaceModel(dff, 458)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
