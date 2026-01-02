function replaceModel()
  txd = engineLoadTXD("sunrise.txd", 550 )
  engineImportTXD(txd, 550)
  dff = engineLoadDFF("sunrise.dff", 550 )
  engineReplaceModel(dff, 550)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
