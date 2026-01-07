txd = engineLoadTXD("flash.txd")
engineImportTXD(txd, 565)
dff = engineLoadDFF("flash.dff", 565)
engineReplaceModel(dff, 565)
