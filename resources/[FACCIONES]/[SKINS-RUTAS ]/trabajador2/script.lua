-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD('wmybp.txd' ) 
engineImportTXD( txd, 199 ) 
dff = engineLoadDFF('wmybp.dff', 199) 
engineReplaceModel( dff, 199 )
end)
