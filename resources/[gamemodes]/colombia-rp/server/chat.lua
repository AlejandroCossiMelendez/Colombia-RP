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

-- Interceptar comandos de roleplay (/me, /do, /ame, etc.)
-- Función para obtener solo el nombre del personaje (sin ID para comandos de roleplay)
function getCharacterNameOnly(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return getPlayerName(player)
    end
    
    if not getElementData(player, "character:selected") then
        return getPlayerName(player)
    end
    
    local charName = getElementData(player, "character:name")
    local charSurname = getElementData(player, "character:surname")
    
    if charName and charSurname then
        return charName .. " " .. charSurname
    else
        return getPlayerName(player)
    end
end

-- Comando /me (acción de roleplay)
addCommandHandler("me", function(player, cmd, ...)
    if not getElementData(player, "character:selected") then
        -- Si no tiene personaje, usar el comando por defecto
        return
    end
    
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("Uso: /me [acción]", player, 255, 255, 255)
        return
    end
    
    -- Cancelar el comando por defecto
    cancelEvent()
    
    -- Obtener el nombre del personaje
    local charName = getCharacterNameOnly(player)
    
    -- Enviar el mensaje a todos los jugadores en la misma dimensión e interior
    for _, targetPlayer in ipairs(getElementsByType("player")) do
        if getElementDimension(targetPlayer) == getElementDimension(player) and 
           getElementInterior(targetPlayer) == getElementInterior(player) then
            outputChatBox("* " .. charName .. " " .. message, targetPlayer, 200, 100, 200, false)
        end
    end
end)

-- Comando /do (descripción de roleplay)
addCommandHandler("do", function(player, cmd, ...)
    if not getElementData(player, "character:selected") then
        return
    end
    
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("Uso: /do [descripción]", player, 255, 255, 255)
        return
    end
    
    -- Cancelar el comando por defecto
    cancelEvent()
    
    -- Obtener el nombre del personaje
    local charName = getCharacterNameOnly(player)
    
    -- Enviar el mensaje a todos los jugadores en la misma dimensión e interior
    for _, targetPlayer in ipairs(getElementsByType("player")) do
        if getElementDimension(targetPlayer) == getElementDimension(player) and 
           getElementInterior(targetPlayer) == getElementInterior(player) then
            outputChatBox("* " .. message .. " (( " .. charName .. " ))", targetPlayer, 100, 200, 200, false)
        end
    end
end)

-- Comando /ame (acción con emote)
addCommandHandler("ame", function(player, cmd, ...)
    if not getElementData(player, "character:selected") then
        return
    end
    
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("Uso: /ame [acción]", player, 255, 255, 255)
        return
    end
    
    -- Cancelar el comando por defecto si existe
    cancelEvent()
    
    -- Obtener el nombre del personaje
    local charName = getCharacterNameOnly(player)
    
    -- Enviar el mensaje a todos los jugadores en la misma dimensión e interior
    for _, targetPlayer in ipairs(getElementsByType("player")) do
        if getElementDimension(targetPlayer) == getElementDimension(player) and 
           getElementInterior(targetPlayer) == getElementInterior(player) then
            outputChatBox("** " .. charName .. " " .. message, targetPlayer, 255, 200, 100, false)
        end
    end
end)

