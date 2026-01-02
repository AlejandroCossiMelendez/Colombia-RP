-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'skinpersonality.txd' ) 
engineImportTXD( txd, 3 ) 
dff = engineLoadDFF('skinpersonality.dff', 3) 
engineReplaceModel( dff, 3 )
end)
