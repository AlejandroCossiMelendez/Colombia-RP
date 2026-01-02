function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980,  286.845703125, 1410.7490234375, 10.395060539246, 0, 0, 90 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1900,  286.845703125, 1410.7490234375, 5.395060539246, 0 )
 end
 addCommandHandler("c1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1900,  286.845703125, 1410.7490234375, 11.395060539246, 0, 0, 0 )
 end
 addCommandHandler("c2",openMyGate)