-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'primo.txd' ) 
engineImportTXD( txd, 547 ) 
dff = engineLoadDFF('primo.dff', 547) 
engineReplaceModel( dff, 547 )
end)