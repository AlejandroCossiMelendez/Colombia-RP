function reemplazarTextura1()
    textura = engineLoadTXD("archivos/sw_apartflat.txd") 
    engineImportTXD(textura, 12962)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)