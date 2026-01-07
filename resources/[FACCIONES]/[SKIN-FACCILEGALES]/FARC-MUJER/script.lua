-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByMalvaDonna.txd' ) 
engineImportTXD( txd, 10 ) 
dff = engineLoadDFF('ByMalvaDonna.dff', 10) 
engineReplaceModel( dff, 10 )
end)
