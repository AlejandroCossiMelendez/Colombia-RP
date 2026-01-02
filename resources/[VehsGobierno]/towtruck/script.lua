-- Hecho por Supreme -- Autor Supreme --

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'towtruck.txd' ) 
engineImportTXD( txd, 525 ) 
dff = engineLoadDFF('towtruck.dff', 525) 
engineReplaceModel( dff, 525 )
end)
