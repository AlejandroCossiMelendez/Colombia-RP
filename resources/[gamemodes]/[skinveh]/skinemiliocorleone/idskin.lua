function replaceModel()
  txd = engineLoadTXD("emilio.txd", 310 )
  engineImportTXD(txd, 310)
  dff = engineLoadDFF("emilio.dff", 310 )
  engineReplaceModel(dff, 310)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
