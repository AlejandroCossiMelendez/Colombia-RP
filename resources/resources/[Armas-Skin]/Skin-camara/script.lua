-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'camera.txd' ) 
engineImportTXD( txd, 367 ) 
dff = engineLoadDFF('camera.dff', 367) 
engineReplaceModel( dff, 367 )
end)
