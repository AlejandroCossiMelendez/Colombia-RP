txd = engineLoadTXD("ballas2.txd")
engineImportTXD(txd, 103)
dff = engineLoadDFF("ballas2.dff", 103)
engineReplaceModel(dff, 103)