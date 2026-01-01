-- Aaron Mussio Scripter
-- COMANDOS :  /gucci /nike /adidas1 /adidas2

local ids = {
	[1547] = true,
    [1548] = true,
	[3103] = true,
	[3102] = true,
	[3101] = true
}

local bag = {}
local timer = {}

function createBag(player, id)
	if ids[id] then
		if isElement(bag[player]) then
			destroyElement(bag[player])
			if isTimer(timer[player]) then
				killTimer(timer[player])
			end
		end
		bag[player] = createObject(id, 0, 0, 0)
		exports["bone_attach"]:attachElementToBone(bag[player],player,3,0,-0.005,-0.18,0,0,90)
		timer[player] = setTimer(function()
			setElementDimension(bag[player], getElementDimension(player) )
			setElementInterior(bag[player], getElementInterior(player) )
		end, 100, 0)
	else
		outputDebugString("BAGS: ID INVALIDO")
	end
end

function destroyBag( player )
	if isElement(bag[player]) then
		destroyElement(bag[player])
		if isTimer(timer[player]) then
			killTimer(timer[player])
		end
	end
end

addEventHandler("onPlayerQuit", root,
	function()
		destroyBag(source)
	end
)

addCommandHandler("gucci",
function(me)
	local id = tonumber(id)
	if getElementData(me, "zg:bag") == tonumber(1548) then
		createBag(me, 1548)
		outputChatBox( "#7cc576[BOLSO]#FFFFFFPara Retirar el Bolso /quitarbolso.", me, 255, 255, 0, true )
	elseif getElementData(me, "zg:bag") == tonumber(3103) then
		createBag(me, 3103)
		outputChatBox( "#7cc576[BOLSO]#FFFFFFPara Retirar el Bolso /quitarbolso.", me, 255, 255, 0, true )
	elseif getElementData(me, "zg:bag") == tonumber(3102) then
		createBag(me, 3102)
		outputChatBox( "#7cc576[BOLSO]#FFFFFFPara Retirar el Bolso /quitarbolso.", me, 255, 255, 0, true )
	elseif getElementData(me, "zg:bag") == tonumber(3101) then
		createBag(me, 3101)
		outputChatBox( "#7cc576[BOLSO]#FFFFFFPara Retirar el Bolso /quitarbolso.", me, 255, 255, 0, true )
	else
		createBag(me, 3103)
		outputChatBox( "#7cc576[BOLSO]#FFFFFFPara Retirar el Bolso /quitarbolso.", me, 255, 255, 0, true )
	end
end)

addCommandHandler("quitarbolso",
function(me)
	destroyBag(me)
end)

