-- Sistema de Teléfono Móvil
-- Basado en phone-example pero integrado en colombia-rp

local sw, sh = guiGetScreenSize()
local phoneVisible = false
local phoneBrowser, browserContent, renderTimer = nil
local w, h = 300, 570  -- Reducido un 10% (300*0.9 = 270, 570*0.9 = 513)

function loadPhoneBrowser() 
    if source and isElement(source) then
        loadBrowserURL(source, "http://mta/local/html/phone.html")
    end
end

function whenPhoneBrowserReady()
    -- El navegador está listo
    if browserContent and isElement(browserContent) then
        executeBrowserJavascript(browserContent, "updateTime();")
        -- Asegurar que el teléfono se abra directamente en el home
        executeBrowserJavascript(browserContent, [[
            const lock = document.querySelector('.lock-screen');
            const unlock = document.querySelector('.unlock-screen');
            if (lock && unlock) {
                lock.style.display = 'none';
                unlock.style.display = 'flex';
            }
        ]])
        
        -- Enviar el número de teléfono al navegador
        local phoneNumber = getElementData(localPlayer, "phone:number")
        if phoneNumber then
            executeBrowserJavascript(browserContent, "setMyPhoneNumber('" .. tostring(phoneNumber) .. "');")
        end
    end
end

function renderTime(bool)
    if bool then         
        if renderTimer and isTimer(renderTimer) then
            killTimer(renderTimer)
        end
        renderTimer = setTimer(
            function () 
                if browserContent and isElement(browserContent) then
                    executeBrowserJavascript(browserContent, "updateTime();")
                end
            end, 1000, 0
        )
    else
        if renderTimer and isTimer(renderTimer) then
            killTimer(renderTimer)
            renderTimer = nil
        end
    end
end

function openPhone()
    if phoneVisible then
        return
    end
    
    -- Cerrar inventario si está abierto (usar evento para evitar dependencias)
    triggerEvent("closeInventoryForPhone", localPlayer)
    
    phoneVisible = true
    -- Posición: 30px más a la izquierda y un poco más abajo
    local phoneX = (sw - w) - 130
    local phoneY = (sh - h) / 2 + 180  -- Bajarlo 190px más
    phoneBrowser = guiCreateBrowser(phoneX, phoneY, w, h, true, true, false)
    browserContent = guiGetBrowser(phoneBrowser)
    
    if not phoneBrowser or not browserContent then
        outputChatBox("Error: No se pudo crear el navegador del teléfono", 255, 0, 0)
        phoneVisible = false
        return
    end
    
    guiSetInputMode("no_binds_when_editing")
    showCursor(true)
    guiSetInputEnabled(true)
    
    addEventHandler("onClientBrowserCreated", phoneBrowser, loadPhoneBrowser)
    addEventHandler("onClientBrowserDocumentReady", phoneBrowser, whenPhoneBrowserReady)
    
    renderTime(true)
end

-- Variable para rastrear si necesitamos forzar el cursor oculto
local forceCursorHidden = false

function closePhone()
    if not phoneVisible then
        return
    end
    
    phoneVisible = false
    forceCursorHidden = true  -- Activar flag para forzar cursor oculto
    
    -- PRIMERO: Remover event handlers ANTES de hacer cualquier cosa
    if phoneBrowser and isElement(phoneBrowser) then
        removeEventHandler("onClientBrowserCreated", phoneBrowser, loadPhoneBrowser)
        removeEventHandler("onClientBrowserDocumentReady", phoneBrowser, whenPhoneBrowserReady)
    end
    
    -- SEGUNDO: Ocultar el navegador inmediatamente
    if phoneBrowser and isElement(phoneBrowser) then
        guiSetVisible(phoneBrowser, false)
    end
    
    -- TERCERO: DESTRUIR el navegador INMEDIATAMENTE para que deje de capturar eventos
    if phoneBrowser and isElement(phoneBrowser) then
        destroyElement(phoneBrowser)
        phoneBrowser = nil
        browserContent = nil
    end
    
    renderTime(false)
    
    -- CUARTO: Restaurar controles del juego INMEDIATAMENTE - FORZAR MÚLTIPLES VECES
    showCursor(false)
    guiSetInputEnabled(false)
    guiSetInputMode("allow_binds")
    
    -- Repetir inmediatamente varias veces
    showCursor(false)
    guiSetInputEnabled(false)
    guiSetInputMode("allow_binds")
    showCursor(false)
    guiSetInputEnabled(false)
    guiSetInputMode("allow_binds")
    
    -- QUINTO: Forzar restauración de TODOS los controles inmediatamente
    local controlsToEnable = {
        "fire", "next_weapon", "previous_weapon", "forwards", "backwards", 
        "left", "right", "jump", "sprint", "crouch", "walk", "enter_exit",
        "vehicle_fire", "vehicle_secondary_fire", "steer_forward", "steer_back",
        "accelerate", "brake_reverse", "handbrake", "horn", "sub_mission",
        "radio_next", "radio_previous", "radio_user_track_skip",
        "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind",
        "vehicle_mouse_look", "special_control_left", "special_control_right",
        "special_control_up", "special_control_down", "aim_weapon",
        "conversation_yes", "conversation_no", "group_control_forwards",
        "group_control_back", "enter_passenger", "cycle_weapon_left",
        "cycle_weapon_right", "change_camera", "vehicle_next_radio", "vehicle_prev_radio"
    }
    
    for _, control in ipairs(controlsToEnable) do
        toggleControl(control, true)
    end
    
    -- SEXTO: Forzar restauración múltiple veces de forma MUY AGRESIVA
    -- Ejecutar inmediatamente (delay 0)
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
    end, 0, 1)
    
    -- Ejecutar después de 5ms
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
    end, 5, 1)
    
    -- Ejecutar después de 10ms
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
    end, 10, 1)
    
    -- Ejecutar después de 25ms
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
    end, 25, 1)
    
    -- Ejecutar después de 50ms
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
    end, 50, 1)
    
    -- Ejecutar después de 100ms
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
        triggerEvent("phoneClosed", localPlayer)
    end, 100, 1)
    
    -- Ejecutar después de 200ms (verificación final)
    setTimer(function()
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
        for _, control in ipairs(controlsToEnable) do
            toggleControl(control, true)
        end
        forceCursorHidden = false  -- Desactivar flag después de 200ms
    end, 200, 1)
    
    -- Notificar inmediatamente que el teléfono se cerró
    triggerEvent("phoneClosed", localPlayer)
