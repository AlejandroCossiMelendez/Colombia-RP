-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'vice.txd' ) 
engineImportTXD( txd, 5 ) 
dff = engineLoadDFF('vice.dff', 5) 
engineReplaceModel( dff, 5 )
end)
