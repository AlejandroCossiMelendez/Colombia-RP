-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'buccanee.txd' ) 
engineImportTXD( txd, 518 ) 
dff = engineLoadDFF('buccanee.dff', 518) 
engineReplaceModel( dff, 518 )
end)