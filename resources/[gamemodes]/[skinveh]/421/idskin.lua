function replaceModel()
  txd = engineLoadTXD("421.txd", 421 )
  engineImportTXD(txd, 421)
  dff = engineLoadDFF("421.dff", 421 )
  engineReplaceModel(dff, 421)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
