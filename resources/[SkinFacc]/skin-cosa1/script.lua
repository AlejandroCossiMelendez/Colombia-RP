-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByKN.txd' ) 
engineImportTXD( txd, 161 ) 
dff = engineLoadDFF('ByKN.dff', 161) 
engineReplaceModel( dff, 161 )
end)
