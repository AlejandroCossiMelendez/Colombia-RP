addEventHandler( "onClientResourceStart", getRootElement( ),
    function ()
	txd_floors = engineLoadTXD ( "bag_default.txd" )
	engineImportTXD ( txd_floors, 1547 )
	dff_floors = engineLoadDFF ( "bag.dff" )
	engineReplaceModel ( dff_floors, 1547 )
	engineSetModelLODDistance(1547, 2000)

	txd_floors = engineLoadTXD ( "bag_adidasblack.txd" )
	engineImportTXD ( txd_floors, 1548 )
	dff_floors = engineLoadDFF ( "bag.dff" )
	engineReplaceModel ( dff_floors, 1548 )
	engineSetModelLODDistance(1548, 2000)

	txd_floors = engineLoadTXD ( "bag_gucci.txd" )
	engineImportTXD ( txd_floors, 3103 )
	dff_floors = engineLoadDFF ( "bag.dff" )
	engineReplaceModel ( dff_floors, 3103 )
	engineSetModelLODDistance(3103, 2000)

	txd_floors = engineLoadTXD ( "bag_nikecouropreto.txd" )
	engineImportTXD ( txd_floors, 3102 )
	dff_floors = engineLoadDFF ( "bag.dff" )
	engineReplaceModel ( dff_floors, 3102 )
	engineSetModelLODDistance(3102, 2000)
	

	txd_floors = engineLoadTXD ( "bag_rainbowadidas.txd" )
	engineImportTXD ( txd_floors, 3101 )
	dff_floors = engineLoadDFF ( "bag.dff" )
	engineReplaceModel ( dff_floors, 3101 )
	engineSetModelLODDistance(3101, 2000)
    end
);
