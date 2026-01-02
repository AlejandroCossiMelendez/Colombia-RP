addEventHandler('onClientResourceStart',resourceRoot,function () 
    zamplet = engineLoadTXD( 'byzample.txd' ) 
    engineImportTXD( zamplet, 122 ) 
    zampled = engineLoadDFF('byzample.dff', 122) 
    engineReplaceModel( zampled, 122 )

    end)
    