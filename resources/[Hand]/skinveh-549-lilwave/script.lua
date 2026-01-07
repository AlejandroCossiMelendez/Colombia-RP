local id =549
addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByGordoX.txd' ) 
engineImportTXD( txd, 549) 
dff = engineLoadDFF('ByGordoX.dff', 549) 
engineReplaceModel( dff, 549)
end)
