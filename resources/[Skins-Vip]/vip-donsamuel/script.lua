-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( '60.txd' ) 
engineImportTXD( txd, 60 ) 
dff = engineLoadDFF('60.dff', 60) 
engineReplaceModel( dff, 60 )
end)
