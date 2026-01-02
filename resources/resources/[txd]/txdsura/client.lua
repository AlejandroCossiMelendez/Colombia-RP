function reemplazarTextura1()
    textura = engineLoadTXD("archivos/vgwstbboard.txd") 
    engineImportTXD(textura, 7907)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)