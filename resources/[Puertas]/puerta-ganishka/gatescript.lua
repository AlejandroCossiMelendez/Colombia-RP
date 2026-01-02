function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, 1861.8466796875, -1378.9221328125, 13.5625, 0, 0, 90)

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 2000, 1861.8466796875, -1378.9211328125, 20.5625, 0 )
 end
 addCommandHandler("gh1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 2000, 1861.8466796875, -1378.9211328125, 14.5625, 0, 0, 0 )
 end
 addCommandHandler("gh2",openMyGate)
