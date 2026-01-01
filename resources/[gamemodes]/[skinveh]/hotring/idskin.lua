function replaceModel()
  txd = engineLoadTXD("419.txd", 419 )
  engineImportTXD(txd, 419)
  dff = engineLoadDFF("494.dff", 419 )
  engineReplaceModel(dff, 419)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
