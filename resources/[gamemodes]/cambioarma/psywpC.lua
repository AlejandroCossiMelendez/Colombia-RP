

function addAnimation(where)
    if where == "add" then
        setPedAnimation(localPlayer, "weaponswitch", "weaponswitch", 500, false, false, false, false,250,false)
        setTimer(function() 
            setPedAnimation(localPlayer, "ped", "Idle_Gang1", 1, false, false, false, false,250,false)
          end, 1030, 1, source) 
   -- elseif where == "rem" then
    --    setPedAnimation(localPlayer, "weaponswitch2", "weaponswitch2", 900000000, false, false, false, false, 10, false)
    end
end
addEvent("psy:wp", true)
addEventHandler("psy:wp", getRootElement(), addAnimation)

engineLoadIFP("imgs/weaponswitch.ifp", "weaponswitch")
engineLoadIFP("imgs/weaponswitch2.ifp", "weaponswitch2")