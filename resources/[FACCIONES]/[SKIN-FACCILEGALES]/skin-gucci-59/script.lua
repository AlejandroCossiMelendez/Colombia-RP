txd = engineLoadTXD( 'ByAzXx.txd' )
engineImportTXD( txd, 59 )
dff = engineLoadDFF('ByAzXx.dff', 59)
engineReplaceModel( dff, 59 )