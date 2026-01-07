-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByAkemi.txd' ) 
engineImportTXD( txd, 64 ) 
dff = engineLoadDFF('ByAkemi.dff', 64) 
engineReplaceModel( dff, 64 )
end)
