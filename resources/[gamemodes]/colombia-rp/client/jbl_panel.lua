-- Panel JBL - F6
-- Sistema para activar JBL y controlar música

local screenW, screenH = guiGetScreenSize()
local jblWindow = nil
local jblActive = false
local jblObject = nil
local currentMusic = nil
local musicVolume = 0.5

-- Función helper para obtener el browser del teléfono
function getPhoneBrowser()
    -- Intentar obtener desde el recurso phone
    local phoneResource = getResourceFromName("colombia-rp")
    if phoneResource then
        -- El browser se obtiene mediante eventos o exports
        -- Por ahora, usaremos un método alternativo
        return nil -- Se obtendrá mediante eventos
    end
    return nil
end

-- Evento para recibir browserContent desde phone.lua
addEvent("phone:setBrowserContent", true)
addEventHandler("phone:setBrowserContent", resourceRoot, function(browser)
    -- Guardar referencia al browser
    setElementData(localPlayer, "phone:browserContent", browser)
end)

-- Verificar si el jugador tiene un JBL
function hasJBL()
    -- Aquí puedes verificar en el inventario si tiene el item JBL
    -- Por ahora retornamos true para pruebas
    return true
end

-- Crear panel JBL
function createJBLPanel()
    if jblWindow and isElement(jblWindow) then
        destroyElement(jblWindow)
    end
    
    if not hasJBL() then
        outputChatBox("No tienes un JBL en tu inventario.", 255, 0, 0)
        return
    end
    
    local windowWidth = 400
    local windowHeight = 300
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    jblWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Control JBL", false)
    guiWindowSetSizable(jblWindow, false)
    guiSetAlpha(jblWindow, 0.95)
    
    local titleLabel = guiCreateLabel(20, 30, windowWidth - 40, 30, "Selecciona una opción:", false, jblWindow)
    guiSetFont(titleLabel, "default-bold-small")
    
    local spotifyBtn = guiCreateButton(20, 70, windowWidth - 40, 40, "🎵 Spotify", false, jblWindow)
    addEventHandler("onClientGUIClick", spotifyBtn, function()
        closeJBLPanel()
        -- Abrir teléfono y luego abrir Spotify
        triggerEvent("openPhone", localPlayer)
        -- Esperar a que el teléfono se abra y luego abrir Spotify
        setTimer(function()
            -- Obtener browserContent desde elementData
            local browser = getElementData(localPlayer, "phone:browserContent")
            if browser and isElement(browser) then
                executeBrowserJavascript(browser, "if (typeof openApp === 'function') { openApp(8); }")
            else
                -- Intentar obtener desde el recurso directamente
                -- Esto requiere que phone.lua exponga el browser
                outputChatBox("Abre el teléfono primero y luego selecciona Spotify desde F6.", 255, 255, 0)
            end
        end, 800, 1)
    end, false)
    
    local linkBtn = guiCreateButton(20, 120, windowWidth - 40, 40, "🔗 Link (y2mate)", false, jblWindow)
    addEventHandler("onClientGUIClick", linkBtn, function()
        closeJBLPanel()
        -- Abrir panel de Link
        showLinkPanel()
    end, false)
    
    local activateBtn = guiCreateButton(20, 170, windowWidth - 40, 40, jblActive and "Desactivar JBL" or "Activar JBL", false, jblWindow)
    addEventHandler("onClientGUIClick", activateBtn, function()
        toggleJBL()
        closeJBLPanel()
    end, false)
    
    local closeBtn = guiCreateButton(20, windowHeight - 50, windowWidth - 40, 30, "Cerrar", false, jblWindow)
    addEventHandler("onClientGUIClick", closeBtn, function()
        closeJBLPanel()
    end, false)
    
    showCursor(true)
    guiSetInputEnabled(true)
end

-- Cerrar panel JBL
function closeJBLPanel()
    if jblWindow and isElement(jblWindow) then
        destroyElement(jblWindow)
        jblWindow = nil
    end
    showCursor(false)
    guiSetInputEnabled(false)
end

