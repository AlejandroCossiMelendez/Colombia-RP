--local ammoRifle = getPedTotalAmmo ( k, 5 )

local jugadores = {}
local lplayer = getLocalPlayer()
local info = {}
local sx,sy = guiGetScreenSize()

function crearArma(jug,arma)
	local model = obtenerObjeto(arma)
	local slot = getSlotFromWeapon(arma)
	jugadores[jug][slot] = createObject(model,0,0,0)
	setElementCollisionsEnabled(jugadores[jug][slot],false)
end

function destruirArma(jug,slot)
	destroyElement(jugadores[jug][slot])
	jugadores[jug][slot] = nil
end

addEventHandler("onClientResourceStart",getResourceRootElement(),function()
	for k,v in ipairs(getElementsByType("player",root,true)) do
		jugadores[v] = {}
		info[v] = {true,isPedInVehicle(v)}
	end
end,false)

addEventHandler("onClientPlayerQuit",root,function()
	if jugadores[source] and source ~= lplayer then
		for k,v in pairs(jugadores[source]) do
			destroyElement(v)
		end
		jugadores[source] = nil
		info[source] = nil
	end
end)

addEventHandler("onClientElementStreamIn",root,function()
	if getElementType(source) == "player" and source ~= lplayer then
		jugadores[source] = {}
		info[source] = {true,isPedInVehicle(source)}
	end
end)

addEventHandler("onClientElementStreamOut",root,function()
	if jugadores[source] and source ~= lplayer then
		for k,v in pairs(jugadores[source]) do
			destroyElement(v)
		end
		jugadores[source] = nil
		info[source] = nil
	end
end)


function nascer()
	if jugadores[source] then
		info[source][1] = true
	end
end
addEventHandler("onClientPlayerSpawn",root, nascer)

function sumirArma()
	if jugadores[source] then
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
		info[source][1] = false
	end
end
addEventHandler("onClientPlayerWasted",root, sumirArma)

function sumirArma2()
local ammoRifle = getPedTotalAmmo(localPlayer, 5) 
local ammoSniper = getPedTotalAmmo(localPlayer, 6) 
local armaa = getPedWeapon(localPlayer, 5)
local armaaSniper = getPedWeapon(localPlayer, 6)
	if ammoRifle >= 1 then
		if armaa == 30 or armaa == 31 then
			setElementData ( localPlayer, "Arma", sim )
		end	
	else
		setElementData ( localPlayer, "Arma", false )	
	end
	
	if ammoSniper >= 1 then
		if armaaSniper == 34 then
			setElementData ( localPlayer, "ArmaSniper", sim )
		end	
	else
		setElementData ( localPlayer, "ArmaSniper", false )	
	end
end
addEventHandler("onClientPreRender",root, sumirArma2)

function sumirArma3()
	if jugadores[source] then
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
	end
end
addEventHandler("onClientPlayerVehicleEnter",root, sumirArma3)
addEventHandler("onClientPlayerDamage",root, sumirArma3)
addEventHandler("onClientPlayerChangeNick",root, sumirArma3)
addEventHandler("onClientPlayerVoiceStop",root, sumirArma3)
addEventHandler("onClientPlayerPickupHit",root, sumirArma3)

addEventHandler("onClientPlayerVehicleEnter",root,function()
	if jugadores[source] then
		for k,v in pairs(jugadores[source]) do
			destruirArma(source,k)
		end
		info[source][2] = true
	end
end)


addEventHandler("onClientPlayerVehicleExit",root,function()
	if jugadores[source] then
		info[source][2] = false
	end
end)

addEventHandler("onClientPreRender",root,function()
	for k,v in pairs(jugadores) do
		local x,y,z = getPedBonePosition(k,3)
		local rot = math.rad(90-getPedRotation(k))
		local i = 15
		local wep = getPedWeaponSlot(k)
		local ox,oy = math.cos(rot+2.4)*0.22,-math.sin(rot+2.4)*0.22
		local alpha = getElementAlpha(k)
		for q,w in pairs(v) do
			if q == wep then
				destruirArma(k,q)
			else
				setElementRotation(w,0,70,getPedRotation(k)+90)
				setElementAlpha(w,alpha)
				if q==2 then
					
				elseif q==4 then
					
				else
					setElementPosition(w,x+ox,y+oy,z+0.1)
					setElementRotation(w,5,58,getPedRotation(k))
					i=i+15
				end
			end
		end
		local armado = getElementData( k, "Arma" )
		local armadoSniper = getElementData( k, "ArmaSniper" )
		if info[k][1] and not info[k][2] and armado == sim then
			for i=1,7 do
				local arma = getPedWeapon(k,i)
				if arma~=wep and arma>0 and not jugadores[k][i] then
				if arma == 30 or arma == 31 then
					crearArma(k,arma)
				end
				end
			end
		end
		if info[k][1] and not info[k][2] and armadoSniper == sim then
			for i=1,7 do
				local arma = getPedWeapon(k,i)
				if arma~=wep and arma>0 and not jugadores[k][i] then
				if arma == 34 then
					crearArma(k,arma)
				end
				end
			end
		end
	end
end)

function obtenerObjeto(arma)
	local m
	if arma > 1 and arma < 9 then
		m = 331 + arma
	elseif arma == 9 then
		m = 341
	elseif arma == 15 then
		m = 326
	elseif (arma > 21 and arma < 30) or (arma > 32 and arma < 39) or (arma > 40 and arma < 44) then
		m = 324 + arma
	elseif arma > 29 and arma < 32 then
		m = 325 + arma
	elseif arma == 32 then
		m = 372
	end
	return m
end