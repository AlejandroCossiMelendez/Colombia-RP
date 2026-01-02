-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Prisionero2.txd' ) 
engineImportTXD( txd, 96 ) 
dff = engineLoadDFF('Prisionero2.dff', 96) 
engineReplaceModel( dff, 96 )
end)
