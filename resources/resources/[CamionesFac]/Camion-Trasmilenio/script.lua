-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'coach.txd' ) 
engineImportTXD( txd, 437 ) 
dff = engineLoadDFF('coach.dff', 437 ) 
engineReplaceModel( dff, 437 )
end)
