-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'car.txd' ) 
engineImportTXD( txd, 419 ) 
dff = engineLoadDFF('car.dff', 419) 
engineReplaceModel( dff, 419 )
end)
