-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByViniZx.txd' ) 
engineImportTXD( txd, 55 ) 
dff = engineLoadDFF('ByViniZx.dff', 55) 
engineReplaceModel( dff, 55 )
end)
