-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( '525.txd' ) 
engineImportTXD( txd, 525 ) 
dff = engineLoadDFF('525.dff', 525) 
engineReplaceModel( dff, 525 )
end)