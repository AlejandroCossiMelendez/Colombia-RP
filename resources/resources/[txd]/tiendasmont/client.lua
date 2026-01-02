function reemplazarTextura1()
    textura = engineLoadTXD("archivos/sw_block12.txd") 
    engineImportTXD(textura, 13013)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)