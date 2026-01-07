-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByAzXx.txd' ) 
engineImportTXD( txd, 335 ) 
dff = engineLoadDFF('ByAzXx.dff', 335) 
engineReplaceModel( dff, 335 )
end)
