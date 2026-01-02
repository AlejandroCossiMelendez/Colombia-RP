-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'carro5.txd' ) 
engineImportTXD( txd, 559 ) 
dff = engineLoadDFF('carro5.dff', 559) 
engineReplaceModel( dff, 559 )
end)
