-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'skincacique.txd' ) 
engineImportTXD( txd, 156 ) 
dff = engineLoadDFF('skincacique.dff', 156) 
engineReplaceModel( dff, 156 )
end)
