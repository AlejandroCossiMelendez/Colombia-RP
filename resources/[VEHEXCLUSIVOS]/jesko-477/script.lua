txd = engineLoadTXD("zr350.txd")
engineImportTXD(txd, 477)
dff = engineLoadDFF("zr350.dff", 477)
engineReplaceModel(dff, 477)
