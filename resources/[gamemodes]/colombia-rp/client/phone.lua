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
        -- Notificar a phone_calls.lua y jbl_panel.lua sobre el browserContent
        triggerEvent("phone:setBrowserContent", resourceRoot, browserContent)
        setElementData(localPlayer, "phone:browserContent", browserContent)
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
        
        -- Exponer función global para abrir navegador web desde JavaScript
        executeBrowserJavascript(browserContent, [[
            window.openMTAWebBrowser = function(url) {
                if (window.mta && window.mta.triggerEvent) {
                    window.mta.triggerEvent('phone:browserNavigate', url);
                } else {
                    console.error('MTA no disponible');
                }
            };
        ]])
        
        -- Enviar el número de teléfono al navegador
        local phoneNumber = getElementData(localPlayer, "phone:number")
        if phoneNumber then
            executeBrowserJavascript(browserContent, "setMyPhoneNumber('" .. tostring(phoneNumber) .. "');")
        end
        
        -- Los contactos se cargarán desde el evento openPhone del servidor
        -- No necesitamos cargarlos aquí porque ya vienen con el evento
        
        -- Solicitar estado de llamada activa cuando el navegador está listo
        -- Esto asegura que si hay una llamada activa, se muestre al abrir el teléfono
        setTimer(function()
            triggerServerEvent("phone:requestCallStatus", localPlayer)
        end, 500, 1)
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
    
    -- Verificar que el personaje esté completamente seleccionado antes de abrir el teléfono
    local characterSelected = getElementData(localPlayer, "character:selected")
    local characterId = getElementData(localPlayer, "character:id")
    
    if not characterSelected or not characterId then
        outputChatBox("Espera a que tu personaje esté completamente cargado.", 255, 165, 0)
        return
    end
    
    -- Cerrar inventario si está abierto (usar evento para evitar dependencias)
    triggerEvent("closeInventoryForPhone", localPlayer)
    
    -- Animación: Sacar teléfono (PHONE_OUT)
    setPedAnimation(localPlayer, "PED", "PHONE_OUT", -1, false, false, false, false)
    
    phoneVisible = true
    -- Guardar estado del teléfono en elementData para que otros scripts puedan verificar
    setElementData(localPlayer, "phone:visible", true)
    -- Posición: 30px más a la izquierda y un poco más abajo
    local phoneX = (sw - w) - 130
    local phoneY = (sh - h) / 2 + 180  -- Bajarlo 190px más
    phoneBrowser = guiCreateBrowser(phoneX, phoneY, w, h, true, true, false)
    browserContent = guiGetBrowser(phoneBrowser)
    
    if not phoneBrowser or not browserContent then
        outputChatBox("Error: No se pudo crear el navegador del teléfono", 255, 0, 0)
        phoneVisible = false
        -- Limpiar animación si falla
        setPedAnimation(localPlayer, false)
        return
    end
    
    guiSetInputMode("no_binds_when_editing")
    showCursor(true)
    guiSetInputEnabled(true)
    
    addEventHandler("onClientBrowserCreated", phoneBrowser, loadPhoneBrowser)
    addEventHandler("onClientBrowserDocumentReady", phoneBrowser, whenPhoneBrowserReady)
    
    renderTime(true)
    
    -- Después de la animación de sacar teléfono, cambiar a animación de usar apps (si no está en llamada)
    setTimer(function()
        if phoneVisible and not getElementData(localPlayer, "phone:inCall") then
            -- Animación para usar apps/mensajes (COPLOOK_THINK)
            setPedAnimation(localPlayer, "COP_AMBIENT", "COPLOOK_THINK", -1, true, false, false, false)
        end
    end, 1500, 1) -- Esperar 1.5 segundos para que termine PHONE_OUT
end

-- Función auxiliar para restaurar controles del juego
local function restoreGameControls()
    showCursor(false)
    guiSetInputEnabled(false)
    guiSetInputMode("allow_binds")
    
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
end

