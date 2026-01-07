txd = engineLoadTXD("majestic.txd")
engineImportTXD(txd, 517)
dff = engineLoadDFF("majestic.dff", 517)
engineReplaceModel(dff, 517)
