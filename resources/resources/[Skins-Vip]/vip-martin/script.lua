-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByCaiqueS.txd' ) 
engineImportTXD( txd, 195 ) 
dff = engineLoadDFF('ByCaiqueS.dff', 195) 
engineReplaceModel( dff, 195 )
end)
