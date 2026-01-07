-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Gang.txd' ) 
engineImportTXD( txd, 1 ) 
dff = engineLoadDFF('Gang.dff', 1) 
engineReplaceModel( dff, 1 )
end)
