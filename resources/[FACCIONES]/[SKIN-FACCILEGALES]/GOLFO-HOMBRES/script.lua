-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 101 ) 
dff = engineLoadDFF('bybeyby.dff', 101) 
engineReplaceModel( dff, 101 )
end)