-- Mostrar panel de Link
function showLinkPanel()
    if jblWindow and isElement(jblWindow) then
        destroyElement(jblWindow)
    end
    
    local windowWidth = 450
    local windowHeight = 200
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    jblWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Reproducir desde Link", false)
    guiWindowSetSizable(jblWindow, false)
    guiSetAlpha(jblWindow, 0.95)
    
    local label = guiCreateLabel(20, 30, windowWidth - 40, 20, "Ingresa el link de YouTube para convertir a MP3:", false, jblWindow)
    
    local linkEdit = guiCreateEdit(20, 60, windowWidth - 40, 30, "", false, jblWindow)
    
    local playBtn = guiCreateButton(20, 100, (windowWidth - 50) / 2, 35, "Reproducir", false, jblWindow)
    addEventHandler("onClientGUIClick", playBtn, function()
        local link = guiGetText(linkEdit)
        if link and link ~= "" then
            triggerServerEvent("jbl:playFromLink", localPlayer, link)
            closeJBLPanel()
        else
            outputChatBox("Por favor ingresa un link válido.", 255, 0, 0)
        end
    end, false)
    
    local cancelBtn = guiCreateButton((windowWidth - 50) / 2 + 30, 100, (windowWidth - 50) / 2, 35, "Cancelar", false, jblWindow)
    addEventHandler("onClientGUIClick", cancelBtn, function()
        closeJBLPanel()
    end, false)
    
    showCursor(true)
    guiSetInputEnabled(true)
end

-- Activar/Desactivar JBL
function toggleJBL()
    if not jblActive then
        -- Activar JBL
        triggerServerEvent("jbl:activate", localPlayer)
        jblActive = true
        outputChatBox("JBL activado. Usa F6 para controlar la música.", 0, 255, 0)
    else
        -- Desactivar JBL
        triggerServerEvent("jbl:deactivate", localPlayer)
        jblActive = false
        outputChatBox("JBL desactivado.", 255, 255, 0)
    end
end

-- Tecla F6 para abrir panel
bindKey("f6", "down", function()
    if jblActive or hasJBL() then
        createJBLPanel()
    else
        outputChatBox("No tienes un JBL. Compra uno en una tienda.", 255, 0, 0)
    end
end)

-- Eventos del servidor
addEvent("jbl:activated", true)
addEventHandler("jbl:activated", resourceRoot, function()
    jblActive = true
end)

addEvent("jbl:deactivated", true)
addEventHandler("jbl:deactivated", resourceRoot, function()
    jblActive = false
    if jblObject and isElement(jblObject) then
        destroyElement(jblObject)
        jblObject = nil
    end
end)

addEvent("jbl:musicStarted", true)
addEventHandler("jbl:musicStarted", resourceRoot, function(url, x, y, z)
    -- Reproducir música 3D en la posición del JBL
    if currentMusic then
        stopSound(currentMusic)
        currentMusic = nil
    end
    
    -- Intentar reproducir el sonido
    -- Nota: playSound3D requiere una URL válida de audio
    -- Para y2mate, necesitaríamos descargar el MP3 primero
    currentMusic = playSound3D(url, x, y, z, true)
    
    if currentMusic then
        setSoundVolume(currentMusic, musicVolume)
        setSoundMaxDistance(currentMusic, 50) -- Radio de 50 metros
        setSoundMinDistance(currentMusic, 5) -- Distancia mínima para mejor calidad
        outputChatBox("Música iniciada. Todos los jugadores cercanos pueden escuchar.", 0, 255, 0)
    else
        outputChatBox("Error: No se pudo reproducir la música. Verifica que la URL sea válida.", 255, 0, 0)
    end
end)

addEvent("jbl:musicStopped", true)
addEventHandler("jbl:musicStopped", resourceRoot, function()
    if currentMusic then
        stopSound(currentMusic)
        currentMusic = nil
    end
end)

addEvent("jbl:convertAndPlay", true)
addEventHandler("jbl:convertAndPlay", resourceRoot, function(link, x, y, z)
    -- Convertir link de YouTube a MP3 usando y2mate
    -- Nota: En MTA no podemos hacer requests HTTP directamente desde el cliente
    -- Esto se hará en el servidor o usando un navegador oculto
    outputChatBox("Convirtiendo " .. link .. " a MP3...", 0, 255, 0)
    
    -- Por ahora, simular conversión (en producción, esto se haría en el servidor)
    -- El servidor debería usar y2mate API o similar para convertir
    triggerServerEvent("jbl:convertYouTube", localPlayer, link, x, y, z)
end)

addEvent("jbl:playFromSpotify", true)
addEventHandler("jbl:playFromSpotify", resourceRoot, function(trackUrl, trackName)
    triggerServerEvent("jbl:playFromSpotify", localPlayer, trackUrl, trackName)
end)

addEvent("jbl:resumeMusic", true)
addEventHandler("jbl:resumeMusic", resourceRoot, function()
    if currentMusic then
        setSoundPaused(currentMusic, false)
    end
end)

addEvent("jbl:pauseMusic", true)
addEventHandler("jbl:pauseMusic", resourceRoot, function()
    if currentMusic then
        setSoundPaused(currentMusic, true)
    end
end)

addEvent("jbl:volumeChanged", true)
addEventHandler("jbl:volumeChanged", resourceRoot, function(volume)
    musicVolume = volume
    if currentMusic then
        setSoundVolume(currentMusic, volume)
    end
end)

