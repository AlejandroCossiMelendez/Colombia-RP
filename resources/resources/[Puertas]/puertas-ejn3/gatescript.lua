function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, 157.96484375, 1958.93359375, 19.959861755371, 0, 0, 95 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1400, 157.96484375, 1958.93359375, 13.959861755371 )
 end
 addCommandHandler("ej4",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1400, 157.96484375, 1958.93359375, 19.959861755371 )
 end
 addCommandHandler("ej3",openMyGate)

 
