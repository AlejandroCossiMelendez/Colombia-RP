-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 75 ) 
dff = engineLoadDFF('bybeyby.dff', 75) 
engineReplaceModel( dff, 75 )
end)
