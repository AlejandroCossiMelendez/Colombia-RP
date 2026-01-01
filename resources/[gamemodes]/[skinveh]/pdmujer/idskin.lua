function replaceModel()
  txd = engineLoadTXD("sofybu.txd", 9 )
  engineImportTXD(txd, 9)
  dff = engineLoadDFF("sofybu.dff", 9 )
  engineReplaceModel(dff, 9)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
