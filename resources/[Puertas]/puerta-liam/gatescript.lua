function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980,  1245.8642578125, -767.4912109375, 92.032272338867, 0, 0, 1 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1800,  1245.8642578125, -767.4912109375, 94.032272338867, 0 )
 end
 addCommandHandler("li1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 2000,  1245.8642578125, -767.4912109375, 85.032272338867, 0, 0, 0 )
 end
 addCommandHandler("li2",openMyGate)