-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bybeyby.txd' ) 
engineImportTXD( txd, 214 ) 
dff = engineLoadDFF('bybeyby.dff', 214) 
engineReplaceModel( dff, 214 )
end)
