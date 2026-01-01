function replaceModel()
  txd = engineLoadTXD("quad.txd", 471 )
  engineImportTXD(txd, 471)
  dff = engineLoadDFF("quad.dff", 471 )
  engineReplaceModel(dff, 471)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
