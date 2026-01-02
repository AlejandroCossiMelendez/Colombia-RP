txd = engineLoadTXD( 'M4.txd' )
engineImportTXD( txd, 322 )
dff = engineLoadDFF('M4.dff', 322)
engineReplaceModel( dff, 322 )