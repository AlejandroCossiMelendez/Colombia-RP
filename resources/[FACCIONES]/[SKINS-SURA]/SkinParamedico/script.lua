-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'paramedico.txd' ) 
engineImportTXD( txd, 276 ) 
dff = engineLoadDFF('paramedico.dff', 276) 
engineReplaceModel( dff, 276 )
end)
