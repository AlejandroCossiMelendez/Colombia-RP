function replaceModel()

TXD= engineLoadTXD ( "burgsh01_law.txd" )
engineImportTXD ( TXD, 6257 )

end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( "reloadmod", replaceModel )