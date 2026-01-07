-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByAkemi.txd' ) 
engineImportTXD( txd, 63 ) 
dff = engineLoadDFF('ByAkemi.dff', 63) 
engineReplaceModel( dff, 63 )
end)
