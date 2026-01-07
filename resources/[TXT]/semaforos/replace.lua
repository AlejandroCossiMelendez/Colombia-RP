function Loja ()
Lojatxd = engineLoadTXD ( "1283.txd" )
engineImportTXD ( Lojatxd, 1283 )

end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), Loja )