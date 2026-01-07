txd = engineLoadTXD( 'ByMELZ.txd' )
engineImportTXD( txd, 40 )
dff = engineLoadDFF('ByMELZ.dff', 40)
engineReplaceModel( dff, 40 )