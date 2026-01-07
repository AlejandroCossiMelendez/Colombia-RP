txd = engineLoadTXD("cruiser.txd")
engineImportTXD(txd, 579)
dff = engineLoadDFF("cruiser.dff", 579)
engineReplaceModel(dff, 579)
