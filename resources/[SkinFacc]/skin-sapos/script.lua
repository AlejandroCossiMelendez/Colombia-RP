-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'ByCruz.txd' ) 
    engineImportTXD( txd, 273 ) 
    dff = engineLoadDFF('ByCruz.dff', 273) 
    engineReplaceModel( dff, 273 )
end)
