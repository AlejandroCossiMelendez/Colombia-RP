-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'vanrobo.txd' ) 
engineImportTXD( txd, 482 ) 
dff = engineLoadDFF('vanrobo.dff', 482) 
engineReplaceModel( dff, 482 )
end)