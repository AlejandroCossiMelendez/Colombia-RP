-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'hpv1000.txd' ) 
    engineImportTXD( txd, 523 ) 
    dff = engineLoadDFF('hpv1000.dff', 523) 
    engineReplaceModel( dff, 523 )
end)
