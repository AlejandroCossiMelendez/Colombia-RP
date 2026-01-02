function replaceModel()
  txd = engineLoadTXD("554.txd", 470 )
  engineImportTXD(txd, 470)
  dff = engineLoadDFF("554.dff", 470 )
  engineReplaceModel(dff, 470)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
