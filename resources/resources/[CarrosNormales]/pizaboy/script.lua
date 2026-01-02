-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'pizzaboy.txd' ) 
engineImportTXD( txd, 448 ) 
dff = engineLoadDFF('pizzaboy.dff', 448) 
engineReplaceModel( dff, 448 )
end)