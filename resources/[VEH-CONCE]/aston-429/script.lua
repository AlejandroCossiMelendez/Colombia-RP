-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'banshee.txd' ) 
engineImportTXD( txd, 429 ) 
dff = engineLoadDFF('banshee.dff', 429) 
engineReplaceModel( dff, 429 )
end)