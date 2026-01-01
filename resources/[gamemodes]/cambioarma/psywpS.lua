

function psyweaponswitch( player )
    local weaponType = getPedWeapon ( getRandomPlayer() )
    if ( weaponType ) then
    triggerClientEvent(source, "psy:wp", source, "add")
   -- timer = setTimer(function() 
  --      setPedAnimation(player)
  --  end, 1200, 1, player) 
    end
end
addEventHandler("onPlayerWeaponSwitch", root, psyweaponswitch)
