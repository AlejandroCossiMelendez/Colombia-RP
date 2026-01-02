function createTheGate () -- AgogoLoMasNeaa
 
         myGate1 = createObject ( 980, 183.4482421875, 2045.16796875, 19.542255401611, 0, 0, 0 )

      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )

 function openMyGate ( )
 moveObject ( myGate1, 1400, 183.4482421875, 2045.16796875, 19.542255401611 )
 end
 addCommandHandler("ejnc1",openMyGate)
 
 function openMyGate ( )
 moveObject ( myGate1, 1400, 183.4482421875, 2045.16796875, 13.542255401611 )
 end
 addCommandHandler("ejnc2",openMyGate)