function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, -487.75390625, -1002.34375, 24.845205307007, 0, 0, 150 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1900, -487.75390625, -1002.34375, 25.845205307007, 0 )
 end
 addCommandHandler("l2",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1900, -487.75390625, -1002.34375, 20.845205307007, 0, 0, 0 )
 end
 addCommandHandler("l4",openMyGate)