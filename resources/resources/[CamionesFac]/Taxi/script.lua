-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'flatbed.txd' ) 
engineImportTXD( txd, 420 ) 
dff = engineLoadDFF('flatbed.dff', 420) 
engineReplaceModel( dff, 420 )
end)
