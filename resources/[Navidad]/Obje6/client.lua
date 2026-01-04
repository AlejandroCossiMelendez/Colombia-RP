col = engineLoadCOL ( "object.col" )
engineReplaceCOL ( col, 1866 )
txd = engineLoadTXD ( "object.txd" )
engineImportTXD ( txd, 1866 )
dff = engineLoadDFF ( "object.dff" )
engineReplaceModel ( dff, 1866)
engineSetModelLODDistance ( 1866, 9999)

--- 2

cola = engineLoadCOL ( "object1.col" )
engineReplaceCOL ( cola, 1867 )
txda = engineLoadTXD ( "object.txd" )
engineImportTXD ( txd1, 1867 )
dffa = engineLoadDFF ( "object1.dff" )
engineReplaceModel ( dffa, 1867)
engineSetModelLODDistance ( 1867, 9999)

-----

colb = engineLoadCOL ( "object2.col" )
engineReplaceCOL ( colb, 1868 )
txdb = engineLoadTXD ( "object.txd" )
engineImportTXD ( txdb, 1868 )
dffb = engineLoadDFF ( "object2.dff" )
engineReplaceModel ( dffb, 1868)
engineSetModelLODDistance ( 1868, 9999)

