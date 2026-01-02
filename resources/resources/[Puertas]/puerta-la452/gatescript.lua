function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, -576.5693359375, -1145.841796875, 22.342140197754, 0, 0, 150 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1900, -576.5693359375, -1145.841796875, 23.342140197754, 0 )
 end
 addCommandHandler("l3",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1900, -576.5693359375, -1145.841796875, 16.342140197754, 0, 0, 0 )
 end
 addCommandHandler("l5",openMyGate)