-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByJostin_Gang.txd' ) 
engineImportTXD( txd, 209 ) 
dff = engineLoadDFF('ByJostin_Gang.dff', 209) 
engineReplaceModel( dff, 209 )
end)
