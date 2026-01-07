local sx, sy = guiGetScreenSize()
local sw, sh = sx / 1920, sy / 1080

local showPanel = false
local panelAlpha = 0
local buttonHover = {reclamar = false, cerrar = false, cerrarTop = false}
local animState = 0
local animTimer = nil

-- Colores (paleta inspirada en el logo y bandera de Colombia)
local colorPrincipal = {252, 191, 0, 255}      -- Amarillo dorado
local colorSecundario = {210, 35, 42, 255}     -- Rojo acento
local colorHover = {255, 255, 255, 30}
local colorFondo = {10, 24, 43, 220}           -- Azul profundo para el panel
local colorAzulBandera = {0, 56, 168, 255}     -- Azul bandera

-- Dimensiones y posiciones
local windowX, windowY = (sx - 560 * sw) / 2, (sy - 420 * sh) / 2
local windowWidth, windowHeight = 560 * sw, 420 * sh
local buttonWidth, buttonHeight = 200 * sw, 45 * sh

-- Animación para el texto 3D
local textAnimOffset = 0
local textAnimDirection = 1
local textColor = {255, 255, 255}
local textGlowColor = {255, 215, 0} -- Color dorado para el brillo
local textGlowAlpha = 0
local textGlowDirection = 1

-- Modo rendimiento para el texto flotante (reduce draw calls)
local markerPerfMode = true

-- Fuentes (opcional: Montserrat). Si no existen, se hará fallback automático
local fontTitle, fontBody, fontButton, fontMarker

local function tryCreateFont(path, size)
    if fileExists(path) then
        local f = dxCreateFont(path, size, false, "cleartype")
        if f then return f end
    end
    return false
end

local function loadBrandFonts()
    local base = 1
    fontTitle = tryCreateFont("fonts/Montserrat-ExtraBold.ttf", math.max(20, math.floor(26 * sh * base))) or "default-bold"
    fontBody = tryCreateFont("fonts/Montserrat-Regular.ttf", math.max(12, math.floor(14 * sh * base))) or "default-bold"
    fontButton = tryCreateFont("fonts/Montserrat-SemiBold.ttf", math.max(14, math.floor(16 * sh * base))) or "default-bold"
    fontMarker = tryCreateFont("fonts/Montserrat-ExtraBold.ttf", math.max(16, math.floor(20 * sh * base))) or "default-bold"
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    loadBrandFonts()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    if type(fontTitle) == "userdata" then destroyElement(fontTitle) end
    if type(fontBody) == "userdata" then destroyElement(fontBody) end
    if type(fontButton) == "userdata" then destroyElement(fontButton) end
    if type(fontMarker) == "userdata" then destroyElement(fontMarker) end
end)

-- Coordenadas del marcador de kit (alineadas con el servidor)
local kitMarkerX, kitMarkerY, kitMarkerZ = 1693.9884033203, -2294.8310546875, 13.377690315247

