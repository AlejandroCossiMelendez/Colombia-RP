-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByKAZIDE.txd' ) 
engineImportTXD( txd, 38 ) 
dff = engineLoadDFF('ByKAZIDE.dff', 38) 
engineReplaceModel( dff, 38 )
end)
