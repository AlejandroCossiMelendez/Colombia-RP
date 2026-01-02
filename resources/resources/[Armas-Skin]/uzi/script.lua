-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByAzXx.txd' ) 
engineImportTXD( txd, 352 ) 
dff = engineLoadDFF('ByAzXx.dff', 352) 
engineReplaceModel( dff, 352 )
end)
