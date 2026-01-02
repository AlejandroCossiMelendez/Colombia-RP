-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'fortune.txd' ) 
engineImportTXD( txd, 587 ) 
dff = engineLoadDFF('fortune.dff', 587) 
engineReplaceModel( dff, 587 )
end)
