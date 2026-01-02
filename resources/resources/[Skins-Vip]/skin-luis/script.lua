-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 172 ) 
dff = engineLoadDFF('bybeyby.dff', 172) 
engineReplaceModel( dff, 172 )
end)
