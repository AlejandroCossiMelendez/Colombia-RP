-- Sistema de Radio/Frecuencia para Jugadores
local playerFrequency = {} -- Tabla para almacenar la frecuencia de cada jugador

-- Configuración de radio
local ConfigRadio = {
    defaultFrequency = 0, -- Frecuencia por defecto (0 = sin radio)
    minFrequency = 0, -- Frecuencia mínima
    maxFrequency = 999, -- Frecuencia máxima
}

-- Inicializar frecuencia cuando un jugador se une
addEventHandler("onPlayerJoin", root, function()
    playerFrequency[source] = ConfigRadio.defaultFrequency
    setElementData(source, "player:frequency", ConfigRadio.defaultFrequency)
end)

-- Inicializar frecuencia cuando un personaje es seleccionado
addEventHandler("onPlayerSpawn", root, function()
    if getElementData(source, "character:selected") then
        if not playerFrequency[source] then
            playerFrequency[source] = ConfigRadio.defaultFrequency
        end
        setElementData(source, "player:frequency", playerFrequency[source] or ConfigRadio.defaultFrequency)
    end
end)

-- Comando para cambiar frecuencia
addCommandHandler("freq", function(player, cmd, frequency)
    if not getElementData(player, "character:selected") then
        outputChatBox("Debes tener un personaje seleccionado para usar la radio.", player, 255, 0, 0)
        return
    end
    
    if not frequency then
        local currentFreq = playerFrequency[player] or ConfigRadio.defaultFrequency
        outputChatBox("Tu frecuencia actual es: " .. currentFreq .. " Hz", player, 255, 255, 0)
        outputChatBox("Uso: /freq [frecuencia] (0-999)", player, 255, 255, 0)
        return
    end
    
    local freq = tonumber(frequency)
    if not freq then
        outputChatBox("La frecuencia debe ser un número.", player, 255, 0, 0)
        return
    end
    
    if freq < ConfigRadio.minFrequency or freq > ConfigRadio.maxFrequency then
        outputChatBox("La frecuencia debe estar entre " .. ConfigRadio.minFrequency .. " y " .. ConfigRadio.maxFrequency .. " Hz.", player, 255, 0, 0)
        return
    end
    
    playerFrequency[player] = freq
    setElementData(player, "player:frequency", freq)
    outputChatBox("Has cambiado tu frecuencia a: " .. freq .. " Hz", player, 0, 255, 0)
    
    -- Notificar a otros jugadores en la misma frecuencia
    for _, otherPlayer in ipairs(getElementsByType("player")) do
        if otherPlayer ~= player and getElementData(otherPlayer, "player:frequency") == freq then
            local playerName = getElementData(player, "character:name") or getPlayerName(player)
            outputChatBox(playerName .. " se ha unido a la frecuencia " .. freq .. " Hz", otherPlayer, 0, 255, 255)
        end
    end
end)

-- Comando alternativo
addCommandHandler("frecuencia", function(player, cmd, frequency)
    triggerEvent("onPlayerCommand", player, "freq", frequency)
end)

-- Limpiar datos cuando un jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    if playerFrequency[source] then
        playerFrequency[source] = nil
    end
end)

