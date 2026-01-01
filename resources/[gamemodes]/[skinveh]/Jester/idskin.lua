function replaceModel()
  txd = engineLoadTXD("jester.txd", 559 )
  engineImportTXD(txd, 559)
  dff = engineLoadDFF("jester.dff", 559 )
  engineReplaceModel(dff, 559)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
