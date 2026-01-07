txd = engineLoadTXD("elegy.txd")
engineImportTXD(txd, 475)
dff = engineLoadDFF("elegy.dff", 475)
engineReplaceModel(dff, 475)
