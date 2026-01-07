-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bartolo.txd' ) 
engineImportTXD( txd, 275 ) 
dff = engineLoadDFF('bartolo.dff', 275) 
engineReplaceModel( dff, 275 )
end)
