-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'MECANICO.txd' ) 
engineImportTXD( txd, 309 ) 
dff = engineLoadDFF('MC.dff', 309) 
engineReplaceModel( dff, 309 )
end)
