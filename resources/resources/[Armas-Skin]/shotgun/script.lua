-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByBetinho.txd' ) 
engineImportTXD( txd, 349 ) 
dff = engineLoadDFF('ByBetinho.dff', 349) 
engineReplaceModel( dff, 349 )
end)
