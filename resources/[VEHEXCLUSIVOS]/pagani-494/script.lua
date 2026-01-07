txd = engineLoadTXD("hotring.txd")
engineImportTXD(txd, 494)
dff = engineLoadDFF("hotring.dff", 494)
engineReplaceModel(dff, 494)
