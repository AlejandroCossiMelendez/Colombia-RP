addEventHandler('onClientResourceStart',resourceRoot,function () 
    zamplet = engineLoadTXD( 'byzample.txd' ) 
    engineImportTXD( zamplet, 77 ) 
    zampled = engineLoadDFF('byzample.dff', 77) 
    engineReplaceModel( zampled, 77 )

    end)
    