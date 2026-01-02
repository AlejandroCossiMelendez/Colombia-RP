-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BySobs.txd' ) 
engineImportTXD( txd, 235 ) 
dff = engineLoadDFF('BySobs.dff', 235) 
engineReplaceModel( dff, 235 )
end)
