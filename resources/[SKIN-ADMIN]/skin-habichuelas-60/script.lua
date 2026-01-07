-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'bydzz.txd' ) 
engineImportTXD( txd, 60 ) 
dff = engineLoadDFF('bydzz.dff', 60) 
engineReplaceModel( dff, 60 )
end)
