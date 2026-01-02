-- Sistema de Chat - Mostrar nombre del personaje en lugar del nombre de MTA

-- Función para obtener el nombre del personaje
function getCharacterDisplayName(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return getPlayerName(player)
    end
    
    if not getElementData(player, "character:selected") then
        return getPlayerName(player)
    end
    
    local charName = getElementData(player, "character:name")
    local charSurname = getElementData(player, "character:surname")
    local charId = getElementData(player, "character:id")
    
    if charName and charSurname and charId then
        return charName .. " " .. charSurname .. " (ID: " .. charId .. ")"
    elseif charName and charSurname then
        return charName .. " " .. charSurname
    else
        return getPlayerName(player)
    end
end

-- Interceptar mensajes de chat normales
addEventHandler("onPlayerChat", root, function(message, messageType)
    -- Solo procesar mensajes de chat normales (tipo 0)
    if messageType ~= 0 then
        return
    end
    
    -- Cancelar el mensaje por defecto
    cancelEvent()
    
    -- Obtener el nombre del personaje
    local displayName = getCharacterDisplayName(source)
    
    -- Enviar el mensaje con el nombre del personaje a todos los jugadores
    -- Usar formato estándar de MTA para el chat
    local chatMessage = displayName .. ": " .. message
    
    -- Enviar el mensaje a todos los jugadores visibles
    for _, player in ipairs(getElementsByType("player")) do
        -- Verificar si están en la misma dimensión e interior
        if getElementDimension(player) == getElementDimension(source) and 
           getElementInterior(player) == getElementInterior(source) then
            outputChatBox(chatMessage, player, 255, 255, 255, false)
        end
    end
end)

-- Interceptar comandos de chat (como /me, /do, etc.)
-- Nota: Los comandos personalizados ya se manejan en sus respectivos archivos
-- Este sistema solo afecta los mensajes de chat normales

