function AndrixxClient ()
txd = engineLoadTXD("cityhall_tr_lan.txd") 
engineImportTXD(txd, 4003 )
end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )