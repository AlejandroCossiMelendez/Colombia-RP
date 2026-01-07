function Loja ()
Lojatxd = engineLoadTXD ( "idlewood3_lae.txd" )
engineImportTXD ( Lojatxd, 5418  )

end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), Loja )