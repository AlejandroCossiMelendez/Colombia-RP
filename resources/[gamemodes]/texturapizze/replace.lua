function replaceModel()

TXD= engineLoadTXD ( "ce_pizza.txd" )
engineImportTXD ( TXD, 5418 )

end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( "reloadmod", replaceModel )