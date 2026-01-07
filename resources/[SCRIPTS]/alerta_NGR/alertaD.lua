
 addEventHandler ("onPlayerWeaponFire", root, 
 function (weapons)
	  if not (getElementData(source, "Fire")) then
		  setElementData(source, "Fire", true)
		  x,y,z = getElementPosition(source)
		  local weaponName = getWeaponNameFromID(weapons)
		  if (weaponName == "Silenced") then
		   local weaponName = "Teaser"
		  end
			local posX, posY, posZ = getElementPosition ( source )
		  local chatSp = createColSphere ( posX, posY, posZ, 50 ) -- 50 es el radio
		  local elements = getElementsWithinColShape (chatSp, "player" )
		  destroyElement (chatSp)
		  for i,Players in ipairs(elements) do
			  outputChatBox("#FFFB00 ¡Ten cuidado!, se escuchan disparos por tu zona!.",Players,255,255,255,true)  
		  end
		  setTimer(setElementData, 10000, 1, source, "Fire", false)
	   end
	end
 )