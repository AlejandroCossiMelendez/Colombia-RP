function replaceModel()
  txd = engineLoadTXD("elegy.txd", 562 )
  engineImportTXD(txd, 562)
  dff = engineLoadDFF("elegy.dff", 562 )
  engineReplaceModel(dff, 562)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
