-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'car.txd' ) 
engineImportTXD( txd, 560 ) 
dff = engineLoadDFF('car.dff', 560) 
engineReplaceModel( dff, 560 )
end)