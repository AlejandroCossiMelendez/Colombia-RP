-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'tom j.txd' ) 
engineImportTXD( txd, 204 ) 
dff = engineLoadDFF('tom j.dff', 204 ) 
engineReplaceModel( dff, 204 )
end)
