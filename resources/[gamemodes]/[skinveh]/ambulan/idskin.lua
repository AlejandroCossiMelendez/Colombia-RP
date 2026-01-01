function replaceModel()
  txd = engineLoadTXD("ambulan.txd", 416 )
  engineImportTXD(txd, 416)
  dff = engineLoadDFF("ambulan.dff", 416 )
  engineReplaceModel(dff, 416)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