-- Función para renderizar texto 3D mejorado SOLO para el marcador del kit
function renderMarkerText()
    -- No mostrar el texto del marcador si el panel está abierto
    if showPanel then return end
    -- Actualizar animación del texto
    textAnimOffset = textAnimOffset + 0.01 * textAnimDirection
    if textAnimOffset > 0.3 then
        textAnimDirection = -1
    elseif textAnimOffset < 0 then
        textAnimDirection = 1
    end
    
    -- Actualizar efecto de brillo
    textGlowAlpha = textGlowAlpha + 2 * textGlowDirection
    if textGlowAlpha > 150 then
        textGlowDirection = -1
    elseif textGlowAlpha < 30 then
        textGlowDirection = 1
    end
    
    -- Calcular distancia al jugador (versión optimizada sin sqrt cuando es posible)
    local px, py, pz = getElementPosition(localPlayer)
    local dx_, dy_, dz_ = px - kitMarkerX, py - kitMarkerY, pz - kitMarkerZ
    local distanceSq = dx_ * dx_ + dy_ * dy_ + dz_ * dz_
    local maxDistance = markerPerfMode and 35 or 50

    -- Solo mostrar si está a menos de maxDistance unidades
    if distanceSq < (maxDistance * maxDistance) then
        -- Calcular posición en pantalla
        local screenX, screenY = getScreenFromWorldPosition(kitMarkerX, kitMarkerY, kitMarkerZ + 1.25 + textAnimOffset)
        
        if screenX and screenY then
            local text = "Reclama tu Kit de Bienvenida"
            local scale = markerPerfMode and 0.85 or 0.95
            local font = fontMarker or "default-bold"

            -- Color de brillo dinámico (de amarillo a rojo)
            local tick = getTickCount() / 700
            local pulse = (math.sin(tick) + 1) / 2
            local glowR = math.floor(252 * (0.6 + 0.4 * pulse))
            local glowG = math.floor(191 * (0.5 + 0.2 * (1 - pulse)))
            local glowB = math.floor(0 * (0.8 - 0.8 * pulse) + 42 * pulse)
            
            -- Ajustar escala según distancia (solo en alta calidad)
            local adjustedScale = scale
            if not markerPerfMode then
                local distance = math.sqrt(distanceSq)
                adjustedScale = math.max(0.7, scale * (1 - distance/100))
            end
            
            -- Sombra/contorno (menos pasadas en modo rendimiento)
            if markerPerfMode then
                dxDrawText(text, screenX - 1, screenY - 1, screenX - 1, screenY - 1,
                    tocolor(0, 0, 0, 160), adjustedScale, font, "center", "center", false, false, false, true)
                dxDrawText(text, screenX + 1, screenY + 1, screenX + 1, screenY + 1,
                    tocolor(0, 0, 0, 140), adjustedScale, font, "center", "center", false, false, false, true)
            else
                for i = 1, 6 do
                    local angle = (i / 6) * math.pi * 2
                    local offsetX = math.cos(angle) * 1.5
                    local offsetY = math.sin(angle) * 1.5
                    dxDrawText(text, screenX + offsetX, screenY + offsetY, screenX + offsetX, screenY + offsetY,
                        tocolor(0, 0, 0, 180), adjustedScale, font, "center", "center", false, false, false, true)
                end
            end
            
            -- Dibujar efecto de brillo
            dxDrawText(text, screenX, screenY, screenX, screenY,
                tocolor(glowR, glowG, glowB, textGlowAlpha),
                adjustedScale * 1.05, font, "center", "center", false, false, false, true)
            
            -- Dibujar texto principal
            dxDrawText(text, screenX, screenY, screenX, screenY,
                tocolor(255, 255, 255, 255), adjustedScale, font, "center", "center", false, false, false, true)
        end
    end
end
addEventHandler("onClientRender", root, renderMarkerText)

-- Función simplificada para cerrar el panel
function closeKitPanel()
    showPanel = false
    showCursor(false)
    exports.a_infobox:addBox(localPlayer, "Panel cerrado.", "info")
end

