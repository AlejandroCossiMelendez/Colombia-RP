--Aaron Mussio Scripter

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

addCommandHandler("adidas2",
function(me2)
	local id = tonumber(id)
	if getElementData(me2, "zg:bag") == tonumber(1548) then
		createBag(me2, 1548)
		outputChatBox( "#7cc576[BOLSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me2, 255, 255, 0, true )
	elseif getElementData(me2, "zg:bag") == tonumber(3103) then
		createBag(me2, 3103)
		outputChatBox( "#7cc576[BOLSO]#FFFFFF Para retirar a su bolso use /quitarbolso.", me2, 255, 255, 0, true )
	elseif getElementData(me2, "zg:bag") == tonumber(3102) then
		createBag(me2, 3102)
		outputChatBox( "#7cc576[BOLSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me2, 255, 255, 0, true )
	elseif getElementData(me2, "zg:bag") == tonumber(3101) then
		createBag(me2, 3101)
		outputChatBox( "#7cc576[BOLSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me2, 255, 255, 0, true )
	else
		createBag(me2, 3101)
		outputChatBox( "#7cc576[BOlSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me2, 255, 255, 0, true )
	end
end)

addCommandHandler("removbag",
function(me2)
	destroyBag(me2)
end)

addCommandHandler("nike",
function(me3)
	local id = tonumber(id)
	if getElementData(me3, "zg:bag") == tonumber(1548) then
		createBag(me3, 1548)
		outputChatBox( "#7cc576[BOlSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me3, 255, 255, 0, true )
	elseif getElementData(me3, "zg:bag") == tonumber(3103) then
		createBag(me3, 3103)
		outputChatBox( "#7cc576[BOlSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me3, 255, 255, 0, true )
	elseif getElementData(me3, "zg:bag") == tonumber(3102) then
		createBag(me3, 3102)
		outputChatBox( "#7cc576[BOlSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me3, 255, 255, 0, true )
	elseif getElementData(me3, "zg:bag") == tonumber(3101) then
		createBag(me3, 3101)
		outputChatBox( "#7cc576[BOlSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me3, 255, 255, 0, true )
	else
		createBag(me3, 3102)
		outputChatBox( "#7cc576[BOlSO]#FFFFFF Para retirar su bolso use /quitarbolso.", me3, 255, 255, 0, true )
	end
end)

addCommandHandler("quitarbolso",
function(me3)
	destroyBag(me3)
end)

addCommandHandler("adidas1",
function(me4)
	local id = tonumber(id)
	if getElementData(me4, "zg:bag") == tonumber(1548) then
		createBag(me4, 1548)
		outputChatBox( "#7cc576[BAG]#FFFFFF Para retirar a sua bag use /removbag.", me4, 255, 255, 0, true )
	elseif getElementData(me4, "zg:bag") == tonumber(3103) then
		createBag(me4, 3103)
		outputChatBox( "#7cc576[BAG]#FFFFFF Para retirar a sua bag use /removbag.", me4, 255, 255, 0, true )
	elseif getElementData(me4, "zg:bag") == tonumber(3102) then
		createBag(me4, 3102)
		outputChatBox( "#7cc576[BAG]#FFFFFF Para retirar a sua bag use /removbag.", me4, 255, 255, 0, true )
	elseif getElementData(me4, "zg:bag") == tonumber(3101) then
		createBag(me4, 3101)
		outputChatBox( "#7cc576[BAG]#FFFFFF Para retirar a sua bag use /removbag.", me4, 255, 255, 0, true )
	else
		createBag(me4, 1548)
		outputChatBox( "#7cc576[BAG]#FFFFFF Para retirar a sua bag use /removbag.", me4, 255, 255, 0, true )
	end
end)

addCommandHandler("quitarbolso",
function(me4)
	destroyBag(me4)
end)

