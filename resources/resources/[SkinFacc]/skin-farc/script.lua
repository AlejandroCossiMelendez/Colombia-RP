-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'BopeNathaan.txd' ) 
engineImportTXD( txd, 73 ) 
dff = engineLoadDFF('BopeNathaan.dff', 73) 
engineReplaceModel( dff, 73 )
end)
