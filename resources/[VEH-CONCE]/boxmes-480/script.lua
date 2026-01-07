-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'comet.txd' ) 
engineImportTXD( txd, 480 ) 
dff = engineLoadDFF('comet.dff', 480) 
engineReplaceModel( dff, 480 )
end)
