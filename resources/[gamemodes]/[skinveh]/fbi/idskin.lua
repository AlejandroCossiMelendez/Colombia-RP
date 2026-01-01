function replaceModel()
  txd = engineLoadTXD("elegy.txd", 279 )
  engineImportTXD(txd, 279)
  dff = engineLoadDFF("fbi.dff", 279 )
  engineReplaceModel(dff, 279)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
