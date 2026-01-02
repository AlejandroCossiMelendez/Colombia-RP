-- Sistema de Dinero
function getPlayerMoney(player)
    local money = getElementData(player, "character:money")
    return money or 0
end

function givePlayerMoney(player, amount)
    if not isElement(player) or amount <= 0 then
        return false
    end
    
    local currentMoney = getPlayerMoney(player)
    local newMoney = currentMoney + amount
    
    setElementData(player, "character:money", newMoney)
    setPlayerMoney(player, newMoney)
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET money = ? WHERE id = ?", newMoney, characterId)
    end
    
    return true
end

function takePlayerMoney(player, amount)
    if not isElement(player) or amount <= 0 then
        return false
    end
    
    local currentMoney = getPlayerMoney(player)
    
    if currentMoney < amount then
        return false
    end
    
    local newMoney = currentMoney - amount
    
    setElementData(player, "character:money", newMoney)
    setPlayerMoney(player, newMoney)
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET money = ? WHERE id = ?", newMoney, characterId)
    end
    
    return true
end

function setPlayerMoney(player, amount)
    if not isElement(player) or amount < 0 then
        return false
    end
    
    setElementData(player, "character:money", amount)
    givePlayerMoney(player, amount) -- MTA función nativa
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET money = ? WHERE id = ?", amount, characterId)
    end
    
    return true
end

-- Comandos
addCommandHandler("dinero", function(player, cmd, amount)
    local money = getPlayerMoney(player)
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
    
    if takePlayerMoney(player, amount) then
        givePlayerMoney(target, amount)
        outputChatBox("Le diste $" .. amount .. " a " .. getPlayerName(target), player, 0, 255, 0)
        outputChatBox(getPlayerName(player) .. " te dio $" .. amount, target, 0, 255, 0)
    else
        outputChatBox("No tienes suficiente dinero", player, 255, 0, 0)
    end
end)

