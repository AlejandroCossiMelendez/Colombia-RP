function replaceModel()
  txd = engineLoadTXD("rancher.txd", 458)
  engineImportTXD(txd, 458)
  dff = engineLoadDFF("rancher.dff", 458)
  engineReplaceModel(dff, 458)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En rancher.txd, debes poner antes de txd borrar el rancher y poner el nombre de tu txd y en rancher.dff lo mismo.
--458: 458 del skin que vas a remplazar
--No Borrar .txd ni .dff
