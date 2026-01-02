function reemplazarTextura1()
    textura = engineLoadTXD("archivos/cunte_lik.txd") 
    engineImportTXD(textura, 12843)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)