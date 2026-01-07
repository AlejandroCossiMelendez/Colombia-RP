addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Skin ID 72
    local txd72 = engineLoadTXD("mafboss.txd")
    local dff72 = engineLoadDFF("mafboss.dff", 72)
    engineImportTXD(txd72, 72)
    engineReplaceModel(dff72, 72)
    
    -- Skin ID 73
    local txd73 = engineLoadTXD("shmycr.txd")
    local dff73 = engineLoadDFF("shmycr.dff", 73)
    engineImportTXD(txd73, 73)
    engineReplaceModel(dff73, 73)
    
    -- Skin ID 49
    local txd49 = engineLoadTXD("vmaff1.txd")
    local dff49 = engineLoadDFF("vmaff1.dff", 49)
    engineImportTXD(txd49, 49)
    engineReplaceModel(dff49, 49)
end)
