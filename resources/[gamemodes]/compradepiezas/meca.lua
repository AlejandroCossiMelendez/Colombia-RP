function consoleCreateMarker ( thePlayer , CommandName )
      marker1 = createMarker ( 245.39199829102, -120.75077819824, 1.5679507255554, "cylinder", 1.5, 255 , 255, 0, 170 )
	  outputChatBox ( "Marker Creado Por Aaron_Mussio" )
end
addEventHandler ( "onResourceStart" , resourceRoot, consoleCreateMarker )

function militaresropa (source)
    addCommandHandler ("comprarpiezas 30", source )
end
addEventHandler ( "onMarkerHit", resourceRoot, meca )