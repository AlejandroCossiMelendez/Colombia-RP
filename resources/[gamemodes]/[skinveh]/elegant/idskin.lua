function replaceModel()
  txd = engineLoadTXD("elegant.txd", 507 )
  engineImportTXD(txd, 507)
  dff = engineLoadDFF("elegant.dff", 507 )
  engineReplaceModel(dff, 507)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