function drawKitPanel()
    if showPanel then
        -- Actualizar animación
        if animState < 1 then
            animState = animState + 0.05
            if animState > 1 then animState = 1 end
        end
        
        panelAlpha = 255 * animState
        
        -- Fondo con efecto de desvanecimiento
        dxDrawRectangle(windowX - 5 * sw, windowY - 5 * sh, windowWidth + 10 * sw, windowHeight + 10 * sh, tocolor(0, 0, 0, 150 * animState))
        
        -- Panel principal con efecto de escala
        local scaleEffect = 0.95 + 0.05 * animState
        local adjustedX = windowX + (windowWidth * (1 - scaleEffect)) / 2
        local adjustedY = windowY + (windowHeight * (1 - scaleEffect)) / 2
        local adjustedWidth = windowWidth * scaleEffect
        local adjustedHeight = windowHeight * scaleEffect
        
        -- Panel principal con borde redondeado
        -- Sombra de panel
        dxDrawRectangle(adjustedX + 4 * sw, adjustedY + 4 * sh, adjustedWidth, adjustedHeight, tocolor(0, 0, 0, 90 * animState))
        -- Panel principal
        dxDrawRectangle(adjustedX, adjustedY, adjustedWidth, adjustedHeight, tocolor(colorFondo[1], colorFondo[2], colorFondo[3], colorFondo[4] * animState))
        
        -- Borde superior en doble tono
        dxDrawRectangle(adjustedX, adjustedY, adjustedWidth, 3 * sh, tocolor(colorPrincipal[1], colorPrincipal[2], colorPrincipal[3], panelAlpha))
        dxDrawRectangle(adjustedX, adjustedY + 3 * sh, adjustedWidth, 2 * sh, tocolor(colorAzulBandera[1], colorAzulBandera[2], colorAzulBandera[3], panelAlpha * 0.9))
        
        -- Título con efecto de desplazamiento
        local titleY = adjustedY + (20 * animState) * sh
        dxDrawText("Kit de Bienvenida", adjustedX, titleY, adjustedX + adjustedWidth, titleY + 30 * sh,
            tocolor(255, 255, 255, panelAlpha), 1.0, fontTitle or "default-bold", "center", "top")
        
        -- Línea separadora con animación
        local lineWidth = adjustedWidth * animState * 0.8
        dxDrawRectangle(adjustedX + (adjustedWidth - lineWidth) / 2, titleY + 35 * sh, lineWidth, 2 * sh,
            tocolor(colorPrincipal[1], colorPrincipal[2], colorPrincipal[3], panelAlpha))
        
        -- Botón cerrar superior (X)
        local uiScale = math.max(sw, sh)
        local closeSize = 22 * uiScale
        local closeX = adjustedX + adjustedWidth - closeSize - 12 * sw
        local closeY = adjustedY + 8 * sh
        local closeBg = buttonHover.cerrarTop and tocolor(255,255,255,35 * animState) or tocolor(255,255,255,15 * animState)
        dxDrawRectangle(closeX, closeY, closeSize, closeSize, closeBg)
        dxDrawText("X", closeX, closeY, closeX + closeSize, closeY + closeSize, tocolor(20,20,20, 220 * animState), 1.0, fontButton or "default-bold", "center", "center")

        -- Logo y nombre del servidor
        local logoY = titleY + 40 * sh
        local logoSize = 96 * uiScale
        local logoX = adjustedX + (adjustedWidth - logoSize) / 2
        dxDrawImage(logoX, logoY, logoSize, logoSize, "images/logo.png", 0, 0, 0, tocolor(255,255,255, panelAlpha))

        local nameY = logoY + logoSize + 6 * sh
        dxDrawText("La Capital Roleplay", adjustedX, nameY, adjustedX + adjustedWidth, nameY + 26 * sh,
            tocolor(colorPrincipal[1], colorPrincipal[2], colorPrincipal[3], panelAlpha), 1.0, fontTitle or "default-bold", "center", "top")
        
        -- Descripción
        local descY = nameY + 34 * sh
        dxDrawText("Reclama tu kit de bienvenida que incluye:\n• Una moto para explorar la ciudad\n• $2,000,000 para comenzar tu aventura",
            adjustedX + 24 * sw, descY, adjustedX + adjustedWidth - 24 * sw, adjustedY + 310 * sh,
            tocolor(215, 215, 215, panelAlpha * 0.95), 1.0, fontBody or "default-bold", "center", "top")
        
        -- Botón Reclamar Kit con efecto hover
        local reclamarX = adjustedX + (adjustedWidth - buttonWidth) / 2
        local reclamarY = adjustedY + 320 * sh
        local reclamarColor = buttonHover.reclamar and tocolor(colorPrincipal[1] + 30, colorPrincipal[2] + 30, colorPrincipal[3] + 30, panelAlpha) 
            or tocolor(colorPrincipal[1], colorPrincipal[2], colorPrincipal[3], panelAlpha)
        
        dxDrawRectangle(reclamarX, reclamarY, buttonWidth, buttonHeight, reclamarColor)
        if buttonHover.reclamar then
            dxDrawRectangle(reclamarX, reclamarY, buttonWidth, buttonHeight, tocolor(255, 255, 255, 30 * animState))
        end
        -- Brillo superior del botón
        dxDrawRectangle(reclamarX, reclamarY, buttonWidth, buttonHeight * 0.45, tocolor(255, 255, 255, 15 * animState))
        dxDrawText("RECLAMAR KIT", reclamarX, reclamarY, reclamarX + buttonWidth, reclamarY + buttonHeight,
            tocolor(255, 255, 255, panelAlpha), 1.0, fontButton or "default-bold", "center", "center")
        
        -- Botón Cerrar Panel con efecto hover
        local cerrarX = adjustedX + (adjustedWidth - buttonWidth) / 2
        local cerrarY = adjustedY + 375 * sh
        local cerrarColor = buttonHover.cerrar and tocolor(colorSecundario[1] + 30, colorSecundario[2] + 30, colorSecundario[3] + 30, panelAlpha) 
            or tocolor(colorSecundario[1], colorSecundario[2], colorSecundario[3], panelAlpha)
        
        dxDrawRectangle(cerrarX, cerrarY, buttonWidth, buttonHeight, cerrarColor)
        if buttonHover.cerrar then
            dxDrawRectangle(cerrarX, cerrarY, buttonWidth, buttonHeight, tocolor(255, 255, 255, 30 * animState))
        end
        dxDrawText("CERRAR", cerrarX, cerrarY, cerrarX + buttonWidth, cerrarY + buttonHeight,
            tocolor(255, 255, 255, panelAlpha), 1.0, fontButton or "default-bold", "center", "center")
    end
