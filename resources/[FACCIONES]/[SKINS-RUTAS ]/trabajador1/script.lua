-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'amet.txd' ) 
engineImportTXD( txd, 18 ) 
dff = engineLoadDFF('amet.dff', 18) 
engineReplaceModel( dff, 18 )
end)
