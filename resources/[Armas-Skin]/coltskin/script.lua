-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByKAZIDE.txd' ) 
engineImportTXD( txd, 346 ) 
dff = engineLoadDFF('ByKAZIDE.dff', 346) 
engineReplaceModel( dff, 346 )
end)
