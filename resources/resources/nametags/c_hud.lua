local active = true
local screenWidth, screenHeight = guiGetScreenSize()
local localPlayer = getLocalPlayer()
local estadohud = getElementData(localPlayer, "hud")
r,g,b=255,255,255
alpha=200
           
function drawHUD()
	if getElementData(localPlayer, "nohud") then return end
	if active and not isPlayerMapVisible() and not estadohud or estadohud == true then
		local ax, ay = screenWidth - 122, 0	
		local health = getElementHealth( localPlayer )
		if (health <= 30) then
			dxDrawImage(ax,ay,32,37,"images/hud/lowhp.png")
			ax = ax - 34
		end
		local armour = getPedArmor( localPlayer )
		if armour > 0 then
			dxDrawImage(ax,ay,32,37,"images/hud/armour.png")
			ax = ax - 34
		end
		local dutyPol = getElementData(localPlayer, "duty")
		local dutyMed = getElementData(localPlayer, "dutymedico")
		if dutyPol == true or dutyMed == true then
			dxDrawImage(ax,ay,32,37,"images/hud/badge2.png")
			ax = ax - 34
		end
        local isGM = getElementData( localPlayer,"account:gmduty")
        if isGM  then
			dxDrawImage(ax,ay,32,37,"images/hud/gm.png")
			ax = ax - 34
        end
        local isHelper = getElementData( localPlayer,"account:helpduty")
        if isHelper  then
			dxDrawImage(ax,ay,32,37,"images/hud/helper.png")
			ax = ax - 34
		end
		if getElementData( localPlayer,"Cascos") then
			dxDrawImage(ax,ay,32,37,"images/hud/helmet.png")
			ax = ax - 34
		end	
        if getElementData( localPlayer,"mascara") then
             dxDrawImage(ax,ay,32,37,"images/hud/mask.png")
			ax = ax - 34
        end
        if getElementData( localPlayer,"buzo") then
             dxDrawImage(ax,ay,32,37,"images/hud/scuba.png")
			ax = ax - 34
        end
		if getElementData( localPlayer,"programandos") then
             dxDrawImage(ax,ay,32,37,"images/hud/dev.png")
			ax = ax - 34
        end
		if getElementData(localPlayer, "player.cinturon") == true then
            dxDrawImage(ax,ay,32,37,"images/hud/cinturon.png")
			ax = ax - 34
		end
		if (getPedWeapon(localPlayer) == 24) and (getPedTotalAmmo(localPlayer) > 0) then
			local deagleMode = getElementData(localPlayer, "tazerOn")
			if deagleMode == true then
				dxDrawImage(ax,ay,32,37,"images/hud/dtazer.png")
			end
			ax = ax - 34
		end
		if getPedOccupiedVehicle(getLocalPlayer()) and getVehicleSirensOn(getPedOccupiedVehicle(getLocalPlayer())) == true then
			dxDrawImage(ax,ay,32,37,"images/hud/siren.png")
			ax = ax - 34
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), drawHUD)

function drawStates ()
    addEventHandler ( "onClientRender", root, pingAndFPSState )
end
addEventHandler ( "onClientResourceStart", resourceRoot, drawStates )