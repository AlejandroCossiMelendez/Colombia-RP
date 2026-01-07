-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'patriot.txd' ) 
    engineImportTXD( txd, 470 ) 
    dff = engineLoadDFF('patriot.dff', 470) 
    engineReplaceModel( dff, 470 )
end)
