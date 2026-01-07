bindKey("0", "both",
    function(key, state)
        if state == "down" then
	if getElementData(localPlayer, "apontar") == false then
	setElementData(localPlayer, "apontar", true)

	triggerServerEvent ( "onClientSyncVOZ", localPlayer )
	end
        else
	setElementData(localPlayer, "apontar", false)

	triggerServerEvent ( "onClientSyncVOZparar", localPlayer )
    end
end
)
