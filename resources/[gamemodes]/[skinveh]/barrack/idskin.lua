function replaceModel()
  txd = engineLoadTXD("barracks.txd", 433 )
  engineImportTXD(txd, 433)
  dff = engineLoadDFF("barracks.dff", 433 )
  engineReplaceModel(dff, 433)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
