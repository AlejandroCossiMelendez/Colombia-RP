-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'wayfarer.txd' ) 
engineImportTXD( txd, 586) 
dff = engineLoadDFF('wayfarer.dff', 586) 
engineReplaceModel( dff, 586 )
end)
