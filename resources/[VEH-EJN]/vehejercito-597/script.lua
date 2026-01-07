-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'fbi.txd' ) 
    engineImportTXD( txd, 597 ) 
    dff = engineLoadDFF('fbi.dff', 597) 
    engineReplaceModel( dff, 597 )
end)
