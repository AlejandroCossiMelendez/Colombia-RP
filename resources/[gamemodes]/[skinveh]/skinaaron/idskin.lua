function replaceModel()
  txd = engineLoadTXD("bmost.txd", 124 )
  engineImportTXD(txd, 124)
  dff = engineLoadDFF("bmost.dff", 124 )
  engineReplaceModel(dff, 124)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
