function replaceModel()
  txd = engineLoadTXD("nrg500.txd", 522 )
  engineImportTXD(txd, 522)
  dff = engineLoadDFF("nrg500.dff", 522 )
  engineReplaceModel(dff, 522)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
