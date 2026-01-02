-- Sistema de Dinero
-- Usamos prefijos para evitar conflictos con funciones nativas de MTA

function getCharacterMoney(player)
    local money = getElementData(player, "character:money")
    return money or 0
end

function giveCharacterMoney(player, amount)
    if not isElement(player) or amount <= 0 then
        return false
    end
    
    local currentMoney = getCharacterMoney(player)
    local newMoney = currentMoney + amount
    
    setElementData(player, "character:money", newMoney)
    -- Usar la función nativa de MTA para dar dinero
    givePlayerMoney(player, amount) -- Función nativa de MTA
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET money = ? WHERE id = ?", newMoney, characterId)
    end
    
    return true
end

function takeCharacterMoney(player, amount)
    if not isElement(player) or amount <= 0 then
        return false
    end
    
    local currentMoney = getCharacterMoney(player)
    
    if currentMoney < amount then
        return false
    end
    
    local newMoney = currentMoney - amount
    
    setElementData(player, "character:money", newMoney)
    -- Usar la función nativa de MTA para quitar dinero
    takePlayerMoney(player, amount) -- Función nativa de MTA
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET money = ? WHERE id = ?", newMoney, characterId)
    end
    
    return true
end

function setCharacterMoney(player, amount)
    if not isElement(player) or amount < 0 then
        return false
    end
    
    setElementData(player, "character:money", amount)
    -- Usar la función nativa de MTA directamente
    local currentMoney = getCharacterMoney(player)
    local difference = amount - currentMoney
    
    if difference > 0 then
        givePlayerMoney(player, difference) -- Función nativa de MTA
    elseif difference < 0 then
        takePlayerMoney(player, math.abs(difference)) -- Función nativa de MTA
    end
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET money = ? WHERE id = ?", amount, characterId)
    end
    
    return true
end

-- Comandos
addCommandHandler("dinero", function(player, cmd, amount)
    local money = getCharacterMoney(player)
    outputChatBox("Tu dinero: $" .. money, player, 255, 255, 0)
end)

-- Transferir dinero entre jugadores
addCommandHandler("dar", function(player, cmd, targetName, amount)
    if not targetName or not amount then
        outputChatBox("Uso: /dar [jugador] [cantidad]", player, 255, 0, 0)
        return
    end
    
    amount = tonumber(amount)
    if not amount or amount <= 0 then
        outputChatBox("Cantidad inválida", player, 255, 0, 0)
        return
    end
    
    local target = getPlayerFromName(targetName)
    if not target then
        outputChatBox("Jugador no encontrado", player, 255, 0, 0)
        return
    end
    
    if takeCharacterMoney(player, amount) then
        giveCharacterMoney(target, amount)
        outputChatBox("Le diste $" .. amount .. " a " .. getPlayerName(target), player, 0, 255, 0)
        outputChatBox(getPlayerName(player) .. " te dio $" .. amount, target, 0, 255, 0)
    else
        outputChatBox("No tienes suficiente dinero", player, 255, 0, 0)
    end
end)
