-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'cirujana.txd' ) 
engineImportTXD( txd, 274 ) 
dff = engineLoadDFF('cirujana.dff', 274) 
engineReplaceModel( dff, 274 )
end)
