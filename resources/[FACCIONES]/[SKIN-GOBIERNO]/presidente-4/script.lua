-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'presidente.txd' ) 
engineImportTXD( txd, 4 ) 
dff = engineLoadDFF('presidente.dff', 4) 
engineReplaceModel( dff, 4 )
end)
