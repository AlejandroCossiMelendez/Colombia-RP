-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'ByCruz.txd' ) 
    engineImportTXD( txd, 148 ) 
    dff = engineLoadDFF('ByCruz.dff', 148) 
    engineReplaceModel( dff, 148 )
end)
