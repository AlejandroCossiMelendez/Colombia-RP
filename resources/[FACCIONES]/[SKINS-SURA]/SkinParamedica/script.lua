-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'paramedica.txd' ) 
engineImportTXD( txd, 278) 
dff = engineLoadDFF('paramedica.dff', 278 )
engineReplaceModel( dff, 278 )
end)
