-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'robobanco.txd' ) 
engineImportTXD( txd, 20 ) 
dff = engineLoadDFF('robobanco.dff', 20) 
engineReplaceModel( dff, 20 )
end)
