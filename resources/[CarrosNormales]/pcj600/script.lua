-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bf-400.txd' ) 
engineImportTXD( txd, 461 ) 
dff = engineLoadDFF('bf-400.dff', 461) 
engineReplaceModel( dff, 461 )
end)
