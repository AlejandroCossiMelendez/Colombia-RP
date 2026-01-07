function setHora(player, command, time)
    if not time then
        outputChatBox("Uso: /sethora [dia/tarde/noche]", player, 255, 255, 255)
        return
    end

    local horas = {
        dia = 12,     -- Mediodía (12:00 PM)
        tarde = 18,   -- Tarde (6:00 PM)
        noche = 0     -- Medianoche (12:00 AM)
    }

    local nuevaHora = horas[string.lower(time)]
    
    if nuevaHora then
        setTime(nuevaHora, 0)
        outputChatBox("Hora del servidor cambiada a " .. time, player, 0, 255, 0)
    else
        outputChatBox("Opciones válidas: dia, tarde, noche", player, 255, 0, 0)
    end
end
addCommandHandler("sethora", setHora)
