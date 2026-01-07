local MAX_DISTANCE = 2

local solicitudes = {}

addCommandHandler("despojar", function(player, cmd, targetName)
    if not targetName then
        outputChatBox("Uso correcto: /despojar [ID]", player, 255, 0, 0)
        return
    end

    local targetPlayer, targetName = exports.players:getFromName(player, targetName)

    if not targetPlayer then
        exports.infobox:addNotification(player, "Jugador no encontrado", "error")
        return
    end

    local targetMoney = exports.players:getMoney(targetPlayer)
    local cantidad = math.floor(targetMoney * 0.5)

    if cantidad <= 0 then
        exports.infobox:addNotification(player, "El jugador no tiene suficiente dinero para despojar", "error")
        return
    end

    local x, y, z = getElementPosition(player)
    local targetX, targetY, targetZ = getElementPosition(targetPlayer)
    local distance = getDistanceBetweenPoints3D(x, y, z, targetX, targetY, targetZ)
    if distance > MAX_DISTANCE then
         exports.infobox:addNotification(player, "Solo puedes despojar a civiles cercanos", "error")
        return
    end

    solicitudes[targetPlayer] = {solicitante = player, cantidad = cantidad}

    outputChatBox("Te está despojando $" .. cantidad .. " el jugador " .. getPlayerName(player) .. ".", targetPlayer, 255, 255, 0)
    outputChatBox("Usa /aceptar o /rechazar para proceder con el rol.", targetPlayer, 255, 255, 0)
    exports.infobox:addNotification(player, "Estás despojando, espera a que la victima acepte", "success")
end)

addCommandHandler("aceptar", function(player)
    local solicitud = solicitudes[player]

    if not solicitud then
        exports.infobox:addNotification(player, "No te están despojando", "error")
        return
    end

    if exports.players:takeMoney(player, solicitud.cantidad) then
        exports.players:giveMoney(solicitud.solicitante, solicitud.cantidad)
        outputChatBox("Te ha despojado $" .. solicitud.cantidad .. " el jugador " .. getPlayerName(solicitud.solicitante) .. ".", player, 0, 255, 0)
        outputChatBox("Le quitaste $" .. solicitud.cantidad .. " a " .. getPlayerName(player) .. ".", solicitud.solicitante, 0, 255, 0)
    else
        exports.infobox:addNotification(player, "No puedes entregar esa cantidad, verifica tu dinero", "error")
    end

    solicitudes[player] = nil
end)

addCommandHandler("rechazar", function(player)
    local solicitud = solicitudes[player]

    if not solicitud then
        exports.infobox:addNotification(player, "No te están despojando", "error")
        return
    end

    outputChatBox("El jugador " .. getPlayerName(player) .. " se ha negado al despoje.", solicitud.solicitante, 255, 0, 0)

    solicitudes[player] = nil
end)
