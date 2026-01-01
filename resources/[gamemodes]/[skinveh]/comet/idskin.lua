function replaceModel()
  txd = engineLoadTXD("comet.txd", 480 )
  engineImportTXD(txd, 480)
  dff = engineLoadDFF("comet.dff", 480 )
  engineReplaceModel(dff, 480)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
