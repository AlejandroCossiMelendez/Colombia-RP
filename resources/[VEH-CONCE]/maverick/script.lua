-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'sparrow.txd' ) 
    engineImportTXD( txd, 487 ) 
    dff = engineLoadDFF('sparrow.dff', 487) 
    engineReplaceModel( dff, 487 )
end)
