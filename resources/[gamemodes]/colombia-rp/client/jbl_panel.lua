-- Panel JBL - F6
-- Sistema para activar JBL y controlar música

local screenW, screenH = guiGetScreenSize()
local sx, sy = screenW / 1366, screenH / 768
local jblWindow = nil
local jblActive = false
local jblObject = nil
local currentMusic = nil
local musicVolume = 0.5

-- Variables para panel de link avanzado
local linkPanelAbierto = false
local linkEditBox = nil
local linkAnimAlpha = 1
local tituloCancion = "Esperando música..."

-- COLORES
local C = {
    fondo       = tocolor(15, 15, 20, 255),
    primario    = tocolor(0, 191, 255, 255),
    secundario  = tocolor(0, 255, 255, 255),
    blanco      = tocolor(255, 255, 255, 255),
    inputBg     = tocolor(25, 25, 35, 255),
    btnBg       = tocolor(10, 10, 15, 255)
}

-- Textura circular para bordes redondeados
local roundTexture = nil
local function createCircleTexture()
    local size = 64
    local pixels = {} 
    for y = 0, size - 1 do
        for x = 0, size - 1 do
            local dist = math.sqrt((x - size/2 + 0.5)^2 + (y - size/2 + 0.5)^2)
            local alpha = (dist <= size/2) and 255 or 0
            table.insert(pixels, string.char(255, 255, 255, alpha))
        end
    end
    roundTexture = dxCreateTexture(table.concat(pixels), size, size, "argb")
end
createCircleTexture()

function dxDrawRounded(x, y, w, h, radius, color)
    if not roundTexture then return end
    radius = radius * sx
    dxDrawImage(x, y, radius, radius, roundTexture, 180, 0, 0, color, true) 
    dxDrawImage(x + w - radius, y, radius, radius, roundTexture, 270, 0, 0, color, true)
    dxDrawImage(x, y + h - radius, radius, radius, roundTexture, 90, 0, 0, color, true)
    dxDrawImage(x + w - radius, y + h - radius, radius, radius, roundTexture, 0, 0, 0, color, true)
    dxDrawRectangle(x + radius, y, w - (radius*2), h, color, true) 
    dxDrawRectangle(x, y + radius, radius, h - (radius*2), color, true) 
    dxDrawRectangle(x + w - radius, y + radius, radius, h - (radius*2), color, true) 
