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
    
    if phoneBrowser and isElement(phoneBrowser) then
        removeEventHandler("onClientBrowserCreated", phoneBrowser, loadPhoneBrowser)
        removeEventHandler("onClientBrowserDocumentReady", phoneBrowser, whenPhoneBrowserReady)
        guiSetInputMode("allow_binds")
        destroyElement(phoneBrowser)
        phoneBrowser = nil
        browserContent = nil
    end
    
    renderTime(false)
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Evento del servidor para abrir el teléfono
addEvent("openPhone", true)
addEventHandler("openPhone", resourceRoot, function(phoneNumber)
    if phoneNumber then
        -- Guardar el número de teléfono en el elemento data del jugador
        setElementData(localPlayer, "phone:number", phoneNumber)
        -- Mostrar el número en el teléfono (opcional, puedes agregarlo a la interfaz)
        outputChatBox("Tu número: " .. phoneNumber, 0, 255, 0)
    end
    openPhone()
    
    -- Enviar el número al navegador cuando esté listo
    setTimer(function()
        if browserContent and isElement(browserContent) and phoneNumber then
            executeBrowserJavascript(browserContent, "setMyPhoneNumber('" .. tostring(phoneNumber) .. "');")
        end
    end, 500, 1)
end)

-- Evento del servidor para cerrar el teléfono
addEvent("closePhone", true)
addEventHandler("closePhone", resourceRoot, function()
    closePhone()
end)

-- Evento para cerrar el teléfono desde el navegador (botón home cuando ya está en home)
addEvent("closePhoneFromBrowser", true)
addEventHandler("closePhoneFromBrowser", localPlayer, function()
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

