-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'washing.txd' ) 
engineImportTXD( txd, 560 ) 
dff = engineLoadDFF('washing.dff', 560) 
engineReplaceModel( dff, 560 )
end)
