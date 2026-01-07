local solicitudesDeRobo = {}
local temporizadoresDeRobo = {}

function robarJugador(player, command, target)
    if not target then
        outputChatBox("Uso: /robo [jugador]", player, 255, 0, 0)
        return
    end

    if target == player then
        outputChatBox("No puedes robarte a ti mismo.", player, 255, 0, 0)
        return
    end

    local otro, nombre = exports.players:getFromName(player, target)
    if otro then
        local x, y, z = getElementPosition(player)
        local px, py, pz = getElementPosition(otro)
        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 5 then
            outputChatBox("Estás demasiado lejos de " .. getPlayerName(otro) .. ".", player, 255, 0, 0)
            return
        end

        solicitudesDeRobo[getPlayerName(otro)] = player

        outputChatBox("#D7AB6B[ROBO] #FFFFFF¡Estás siendo robado por #00FFFF" .. tostring(getPlayerName(player):gsub("_", " ")) .. "#FFFFFF!", otro, 255, 0, 0, true)
        outputChatBox("#D7AB6B[ROBO] #FFFFFFUtiliza #00FF00/aceptarrobo #FFFFFFen los próximos 5 minutos.", otro, 255, 0, 0, true)
        outputChatBox("#D7AB6B[ROBO] #FFFFFFHas enviado una solicitud de robo a #00FFFF" .. tostring(getPlayerName(otro):gsub("_", " ")) .. "#FFFFFF.", player, 0, 255, 0, true)

        temporizadoresDeRobo[getPlayerName(otro)] = setTimer(function()
            solicitudesDeRobo[getPlayerName(otro)] = nil
            temporizadoresDeRobo[getPlayerName(otro)] = nil
        end, 300000, 1) -- 300000 milisegundos (5 minutos)
    else
        outputChatBox("El jugador objetivo no es válido o su posición no está disponible.", player, 255, 0, 0)
    end
end
addCommandHandler("robo", robarJugador)

function aceptarRobo(player)
    local playerName = getPlayerName(player)

    if solicitudesDeRobo[playerName] then
        local robador = solicitudesDeRobo[playerName]

        -- Obtener el dinero del jugador robado
        local dineroRobado = getPlayerMoney(player)
        local dineroTransferido = math.floor(dineroRobado * 0.5) -- Calcular el 50%

        if dineroTransferido > 0 then
            -- Transferir dinero al robador
            exports.players:giveMoney(robador, dineroTransferido)
            exports.players:takeMoney(player, dineroTransferido)

            -- Mensajes para ambos jugadores
            outputChatBox("#D7AB6B[ROBO] #FFFFFFHas aceptado el robo de #00BB00".. tostring(getPlayerName(robador):gsub("_", " ")) .." #FFFFFFy le has entregado el 50% de tu dinero (#00FF00$" .. dineroTransferido .. "#FFFFFF).", player, 255, 0, 0, true)
            outputChatBox("#D7AB6B[ROBO] #FFFFFF¡#00BB00" .. tostring(getPlayerName(player):gsub("_", " ")) .. " #FFFFFFha aceptado tu solicitud de robo! Le has robado #00FF00$" .. dineroTransferido .. "#FFFFFF.", robador, 255, 255, 0, true)
        else
            -- Si el jugador no tiene dinero
            outputChatBox("#D7AB6B[ROBO] #FFFFFFEl jugador no tiene suficiente dinero para ser robado.", robador, 255, 0, 0, true)
            outputChatBox("#D7AB6B[ROBO] #FFFFFFNo tienes suficiente dinero para que te roben.", player, 255, 0, 0, true)
        end

        -- Limpiar las solicitudes de robo y temporizadores
        solicitudesDeRobo[playerName] = nil
        if temporizadoresDeRobo[playerName] then
            killTimer(temporizadoresDeRobo[playerName])
            temporizadoresDeRobo[playerName] = nil
        end
    else
        outputChatBox("No tienes ninguna solicitud de robo pendiente.", player, 255, 0, 0)
    end
end
addCommandHandler("aceptarrobo", aceptarRobo)
