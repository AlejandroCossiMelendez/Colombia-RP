-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'army.txd' ) 
engineImportTXD( txd, 290 ) 
dff = engineLoadDFF('army.dff', 290) 
engineReplaceModel( dff, 290 )
end)
