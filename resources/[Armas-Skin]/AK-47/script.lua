-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByBetinho.txd' ) 
engineImportTXD( txd, 355 ) 
dff = engineLoadDFF('ByBetinho.dff', 355) 
engineReplaceModel( dff, 355 )
end)
