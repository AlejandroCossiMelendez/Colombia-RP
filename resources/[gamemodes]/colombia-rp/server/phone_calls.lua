-- Sistema de Llamadas Telefónicas

local activeCalls = {} -- {callId = {caller = player, receiver = player, startTime = timestamp, speaker = {caller = bool, receiver = bool}}}
local playerCalls = {} -- {player = callId} para búsqueda rápida
local incomingCalls = {} -- {player = {caller = player, number = string, name = string}}

-- Función para obtener el número de teléfono de un jugador
function getPlayerPhoneNumber(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return nil
    end
    
    -- Buscar en la base de datos
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return nil
    end
    
    local query = "SELECT numero FROM tlf_data WHERE titular = ? LIMIT 1"
    local result = queryDatabase(query, characterId)
    
    if result and #result > 0 then
        return result[1].numero
    end
    
    return nil
end

-- Función para encontrar jugador por número de teléfono
function findPlayerByPhoneNumber(phoneNumber)
    if not phoneNumber then
        return nil
    end
    
    -- Buscar en la base de datos
    local query = "SELECT titular FROM tlf_data WHERE numero = ? LIMIT 1"
    local result = queryDatabase(query, phoneNumber)
    
    if result and #result > 0 then
        local characterId = result[1].titular
        
        -- Buscar jugador con ese character_id
        for _, player in ipairs(getElementsByType("player")) do
            if getElementData(player, "character:id") == characterId and 
               getElementData(player, "character:selected") then
                return player
            end
        end
    end
    
    return nil
end

-- Función para obtener nombre del contacto
function getContactName(player, phoneNumber)
    if not isElement(player) or not phoneNumber then
        return phoneNumber
    end
    
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return phoneNumber
    end
    
    -- Buscar en contactos
    local query = "SELECT contact_name FROM phone_contacts WHERE character_id = ? AND contact_number = ? LIMIT 1"
    local result = queryDatabase(query, characterId, phoneNumber)
    
    if result and #result > 0 then
        return result[1].contact_name
    end
    
    return phoneNumber
end

-- Evento: Realizar llamada
addEvent("phone:makeCall", true)
addEventHandler("phone:makeCall", root, function(phoneNumber)
    local caller = source
    
    if not isElement(caller) or getElementType(caller) ~= "player" then
        return
    end
    
    -- Verificar si ya tiene una llamada activa
    if playerCalls[caller] then
        outputChatBox("Ya tienes una llamada activa.", caller, 255, 0, 0)
        return
    end
    
    -- Verificar que el personaje esté seleccionado
    if not getElementData(caller, "character:selected") then
        outputChatBox("Debes tener un personaje seleccionado para llamar.", caller, 255, 0, 0)
        return
    end
    
    -- Buscar receptor
    local receiver = findPlayerByPhoneNumber(phoneNumber)
    
    if not receiver then
        outputChatBox("El número " .. phoneNumber .. " no está disponible.", caller, 255, 0, 0)
        triggerClientEvent(caller, "phone:callFailed", resourceRoot, "Número no disponible")
        return
    end
    
    if receiver == caller then
        outputChatBox("No puedes llamarte a ti mismo.", caller, 255, 0, 0)
        return
    end
    
    -- Verificar si el receptor ya tiene una llamada
    if playerCalls[receiver] then
        outputChatBox("El número está ocupado.", caller, 255, 0, 0)
        triggerClientEvent(caller, "phone:callFailed", resourceRoot, "Número ocupado")
        return
    end
    
    -- Crear llamada
    local callId = "call_" .. getTickCount() .. "_" .. getPlayerName(caller)
    activeCalls[callId] = {
        caller = caller,
        receiver = receiver,
        startTime = nil,
        speaker = {caller = false, receiver = false}
    }
    
    playerCalls[caller] = callId
    playerCalls[receiver] = callId
    
    -- Obtener nombre del contacto
    local callerName = getContactName(receiver, getPlayerPhoneNumber(caller))
    local callerNumber = getPlayerPhoneNumber(caller)
    
    -- Notificar al receptor
    incomingCalls[receiver] = {
        caller = caller,
        number = callerNumber,
        name = callerName,
        callId = callId
    }
    
    triggerClientEvent(receiver, "phone:incomingCall", resourceRoot, callerNumber, callerName, callId)
    triggerClientEvent(caller, "phone:callRinging", resourceRoot, phoneNumber)
    
    outputServerLog("[PHONE] Llamada iniciada: " .. getPlayerName(caller) .. " -> " .. getPlayerName(receiver))
end)

-- Evento: Contestar llamada
addEvent("phone:answerCall", true)
addEventHandler("phone:answerCall", root, function(callId)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local call = activeCalls[callId]
    if not call then
        return
    end
    
    -- Verificar que el jugador sea el receptor
    if call.receiver ~= player then
        return
    end
    
    -- Iniciar llamada
    call.startTime = getTickCount()
    
    -- Configurar chat de voz
    setupCallVoice(call)
    
    -- Notificar a ambos
    triggerClientEvent(call.caller, "phone:callAnswered", resourceRoot, callId)
    triggerClientEvent(call.receiver, "phone:callAnswered", resourceRoot, callId)
    
    -- Limpiar llamada entrante
    incomingCalls[player] = nil
    
    outputServerLog("[PHONE] Llamada contestada: " .. getPlayerName(player))
end)

-- Evento: Colgar llamada
addEvent("phone:hangup", true)
addEventHandler("phone:hangup", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local callId = playerCalls[player]
    if not callId then
        -- Puede ser una llamada entrante que se rechaza
        if incomingCalls[player] then
            local call = incomingCalls[player]
            if call.caller then
                triggerClientEvent(call.caller, "phone:callEnded", resourceRoot, "Llamada rechazada")
            end
            incomingCalls[player] = nil
        end
        return
    end
    
    local call = activeCalls[callId]
    if not call then
        return
    end
    
    -- Terminar chat de voz
    endCallVoice(call)
    
    -- Notificar al otro jugador
    local otherPlayer = (call.caller == player) and call.receiver or call.caller
    if isElement(otherPlayer) then
        triggerClientEvent(otherPlayer, "phone:callEnded", resourceRoot, "Llamada finalizada")
    end
    
    triggerClientEvent(player, "phone:callEnded", resourceRoot, "Llamada finalizada")
    
    -- Calcular duración
    local duration = 0
    if call.startTime then
        duration = math.floor((getTickCount() - call.startTime) / 1000)
    end
    
    outputServerLog("[PHONE] Llamada finalizada: " .. getPlayerName(player) .. " (Duración: " .. duration .. "s)")
    
    -- Limpiar
    activeCalls[callId] = nil
    playerCalls[call.caller] = nil
    playerCalls[call.receiver] = nil
    incomingCalls[call.caller] = nil
    incomingCalls[call.receiver] = nil
end)

-- Evento: Activar/desactivar altavoz
addEvent("phone:toggleSpeaker", true)
addEventHandler("phone:toggleSpeaker", root, function(enabled)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local callId = playerCalls[player]
    if not callId then
        return
    end
    
    local call = activeCalls[callId]
    if not call then
        return
    end
    
    -- Actualizar estado del altavoz
    if call.caller == player then
        call.speaker.caller = enabled
    else
        call.speaker.receiver = enabled
    end
    
    -- Actualizar chat de voz para incluir/excluir personas cercanas
    updateCallVoice(call)
end)

-- Configurar chat de voz para la llamada
function setupCallVoice(call)
    if not call or not isElement(call.caller) or not isElement(call.receiver) then
        return
    end
    
    -- Configurar para que ambos se escuchen sin importar la distancia
    -- Usar setPlayerVoiceBroadcastTo para que se escuchen mutuamente
    setPlayerVoiceBroadcastTo(call.caller, {call.receiver})
    setPlayerVoiceBroadcastTo(call.receiver, {call.caller})
    
    -- Guardar información de la llamada
    setElementData(call.caller, "phone:inCall", true)
    setElementData(call.caller, "phone:callPartner", call.receiver)
    setElementData(call.receiver, "phone:inCall", true)
    setElementData(call.receiver, "phone:callPartner", call.caller)
    
    outputServerLog("[PHONE] Chat de voz configurado para llamada")
end

-- Actualizar chat de voz (para altavoz)
function updateCallVoice(call)
    if not call or not isElement(call.caller) or not isElement(call.receiver) then
        return
    end
    
    -- Actualizar estado del altavoz
    setElementData(call.caller, "phone:speakerEnabled", call.speaker.caller)
    setElementData(call.receiver, "phone:speakerEnabled", call.speaker.receiver)
    
    -- Si el altavoz está activo, los jugadores cercanos también escucharán
    -- Esto se manejará dinámicamente en el cliente
    -- El servidor solo actualiza el estado
end

-- Terminar chat de voz
function endCallVoice(call)
    if not call then
        return
    end
    
    -- Restaurar voz por proximidad
    if isElement(call.caller) then
        setPlayerVoiceBroadcastTo(call.caller, {})
        setElementData(call.caller, "phone:inCall", false)
        setElementData(call.caller, "phone:callPartner", nil)
        setElementData(call.caller, "phone:speakerEnabled", false)
    end
    
    if isElement(call.receiver) then
        setPlayerVoiceBroadcastTo(call.receiver, {})
        setElementData(call.receiver, "phone:inCall", false)
        setElementData(call.receiver, "phone:callPartner", nil)
        setElementData(call.receiver, "phone:speakerEnabled", false)
    end
end

-- Limpiar llamadas cuando un jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    local player = source
    local callId = playerCalls[player]
    
    if callId then
        local call = activeCalls[callId]
        if call then
            -- Notificar al otro jugador
            local otherPlayer = (call.caller == player) and call.receiver or call.caller
            if isElement(otherPlayer) then
                triggerClientEvent(otherPlayer, "phone:callEnded", resourceRoot, "Llamada finalizada")
            end
            
            -- Limpiar
            endCallVoice(call)
            activeCalls[callId] = nil
            playerCalls[call.caller] = nil
            playerCalls[call.receiver] = nil
        end
    end
    
    incomingCalls[player] = nil
end)

