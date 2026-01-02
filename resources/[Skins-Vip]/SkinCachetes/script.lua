-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'skin1.txd' ) 
engineImportTXD( txd, 272 ) 
dff = engineLoadDFF('skin1.dff', 272) 
engineReplaceModel( dff, 272 )
end)
