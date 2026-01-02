-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BY_SEPILLIN.txd' ) 
engineImportTXD( txd, 100 ) 
dff = engineLoadDFF('BY_SEPILLIN.dff', 100) 
engineReplaceModel( dff, 100 )
end)
