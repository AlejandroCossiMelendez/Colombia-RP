-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'RoyStore36.txd' ) 
engineImportTXD( txd, 15 ) 
dff = engineLoadDFF('RoyStore36.dff', 15) 
engineReplaceModel( dff, 15 )
end)
