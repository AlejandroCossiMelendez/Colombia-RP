function replaceModel()
  txd = engineLoadTXD("emilio2.txd", 302 )
  engineImportTXD(txd, 302)
  dff = engineLoadDFF("emilio2.dff", 302 )
  engineReplaceModel(dff, 302)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
