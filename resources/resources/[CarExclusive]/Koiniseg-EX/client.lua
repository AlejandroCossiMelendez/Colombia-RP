-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'car.txd', 494) 
engineImportTXD( txd, 494 ) 
dff = engineLoadDFF('car.dff', 494) 
engineReplaceModel( dff, 494 )
end)