function closePhone()
    if not phoneVisible then
        return
    end
    
    phoneVisible = false
    -- Actualizar estado del teléfono en elementData
    setElementData(localPlayer, "phone:visible", false)
    
    -- Animación: Guardar teléfono (PHONE_IN)
    setPedAnimation(localPlayer, "PED", "PHONE_IN", -1, false, false, false, false)
    
    -- PRIMERO: Ocultar el navegador INMEDIATAMENTE para que desaparezca visualmente
    if phoneBrowser and isElement(phoneBrowser) then
        guiSetVisible(phoneBrowser, false)
    end
    
    -- SEGUNDO: Restaurar controles del juego INMEDIATAMENTE (múltiples veces para asegurar)
    restoreGameControls()
    restoreGameControls() -- Doble verificación
    
    -- TERCERO: Detener el renderizado del tiempo
    renderTime(false)
    
    -- CUARTO: Remover event handlers
    if phoneBrowser and isElement(phoneBrowser) then
        removeEventHandler("onClientBrowserCreated", phoneBrowser, loadPhoneBrowser)
        removeEventHandler("onClientBrowserDocumentReady", phoneBrowser, whenPhoneBrowserReady)
    end
    
    -- QUINTO: Restaurar controles inmediatamente después de remover handlers
    restoreGameControls()
    
    -- SEXTO: Destruir el navegador después de un pequeño delay
    setTimer(function()
        if phoneBrowser and isElement(phoneBrowser) then
            destroyElement(phoneBrowser)
            phoneBrowser = nil
            browserContent = nil
        end
        
        -- Limpiar animación después de que termine PHONE_IN
        setPedAnimation(localPlayer, false)
        
        -- Restaurar controles nuevamente después de destruir el navegador
        restoreGameControls()
        
        -- Notificar que el teléfono se cerró
        triggerEvent("phoneClosed", localPlayer)
    end, 1500, 1) -- Esperar 1.5 segundos para que termine la animación PHONE_IN
    
    -- SÉPTIMO: Restaurar controles múltiples veces con diferentes delays para asegurar
    setTimer(function()
        restoreGameControls()
    end, 10, 1)
    
    setTimer(function()
        restoreGameControls()
    end, 25, 1)
    
    setTimer(function()
        restoreGameControls()
    end, 100, 1)
    
    setTimer(function()
        restoreGameControls()
    end, 200, 1)
end

-- Evento para guardar contactos (desde el navegador)
addEvent("saveContacts", true)
addEventHandler("saveContacts", resourceRoot, function(contactsJson)
    local characterId = getElementData(localPlayer, "character:id")
    if not characterId then
        outputChatBox("Error: No se pudo obtener el ID del personaje para guardar contactos.", 255, 0, 0)
        return
    end
    
    if contactsJson and type(contactsJson) == "string" then
        -- Enviar al servidor usando localPlayer como fuente
        triggerServerEvent("saveContacts", localPlayer, contactsJson)
    end
end)

-- Evento del servidor para abrir el teléfono
addEvent("openPhone", true)
addEventHandler("openPhone", resourceRoot, function(phoneNumber, contactsList)
    -- Verificar que el personaje esté completamente seleccionado antes de abrir el teléfono
    local characterSelected = getElementData(localPlayer, "character:selected")
    local characterId = getElementData(localPlayer, "character:id")
    
    if not characterSelected or not characterId then
        outputChatBox("Espera a que tu personaje esté completamente cargado antes de usar el teléfono.", 255, 165, 0)
        return
    end
    
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
            
            -- Cargar contactos (puede ser una lista vacía)
            local jsonStr = "["
            if contactsList and type(contactsList) == "table" then
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

-- Función para verificar si hay un input activo en el teléfono
local function isPhoneInputActive()
    if not browserContent or not isElement(browserContent) or not phoneVisible then
        return false
    end
    
    -- Intentar ejecutar JavaScript para verificar si hay un input activo
    -- Como no podemos obtener el resultado directamente, asumimos que si el teléfono está abierto
    -- y el cursor está visible, podría haber un input activo
    -- Por ahora, simplemente verificamos si el teléfono está visible
    return phoneVisible
end

-- Usar onClientKey en lugar de bindKey para capturar las teclas antes de que el navegador las capture
-- Esto es necesario porque cuando el teléfono está abierto, el navegador captura todas las teclas
addEventHandler("onClientKey", root, function(key, press)
    -- Solo procesar cuando se presiona la tecla (no cuando se suelta)
    if not press then
        return
    end
    
    -- Solo procesar si el teléfono está abierto
    if not phoneVisible then
        return
    end
    
    -- Procesar tecla "m" para cerrar el teléfono
    if key == "m" then
        -- Verificar si hay un personaje seleccionado
        if not getElementData(localPlayer, "character:selected") then
            return
        end
        
        -- Guardar contactos antes de cerrar
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "saveContactsToMTA();")
        end
        -- Cerrar el teléfono inmediatamente
        closePhone()
        -- Cancelar el evento para evitar que el navegador lo procese y que el cursor toggle lo procese
        cancelEvent()
        return
    end
    
    -- Procesar tecla ESC para cerrar el teléfono
    if key == "escape" then
        -- Guardar contactos antes de cerrar
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, "saveContactsToMTA();")
        end
        closePhone()
        cancelEvent()
        return
    end
