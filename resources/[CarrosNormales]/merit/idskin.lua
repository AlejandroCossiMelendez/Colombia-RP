function replaceModel()
  txd = engineLoadTXD("merit.txd", 551)
  engineImportTXD(txd, 551)
  dff = engineLoadDFF("merit.dff", 551)
  engineReplaceModel(dff, 551)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
