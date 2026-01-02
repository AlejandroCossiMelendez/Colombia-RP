-- Sistema de Llamadas Telefónicas - Cliente

local incomingCallNotification = nil
local isInCall = false
local callFrequency = nil
local callSpeakerEnabled = false

-- Evento: Llamada entrante
addEvent("phone:incomingCall", true)
addEventHandler("phone:incomingCall", resourceRoot, function(callerNumber, callerName, callId)
    -- Mostrar notificación de llamada entrante (sin pausar el juego)
    showIncomingCallNotification(callerNumber, callerName, callId)
end)

-- Mostrar notificación de llamada entrante
function showIncomingCallNotification(callerNumber, callerName, callId)
    -- Crear notificación visual
    local screenW, screenH = guiGetScreenSize()
    
    if incomingCallNotification then
        destroyElement(incomingCallNotification)
    end
    
    incomingCallNotification = guiCreateWindow(screenW/2 - 200, 50, 400, 150, "Llamada Entrante", false)
    guiWindowSetSizable(incomingCallNotification, false)
    guiSetAlpha(incomingCallNotification, 0.9)
    
    local label = guiCreateLabel(20, 30, 360, 30, callerName .. "\n" .. callerNumber, false, incomingCallNotification)
    guiLabelSetHorizontalAlign(label, "center", false)
    guiSetFont(label, "default-bold-small")
    
    local answerBtn = guiCreateButton(50, 80, 120, 40, "Contestar (R)", false, incomingCallNotification)
    local rejectBtn = guiCreateButton(230, 80, 120, 40, "Rechazar (C)", false, incomingCallNotification)
    
    addEventHandler("onClientGUIClick", answerBtn, function()
        answerCall(callId)
    end, false)
    
    addEventHandler("onClientGUIClick", rejectBtn, function()
        rejectCall()
    end, false)
    
    -- Guardar callId para las teclas
    setElementData(localPlayer, "phone:incomingCallId", callId)
end)

-- Ocultar notificación
function hideIncomingCallNotification()
    if incomingCallNotification then
        destroyElement(incomingCallNotification)
        incomingCallNotification = nil
    end
    setElementData(localPlayer, "phone:incomingCallId", nil)
end

-- Contestar llamada
function answerCall(callId)
    if not callId then
        callId = getElementData(localPlayer, "phone:incomingCallId")
    end
    
    if callId then
        triggerServerEvent("phone:answerCall", localPlayer, callId)
        hideIncomingCallNotification()
    end
end

-- Rechazar llamada
function rejectCall()
    triggerServerEvent("phone:hangup", localPlayer)
    hideIncomingCallNotification()
end

-- Evento: Llamada contestada
addEvent("phone:callAnswered", true)
addEventHandler("phone:callAnswered", resourceRoot, function(callId)
    isInCall = true
    callFrequency = getElementData(localPlayer, "phone:callFrequency")
    
    -- Configurar chat de voz
    setupCallVoiceChat()
    
    -- Notificar al navegador del teléfono
    if browserContent and isElement(browserContent) then
        executeBrowserJavascript(browserContent, "onCallAnswered();")
    end
end)

-- Evento: Llamada finalizada
addEvent("phone:callEnded", true)
addEventHandler("phone:callEnded", resourceRoot, function(reason)
    isInCall = false
    callFrequency = nil
    callSpeakerEnabled = false
    
    -- Terminar chat de voz
    endCallVoiceChat()
    
    -- Ocultar notificación si existe
    hideIncomingCallNotification()
    
    -- Notificar al navegador del teléfono
    if browserContent and isElement(browserContent) then
        executeBrowserJavascript(browserContent, "onCallEnded();")
    end
    
    -- Mostrar mensaje
    if reason then
        outputChatBox(reason, 255, 255, 255)
    end
end)

-- Configurar chat de voz durante la llamada
function setupCallVoiceChat()
    -- El sistema de voz ya está configurado en el servidor
    -- Aquí solo verificamos el estado
    local callPartner = getElementData(localPlayer, "phone:callPartner")
    if callPartner then
        -- La voz ya está configurada para que ambos se escuchen
        -- La proximidad se manejará automáticamente
    end
end

-- Terminar chat de voz
function endCallVoiceChat()
    -- Limpiar configuración de voz
    setElementData(localPlayer, "phone:callFrequency", nil)
    setElementData(localPlayer, "phone:inCall", false)
end

-- Manejar teclas R y C durante llamadas
addEventHandler("onClientKey", root, function(key, press)
    if not press then
        return
    end
    
    -- Tecla R: Contestar llamada (sobrescribe recargar)
    if key == "r" then
        local incomingCallId = getElementData(localPlayer, "phone:incomingCallId")
        if incomingCallId then
            cancelEvent()
            answerCall(incomingCallId)
            return
        end
    end
    
    -- Tecla C: Colgar llamada
    if key == "c" then
        if isInCall or getElementData(localPlayer, "phone:incomingCallId") then
            cancelEvent()
            rejectCall()
            return
        end
    end
end)

-- Evento: Activar/desactivar altavoz
addEvent("phone:toggleSpeaker", true)
addEventHandler("phone:toggleSpeaker", resourceRoot, function(enabled)
    callSpeakerEnabled = enabled
    setElementData(localPlayer, "phone:speakerEnabled", enabled)
end)

-- Sistema de proximidad y altavoz para escuchar llamadas
addEventHandler("onClientRender", root, function()
    if not isInCall then
        return
    end
    
    local callPartner = getElementData(localPlayer, "phone:callPartner")
    if not callPartner or not isElement(callPartner) then
        return
    end
    
    -- Obtener estado del altavoz
    local speakerEnabled = getElementData(localPlayer, "phone:speakerEnabled") or false
    local partnerSpeakerEnabled = getElementData(callPartner, "phone:speakerEnabled") or false
    
    -- Obtener jugadores cercanos (dentro de 20 metros)
    local localX, localY, localZ = getElementPosition(localPlayer)
    local nearbyPlayers = {}
    
    for _, player in ipairs(getElementsByType("player")) do
        if player ~= localPlayer and player ~= callPartner and isElementStreamedIn(player) then
            local x, y, z = getElementPosition(player)
            local distance = getDistanceBetweenPoints3D(localX, localY, localZ, x, y, z)
            
            if distance <= 20 then
                table.insert(nearbyPlayers, player)
            end
        end
    end
    
    -- Si hay jugadores cercanos y el altavoz está activo, permitir que escuchen al otro lado
    if #nearbyPlayers > 0 and (speakerEnabled or partnerSpeakerEnabled) then
        -- Los jugadores cercanos podrán escuchar al otro lado de la llamada
        -- Esto se maneja automáticamente por el sistema de voz de MTA
        -- Solo necesitamos asegurarnos de que el broadcast esté configurado correctamente
    end
end)

-- Obtener browserContent desde phone.lua
local function getBrowserContent()
    -- Intentar obtener desde phone.lua
    local phoneResource = getResourceFromName("colombia-rp")
    if phoneResource then
        -- El browserContent se define en phone.lua, lo obtenemos mediante eventos
        return nil -- Se obtendrá mediante eventos
    end
    return nil
end

-- Evento para recibir browserContent desde phone.lua
addEvent("phone:setBrowserContent", true)
addEventHandler("phone:setBrowserContent", resourceRoot, function(browser)
    browserContent = browser
end)

-- Función para ejecutar JavaScript en el navegador
local function executePhoneJS(code)
    if browserContent and isElement(browserContent) then
        executeBrowserJavascript(browserContent, code)
    end
end

