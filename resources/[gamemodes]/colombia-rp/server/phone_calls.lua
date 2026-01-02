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

-- Función para normalizar número de teléfono (quitar guiones y espacios)
function normalizePhoneNumber(phoneNumber)
    if not phoneNumber then
        return nil
    end
    -- Convertir a string y quitar guiones y espacios
    local normalized = tostring(phoneNumber):gsub("-", ""):gsub(" ", ""):gsub("%s", "")
    return normalized
end

-- Función para encontrar jugador por número de teléfono
function findPlayerByPhoneNumber(phoneNumber)
    if not phoneNumber then
        return nil
    end
    
    -- Normalizar el número de búsqueda (quitar guiones)
    local normalizedSearch = normalizePhoneNumber(phoneNumber)
    
    -- Buscar en la base de datos - comparar tanto con formato como sin formato
    -- Primero intentar con el número tal cual viene
    local query = "SELECT titular, numero FROM tlf_data WHERE numero = ? OR REPLACE(REPLACE(numero, '-', ''), ' ', '') = ? LIMIT 1"
    local result = queryDatabase(query, phoneNumber, normalizedSearch)
    
    if result and #result > 0 then
        local characterId = result[1].titular
        
        -- Log para debugging
        outputServerLog("[PHONE] Número encontrado: " .. tostring(result[1].numero) .. " para character_id: " .. tostring(characterId))
        
        -- Buscar jugador con ese character_id
        for _, player in ipairs(getElementsByType("player")) do
            local playerCharacterId = getElementData(player, "character:id")
            local playerSelected = getElementData(player, "character:selected")
            
            if playerCharacterId == characterId and playerSelected then
                outputServerLog("[PHONE] Jugador encontrado: " .. getPlayerName(player) .. " (ID: " .. tostring(characterId) .. ")")
                return player
            end
        end
        
        outputServerLog("[PHONE] Jugador con character_id " .. tostring(characterId) .. " no está conectado o no tiene personaje seleccionado")
    else
        outputServerLog("[PHONE] Número no encontrado en la base de datos: " .. tostring(phoneNumber) .. " (normalizado: " .. tostring(normalizedSearch) .. ")")
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
    
    -- Verificar que el receptor esté conectado y tenga personaje seleccionado
    if not isElement(receiver) or getElementType(receiver) ~= "player" then
        outputChatBox("El jugador receptor no está disponible.", caller, 255, 0, 0)
        triggerClientEvent(caller, "phone:callFailed", resourceRoot, "Jugador no disponible")
        return
    end
    
    if not getElementData(receiver, "character:selected") then
        outputChatBox("El jugador receptor no tiene un personaje seleccionado.", caller, 255, 0, 0)
        triggerClientEvent(caller, "phone:callFailed", resourceRoot, "Jugador no disponible")
        return
    end
    
    -- Enviar notificación al receptor
    outputServerLog("[PHONE] Enviando notificación de llamada a " .. getPlayerName(receiver) .. " (ID: " .. tostring(callId) .. ")")
    outputServerLog("[PHONE] CallerNumber: " .. tostring(callerNumber) .. ", CallerName: " .. tostring(callerName))
    
    -- Enviar evento al receptor (usar root en lugar de resourceRoot para asegurar que llegue)
    triggerClientEvent(receiver, "phone:incomingCall", root, callerNumber, callerName, callId)
    triggerClientEvent(caller, "phone:callRinging", root, phoneNumber)
    
    -- También enviar outputChatBox como backup
    outputChatBox("📞 Llamada entrante de " .. callerName .. " (" .. callerNumber .. ")", receiver, 0, 255, 0)
    outputChatBox("Presiona R para contestar o C para rechazar", receiver, 255, 255, 0)
    
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
    triggerClientEvent(call.caller, "phone:callAnswered", root, callId)
    triggerClientEvent(call.receiver, "phone:callAnswered", root, callId)
    
    outputServerLog("[PHONE] Llamada contestada por " .. getPlayerName(player))
    
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
            if call.caller and isElement(call.caller) then
                triggerClientEvent(call.caller, "phone:callEnded", root, "Llamada rechazada")
                -- Limpiar llamada del caller también
                if playerCalls[call.caller] then
                    local callerCallId = playerCalls[call.caller]
                    if activeCalls[callerCallId] then
                        endCallVoice(activeCalls[callerCallId])
                        activeCalls[callerCallId] = nil
                    end
                    playerCalls[call.caller] = nil
                end
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
        triggerClientEvent(otherPlayer, "phone:callEnded", root, "Llamada finalizada")
    end
    
    triggerClientEvent(player, "phone:callEnded", root, "Llamada finalizada")
    
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
        outputChatBox("No tienes una llamada activa.", player, 255, 0, 0)
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
    
    outputServerLog("[PHONE] Altavoz " .. (enabled and "activado" or "desactivado") .. " para " .. getPlayerName(player))
end)

