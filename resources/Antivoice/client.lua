addEventHandler("onClientPlayerVoiceStart", localPlayer, function()
    if getElementData(localPlayer, "muerto") == true then
        cancelEvent()
    end
end)
