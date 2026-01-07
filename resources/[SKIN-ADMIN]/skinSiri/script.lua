-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Spike.txd' ) 
engineImportTXD( txd, 61 ) 
dff = engineLoadDFF('Spike.dff', 61 ) 
engineReplaceModel( dff, 61 )
end)
