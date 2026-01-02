-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BopeNathaan.txd' ) 
engineImportTXD( txd, 248 ) 
dff = engineLoadDFF('BopeNathaan.dff', 248) 
engineReplaceModel( dff, 248 )
end)
