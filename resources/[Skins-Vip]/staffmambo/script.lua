-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Spike.txd' ) 
engineImportTXD( txd, 109 ) 
dff = engineLoadDFF('Spike.dff', 109 ) 
engineReplaceModel( dff, 109 )
end)