end
addEventHandler("onClientRender", root, drawKitPanel)

-- Actualizar estado de hover
addEventHandler("onClientCursorMove", root, function(_, _, mouseX, mouseY)
    if showPanel then
        local adjustedX = windowX + (windowWidth * (1 - (0.95 + 0.05 * animState))) / 2
        local adjustedY = windowY + (windowHeight * (1 - (0.95 + 0.05 * animState))) / 2
        local adjustedWidth = windowWidth * (0.95 + 0.05 * animState)
        
        local reclamarX = adjustedX + (adjustedWidth - buttonWidth) / 2
        local reclamarY = adjustedY + 320 * sh
        buttonHover.reclamar = (mouseX >= reclamarX and mouseX <= reclamarX + buttonWidth and 
                               mouseY >= reclamarY and mouseY <= reclamarY + buttonHeight)
        
        local cerrarX = adjustedX + (adjustedWidth - buttonWidth) / 2
        local cerrarY = adjustedY + 375 * sh
        buttonHover.cerrar = (mouseX >= cerrarX and mouseX <= cerrarX + buttonWidth and 
                             mouseY >= cerrarY and mouseY <= cerrarY + buttonHeight)

        -- Hover del botón X superior
        local uiScale = math.max(sw, sh)
        local closeSize = 22 * uiScale
        local closeX = adjustedX + adjustedWidth - closeSize - 12 * sw
        local closeY = adjustedY + 8 * sh
        buttonHover.cerrarTop = (mouseX >= closeX and mouseX <= closeX + closeSize and mouseY >= closeY and mouseY <= closeY + closeSize)
    end
end)

-- Solicitar verificación antes de abrir el panel
addEvent("verificarKit", true)
addEventHandler("verificarKit", root, function()
    triggerServerEvent("verificarKit", localPlayer)
end)

-- Mostrar el panel solo si el jugador no ha reclamado el kit
addEvent("mostrarKitPanel", true)
addEventHandler("mostrarKitPanel", root, function(puedeReclamar)
    if puedeReclamar then
        showPanel = true
        animState = 0
        showCursor(true)
        exports.a_infobox:addBox(localPlayer, "Panel de kit de bienvenida abierto.", "info")
    else
        exports.a_infobox:addBox(localPlayer, "Ya has reclamado tu kit de bienvenida.", "error")
    end
end)

-- Detectar clics en los botones
addEventHandler("onClientClick", root, function(button, state)
    if button == "left" and state == "down" and showPanel then
        local mouseX, mouseY = getCursorPosition()
        mouseX, mouseY = mouseX * sx, mouseY * sy
        
        local adjustedX = windowX + (windowWidth * (1 - (0.95 + 0.05 * animState))) / 2
        local adjustedY = windowY + (windowHeight * (1 - (0.95 + 0.05 * animState))) / 2
        local adjustedWidth = windowWidth * (0.95 + 0.05 * animState)
        
        -- Botón Reclamar Kit
        local reclamarX = adjustedX + (adjustedWidth - buttonWidth) / 2
        local reclamarY = adjustedY + 320 * sh
        if mouseX >= reclamarX and mouseX <= reclamarX + buttonWidth and mouseY >= reclamarY and mouseY <= reclamarY + buttonHeight then
            triggerServerEvent("darKitBienvenida", localPlayer)
            exports.a_infobox:addBox(localPlayer, "¡Has reclamado tu kit de bienvenida con éxito!", "success")
            closeKitPanel()
        end
        
        -- Botón Cerrar
        local cerrarX = adjustedX + (adjustedWidth - buttonWidth) / 2
        local cerrarY = adjustedY + 375 * sh
        if mouseX >= cerrarX and mouseX <= cerrarX + buttonWidth and mouseY >= cerrarY and mouseY <= cerrarY + buttonHeight then
            closeKitPanel()
        end

        -- Botón X superior
        local uiScale = math.max(sw, sh)
        local closeSize = 22 * uiScale
        local closeX = adjustedX + adjustedWidth - closeSize - 12 * sw
        local closeY = adjustedY + 8 * sh
        if mouseX >= closeX and mouseX <= closeX + closeSize and mouseY >= closeY and mouseY <= closeY + closeSize then
            closeKitPanel()
        end
    end
end)

-- Tecla de escape para cerrar el panel
addEventHandler("onClientKey", root, function(button, press)
    if button == "escape" and press and showPanel then
        closeKitPanel()
        cancelEvent() -- Evitar que se abra el menú de MTA
    end
end)
