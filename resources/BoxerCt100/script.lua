-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'wayfarer.txd' ) 
engineImportTXD( txd, 581) 
dff = engineLoadDFF('wayfarer.dff', 581) 
engineReplaceModel( dff, 581 )
end)
