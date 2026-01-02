-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Club.txd' ) 
engineImportTXD( txd, 589 ) 
dff = engineLoadDFF('Club.dff', 589) 
engineReplaceModel( dff, 589 )
end)
