-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'fLOWd.txd' ) 
engineImportTXD( txd, 166 ) 
dff = engineLoadDFF('FlowD.dff', 166) 
engineReplaceModel( dff, 166 )
end)
