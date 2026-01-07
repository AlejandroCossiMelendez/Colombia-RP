-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( '1.txd' ) 
engineImportTXD( txd, 286 ) 
dff = engineLoadDFF('1.dff', 286) 
engineReplaceModel( dff, 286 )
end)