end

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
    
    local linkBtn = guiCreateButton(20, 120, windowWidth - 40, 40, "🔗 Link (URL Directa)", false, jblWindow)
    addEventHandler("onClientGUIClick", linkBtn, function()
        closeJBLPanel()
        -- Abrir panel de Link avanzado
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

-- Funciones de utilidad para botones
function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return false end
    local mx, my = getCursorPosition()
    local cx, cy = mx*screenW, my*screenH
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local clickTick = 0
function isClicked()
    if getKeyState("mouse1") and (getTickCount() - clickTick > 250) then
        clickTick = getTickCount()
        return true
    end
    return false
end

function drawSimpleBtn(x, y, w, h, text, color, alpha)
    local hover = isMouseInPosition(x, y, w, h)
    local bg = hover and tocolor(40, 40, 60, math.floor(alpha)) or C.btnBg
    dxDrawRounded(x, y, w, h, 4, bg)
    dxDrawText(text, x, y, x + w, y + h, color, 1, "default-bold", "center", "center", false, false, true)
    return hover and isClicked()
end

-- Renderizar panel de Link avanzado
function renderLinkPanel()
    if linkPanelAbierto then
        if linkAnimAlpha < 1 then linkAnimAlpha = linkAnimAlpha + 0.1 end
    else
        if linkAnimAlpha > 0 then linkAnimAlpha = linkAnimAlpha - 0.1 else
            removeEventHandler("onClientRender", root, renderLinkPanel)
            if isElement(linkEditBox) then destroyElement(linkEditBox) end
            return
        end
    end
    
    local w, h = 550 * sx, 380 * sy
    local x, y = (screenW - w) / 2, (screenH - h) / 2
    local alpha = 255 * linkAnimAlpha

    -- Borde de Neón y Fondo Principal
    dxDrawRounded(x - 2, y - 2, w + 4, h + 4, 6, tocolor(0, 191, 255, 100 * linkAnimAlpha)) 
    dxDrawRounded(x, y, w, h, 6, tocolor(15, 15, 20, 255 * linkAnimAlpha))

    -- Visualizador FFT
    if currentMusic and isElement(currentMusic) and not isSoundPaused(currentMusic) then
        local fft = getSoundFFTData(currentMusic, 2048, 64)
        if fft then
            local barW = w / 64
            for i = 0, 63 do
                local barH = math.min((fft[i] or 0) * 150, 100) * sy
                dxDrawRectangle(x + (i * barW), y + h - barH, barW - 1, barH, tocolor(0, 255, 255, 120 * linkAnimAlpha), true)
            end
        end
    end

    -- CABECERA
    dxDrawText("JBL ⚡ LINK", x + 20*sx, y + 20*sy, x + w, 0, C.secundario, 1.5, "default-bold", "left", "top", false, false, true)
    
    if drawSimpleBtn(x + w - 30*sx, y + 10*sy, 20*sx, 20*sy, "✕", tocolor(200, 50, 50, 255), alpha) then 
        cerrarLinkPanel() 
    end

    -- Título de Canción
    dxDrawRounded(x + 30*sx, y + 70*sy, w - 60*sx, 40*sy, 4, tocolor(0, 0, 0, 200 * linkAnimAlpha))
    dxDrawText("♪ " .. tituloCancion, x + 40*sx, y + 70*sy, x + w - 40*sx, y + 110*sy, C.blanco, 1, "default", "center", "center", true, false, true)

    -- INPUT URL
    local inputY = y + 120*sy
    dxDrawRounded(x + 30*sx, inputY, w - 60*sx, 40*sy, 4, C.inputBg)
    if isMouseInPosition(x + 30*sx, inputY, w - 60*sx, 40*sy) and getKeyState("mouse1") then
        guiBringToFront(linkEditBox)
        guiSetInputMode("no_binds")
    end
    local txt = guiGetText(linkEditBox)
    dxDrawText(txt == "" and "Pega el enlace de la música aquí..." or txt, x + 40*sx, inputY, x + w - 40*sx, inputY + 40*sy, txt == "" and tocolor(80, 80, 90, 255*linkAnimAlpha) or C.blanco, 1, "default", "left", "center", true, false, true)
    dxDrawRectangle(x + 30*sx, inputY + 38*sy, w - 60*sx, 2, C.primario, true)

    -- Barra de progreso
    local progress = 0
    if currentMusic and isElement(currentMusic) then
        local len = getSoundLength(currentMusic)
        if len and len > 0 then progress = getSoundPosition(currentMusic) / len end
    end
    dxDrawRectangle(x + 30*sx, inputY + 60*sy, w - 60*sx, 4, tocolor(40, 40, 50, alpha), true)
    dxDrawRectangle(x + 30*sx, inputY + 60*sy, (w - 60*sx) * progress, 4, C.secundario, true)

    -- BOTONES
    local btnW, btnH = 160*sx, 40*sy
    if drawSimpleBtn(x + 40*sx, y + 240*sy, btnW, btnH, "▶ REPRODUCIR", C.secundario, alpha) then
        local url = guiGetText(linkEditBox)
        if url ~= "" then 
            triggerServerEvent("jbl:playFromLink", localPlayer, url)
            tituloCancion = "Cargando música..."
        end
    end

    if drawSimpleBtn(x + w - btnW - 40*sx, y + 240*sy, btnW, btnH, "■ APAGAR", C.blanco, alpha) then
        triggerServerEvent("jbl:stopMusic", localPlayer)
        tituloCancion = "Esperando música..."
    end

    if drawSimpleBtn(x + (w - btnW)/2, y + 300*sy, btnW, btnH, "CERRAR PANEL", C.primario, alpha) then
        cerrarLinkPanel()
    end
end

-- Mostrar panel de Link avanzado
function showLinkPanel()
    if linkPanelAbierto then return end
    linkPanelAbierto = true
    linkAnimAlpha = 1
    showCursor(true)
    if isElement(linkEditBox) then destroyElement(linkEditBox) end
    linkEditBox = guiCreateEdit(-1000, -1000, 200, 50, "", false)
    addEventHandler("onClientRender", root, renderLinkPanel)
end

function cerrarLinkPanel()
    linkPanelAbierto = false
    showCursor(false)
    guiSetInputMode("allow_binds")
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
addEventHandler("jbl:musicStarted", resourceRoot, function(url, x, y, z, entidad)
    -- Reproducir música 3D en la posición del JBL
    if currentMusic then
        stopSound(currentMusic)
        currentMusic = nil
    end
    
    -- Reproducir el sonido directamente desde la URL
    if entidad and isElement(entidad) then
        local ex, ey, ez = getElementPosition(entidad)
        currentMusic = playSound3D(url, ex, ey, ez, true)
        if currentMusic then
            setSoundMaxDistance(currentMusic, getElementType(entidad) == "vehicle" and 150 or 80)
            attachElements(currentMusic, entidad)
        end
    else
        currentMusic = playSound3D(url, x, y, z, true)
    end
    
    if currentMusic then
        setSoundVolume(currentMusic, musicVolume)
        if not entidad then
            setSoundMaxDistance(currentMusic, 50) -- Radio de 50 metros
            setSoundMinDistance(currentMusic, 5) -- Distancia mínima para mejor calidad
        end
        tituloCancion = "Reproduciendo música..."
        outputChatBox("Música iniciada. Todos los jugadores cercanos pueden escuchar.", 0, 255, 0)
    else
        tituloCancion = "Error al reproducir"
        outputChatBox("Error: No se pudo reproducir la música. Verifica que la URL sea válida.", 255, 0, 0)
    end
end)

addEvent("jbl:musicStopped", true)
addEventHandler("jbl:musicStopped", resourceRoot, function()
    if currentMusic then
        stopSound(currentMusic)
        currentMusic = nil
    end
    tituloCancion = "Esperando música..."
end)

-- Evento para reproducir directamente desde URL (sistema mejorado)
addEvent("jbl:ReproducirCliente", true)
addEventHandler("jbl:ReproducirCliente", root, function(url, entidad)
    if currentMusic and isElement(currentMusic) then 
        stopSound(currentMusic) 
    end
    if entidad and isElement(entidad) then
        local x, y, z = getElementPosition(entidad)
        local sound = playSound3D(url, x, y, z, true)
        setSoundMaxDistance(sound, getElementType(entidad) == "vehicle" and 150 or 80)
        attachElements(sound, entidad)
        currentMusic = sound
        tituloCancion = "Reproduciendo música..."
    end
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

