-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByBetinho.txd' ) 
engineImportTXD( txd, 356 ) 
dff = engineLoadDFF('ByBetinho.dff', 356) 
engineReplaceModel( dff, 356 )
end)
