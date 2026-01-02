-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'skindrop5.txd' ) 
engineImportTXD( txd, 72) 
dff = engineLoadDFF('skindrop5.dff', 72) 
engineReplaceModel( dff, 72)
end)
