-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByNathaan.txd' ) 
engineImportTXD( txd, 183 ) 
dff = engineLoadDFF('ByNathaan.dff', 183) 
engineReplaceModel( dff, 183 )
end)
