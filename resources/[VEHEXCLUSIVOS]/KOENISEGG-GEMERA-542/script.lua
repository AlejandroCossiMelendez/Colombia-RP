txd = engineLoadTXD("elegy.txd")
engineImportTXD(txd, 542)
dff = engineLoadDFF("elegy.dff", 542)
engineReplaceModel(dff, 542)
