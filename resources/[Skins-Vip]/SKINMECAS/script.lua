-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByGuuh_MEC.txd' ) 
engineImportTXD( txd, 309 ) 
dff = engineLoadDFF('ByGuuh_MEC.dff', 309) 
engineReplaceModel( dff, 309 )
end)
