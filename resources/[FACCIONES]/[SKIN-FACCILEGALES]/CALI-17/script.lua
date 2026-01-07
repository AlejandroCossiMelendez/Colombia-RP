-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'MafiaByCostela.txd' ) 
engineImportTXD( txd, 17 ) 
dff = engineLoadDFF('MafiaByCostela.dff', 17) 
engineReplaceModel( dff, 17 )
end)
