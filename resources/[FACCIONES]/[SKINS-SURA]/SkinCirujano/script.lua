-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'cirujano.txd' ) 
engineImportTXD( txd, 277 ) 
dff = engineLoadDFF('cirujano.dff', 277) 
engineReplaceModel( dff, 277 )
end)
