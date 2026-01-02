function replaceModel()
  txd = engineLoadTXD("greenwood.txd", 492 )
  engineImportTXD(txd, 492)
  dff = engineLoadDFF("greenwood.dff", 492 )
  engineReplaceModel(dff, 492)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
