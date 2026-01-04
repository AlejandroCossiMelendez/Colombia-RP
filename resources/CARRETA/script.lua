-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'quad.txd' ) 
engineImportTXD( txd, 471 ) 
dff = engineLoadDFF('quad.dff', 471) 
engineReplaceModel( dff, 471 )
end)
