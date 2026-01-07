-- Hecho por Supreme -- Autor Supreme --

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'Rumpo.txd' ) 
engineImportTXD( txd, 440 ) 
dff = engineLoadDFF('Rumpo.dff', 440) 
engineReplaceModel( dff, 440 )
end)
