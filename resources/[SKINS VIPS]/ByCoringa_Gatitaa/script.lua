-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByCoringa.txd' ) 
engineImportTXD( txd, 13 ) 
dff = engineLoadDFF('ByCoringa.dff', 13) 
engineReplaceModel( dff, 13 )
end)
