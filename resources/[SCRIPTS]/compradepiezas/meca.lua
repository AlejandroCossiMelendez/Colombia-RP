

meca = createMarker (1041.328125, -997.494140625, 32.25 -1, "cylinder", 1.5, 7 , 7, 7, 100 )

function militaresropa ( source )
    outputChatBox ("#ff0000[La Capital Mecánicos]: #ffffffBienvenido, usa #00ff00/comprarpiezas [Unidades] #ffffffpara comprar tu material de trabajo.", source, 255, 255, 255, true )
end
addEventHandler ( "onMarkerHit", meca, militaresropa )
