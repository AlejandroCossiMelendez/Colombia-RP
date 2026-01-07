-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'tesla.txd' ) 
engineImportTXD( txd, 604 ) 
dff = engineLoadDFF('tesla.dff', 604) 
engineReplaceModel( dff, 604 )
end)