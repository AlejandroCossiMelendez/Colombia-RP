
addEventHandler( "onClientRender", root, 
    function ( )
        local time = getRealTime( )
        setTime( time.hour, time.minute );
    end
)