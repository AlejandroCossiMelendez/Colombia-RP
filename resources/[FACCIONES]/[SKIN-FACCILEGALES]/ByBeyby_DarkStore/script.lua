-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 2 ) 
dff = engineLoadDFF('bybeyby.dff', 2) 
engineReplaceModel( dff, 2 )
end)
