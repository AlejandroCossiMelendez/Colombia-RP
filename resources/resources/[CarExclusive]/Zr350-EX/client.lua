-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Zr350.txd', 477) 
engineImportTXD( txd, 477 ) 
dff = engineLoadDFF('Zr350.dff', 477) 
engineReplaceModel( dff, 477 )
end)
