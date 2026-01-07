txd = engineLoadTXD("hotrina.txd")
engineImportTXD(txd, 502)
dff = engineLoadDFF("hotrina.dff", 502)
engineReplaceModel(dff, 502)
