-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'elegant.txd' ) 
engineImportTXD( txd, 507 ) 
dff = engineLoadDFF('elegant.dff', 507) 
engineReplaceModel( dff, 507 )
end)
