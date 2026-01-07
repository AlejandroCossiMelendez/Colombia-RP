-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'SAMURAI.txd' ) 
engineImportTXD( txd, 105 ) 
dff = engineLoadDFF('SAMURAI.dff', 105) 
engineReplaceModel( dff, 105 )
end)
