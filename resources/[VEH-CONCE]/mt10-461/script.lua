-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'mt10.txd' ) 
engineImportTXD( txd, 461 ) 
dff = engineLoadDFF('mt10.dff', 461) 
engineReplaceModel( dff, 461 )
end)
