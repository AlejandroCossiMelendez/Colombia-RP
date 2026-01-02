-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByBetinho.txd' ) 
engineImportTXD( txd, 372 ) 
dff = engineLoadDFF('ByBetinho.dff', 372) 
engineReplaceModel( dff, 372 )
end)