-- Configurar chat de voz para la llamada
function setupCallVoice(call)
    if not call or not isElement(call.caller) or not isElement(call.receiver) then
        return
    end
    
    -- IMPORTANTE: Limpiar cualquier configuración de voz anterior
    -- Primero, limpiar ignore lists para asegurar que se escuchen
    setPlayerVoiceIgnoreFrom(call.caller, {})
    setPlayerVoiceIgnoreFrom(call.receiver, {})
    
    -- Configurar para que ambos se escuchen sin importar la distancia
    -- Usar setPlayerVoiceBroadcastTo para que se escuchen mutuamente
    setPlayerVoiceBroadcastTo(call.caller, {call.receiver})
    setPlayerVoiceBroadcastTo(call.receiver, {call.caller})
    
    -- Guardar información de la llamada
    setElementData(call.caller, "phone:inCall", true)
    setElementData(call.caller, "phone:callPartner", call.receiver)
    setElementData(call.receiver, "phone:inCall", true)
    setElementData(call.receiver, "phone:callPartner", call.caller)
    
    outputServerLog("[PHONE] Chat de voz configurado para llamada entre " .. getPlayerName(call.caller) .. " y " .. getPlayerName(call.receiver))
end

-- Actualizar chat de voz (para altavoz)
function updateCallVoice(call)
    if not call or not isElement(call.caller) or not isElement(call.receiver) then
        return
    end
    
    -- Lista base de jugadores que siempre se escuchan (los dos de la llamada)
    local callerBroadcast = {call.receiver}
    local receiverBroadcast = {call.caller}
    
    -- Si el altavoz está activo, agregar jugadores cercanos
    if call.speaker.caller or call.speaker.receiver then
        -- Obtener posición del caller
        local callerX, callerY, callerZ = getElementPosition(call.caller)
        local receiverX, receiverY, receiverZ = getElementPosition(call.receiver)
        
        -- Buscar jugadores cercanos al caller (dentro de 20 metros)
        for _, player in ipairs(getElementsByType("player")) do
            if player ~= call.caller and player ~= call.receiver and isElement(player) then
                local px, py, pz = getElementPosition(player)
                local distanceToCaller = getDistanceBetweenPoints3D(callerX, callerY, callerZ, px, py, pz)
                local distanceToReceiver = getDistanceBetweenPoints3D(receiverX, receiverY, receiverZ, px, py, pz)
                
                -- Si está cerca del caller y el altavoz del caller está activo
                if distanceToCaller <= 20 and call.speaker.caller then
                    table.insert(callerBroadcast, player)
                end
                
                -- Si está cerca del receiver y el altavoz del receiver está activo
                if distanceToReceiver <= 20 and call.speaker.receiver then
                    table.insert(receiverBroadcast, player)
                end
            end
        end
    end
    
    -- Configurar broadcast
    setPlayerVoiceBroadcastTo(call.caller, callerBroadcast)
    setPlayerVoiceBroadcastTo(call.receiver, receiverBroadcast)
    
    -- Limpiar ignore lists para asegurar que se escuchen
    setPlayerVoiceIgnoreFrom(call.caller, {})
    setPlayerVoiceIgnoreFrom(call.receiver, {})
    
    -- Actualizar estado del altavoz
    setElementData(call.caller, "phone:speakerEnabled", call.speaker.caller)
    setElementData(call.receiver, "phone:speakerEnabled", call.speaker.receiver)
    
    outputServerLog("[PHONE] Chat de voz actualizado - Caller altavoz: " .. tostring(call.speaker.caller) .. ", Receiver altavoz: " .. tostring(call.speaker.receiver))
end

-- Terminar chat de voz
function endCallVoice(call)
    if not call then
        return
    end
    
    outputServerLog("[PHONE] Terminando chat de voz para la llamada")
    
    -- Restaurar voz por proximidad
    if isElement(call.caller) then
        -- Limpiar configuración de voz de llamada
        setPlayerVoiceBroadcastTo(call.caller, {})
        setPlayerVoiceIgnoreFrom(call.caller, {}) -- Limpiar ignore list
        
        -- Limpiar datos
        setElementData(call.caller, "phone:inCall", false)
        setElementData(call.caller, "phone:callPartner", nil)
        setElementData(call.caller, "phone:speakerEnabled", false)
        
        -- Restaurar voz de proximidad (verificar si está en frecuencia)
        local frecuencia = getElementData(call.caller, "frecuencia.voz")
        if not frecuencia or tonumber(frecuencia) == -1 or tonumber(frecuencia) >= 2000 then
            -- No está en frecuencia, restaurar voz de proximidad
            setPlayerVoiceIgnoreFrom(call.caller, {})
        end
        
        outputServerLog("[PHONE] Voz restaurada para " .. getPlayerName(call.caller))
    end
    
    if isElement(call.receiver) then
        -- Limpiar configuración de voz de llamada
        setPlayerVoiceBroadcastTo(call.receiver, {})
        setPlayerVoiceIgnoreFrom(call.receiver, {}) -- Limpiar ignore list
        
        -- Limpiar datos
        setElementData(call.receiver, "phone:inCall", false)
        setElementData(call.receiver, "phone:callPartner", nil)
        setElementData(call.receiver, "phone:speakerEnabled", false)
        
        -- Restaurar voz de proximidad (verificar si está en frecuencia)
        local frecuencia = getElementData(call.receiver, "frecuencia.voz")
        if not frecuencia or tonumber(frecuencia) == -1 or tonumber(frecuencia) >= 2000 then
            -- No está en frecuencia, restaurar voz de proximidad
            setPlayerVoiceIgnoreFrom(call.receiver, {})
        end
        
        outputServerLog("[PHONE] Voz restaurada para " .. getPlayerName(call.receiver))
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

