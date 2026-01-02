function replaceModel()
  txd = engineLoadTXD("supergt.txd", 506 )
  engineImportTXD(txd, 506)
  dff = engineLoadDFF("supergt.dff", 506 )
  engineReplaceModel(dff, 506)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
