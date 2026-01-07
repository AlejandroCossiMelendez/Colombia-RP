-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'premier.txd' ) 
engineImportTXD( txd, 426 ) 
dff = engineLoadDFF('premier.dff', 426) 
engineReplaceModel( dff, 426 )
end)