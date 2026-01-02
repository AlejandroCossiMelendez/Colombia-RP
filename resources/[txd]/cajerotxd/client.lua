function reemplazarTextura1()
    textura = engineLoadTXD("archivos/kmb_atmx.txd") 
    engineImportTXD(textura, 2942)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)