function replaceModel()
  txd = engineLoadTXD("buffalo.txd", 402 )
  engineImportTXD(txd, 402)
  dff = engineLoadDFF("buffalo.dff", 402 )
  engineReplaceModel(dff, 402)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
