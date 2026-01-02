function AndrixxClient ()
txd = engineLoadTXD("tempo22_law.txd") 
engineImportTXD(txd,6098)
end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )