function replaceModel()
  txd = engineLoadTXD("alpha.txd", 602 )
  engineImportTXD(txd, 602)
  dff = engineLoadDFF("alpha.dff", 602 )
  engineReplaceModel(dff, 602)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
