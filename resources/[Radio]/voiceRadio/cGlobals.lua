local tick = {}
local Animation = {}
local EventHandler = {} 
local bonesRotation = {}
local bonesRotation2 = {}

local Bones = {
    [5] = {0, 0, -30};
    [32] = {-30, -30, 50};
    [33] = {0, -160, 0};
    [34] = {-120, 0, 0};
}

function setAnimation(player)
    if not bonesRotation2[player] then
        bonesRotation2[player] = {}
    end
    for i,v in pairs(Bones) do
        bonesRotation2[player][i] = {getElementBoneRotation(player, i)}
    end
    tick[player] = getTickCount()
    Animation[player] = true
    if not EventHandler[player] then
        EventHandler[player] = true
        setTimer(function()
            EventHandler[player] = nil
        end,500,1)
    end
    bonesRotation[player] = {}
end
addEvent("TS:setAnimationClient",true)
addEventHandler("TS:setAnimationClient", root,setAnimation)

function cancelAnimation(player)
    Animation[player] = false
end
addEvent("TS:cancelAnimationClient",true)
addEventHandler("TS:cancelAnimationClient", root,cancelAnimation)

function drawAnimation()
    if getIndexTable(EventHandler) ~= 0 then
        for player,_ in pairs(EventHandler) do
            for i,v in pairs(Bones) do
                if bonesRotation2[player][i][1] and bonesRotation2[player][i][2] and bonesRotation2[player][i][3] then
                    local y,p,r = interpolateBetween(bonesRotation2[player][i][1], bonesRotation2[player][i][2], bonesRotation2[player][i][3], v[1], v[2], v[3], (getTickCount() - tick[player])/500, "Linear")
                    if not bonesRotation[player][i] then
                        bonesRotation[player][i] = {}
                    end
                    bonesRotation[player][i]["y"] = y
                    bonesRotation[player][i]["p"] = p
                    bonesRotation[player][i]["r"] = r
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, drawAnimation)


function getIndexTable(table)
    local Index = 0
    for i,v in pairs(table) do
        Index = Index + 1
    end
    return Index
end

--

function changeRotation(bone, y, p, r)
    if getIndexTable(Animation) ~= 0 then
        for player, _ in pairs(Animation) do
            if Animation[player] then
                for i, v in pairs(bonesRotation[player]) do 
                    setElementBoneRotation(player, i, v["y"], v["p"], v["r"])
                end
                updateElementRpHAnim(player)
            end
        end
    end
end
addEventHandler("onClientPedsProcessed", getRootElement(), changeRotation)

SETTINGS_REFRESH = 2000 -- Interval in which team channels are refreshed, in MS.
bShowChatIcons = true

voicePlayers = {}
globalMuted = {}

local range = 8 
  
addEventHandler ( "onClientPlayerVoiceStart", root, function() 
	if (source and isElement(source) and getElementType(source) == "player") and localPlayer ~= source then 
		local x,y,z = getElementPosition(localPlayer)
		local px, py, pz = getElementPosition(source)

        local l = getElementData (localPlayer, "TS:Frequencia")
    	local s = getElementData (source, "TS:Frequencia")
		local a = getElementData (source, "TS:RadioActive")

        if a and l and s and (l == s) then
			voicePlayers[source] = true
			setSoundVolume (localPlayer, 5)
			setSoundVolume (source, 5)
		elseif getDistanceBetweenPoints3D(x,y,z, px,py,pz) <= range then 
            voicePlayers[source] = true 
            setSoundVolume(source, 5)
        else 
            cancelEvent()--This was the shit 
        end 
	end 
end)

addEventHandler ( "onClientPlayerVoiceStop", root,
	function()
		voicePlayers[source] = nil
	end
)

addEventHandler ( "onClientPlayerQuit", root,
	function()
		voicePlayers[source] = nil
	end
)
---

function checkValidPlayer ( player )
	if not isElement(player) or getElementType(player) ~= "player" then
		outputDebugString ( "is/setPlayerVoiceMuted: Bad 'player' argument", 2 )
		return false
	end
	return true
end

---

setTimer ( 
	function()
		bShowChatIcons = getElementData ( resourceRoot, "show_chat_icon", show_chat_icon )
	end,
SETTINGS_REFRESH, 0 )