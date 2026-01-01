function replaceModel()
  txd = engineLoadTXD("skinmartin.txd", 308 )
  engineImportTXD(txd, 308)
  dff = engineLoadDFF("skinmartin.dff", 308 )
  engineReplaceModel(dff, 308)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
