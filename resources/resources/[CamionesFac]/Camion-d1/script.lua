-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'flatbed.txd' ) 
engineImportTXD( txd, 508 ) 
dff = engineLoadDFF('flatbed.dff', 508) 
engineReplaceModel( dff, 508 )
end)
