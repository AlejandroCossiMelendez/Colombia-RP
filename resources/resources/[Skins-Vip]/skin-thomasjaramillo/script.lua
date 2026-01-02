-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 270 ) 
dff = engineLoadDFF('bybeyby.dff', 270) 
engineReplaceModel( dff, 270 )
end)
