-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByBetinho2.txd' ) 
engineImportTXD( txd, 11 ) 
dff = engineLoadDFF('ByBetinho2.dff', 11) 
engineReplaceModel( dff, 11 )
end)
