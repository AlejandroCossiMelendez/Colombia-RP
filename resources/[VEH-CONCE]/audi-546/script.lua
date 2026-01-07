txd = engineLoadTXD("intruder.txd")
engineImportTXD(txd, 546)
dff = engineLoadDFF("intruder.dff", 546)
engineReplaceModel(dff, 546)
