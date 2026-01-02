local reanimando = {}

function usarBotiquinComando(player, command, targetName)
    if reanimando[player] then
        exports.infobox:addNotification(player, "Ya estás reanimando", "error")
        return
    end

    local tieneItem, slot, _ = exports.items:has(player, 53)
    if not tieneItem then
        exports.infobox:addNotification(player, "No tienes un botiquín", "error")
        return
    end

    local targetPlayer, targetName = exports.players:getFromName(player, targetName)
    if not targetPlayer then
        exports.infobox:addNotification(player, "Jugador no encontrado", "error")
        return
    end

    if not getElementData(targetPlayer, "muerto") then
        exports.infobox:addNotification(player, "El jugador no está muerto", "error")
        return
    end

    local x1, y1, z1 = getElementPosition(player)
    local x2, y2, z2 = getElementPosition(targetPlayer)
    local distancia = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
    if distancia > 1 then
        exports.infobox:addNotification(player, "El jugador está demasiado lejos", "error")
        return
    end

    exports.infobox:addNotification(player, "Estás reanimando al jugador", "success")
    exports.infobox:addNotification(targetPlayer, "Estás siendo reanimado por " .. getPlayerName(player), "success")
    exports.items:guardarArmas(targetPlayer, true)
    exports.items:take(player, slot)

    setElementFrozen(player, true)
    setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)

    reanimando[player] = true

    setTimer(function()
        setElementFrozen(player, false)
        setPedAnimation(player)
        reanimando[player] = nil

        local x, y, z = getElementPosition(targetPlayer)
        local rot = getElementRotation(targetPlayer)
        local skin = getElementModel(targetPlayer)
        local dim = getElementDimension(targetPlayer)
        local int = getElementInterior(targetPlayer)

        spawnPlayer(targetPlayer, x, y, z, rot, skin, int, dim)
        setElementData(targetPlayer, "muerto", false)
        setElementHealth(targetPlayer, 10)

        exports.infobox:addNotification(targetPlayer, "Espera 10 segundos para continuar", "warning")
        setElementFrozen(targetPlayer, true)
        setPedAnimation(targetPlayer, "clothes", "clo_pose_legs", -1, true, false, false)

        setTimer(function()
            setElementFrozen(targetPlayer, false)
            setPedAnimation(targetPlayer)
            exports.infobox:addNotification(targetPlayer, "Ya puedes continuar, ¡Recuerda rolear heridas!", "warning")
            exports.infobox:addNotification(player, "Lograste devolverle la vida a un civil", "success")
        end, 10000, 1)
    end, 10000, 1)
end

addCommandHandler("usarboti", usarBotiquinComando)