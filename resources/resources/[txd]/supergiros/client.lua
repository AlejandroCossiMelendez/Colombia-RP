function reemplazarTextura1()
    textura = engineLoadTXD("archivos/sw_apartflat5.txd") 
    engineImportTXD(textura, 13012)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)