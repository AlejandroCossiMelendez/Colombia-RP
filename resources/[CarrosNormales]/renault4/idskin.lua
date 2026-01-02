function replaceModel()
  txd = engineLoadTXD("blista.txd", 496 )
  engineImportTXD(txd, 496)
  dff = engineLoadDFF("blista.dff", 496 )
  engineReplaceModel(dff, 496)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

--Orientacion:
--En nombredetuskin.txd, debes poner antes de txd borrar el nombredetuskin y poner el nombre de tu txd y en nombredetuskin.dff lo mismo.
--ID: Id del skin que vas a remplazar
--No Borrar .txd ni .dff
