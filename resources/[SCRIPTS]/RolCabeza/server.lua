function outputMessage(element, text)
	assert(isElement(element), "outputMessage @ Bad argument: expected element at argument 1, got "..type(element).." "..tostring(element))
	triggerClientEvent("onChatIncome", element, tostring(text))
end

function sendMessageToClient(message, messagetype)
	if not wasEventCancelled() then
		if messagetype == 0 or messagetype == 2 then
			-- Enviar al evento "onChatIncome" (para compatibilidad)
			triggerClientEvent("onChatIncome", source, message, messagetype)
		end
	end
end
addEventHandler("onPlayerChat", getRootElement(), sendMessageToClient)

-- Función para obtener jugadores cercanos (en la misma dimensión e interior)
function getLocalPlayersAround(player, distance)
    if not player or not isElement(player) then return {} end
    
    local x, y, z = getElementPosition(player)
    local dimension = getElementDimension(player)
    local interior = getElementInterior(player)
    local nearbyPlayers = {}
    
    -- Añadir siempre al propio jugador
    table.insert(nearbyPlayers, player)
    
    -- Obtener jugadores cercanos
    local allPlayers = getElementsByType("player")
    for _, nearbyPlayer in ipairs(allPlayers) do
        if nearbyPlayer ~= player then
            local nx, ny, nz = getElementPosition(nearbyPlayer)
            local nDimension = getElementDimension(nearbyPlayer)
            local nInterior = getElementInterior(nearbyPlayer)
            
            -- Verificar distancia y dimensión/interior
            if getDistanceBetweenPoints3D(x, y, z, nx, ny, nz) <= distance and
               nDimension == dimension and nInterior == interior then
                table.insert(nearbyPlayers, nearbyPlayer)
            end
        end
    end
    
    return nearbyPlayers
end

-- Eventos personalizados para los mensajes de rol (me/do)
-- Evento para /me
addEvent("rolme", true)
addEventHandler("rolme", root, function(message)
    -- Verificar que el jugador que dispara el evento es válido
    if client and isElement(client) and getElementType(client) == "player" then
        -- Obtener jugadores cercanos (30 unidades)
        local nearbyPlayers = getLocalPlayersAround(client, 30)
        
        -- Retransmitir el mensaje SOLO a jugadores cercanos
        triggerClientEvent(nearbyPlayers, "onRolReceived", resourceRoot, message, "me", client)
    end
end)

-- Evento para /do
addEvent("roldo", true)
addEventHandler("roldo", root, function(message)
    -- Verificar que el jugador que dispara el evento es válido
    if client and isElement(client) and getElementType(client) == "player" then
        -- Obtener jugadores cercanos (30 unidades)
        local nearbyPlayers = getLocalPlayersAround(client, 30)
        
        -- Retransmitir el mensaje SOLO a jugadores cercanos
        triggerClientEvent(nearbyPlayers, "onRolReceived", resourceRoot, message, "do", client)
    end
end)

-- Función para procesar mensajes de rol desde bindeos externos
function processRoleplayMessage(player, message, messageType)
    if player and isElement(player) and getElementType(player) == "player" then
        if messageType == "me" or messageType == "do" then
            -- Obtener jugadores cercanos (30 unidades)
            local nearbyPlayers = getLocalPlayersAround(player, 30)
            
            -- Enviar a jugadores cercanos para mostrar las burbujas
            triggerClientEvent(nearbyPlayers, "onRolReceived", resourceRoot, message, messageType, player)
            
            -- También enviar como mensaje del chat normal solo a jugadores cercanos
            local playerName = getPlayerName(player)
            if messageType == "me" then
                for _, nearPlayer in ipairs(nearbyPlayers) do
                    outputChatBox("* " .. playerName .. " " .. message, nearPlayer, 255, 0, 0)
                end
            elseif messageType == "do" then
                for _, nearPlayer in ipairs(nearbyPlayers) do
                    outputChatBox("* " .. message .. " (( " .. playerName .. " ))", nearPlayer, 255, 255, 0)
                end
            end
            
            return true
        end
    end
    return false
end

-- Exportar la función para que otros recursos puedan usarla
function processRolFromBinds(message, messageType)
    return processRoleplayMessage(client, message, messageType)
end
addEvent("processRolFromBinds", true)
addEventHandler("processRolFromBinds", root, processRolFromBinds)