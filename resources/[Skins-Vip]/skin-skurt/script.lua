-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Finuraelegante_txd.txd' ) 
engineImportTXD( txd,303 ) 
dff = engineLoadDFF('Eleganciadefrancia_dff.dff', 303) 
engineReplaceModel( dff, 303 )
end)
