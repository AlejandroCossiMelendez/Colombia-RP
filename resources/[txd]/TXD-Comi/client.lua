function reemplazarTextura()
    textura = engineLoadTXD("archivos/cunte_cop.txd") 
    engineImportTXD(textura, 12855)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura)