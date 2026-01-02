function reemplazarVehiculos()
    txd = engineLoadTXD("archivos/203.txd")
    dff = engineLoadDFF("archivos/203.dff")
    engineImportTXD(txd, 311)
    engineReplaceModel(dff, 311)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarVehiculos)