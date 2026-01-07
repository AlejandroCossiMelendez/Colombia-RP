txd = engineLoadTXD( 'ByByelzin.txd' )
engineImportTXD( txd, 36 )
dff = engineLoadDFF('ByByelzin.dff', 36)
engineReplaceModel( dff, 36 )