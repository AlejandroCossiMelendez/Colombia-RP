-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByTaay_CiPE.txd' ) 
engineImportTXD( txd, 287 ) 
dff = engineLoadDFF('ByTaay_CiPE.dff', 287) 
engineReplaceModel( dff, 287 )
end)
