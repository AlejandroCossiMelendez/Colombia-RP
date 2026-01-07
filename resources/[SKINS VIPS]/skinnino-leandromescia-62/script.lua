txd = engineLoadTXD( 'ByByelzin.txd' )
engineImportTXD( txd, 62 )
dff = engineLoadDFF('ByByelzin.dff', 62)
engineReplaceModel( dff, 62 )