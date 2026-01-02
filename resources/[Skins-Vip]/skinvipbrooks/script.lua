-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 19 ) 
dff = engineLoadDFF('bybeyby.dff', 19) 
engineReplaceModel( dff, 19 )
end)
