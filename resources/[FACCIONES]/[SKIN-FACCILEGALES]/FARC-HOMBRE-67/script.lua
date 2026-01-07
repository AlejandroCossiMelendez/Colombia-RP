-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BySobs.txd' ) 
engineImportTXD( txd, 67 ) 
dff = engineLoadDFF('BySobs.dff', 67) 
engineReplaceModel( dff, 67 )
end)
