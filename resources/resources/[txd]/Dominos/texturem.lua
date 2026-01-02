function AndrixxClient ()
txd = engineLoadTXD("CE_pizza.txd") 
engineImportTXD(txd, 13361 )
end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )