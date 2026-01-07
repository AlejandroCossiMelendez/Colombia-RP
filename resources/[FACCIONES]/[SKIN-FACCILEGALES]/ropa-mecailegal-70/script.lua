-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'mc1.txd' ) 
engineImportTXD( txd, 70 ) 
dff = engineLoadDFF('mc1.dff', 70) 
engineReplaceModel( dff, 70 )
end)
