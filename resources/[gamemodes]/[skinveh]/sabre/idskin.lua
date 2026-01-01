function replaceModel()
  txd = engineLoadTXD("sabre.txd", 475 )
  engineImportTXD(txd, 475)
  dff = engineLoadDFF("sabre.dff", 475 )
  engineReplaceModel(dff, 475)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
