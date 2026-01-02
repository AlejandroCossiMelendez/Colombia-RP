addEventHandler("onClientClick", root, function(button, state, _, _, _, _, _, element)
    if button == "left" and state == "down" then
        if element and getElementData(element, "npc:polvora") then
            outputChatBox("NPC: Click para comprar pólvora (precio configurable)", 255, 255, 0)
            triggerServerEvent("polvora:comprar", localPlayer)
        end
    end
end)

addEvent("polvora:colocada", true)
addEventHandler("polvora:colocada", root, function(obj)
    local x, y, z = getElementPosition(obj)

    playSound3D("sounds/place.wav", x, y, z)
    local fuse = playSound3D("sounds/fuse.wav", x, y, z)
    setSoundMaxDistance(fuse, 20)

    setTimer(function()
        if isElement(obj) then
            local fx, fy, fz = getElementPosition(obj)
            fxAddSparks(fx, fy, fz, 0, 0, 1, 1, 5)
        end
    end, 500, 10)
end)

addEvent("polvora:explosion", true)
addEventHandler("polvora:explosion", root, function(x, y, z)
    playSound3D("sounds/explosion.wav", x, y, z)
    fxAddExplosion(x, y, z)
end)
