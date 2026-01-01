

local int = 10
local dim = 779
local progress = 0

local meatPos = {
	{378.9921875, -62.6259765625, 1001.5078125},
	{378.9921875, -62.6259765625, 1001.5078125},
	{378.9921875, -62.6259765625, 1001.5078125},
	{378.9921875, -62.6259765625, 1001.5078125},
	{378.9921875, -62.6259765625, 1001.5078125},
	{378.9921875, -62.6259765625, 1001.5078125},
	
	{376.4072265625, -62.619140625, 1001.5078125},
	{376.4072265625, -62.619140625, 1001.5078125},
	{376.4072265625, -62.619140625, 1001.5078125},
	{376.4072265625, -62.619140625, 1001.5078125},
	{376.4072265625, -62.619140625, 1001.5078125},
	{376.4072265625, -62.619140625, 1001.5078125},
}

local opensans = dxCreateFont("files/opensans.ttf",14)
local showMeat = false
local s = {guiGetScreenSize()}
local box = {142,12}
local pos = {s[1]/2 - box[1]/2, s[2]/1.25 - box[2]/2}
local boxing = nil

local meatObjects = {
	{379.896484375, -57.6337890625, 1001.5078122},
	{379.896484375, -57.6337890625, 1001.507812},
	{379.896484375, -57.6337890625, 1001.507812},
}

addEventHandler("onClientResourceStart",resourceRoot,function()
	for k,v in ipairs(meatObjects) do
		asd = createObject(v[1],v[2],v[3],v[4])
		setElementInterior(asd,10)
		setElementDimension(asd,779)
	end
	for k,v in ipairs(meatPos) do
		obj = createObject(2589,v[1],v[2],v[3])
		setElementInterior(obj,int)
		setElementDimension(obj,dim)
		setElementData(obj,"isMeat",true)
		setElementFrozen(obj,true)
	end
	meatMarker = createMarker(376.4775390625, -59.173828125, 1001.5078125,"cylinder",1,65, 105, 225,60)
	setElementDimension(meatMarker,dim)
	setElementInterior(meatMarker,int)
	setElementData(meatMarker,"boxingMarker",true)
	
	dropMarker = createMarker(376.4775390625, -59.173828125, 1001.5078125,"cylinder",1,65, 105, 225,60)
	setElementDimension(dropMarker,dim)
	setElementInterior(dropMarker,int)
	setElementData(dropMarker,"boxDropMarker",true)
	setElementData(localPlayer, "isMeatInHand",false)
	setElementData(localPlayer, "isBoxInHand",false)
	
end)

addEventHandler("onClientRender",getRootElement(),function()
	if isElement(boxing) then
		local x,y,z = getElementPosition(boxing)
		if y >= 2136.38 then
			if getElementModel(boxing) == 2806 then
				setElementModel(boxing,1271)
				setElementPosition(boxing,x,y,z+0.1)
			end
		end
	end
end)

addEventHandler("onClientObjectDamage", getRootElement(),function(loss,attacker)
	if getElementData(source,"isMeat") then
		if localPlayer == attacker then
			if not isElement(boxing) then
				if getPedWeapon(localPlayer) == 2 then
					if showMeat then
						if progress >= 0 then
							rand = math.random(10,11)
							progress = progress+(loss/rand)
							if progress+(loss/rand) >= 156.2 then
								showMeat = false
								progress = 0
								triggerServerEvent("givePlayerMeat",localPlayer,localPlayer)
								outputChatBox("Despedazaste un trozo de carne",255,255,255,true)
							end
						end
					end
					else
					outputChatBox("Necesitas un machete para cortar carne.",255,255,255,true)
				end
			else
			end
		end
	end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(player,dim)
	if player == localPlayer then
		if getElementData(source, "boxingMarker") then
			if getElementData(localPlayer, "jobedvis") == 3 then
				if getElementData(localPlayer,"isMeatInHand") then
					progress = 0
					triggerServerEvent("takePlayerMeat",localPlayer,localPlayer)
					if not isElement(boxing) then
						boxing = createObject(2806,375.625, -57.783203125, 1001.507812)
						setElementData(boxing,"isBoxingObject",false)
						setObjectScale(boxing,0.7)
						setElementRotation(boxing,0,0,90)
						setElementInterior(boxing,1)
						setElementDimension(boxing,48)
						moveObject ( boxing, 20000,376.28125, -57.9091796875, 1001.507812)
					end
					theTimer = setTimer( function()
					setElementData(boxing,"isBoxingObject",true)
					theTimer = nil
					end, 20000,1)
				end
			end
		elseif getElementData(source,"boxDropMarker") then
			if getElementData(localPlayer, "jobedvis") == 3 then
				if getElementData(localPlayer,"isBoxInHand") then
					triggerServerEvent("takePlayerBox",localPlayer,localPlayer)
					triggerServerEvent("SRG_GiveMoneyMait",localPlayer,localPlayer)
				end
			end
		end
	end
end)

