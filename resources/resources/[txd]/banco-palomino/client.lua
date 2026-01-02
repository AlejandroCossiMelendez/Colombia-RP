function reemplazarTextura1()
    textura = engineLoadTXD("archivos/ce_bankalley3.txd") 
    engineImportTXD(textura, 12822)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)