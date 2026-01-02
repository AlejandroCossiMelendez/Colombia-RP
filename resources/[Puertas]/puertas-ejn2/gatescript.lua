function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, 135.2841796875, 1940.15234375, 20.303995132446, 0, 0, 0 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1400, 135.2841796875, 1940.15234375, 20.303995132446 )
 end
 addCommandHandler("ejn2",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1400, 135.2841796875, 1940.15234375, 14.303995132446 )
 end
 addCommandHandler("ejn1",openMyGate)

 
