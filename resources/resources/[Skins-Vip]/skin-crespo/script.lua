-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Iver_txd.txd' ) 
engineImportTXD( txd, 136 ) 
dff = engineLoadDFF('Iver_dff.dff', 136) 
engineReplaceModel( dff, 136 )
end)
