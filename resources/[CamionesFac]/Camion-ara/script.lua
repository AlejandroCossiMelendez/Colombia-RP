-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'utilityvan.txd' ) 
engineImportTXD( txd, 552 ) 
dff = engineLoadDFF('utilityvan.dff', 552) 
engineReplaceModel( dff, 552 )
end)