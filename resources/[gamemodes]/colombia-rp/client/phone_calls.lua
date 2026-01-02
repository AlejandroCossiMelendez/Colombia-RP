-- Sistema de Llamadas Telefónicas - Cliente

local incomingCallNotification = nil
local isInCall = false
local callFrequency = nil
local callSpeakerEnabled = false
local incomingCallPushNotification = nil
local incomingCallSound = nil

-- Evento: Llamada entrante
addEvent("phone:incomingCall", true)
addEventHandler("phone:incomingCall", root, function(callerNumber, callerName, callId)
    outputChatBox("DEBUG: Llamada entrante recibida - " .. tostring(callerNumber), 0, 255, 0)
    
    -- Reproducir sonido de llamada entrante (usar sonido del juego)
    playSoundFrontEnd(40) -- Sonido de notificación del juego
    
    -- Mostrar notificación de llamada entrante (sin pausar el juego)
    showIncomingCallNotification(callerNumber, callerName, callId)
    
    -- Mostrar notificación push grande en pantalla
    showIncomingCallPushNotification(callerNumber, callerName)
end)

-- Mostrar notificación push grande en pantalla
function showIncomingCallPushNotification(callerNumber, callerName)
    -- Crear notificación DX grande y visible
    incomingCallPushNotification = {
        callerName = callerName,
        callerNumber = callerNumber,
        startTime = getTickCount(),
        alpha = 255
    }
    
    -- Reproducir sonido de llamada (usar un sonido del juego o crear uno)
    -- Intentar reproducir sonido de notificación
    if not incomingCallSound then
        -- Usar un sonido del juego como alternativa
        playSoundFrontEnd(40) -- Sonido de notificación
    end
    
    -- Crear render para mostrar la notificación DX
    addEventHandler("onClientRender", root, renderIncomingCallNotification)
end

-- Renderizar notificación DX de llamada entrante
function renderIncomingCallNotification()
    if not incomingCallPushNotification then
        removeEventHandler("onClientRender", root, renderIncomingCallNotification)
        return
    end
    
    local screenW, screenH = guiGetScreenSize()
    local elapsed = getTickCount() - incomingCallPushNotification.startTime
    
    -- La notificación aparece desde arriba y se desvanece después de 10 segundos
    if elapsed > 10000 then
        incomingCallPushNotification = nil
        removeEventHandler("onClientRender", root, renderIncomingCallNotification)
        return
    end
    
    -- Calcular posición Y (animación de entrada)
    local targetY = 50
    local startY = -150
    local progress = math.min(elapsed / 500, 1) -- Animación de 500ms
    local currentY = startY + (targetY - startY) * progress
    
    -- Calcular alpha (parpadeo)
    local alpha = 255
    if elapsed > 8000 then
        -- Desvanecer en los últimos 2 segundos
        alpha = 255 * (1 - (elapsed - 8000) / 2000)
    else
        -- Parpadeo suave
        alpha = 200 + math.sin(elapsed / 200) * 55
    end
    
    -- Fondo semi-transparente
    dxDrawRectangle(screenW/2 - 250, currentY, 500, 120, tocolor(0, 0, 0, alpha * 0.8), false)
    dxDrawRectangle(screenW/2 - 250, currentY, 500, 5, tocolor(0, 150, 255, alpha), false)
    
    -- Texto principal
    dxDrawText("📞 LLAMADA ENTRANTE", screenW/2, currentY + 10, screenW/2, currentY + 10, tocolor(255, 255, 255, alpha), 1.2, "default-bold", "center", "top", false, false, false, true)
    dxDrawText(incomingCallPushNotification.callerName, screenW/2, currentY + 35, screenW/2, currentY + 35, tocolor(255, 255, 255, alpha), 1.5, "default-bold", "center", "top", false, false, false, true)
    dxDrawText(incomingCallPushNotification.callerNumber, screenW/2, currentY + 60, screenW/2, currentY + 60, tocolor(200, 200, 200, alpha), 1.0, "default", "center", "top", false, false, false, true)
    dxDrawText("Presiona R para contestar | C para rechazar", screenW/2, currentY + 85, screenW/2, currentY + 85, tocolor(150, 150, 150, alpha), 0.8, "default", "center", "top", false, false, false, true)
