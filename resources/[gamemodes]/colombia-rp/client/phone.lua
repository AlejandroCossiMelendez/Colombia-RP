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

function closePhone()
    if not phoneVisible then
        return
    end
    
    phoneVisible = false
    
    -- Restaurar controles del juego INMEDIATAMENTE antes de destruir el navegador
    showCursor(false)
    guiSetInputEnabled(false)
    guiSetInputMode("allow_binds")
    
    -- Forzar restauración de controles inmediatamente
    toggleControl("fire", true)
    toggleControl("next_weapon", true)
    toggleControl("previous_weapon", true)
    toggleControl("forwards", true)
    toggleControl("backwards", true)
    toggleControl("left", true)
    toggleControl("right", true)
    toggleControl("jump", true)
    toggleControl("sprint", true)
    toggleControl("crouch", true)
    toggleControl("walk", true)
    toggleControl("enter_exit", true)
    toggleControl("vehicle_fire", true)
    toggleControl("vehicle_secondary_fire", true)
    toggleControl("steer_forward", true)
    toggleControl("steer_back", true)
    toggleControl("accelerate", true)
    toggleControl("brake_reverse", true)
    toggleControl("handbrake", true)
    toggleControl("horn", true)
    toggleControl("sub_mission", true)
    toggleControl("radio_next", true)
    toggleControl("radio_previous", true)
    toggleControl("radio_user_track_skip", true)
    toggleControl("vehicle_look_left", true)
    toggleControl("vehicle_look_right", true)
    toggleControl("vehicle_look_behind", true)
    toggleControl("vehicle_mouse_look", true)
    toggleControl("special_control_left", true)
    toggleControl("special_control_right", true)
    toggleControl("special_control_up", true)
    toggleControl("special_control_down", true)
    toggleControl("aim_weapon", true)
    toggleControl("conversation_yes", true)
    toggleControl("conversation_no", true)
    toggleControl("group_control_forwards", true)
    toggleControl("group_control_back", true)
    toggleControl("enter_passenger", true)
    toggleControl("cycle_weapon_left", true)
    toggleControl("cycle_weapon_right", true)
    toggleControl("change_camera", true)
    toggleControl("vehicle_next_radio", true)
    toggleControl("vehicle_prev_radio", true)
    
    if phoneBrowser and isElement(phoneBrowser) then
        removeEventHandler("onClientBrowserCreated", phoneBrowser, loadPhoneBrowser)
        removeEventHandler("onClientBrowserDocumentReady", phoneBrowser, whenPhoneBrowserReady)
        destroyElement(phoneBrowser)
        phoneBrowser = nil
        browserContent = nil
    end
    
    renderTime(false)
    
    -- Asegurar que los controles se mantengan habilitados después de un pequeño delay
    setTimer(function()
        -- Forzar restauración de controles nuevamente por si acaso
        toggleControl("fire", true)
        toggleControl("forwards", true)
        toggleControl("backwards", true)
        toggleControl("left", true)
        toggleControl("right", true)
        toggleControl("jump", true)
        toggleControl("sprint", true)
        toggleControl("crouch", true)
        toggleControl("walk", true)
        guiSetInputMode("allow_binds")
    end, 50, 1)
end

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
    -- Guardar contactos antes de cerrar (si el navegador aún existe)
    if browserContent and isElement(browserContent) then
        executeBrowserJavascript(browserContent, "saveContactsToMTA();")
        -- Pequeño delay para asegurar que se guarden los contactos, luego cerrar
        setTimer(function()
            closePhone()
        end, 50, 1)
    else
        -- Si el navegador ya no existe, cerrar inmediatamente
        closePhone()
    end
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

