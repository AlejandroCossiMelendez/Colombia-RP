-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByWSx.txd' ) 
engineImportTXD( txd, 282 ) 
dff = engineLoadDFF('ByWSx.dff', 282) 
engineReplaceModel( dff, 282 )
end)
