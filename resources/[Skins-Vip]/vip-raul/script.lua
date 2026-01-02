-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 291 ) 
dff = engineLoadDFF('bybeyby.dff', 291) 
engineReplaceModel( dff, 291 )
end)
