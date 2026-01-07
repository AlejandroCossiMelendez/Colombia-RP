-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'cabbie.txd' ) 
engineImportTXD( txd, 438 ) 
dff = engineLoadDFF('cabbie.dff', 438) 
engineReplaceModel( dff, 438 )
end)