local screenX, screenY
local drawTimer
local isDrawing
local sound

function OnPlayerFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement, startX, startY, startZ)

   if(hitElement) then
      if(getElementType(hitElement)=="player") then
         screenX, screenY = getScreenFromWorldPosition(hitX, hitY, hitZ)
         if not screenX then return end 
         if isDrawing then removeEventHandler("onClientRender", root, drawHitMarker) isDrawing = false end 
         isDrawing = true
         addEventHandler("onClientRender", root, drawHitMarker) 
         if drawTimer and isTimer(drawTimer) then
            killTimer(drawTimer)
         end
         drawTimer = setTimer(function() 
         isDrawing = false
         removeEventHandler("onClientRender", root, drawHitMarker) 
         end, 200, 1)
      end
   end



   local x, y, z = getElementPosition(localPlayer) 
   if(weapon == 29) then 
      local w, h = guiGetScreenSize () -- thompson
      local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 50 )
      setCameraTarget(xg, yg, zg+0.5)

    end 
    if(weapon == 30) then 
      local w, h = guiGetScreenSize () -- ak
      local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 70 )
      setCameraTarget(xg, yg, zg+0.5)
   end
   if(weapon == 31) then 
      local w, h = guiGetScreenSize () -- lr
      local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 50 )
      setCameraTarget(xg, yg, zg+0.4)
   end   
   if(weapon == 24) then

      local w, h = guiGetScreenSize () -- python
      local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 50 )
      setCameraTarget(xg, yg, zg+4)
   end
   if(weapon == 25) then

      local w, h = guiGetScreenSize () -- pump
      local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 50 )
      setCameraTarget(xg, yg, zg+6)
   end 
   if(weapon == 33) then
      local w, h = guiGetScreenSize () -- bolt
      local xg, yg, zg = getWorldFromScreenPosition ( w/2, h/2, 50 )
      setCameraTarget(xg, yg, zg+4) 
   end
end
addEventHandler("onClientPlayerWeaponFire",localPlayer,OnPlayerFire)
