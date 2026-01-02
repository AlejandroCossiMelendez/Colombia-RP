-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Emperor.txd' ) 
engineImportTXD( txd, 565 ) 
dff = engineLoadDFF('Emperor.dff', 565) 
engineReplaceModel( dff, 565 )
end)
