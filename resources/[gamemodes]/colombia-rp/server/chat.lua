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

-- Interceptar mensajes de chat normales y comandos
addEventHandler("onPlayerChat", root, function(message, messageType)
    -- Procesar mensajes de chat normales (tipo 0)
    if messageType == 0 then
        cancelEvent()
        local displayName = getCharacterDisplayName(source)
        local chatMessage = displayName .. ": " .. message
        
        for _, player in ipairs(getElementsByType("player")) do
            if getElementDimension(player) == getElementDimension(source) and 
               getElementInterior(player) == getElementInterior(source) then
                outputChatBox(chatMessage, player, 255, 255, 255, false)
            end
        end
    -- Procesar mensajes de comandos (tipo 1) - esto incluye /me, /do, etc.
    elseif messageType == 1 then
        -- Verificar si el mensaje es de un comando de roleplay
        if getElementData(source, "character:selected") then
            local messageLower = string.lower(message)
            local playerName = getPlayerName(source)
            
            -- Si el mensaje empieza con "* " seguido del nombre del jugador, es un /me
            local mePattern = "^%* " .. playerName .. " "
            if string.find(message, mePattern) then
                cancelEvent()
                local charName = getCharacterNameOnly(source)
                -- Extraer la acción del mensaje (quitar el "* NombreMTA ")
                local action = string.gsub(message, "^%* " .. playerName .. " ", "")
                
                for _, player in ipairs(getElementsByType("player")) do
                    if getElementDimension(player) == getElementDimension(source) and 
                       getElementInterior(player) == getElementInterior(source) then
                        outputChatBox("* " .. charName .. " " .. action, player, 200, 100, 200, false)
                    end
                end
            end
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

-- Interceptar comandos de roleplay usando onPlayerCommand (se ejecuta antes que el comando nativo)
addEventHandler("onPlayerCommand", root, function(command, ...)
    local cmdLower = string.lower(tostring(command))
    
    -- Solo procesar comandos de roleplay
    if cmdLower ~= "me" and cmdLower ~= "do" then
        return
    end
    
    -- Solo procesar si el jugador tiene personaje seleccionado
    if not getElementData(source, "character:selected") then
        return
    end
    
    local args = {...}
    local message = table.concat(args, " ")
    
    if cmdLower == "me" then
        if not message or message == "" then
            outputChatBox("Uso: /me [acción]", source, 255, 255, 255)
            cancelEvent()
            return
        end
        
        -- Cancelar el comando nativo de MTA
        cancelEvent()
        
        local charName = getCharacterNameOnly(source)
        
        -- Enviar a todos los jugadores en la misma dimensión e interior
        for _, targetPlayer in ipairs(getElementsByType("player")) do
            if getElementDimension(targetPlayer) == getElementDimension(source) and 
               getElementInterior(targetPlayer) == getElementInterior(source) then
                outputChatBox("* " .. charName .. " " .. message, targetPlayer, 200, 100, 200, false)
            end
        end
    elseif cmdLower == "do" then
        if not message or message == "" then
            outputChatBox("Uso: /do [descripción]", source, 255, 255, 255)
            cancelEvent()
            return
        end
        
        cancelEvent()
        local charName = getCharacterNameOnly(source)
        
        for _, targetPlayer in ipairs(getElementsByType("player")) do
            if getElementDimension(targetPlayer) == getElementDimension(source) and 
               getElementInterior(targetPlayer) == getElementInterior(source) then
                outputChatBox("* " .. message .. " (( " .. charName .. " ))", targetPlayer, 100, 200, 200, false)
            end
        end
    end
end)

-- Command handlers adicionales como respaldo
addCommandHandler("me", function(player, cmd, ...)
    if not getElementData(player, "character:selected") then
        return
    end
    
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("Uso: /me [acción]", player, 255, 255, 255)
        return
    end
    
    cancelEvent()
    local charName = getCharacterNameOnly(player)
    
    for _, targetPlayer in ipairs(getElementsByType("player")) do
        if getElementDimension(targetPlayer) == getElementDimension(player) and 
           getElementInterior(targetPlayer) == getElementInterior(player) then
            outputChatBox("* " .. charName .. " " .. message, targetPlayer, 200, 100, 200, false)
        end
    end
end, false)

addCommandHandler("do", function(player, cmd, ...)
    if not getElementData(player, "character:selected") then
        return
    end
    
    local message = table.concat({...}, " ")
    if not message or message == "" then
        outputChatBox("Uso: /do [descripción]", player, 255, 255, 255)
        return
    end
    
    cancelEvent()
    local charName = getCharacterNameOnly(player)
    
    for _, targetPlayer in ipairs(getElementsByType("player")) do
        if getElementDimension(targetPlayer) == getElementDimension(player) and 
           getElementInterior(targetPlayer) == getElementInterior(player) then
            outputChatBox("* " .. message .. " (( " .. charName .. " ))", targetPlayer, 100, 200, 200, false)
        end
    end
end, false)

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
    
    cancelEvent()
    local charName = getCharacterNameOnly(player)
    
    for _, targetPlayer in ipairs(getElementsByType("player")) do
        if getElementDimension(targetPlayer) == getElementDimension(player) and 
           getElementInterior(targetPlayer) == getElementInterior(player) then
            outputChatBox("** " .. charName .. " " .. message, targetPlayer, 255, 200, 100, false)
        end
    end
end, false)

