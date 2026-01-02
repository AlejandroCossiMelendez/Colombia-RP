-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'flatbed.txd' ) 
engineImportTXD( txd, 510 ) 
dff = engineLoadDFF('flatbed.dff', 510) 
engineReplaceModel( dff, 510 )
end)
