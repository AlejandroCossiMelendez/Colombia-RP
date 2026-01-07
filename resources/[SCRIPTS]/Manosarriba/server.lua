addEvent("onClientSyncVOZ", true)
addEventHandler("onClientSyncVOZ", root,
    function()
        local player = source
        local playerHealth = getElementHealth(player)

        if not isPedDead(player) and playerHealth > 10 then
            setPedAnimation(player, "GHANDS", "gsign1", 0, true, false, false)
            setTimer(setPedAnimationProgress, 100, 1, player, "gsign1", 1.16)
            setTimer(setPedAnimationSpeed, 1500, 1, player, "gsign1", 0)
        else
            outputChatBox("No puedes ejecutar la animación cuando estás muerto o tu vida es 10 o menos.", player, 255, 0, 0)
        end
    end
)

addEvent("onClientSyncVOZparar", true)
addEventHandler("onClientSyncVOZparar", root,
    function()
        local player = source
        local playerHealth = getElementHealth(player)

        if not isPedDead(player) and playerHealth > 10 then
            setTimer(setPedAnimation, 100, 1, player, "GHANDS", "gsign1", 5000, false, false, false)
            setTimer(setPedAnimation, 250, 1, player, nil)
        else
            outputChatBox("No puedes detener la animación cuando estás muerto o tu vida es 10 o menos.", player, 255, 0, 0)
        end
    end
)

function isPedDead(player)
    return getElementHealth(player) <= 0
end