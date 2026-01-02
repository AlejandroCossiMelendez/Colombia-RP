txd = engineLoadTXD( 'ByByelzin.txd' )
engineImportTXD( txd, 51 )
dff = engineLoadDFF('ByByelzin.dff', 51)
engineReplaceModel( dff, 51 )