end

-- Handler para forzar cursor oculto después de cerrar el teléfono
addEventHandler("onClientRender", root, function()
    if forceCursorHidden and isCursorShowing() then
        showCursor(false)
        guiSetInputEnabled(false)
        guiSetInputMode("allow_binds")
    end
end)

-- Evento del servidor para abrir el teléfono
addEvent("openPhone", true)
addEventHandler("openPhone", resourceRoot, function(phoneNumber, contactsList)
    if phoneNumber then
        -- Guardar el número de teléfono en el elemento data del jugador
        setElementData(localPlayer, "phone:number", phoneNumber)
    end
    openPhone()
    
    -- Enviar el número y contactos al navegador cuando esté listo
    setTimer(function()
        if browserContent and isElement(browserContent) then
            if phoneNumber then
                executeBrowserJavascript(browserContent, "setMyPhoneNumber('" .. tostring(phoneNumber) .. "');")
            end
            if contactsList and type(contactsList) == "table" and #contactsList > 0 then
                -- Convertir tabla a JSON manualmente
                local jsonStr = "["
                for i, contact in ipairs(contactsList) do
                    if i > 1 then jsonStr = jsonStr .. "," end
                    jsonStr = jsonStr .. "{"
                    jsonStr = jsonStr .. "\"name\":\"" .. (contact.name or ""):gsub("\"", "\\\"") .. "\","
                    jsonStr = jsonStr .. "\"number\":\"" .. (contact.number or ""):gsub("\"", "\\\"") .. "\""
                    jsonStr = jsonStr .. "}"
                end
                jsonStr = jsonStr .. "]"
                executeBrowserJavascript(browserContent, "loadContactsFromServer('" .. jsonStr .. "');")
            end
        end
    end, 500, 1)
end)

-- Evento para recibir contactos del servidor
addEvent("receiveContacts", true)
addEventHandler("receiveContacts", resourceRoot, function(contactsList)
    if browserContent and isElement(browserContent) and contactsList then
        -- Convertir tabla a JSON manualmente
        local jsonStr = "["
        if contactsList and #contactsList > 0 then
            for i, contact in ipairs(contactsList) do
                if i > 1 then jsonStr = jsonStr .. "," end
                jsonStr = jsonStr .. "{"
                jsonStr = jsonStr .. "\"name\":\"" .. (contact.name or ""):gsub("\"", "\\\"") .. "\","
                jsonStr = jsonStr .. "\"number\":\"" .. (contact.number or ""):gsub("\"", "\\\"") .. "\""
                jsonStr = jsonStr .. "}"
            end
        end
        jsonStr = jsonStr .. "]"
        executeBrowserJavascript(browserContent, "loadContactsFromServer('" .. jsonStr .. "');")
    end
end)

-- Evento del servidor para cerrar el teléfono
addEvent("closePhone", true)
addEventHandler("closePhone", resourceRoot, function()
    closePhone()
end)

-- Evento para cerrar el teléfono desde el navegador (botón home cuando ya está en home)
addEvent("closePhoneFromBrowser", true)
addEventHandler("closePhoneFromBrowser", localPlayer, function()
    -- Guardar contactos ANTES de cerrar (si el navegador aún existe)
    if browserContent and isElement(browserContent) and phoneVisible then
        executeBrowserJavascript(browserContent, "saveContactsToMTA();")
    end
    -- Cerrar inmediatamente sin esperar (los contactos se guardan en el servidor de todas formas)
    closePhone()
end)

-- Cerrar teléfono con tecla ESC
bindKey("escape", "down", function()
    if phoneVisible then
        closePhone()
    end
end)

-- Cerrar teléfono al detener el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    closePhone()
end)

