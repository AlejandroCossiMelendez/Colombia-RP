-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BySobs.txd' ) 
engineImportTXD( txd, 51 ) 
dff = engineLoadDFF('BySobs.dff', 51) 
engineReplaceModel( dff, 51 )
end)
