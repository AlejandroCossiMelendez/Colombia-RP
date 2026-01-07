txd = engineLoadTXD("cupra.txd")
engineImportTXD(txd, 561)
dff = engineLoadDFF("cupra.dff", 561)
engineReplaceModel(dff, 561)
