function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980,  -870.40625, -1124.4423828125, 97.94701385498, 0, 0, 85 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1800,  -870.40625, -1124.4423828125, 98.94701385498, 0 )
 end
 addCommandHandler("h1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 2000, -870.40625, -1125.4423828125, 90.94701385498, 0, 0, 0 )
 end
 addCommandHandler("h2",openMyGate)