end

-- Mostrar notificación de llamada entrante
function showIncomingCallNotification(callerNumber, callerName, callId)
    -- Crear notificación visual pequeña en la esquina
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
end

-- Ocultar notificación
function hideIncomingCallNotification()
    if incomingCallNotification then
        destroyElement(incomingCallNotification)
        incomingCallNotification = nil
    end
    
    -- Ocultar notificación push
    if incomingCallPushNotification then
        incomingCallPushNotification = nil
        removeEventHandler("onClientRender", root, renderIncomingCallNotification)
    end
    
    -- Detener sonido
    if incomingCallSound then
        stopSound(incomingCallSound)
        incomingCallSound = nil
    end
    
    setElementData(localPlayer, "phone:incomingCallId", nil)
end

-- Contestar llamada
function answerCall(callId)
    if not callId then
        callId = getElementData(localPlayer, "phone:incomingCallId")
    end
    
    if not callId then
        outputChatBox("Error: No se pudo obtener el ID de la llamada.", 255, 0, 0)
        return
    end
    
    outputChatBox("Contestando llamada...", 0, 255, 0)
    
    -- Enviar evento al servidor
    triggerServerEvent("phone:answerCall", localPlayer, callId)
    
    -- Ocultar notificación
    hideIncomingCallNotification()
    
    -- Marcar como en llamada
    isInCall = true
end

-- Rechazar llamada
function rejectCall()
    triggerServerEvent("phone:hangup", localPlayer)
    hideIncomingCallNotification()
end

-- Evento: Llamada contestada
addEvent("phone:callAnswered", true)
addEventHandler("phone:callAnswered", root, function(callId)
    isInCall = true
    
    outputChatBox("Llamada contestada. Presiona C para colgar.", 0, 255, 0)
    
    -- Configurar chat de voz
    setupCallVoiceChat()
    
    -- Obtener información del navegador del teléfono
    local browser = getElementData(localPlayer, "phone:browserContent")
    if browser and isElement(browser) then
        executeBrowserJavascript(browser, "if (typeof onCallAnswered === 'function') { onCallAnswered(); }")
    end
end)

-- Evento: Llamada finalizada
addEvent("phone:callEnded", true)
addEventHandler("phone:callEnded", root, function(reason)
    isInCall = false
    callFrequency = nil
    callSpeakerEnabled = false
    
    outputChatBox("Llamada finalizada. Voz de proximidad restaurada.", 255, 255, 0)
    
    -- Terminar chat de voz
    endCallVoiceChat()
    
    -- Ocultar notificación si existe
    hideIncomingCallNotification()
    
    -- Limpiar datos
    setElementData(localPlayer, "phone:incomingCallId", nil)
    setElementData(localPlayer, "phone:callPartner", nil)
    setElementData(localPlayer, "phone:inCall", false)
    
    -- Obtener información del navegador del teléfono
    local browser = getElementData(localPlayer, "phone:browserContent")
    if browser and isElement(browser) then
        executeBrowserJavascript(browser, "if (typeof onCallEnded === 'function') { onCallEnded(); }")
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
    setElementData(localPlayer, "phone:callPartner", nil)
    setElementData(localPlayer, "phone:speakerEnabled", false)
    
    -- La voz se restaura automáticamente en el servidor
    -- Solo limpiamos los datos locales aquí
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
addEventHandler("phone:toggleSpeaker", root, function(enabled)
    callSpeakerEnabled = enabled
    setElementData(localPlayer, "phone:speakerEnabled", enabled)
    
    if enabled then
        outputChatBox("Altavoz activado. Los jugadores cercanos pueden escuchar.", 0, 255, 0)
    else
        outputChatBox("Altavoz desactivado.", 255, 255, 0)
    end
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

