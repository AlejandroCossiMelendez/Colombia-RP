function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, 330.8740234375, -823.412109375, 12.30312538147, 0, 0, 70 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1800, 330.8740234375, -823.412109375, 8.30312538147, 0 )
 end
 addCommandHandler("pvip1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1800, 330.8740234375, -823.412109375, 12.30312538147, 0, 0, 0 )
 end
 addCommandHandler("pvip2",openMyGate)
