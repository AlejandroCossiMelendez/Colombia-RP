-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'og.txd' ) 
engineImportTXD( txd, 255 ) 
dff = engineLoadDFF('MMO.dff', 255) 
engineReplaceModel( dff, 255 )
end)
