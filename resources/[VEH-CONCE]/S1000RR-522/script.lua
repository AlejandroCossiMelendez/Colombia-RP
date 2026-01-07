-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bf400.txd' ) 
engineImportTXD( txd, 522 ) 
dff = engineLoadDFF('bf400.dff', 522) 
engineReplaceModel( dff, 522 )
end)
