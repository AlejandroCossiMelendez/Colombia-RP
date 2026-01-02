function reemplazarTextura1()
    textura = engineLoadTXD("archivos/ce_bankalley1.txd") 
    engineImportTXD(textura, 12947)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)