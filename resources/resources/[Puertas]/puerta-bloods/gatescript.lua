function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, -385.880859375, -1413.94140625, 25.7265625, 0, 0, 187)

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 2000, -385.880859375, -1413.94140625, 26.7265625, 0 )
 end
 addCommandHandler("bl1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 2000, -385.880859375, -1413.94140625, 20.7265625, 0, 0, 0 )
 end
 addCommandHandler("bl2",openMyGate)
