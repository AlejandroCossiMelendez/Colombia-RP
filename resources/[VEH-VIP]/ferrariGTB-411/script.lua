
addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'infernus.txd' ) 
engineImportTXD( txd, 411 ) 
dff = engineLoadDFF('infernus.dff', 411) 
engineReplaceModel( dff, 411 )
end)