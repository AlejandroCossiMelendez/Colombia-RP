-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Bybalvin.txd' ) 
engineImportTXD( txd, 71 ) 
dff = engineLoadDFF('Bybalvin.dff', 71) 
engineReplaceModel( dff, 71 )
end)
