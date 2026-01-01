function replaceModel()
  txd = engineLoadTXD("huntley.txd", 579 )
  engineImportTXD(txd, 579)
  dff = engineLoadDFF("huntley.dff", 579 )
  engineReplaceModel(dff, 579)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
