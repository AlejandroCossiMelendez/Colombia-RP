function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, 371.0089890625, -1797.4189453125, 8.0584774017334, 0, 0, 0.35980224609375 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1800, 370.2587890625, -1797.4189453125, 4.0584774017334, 0 )
 end
 addCommandHandler("mn1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1800, 370.2587890625, -1797.4189453125, 9.0584774017334, 0, 0, 0 )
 end
 addCommandHandler("mn2",openMyGate)