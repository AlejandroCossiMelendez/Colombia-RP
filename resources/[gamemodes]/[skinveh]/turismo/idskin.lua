function replaceModel()
  txd = engineLoadTXD("turismo.txd", 451 )
  engineImportTXD(txd, 451)
  dff = engineLoadDFF("turismo.dff", 451 )
  engineReplaceModel(dff, 451)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