end)

-- Cerrar teléfono al detener el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    closePhone()
end)

-- Eventos de llamadas telefónicas
addEvent("phone:makeCall", true)
addEventHandler("phone:makeCall", resourceRoot, function(phoneNumber)
    if phoneNumber and type(phoneNumber) == "string" then
        triggerServerEvent("phone:makeCall", localPlayer, phoneNumber)
    end
end)

addEvent("phone:hangup", true)
addEventHandler("phone:hangup", resourceRoot, function()
    triggerServerEvent("phone:hangup", localPlayer)
end)

addEvent("phone:toggleSpeaker", true)
addEventHandler("phone:toggleSpeaker", resourceRoot, function(enabled)
    if type(enabled) == "boolean" then
        triggerServerEvent("phone:toggleSpeaker", localPlayer, enabled)
    end
end)

-- Eventos del servidor para el navegador
addEvent("phone:callRinging", true)
addEventHandler("phone:callRinging", resourceRoot, function(phoneNumber)
    if browserContent and isElement(browserContent) then
        executeBrowserJavascript(browserContent, "onCallStarted(null, '" .. phoneNumber .. "', false);")
    end
end)

addEvent("phone:callFailed", true)
addEventHandler("phone:callFailed", resourceRoot, function(reason)
    if browserContent and isElement(browserContent) then
        -- Limpiar estado de llamada y restaurar controles
        executeBrowserJavascript(browserContent, "if (typeof onCallEnded === 'function') { onCallEnded(); }")
        -- Asegurar que se restauren los controles
        executeBrowserJavascript(browserContent, "if (typeof hideCallStatus === 'function') { hideCallStatus(); }")
    end
end)

-- Sistema de navegador web secundario para la app del navegador
local webBrowser = nil
local webBrowserContent = nil
local webBrowserVisible = false
local webBrowserUrl = nil

function loadWebBrowser()
    -- Cuando el navegador se crea, cargar la URL guardada
    if webBrowserContent and isElement(webBrowserContent) and webBrowserUrl then
        outputChatBox("[DEBUG] Cargando URL en navegador (evento): " .. tostring(webBrowserUrl), 0, 255, 255)
        -- Usar múltiples intentos para asegurar que se cargue
        loadBrowserURL(webBrowserContent, webBrowserUrl)
        setTimer(function()
            if webBrowserContent and isElement(webBrowserContent) and webBrowserUrl then
                loadBrowserURL(webBrowserContent, webBrowserUrl)
            end
        end, 200, 1)
    end
end

function whenWebBrowserReady()
    -- El navegador web está listo
    if webBrowserContent and isElement(webBrowserContent) then
        outputChatBox("[DEBUG] Navegador web listo", 0, 255, 0)
        
        -- Notificar al navegador del teléfono que el navegador web se abrió
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, [[
                const homeScreen = document.getElementById('browserHomeScreen');
                if (homeScreen) {
                    homeScreen.style.display = 'none';
                }
            ]])
        end
    end
end

