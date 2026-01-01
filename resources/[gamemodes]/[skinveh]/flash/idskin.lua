function replaceModel()
  txd = engineLoadTXD("flash.txd", 565 )
  engineImportTXD(txd, 565)
  dff = engineLoadDFF("flash.dff", 565 )
  engineReplaceModel(dff, 565)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
