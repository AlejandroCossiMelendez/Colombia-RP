function AndrixxClient ()
txd = engineLoadTXD("sunset02_law2.txd") 
engineImportTXD(txd, 6364 )
end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )