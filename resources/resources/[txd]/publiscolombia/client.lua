function reemplazarTextura1()
    textura = engineLoadTXD("archivos/w_towncs_t.txd") 
    engineImportTXD(textura, 18203)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), reemplazarTextura1)