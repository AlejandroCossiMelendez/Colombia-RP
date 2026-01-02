function replaceModel()
  txd = engineLoadTXD("wayfarer.txd", 586 )
  engineImportTXD(txd, 586)
  dff = engineLoadDFF("wayfarer.dff", 586 )
  engineReplaceModel(dff, 586)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