local meatElement = nil

setTimer(function()
		if getElementInterior(localPlayer) == int and getElementDimension(localPlayer) == dim then
			for k,v in ipairs(getElementsByType("object")) do
				if getElementData(v,"isMeat") then
					local pX,pY,pZ = getElementPosition(localPlayer)
					local eX,eY,eZ = getElementPosition(v)
					if getDistanceBetweenPoints3D(pX,pY,pZ,eX,eY,eZ-4) <= 2 then
						if getElementData(localPlayer, "jobedvis") == 3  then
							if getPedWeapon(localPlayer) == 2 then
								if not showMeat then
									showMeat = true
									meatElement = v
								end
							end
						end
					end
					if getDistanceBetweenPoints3D(pX,pY,pZ,eX,eY,eZ-4) >= 2 then
						if meatElement == v then
							if getElementData(localPlayer, "jobedvis") == 3 then
								if showMeat then
									showMeat = false
									meatElement = nil
									if progress >= 0 then
										progress = 0
									end
								end
							end
						end
					end
				end
			end
		end
end,250,0)

addEventHandler("onClientRender",getRootElement(),function()

	if showMeat then
		dxDrawRectangle(pos[1],pos[2],box[1],box[2]+20,tocolor(0,0,0,80))
		dxDrawRectangle(pos[1],pos[2],progress,box[2]+20,tocolor(65, 255, 105,200))
		dxDrawRectangle(pos[1],pos[2]-2,box[1],2,tocolor(0,0,0,160))
		dxDrawRectangle(pos[1],pos[2]+32+0.1,box[1],2,tocolor(0,0,0,160))
		dxDrawRectangle(pos[1]-2,pos[2]-2,2,box[2]+24,tocolor(0,0,0,160))
		dxDrawRectangle(pos[1]+box[1],pos[2]-2,2,box[2]+24,tocolor(0,0,0,160))
	end
	
	if getElementData(localPlayer, "isMeatInHand") then
		toggleControl("fire", false)
		toggleControl("sprint", false)
		toggleControl("crouch", false)
		toggleControl("jump", false)
		toggleControl("aim_weapon", false)
		toggleControl("next_weapon", false)
		toggleControl("previous_weapon", false)
	elseif getElementData(localPlayer,"isBoxInHand") then
		toggleControl("fire", false)
		toggleControl("sprint", false)
		toggleControl("crouch", false)
		toggleControl("jump", false)
		toggleControl("aim_weapon", false)
		toggleControl("next_weapon", false)
		toggleControl("previous_weapon", false)
	end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "down" then
		if isElement(clickedElement) then
			if getElementType(clickedElement) == "object" then
				if getElementData(clickedElement,"isBoxingObject")  == true then
				setElementData(clickedElement,"isBoxingObject",false)
				triggerServerEvent("givePlayerBox",localPlayer,localPlayer)
			    destroyElement(clickedElement)
				end
			end
		end
	end
end)

addEventHandler('onClientResourceStart', resourceRoot,
function()
	txd = engineLoadTXD( "machete/machete.txd" )
	dff = engineLoadDFF( "machete/machete.dff" )

	engineImportTXD( txd, 333 )
	engineReplaceModel( dff, 333 )
end)