function openWebBrowser(url)
    if not url or url == "" then
        outputChatBox("[DEBUG] URL vacía o inválida", 255, 0, 0)
        return
    end
    
    outputChatBox("[DEBUG] Abriendo navegador web con URL: " .. tostring(url), 0, 255, 255)
    
    -- Guardar la URL
    webBrowserUrl = url
    
    -- Si ya existe, solo cambiar la URL
    if webBrowser and isElement(webBrowser) then
        if webBrowserContent and isElement(webBrowserContent) then
            loadBrowserURL(webBrowserContent, url)
            outputChatBox("[DEBUG] Navegador existente, cambiando URL", 0, 255, 255)
        end
        guiSetVisible(webBrowser, true)
        webBrowserVisible = true
        
        -- Ocultar mensaje en el teléfono
        if browserContent and isElement(browserContent) then
            executeBrowserJavascript(browserContent, [[
                const homeScreen = document.getElementById('browserHomeScreen');
                if (homeScreen) {
                    homeScreen.style.display = 'none';
                }
            ]])
        end
        return
    end
    
    -- Crear nuevo navegador web
    local sw, sh = guiGetScreenSize()
    local browserWidth = math.min(1200, sw - 100)
    local browserHeight = math.min(800, sh - 100)
    local browserX = (sw - browserWidth) / 2
    local browserY = (sh - browserHeight) / 2
    
    outputChatBox("[DEBUG] Creando nuevo navegador web...", 0, 255, 255)
    webBrowser = guiCreateBrowser(browserX, browserY, browserWidth, browserHeight, true, true, false)
    webBrowserContent = guiGetBrowser(webBrowser)
    
    if not webBrowser or not webBrowserContent then
        outputChatBox("Error: No se pudo crear el navegador web", 255, 0, 0)
        return
    end
    
    outputChatBox("[DEBUG] Navegador creado exitosamente", 0, 255, 0)
    webBrowserVisible = true
    guiSetInputMode("no_binds_when_editing")
    showCursor(true)
    guiSetInputEnabled(true)
    
    -- Cargar la URL después de que el navegador esté creado
    addEventHandler("onClientBrowserCreated", webBrowser, loadWebBrowser)
    addEventHandler("onClientBrowserDocumentReady", webBrowser, whenWebBrowserReady)
    
    -- Intentar cargar la URL con múltiples intentos para asegurar que funcione
    setTimer(function()
        if webBrowserContent and isElement(webBrowserContent) and webBrowserUrl then
            outputChatBox("[DEBUG] Intento 1 - Cargando URL: " .. tostring(webBrowserUrl), 0, 255, 255)
            loadBrowserURL(webBrowserContent, webBrowserUrl)
        end
    end, 100, 1)
    
    setTimer(function()
        if webBrowserContent and isElement(webBrowserContent) and webBrowserUrl then
            outputChatBox("[DEBUG] Intento 2 - Cargando URL: " .. tostring(webBrowserUrl), 0, 255, 255)
            loadBrowserURL(webBrowserContent, webBrowserUrl)
        end
    end, 300, 1)
    
    setTimer(function()
        if webBrowserContent and isElement(webBrowserContent) and webBrowserUrl then
            outputChatBox("[DEBUG] Intento 3 - Cargando URL: " .. tostring(webBrowserUrl), 0, 255, 255)
            loadBrowserURL(webBrowserContent, webBrowserUrl)
        end
    end, 600, 1)
    
    -- Notificar inmediatamente al navegador del teléfono que se está abriendo
    if browserContent and isElement(browserContent) then
        setTimer(function()
            if browserContent and isElement(browserContent) then
                executeBrowserJavascript(browserContent, [[
                    const homeScreen = document.getElementById('browserHomeScreen');
                    if (homeScreen) {
                        homeScreen.style.display = 'none';
                    }
                ]])
            end
        end, 500, 1) -- Esperar 500ms para que el navegador se cree
    end
end

function closeWebBrowser()
    if not webBrowserVisible then
        return
    end
    
    webBrowserVisible = false
    
    if webBrowser and isElement(webBrowser) then
        guiSetVisible(webBrowser, false)
        removeEventHandler("onClientBrowserCreated", webBrowser, loadWebBrowser)
        removeEventHandler("onClientBrowserDocumentReady", webBrowser, whenWebBrowserReady)
        
        setTimer(function()
            if webBrowser and isElement(webBrowser) then
                destroyElement(webBrowser)
                webBrowser = nil
                webBrowserContent = nil
            end
        end, 50, 1)
    end
    
    showCursor(false)
    guiSetInputEnabled(false)
    guiSetInputMode("allow_binds")
end

-- Evento desde el navegador del teléfono para abrir navegador web
addEvent("phone:browserNavigate", true)
addEventHandler("phone:browserNavigate", resourceRoot, function(url)
    outputChatBox("[DEBUG] Evento phone:browserNavigate recibido. URL: " .. tostring(url), 255, 255, 0)
    if url and type(url) == "string" and url ~= "" then
        outputChatBox("[DEBUG] Llamando a openWebBrowser con: " .. url, 255, 255, 0)
        openWebBrowser(url)
    else
        outputChatBox("[DEBUG] URL inválida o vacía", 255, 0, 0)
    end
end)

-- Cerrar navegador web con ESC
addEventHandler("onClientKey", root, function(key, press)
    if not press then return end
    
    if key == "escape" and webBrowserVisible then
        closeWebBrowser()
        cancelEvent()
        return
    end
end)

