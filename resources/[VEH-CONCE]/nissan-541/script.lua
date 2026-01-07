-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bullet.txd' ) 
engineImportTXD( txd, 541 ) 
dff = engineLoadDFF('bullet.dff', 541) 
engineReplaceModel( dff, 541 )
end)