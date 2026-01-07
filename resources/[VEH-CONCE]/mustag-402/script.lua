-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'buffalo.txd' ) 
engineImportTXD( txd, 402 ) 
dff = engineLoadDFF('buffalo.dff', 402) 
engineReplaceModel( dff, 402 )
end)