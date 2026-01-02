txd = engineLoadTXD( 'M4.txd' )
engineImportTXD( txd, 337 )
dff = engineLoadDFF('M4.dff', 337)
engineReplaceModel( dff, 337 )