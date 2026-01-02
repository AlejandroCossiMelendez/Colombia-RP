local npc
local polvoraJugador = {}

addEventHandler("onResourceStart", resourceRoot, function()
    npc = createPed(167, 2042.50, 1541.76, 10.67)
    setElementFrozen(npc, true)
    setElementRotation(npc, 0, 0, 90)
    setElementData(npc, "npc:polvora", true)
end)

addEvent("polvora:comprar", true)
addEventHandler("polvora:comprar", root, function()
    if polvoraJugador[source] then
        outputChatBox("Ya tienes pólvora.", source, 255, 0, 0)
        return
    end

    polvoraJugador[source] = true
    outputChatBox("Compraste pólvora. Usa /ponerpolvora", source, 0, 255, 0)
end)

addCommandHandler("ponerpolvora", function(player)
    if not polvoraJugador[player] then
        outputChatBox("No tienes pólvora.", player, 255, 0, 0)
        return
    end

    polvoraJugador[player] = false

    local x, y, z = getElementPosition(player)
    local _, _, rz = getElementRotation(player)

    local obj = createObject(1654, x, y, z - 0.9)
    setElementRotation(obj, 0, 0, rz)
    setElementDimension(obj, getElementDimension(player))
    setElementInterior(obj, getElementInterior(player))

    triggerClientEvent(root, "polvora:colocada", root, obj)

    setTimer(function()
        if isElement(obj) then
            local ox, oy, oz = getElementPosition(obj)
            createExplosion(ox, oy, oz, 2)
            triggerClientEvent(root, "polvora:explosion", root, ox, oy, oz)
            destroyElement(obj)
        end
    end, 7000, 1)
end)

addEventHandler("onPlayerQuit", root, function()
    polvoraJugador[source] = nil
end)
