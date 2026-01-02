function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980,  -392.6181640625, 1745.5615234375, 42.437473297119, 0, 0, 65 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1800,  -392.6181640625, 1745.5615234375, 50.437473297119, 0 )
 end
 addCommandHandler("jh1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 2000,  -392.6181640625, 1745.5615234375, 42.437473297119, 0, 0, 0 )
 end
 addCommandHandler("jh2",openMyGate)