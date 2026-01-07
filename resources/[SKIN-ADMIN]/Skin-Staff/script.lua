-- Hecha Por TETEO -- Para GuaroCity RP -- By TETEO -- Autor TETEO -- Rompiendo!

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'ByTeteo.txd' ) 
engineImportTXD( txd, 45 ) 
dff = engineLoadDFF('ByTeteo.dff', 45) 
engineReplaceModel( dff, 45 )
end)
