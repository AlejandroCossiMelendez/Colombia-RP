-- Variables globales responsivas
local interfaceVisible = false
local scoreboardData = nil
local lastDataUpdate = 0
local playerFPS = 0
local nextFPSUpdate = 0
local scrollOffset = 0  -- Variable para el scroll de jugadores

-- Timer para actualizaciones en tiempo real cuando TAB está presionado
local realtimeUpdateTimer = nil

-- Función para iniciar actualizaciones en tiempo real
local function startRealtimeUpdates()
    if realtimeUpdateTimer then
        killTimer(realtimeUpdateTimer)
    end
    
    realtimeUpdateTimer = setTimer(function()
        if interfaceVisible then
            triggerServerEvent("requestScoreboardData", localPlayer)
        end
    end, 1000, 0)  -- Actualización cada segundo para tiempo real
end

-- Función para detener actualizaciones en tiempo real
local function stopRealtimeUpdates()
    if realtimeUpdateTimer then
        killTimer(realtimeUpdateTimer)
        realtimeUpdateTimer = nil
    end
end

-- Variables de optimización - fuentes pre-cargadas
local preloadedFonts = {
    font18 = nil,
    font16 = nil,
    font12 = nil
}

-- Cache para evitar cálculos repetitivos
local scaleCache = {
    lastScreenSize = {0, 0},
    cachedScale = nil
}

-- Cache para datos que no cambian frecuentemente
local staticDataCache = {
    lastUpdate = 0,
    colombiaTime = "",
    ping = 0
}

-- Sistema de escalado optimizado con cache mejorado
local function getResponsiveScale()
    local sx, sy = guiGetScreenSize()
    
    -- Usar cache si la resolución no cambió
    if scaleCache.lastScreenSize[1] == sx and scaleCache.lastScreenSize[2] == sy and scaleCache.cachedScale then
        return scaleCache.cachedScale
    end
    
    -- Calcular escala basada en resolución estándar (1920x1080)
    local baseWidth, baseHeight = 1920, 1080
    local scaleX = sx / baseWidth
    local scaleY = sy / baseHeight
    
    -- Usar la menor escala para mantener proporciones
    local scaleBase = math.min(scaleX, scaleY)
    
    -- Asegurar límites más amplios para mejor compatibilidad
    if scaleBase < 0.5 then
        scaleBase = 0.5
    elseif scaleBase > 2.0 then
        scaleBase = 2.0
    end
    
    -- Calcular anchos de columna responsivos (punto medio para más espacio de nombres)
    local totalWidth = 580 * scaleBase  -- Ancho total del área de jugadores
    local columnWidths = {
        id = math.floor(totalWidth * 0.08),      -- 8% para ID
        name = math.floor(totalWidth * 0.53),    -- 53% para nombre (punto medio)
        fps = math.floor(totalWidth * 0.14),     -- 14% para FPS
        time = math.floor(totalWidth * 0.25)     -- 25% para tiempo
    }
    
    -- Guardar en cache
    scaleCache.cachedScale = {
        base = scaleBase,
        screenWidth = sx,
        screenHeight = sy,
        columnWidths = columnWidths,
        textScale = math.max(0.75, scaleBase * 1.0)  -- Escala de texto en punto medio
    }
    scaleCache.lastScreenSize[1] = sx
    scaleCache.lastScreenSize[2] = sy
    
    return scaleCache.cachedScale
end

-- Función para cargar fuentes una sola vez mejorada
local function loadPreloadedFonts()
    local scale = getResponsiveScale()
    
    -- Limpiar fuentes anteriores
    if preloadedFonts.font18 and isElement(preloadedFonts.font18) then destroyElement(preloadedFonts.font18) end
    if preloadedFonts.font16 and isElement(preloadedFonts.font16) then destroyElement(preloadedFonts.font16) end
    if preloadedFonts.font12 and isElement(preloadedFonts.font12) then destroyElement(preloadedFonts.font12) end
    
    -- Crear fuentes con tamaños optimizados basados en textScale (punto medio)
    local fontSize18 = math.max(14, math.floor(20 * scale.textScale))  -- Punto medio
    local fontSize16 = math.max(13, math.floor(17 * scale.textScale))  -- Punto medio
    local fontSize12 = math.max(11, math.floor(14 * scale.textScale))  -- Punto medio para nombres
    
    -- Intentar cargar fuente personalizada, usar default si falla
    preloadedFonts.font18 = dxCreateFont('fonts/Orbitron-Medium.ttf', fontSize18) or 'default-bold'
    preloadedFonts.font16 = dxCreateFont('fonts/Orbitron-Medium.ttf', fontSize16) or 'default-bold'
    preloadedFonts.font12 = dxCreateFont('fonts/Orbitron-Medium.ttf', fontSize12) or 'default'
    
    -- Verificar que las fuentes se cargaron correctamente
    if not preloadedFonts.font18 or preloadedFonts.font18 == 'default-bold' then
        preloadedFonts.font18 = 'default-bold'
    end
    if not preloadedFonts.font16 or preloadedFonts.font16 == 'default-bold' then
        preloadedFonts.font16 = 'default-bold'
    end
    if not preloadedFonts.font12 or preloadedFonts.font12 == 'default' then
        preloadedFonts.font12 = 'default'
    end
end

-- Función optimizada para actualizar datos que cambian poco
local function updateStaticData()
    local now = getTickCount()
    
    -- Actualizar solo cada 1000ms para optimizar
    if now - staticDataCache.lastUpdate > 1000 then
        -- Hora local del sistema (sin conversiones de zona horaria)
        local realTime = getRealTime()
        
        -- Simplemente usar la hora local del sistema de cada jugador
        -- getRealTime() ya devuelve la hora local, no UTC
        staticDataCache.colombiaTime = string.format("%02d:%02d", realTime.hour, realTime.minute)
        
        -- Ping del jugador
        staticDataCache.ping = getPlayerPing(localPlayer)
        
        staticDataCache.lastUpdate = now
    end
end

-- Función para calcular FPS del jugador local
local function updateFPS(msSinceLastFrame)
    local now = getTickCount()
    if now >= nextFPSUpdate then
        playerFPS = math.floor((1 / msSinceLastFrame) * 1000)
        nextFPSUpdate = now + 1000
        
        -- Enviar FPS al servidor cada 5 segundos
        if math.random(1, 5) == 1 then
            triggerServerEvent("updatePlayerFPS", localPlayer, playerFPS)
        end
    end
end
addEventHandler("onClientPreRender", root, updateFPS)

-- Función para obtener hora de Colombia (optimizada con cache)
local function getColombiaTime()
    return staticDataCache.colombiaTime
end

-- Función para sanitizar y truncar texto inteligentemente
local function sanitizeAndTruncateText(text, maxWidth, font, scale)
    if not text or type(text) ~= "string" then
        return ""
    end
    
    -- Limpiar caracteres extraños
    text = text:gsub("[^%w%s%p]", "")
    
    -- Si el texto cabe completamente, devolverlo tal como está
    local textWidth = dxGetTextWidth(text, scale, font)
    if textWidth <= maxWidth then
        return text
    end
    
    -- Truncar inteligentemente
    local truncated = text
    while dxGetTextWidth(truncated .. "...", scale, font) > maxWidth and #truncated > 3 do
        truncated = truncated:sub(1, #truncated - 1)
    end
    
    return truncated .. "..."
end

-- Función para obtener el color del nametag del jugador
local function getPlayerNametagColorWithAlpha(player, alpha)
    local r, g, b = getPlayerNametagColor(player)
    return tocolor(r, g, b, alpha or 255)
end

-- Función para obtener color de FPS según rendimiento
local function getFPSColor(fps, alpha)
    if fps >= 50 then
        return tocolor(0, 255, 0, alpha or 255)  -- Verde
    elseif fps >= 30 then
        return tocolor(255, 255, 0, alpha or 255)  -- Amarillo
    else
        return tocolor(255, 0, 0, alpha or 255)  -- Rojo
    end
end

-- Función principal de renderizado optimizada
function renderUI()
    -- Actualizar datos estáticos solo cuando sea necesario
    updateStaticData()
    
    local scale = getResponsiveScale()
    local sx, sy = scale.screenWidth, scale.screenHeight
    
    -- Dimensiones base del scoreboard
    local baseWidth = 1000 * scale.base
    local baseHeight = 600 * scale.base
    
    -- Posición centrada del scoreboard
    local centerX = sx / 2
    local centerY = sy / 2
    
    -- DIBUJAR TODAS LAS IMÁGENES INDIVIDUALES EN SUS POSICIONES EXACTAS
    
    -- Fondo principal
    dxDrawImage(centerX - 500 * scale.base, centerY - 300 * scale.base, baseWidth, baseHeight, 'data/BG-PRINCIPAL.png')
    
    -- Header principal (DENTRO del BG-PRINCIPAL, ajustado para no salirse)
    dxDrawImage(centerX - 490 * scale.base, centerY - 290 * scale.base, 980 * scale.base, 60 * scale.base, 'data/HEADER.png')
    
    -- Área de jugadores online (superior derecha)
    dxDrawImage(centerX + 97 * scale.base, centerY - 360 * scale.base, 400 * scale.base, 80 * scale.base, 'data/BG-JUGADORES-ONLINE.png')
    
    -- Área interior de usuarios (izquierda)
    dxDrawImage(centerX - 466 * scale.base, centerY - 206 * scale.base, 600 * scale.base, 450 * scale.base, 'data/BG-INTERIOR-USUARIO.png')
    
    -- Header interior de usuarios (DENTRO del área interior)
    dxDrawImage(centerX - 466 * scale.base, centerY - 206 * scale.base, 600 * scale.base, 50 * scale.base, 'data/HEADER-INTERIOR-USUARIO.png')
    
    -- Rectángulos de funcionarios
    dxDrawImage(centerX + 156 * scale.base, centerY - 155 * scale.base, 150 * scale.base, 100 * scale.base, 'data/POLICE-RECT.png')
    dxDrawImage(centerX + 328 * scale.base, centerY - 155 * scale.base, 150 * scale.base, 100 * scale.base, 'data/MILITARY-RECT.png')
    dxDrawImage(centerX + 156 * scale.base, centerY - 26 * scale.base, 150 * scale.base, 100 * scale.base, 'data/MEDIC-RECT.png')
    dxDrawImage(centerX + 328 * scale.base, centerY - 26 * scale.base, 150 * scale.base, 100 * scale.base, 'data/MECHANIC-RECT.png')
    dxDrawImage(centerX + 156 * scale.base, centerY + 103 * scale.base, 150 * scale.base, 100 * scale.base, 'data/TRANSIT-RECT.png')
    dxDrawImage(centerX + 328 * scale.base, centerY + 103 * scale.base, 150 * scale.base, 100 * scale.base, 'data/MECHANIC-ILEGAL-RECT.png')
    
    -- Logo del servidor (encima del header)
    dxDrawImage(centerX - 383 * scale.base, centerY - 401 * scale.base, 201 * scale.base, 201 * scale.base, 'data/LOGOSERVER.png')
    
    -- Iconos de funcionarios
    dxDrawImage(centerX + 162 * scale.base, centerY - 137 * scale.base, 64 * scale.base, 64 * scale.base, 'data/ICON-POLICE.png')
    dxDrawImage(centerX + 332 * scale.base, centerY - 137 * scale.base, 64 * scale.base, 64 * scale.base, 'data/ICON-MILITARY.png')
    dxDrawImage(centerX + 162 * scale.base, centerY - 8 * scale.base, 64 * scale.base, 64 * scale.base, 'data/ICON-MEDIC.png')
    dxDrawImage(centerX + 332 * scale.base, centerY - 8 * scale.base, 64 * scale.base, 64 * scale.base, 'data/ICON-MECHANIC.png')
    dxDrawImage(centerX + 162 * scale.base, centerY + 121 * scale.base, 64 * scale.base, 64 * scale.base, 'data/ICON-TRANSIT.png')
    dxDrawImage(centerX + 332 * scale.base, centerY + 121 * scale.base, 64 * scale.base, 64 * scale.base, 'data/ICON-MECHANIC-ILEGAL.png')
    
    -- Iconos de información
    dxDrawImage(centerX - 19 * scale.base, centerY - 284 * scale.base, 32 * scale.base, 32 * scale.base, 'data/ICON-PING.png')
    dxDrawImage(centerX + 113 * scale.base, centerY - 354 * scale.base, 54 * scale.base, 54 * scale.base, 'data/ICON-JUGADORES-ONLINE.png')
    dxDrawImage(centerX + 194 * scale.base, centerY - 301 * scale.base, 74 * scale.base, 74 * scale.base, 'data/ICON-HORA.png')
    
    if not scoreboardData then return end
    
    -- Usar fuentes pre-cargadas para optimización (no crear en cada frame)
    local font18 = preloadedFonts.font18
    local font16 = preloadedFonts.font16
    local font12 = preloadedFonts.font12
    
    -- Textos optimizados con colores pre-definidos
    local whiteColorFull = tocolor(255, 255, 255, 255)
    
    -- Headers principales
    dxDrawText('JUGADORES:', centerX + 181 * scale.base, centerY - 332 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    dxDrawText('FUNCIONARIOS:', centerX + 217 * scale.base, centerY - 197 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    dxDrawText('PING:', centerX + 27 * scale.base, centerY - 272 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    dxDrawText('HORA:', centerX + 269 * scale.base, centerY - 272 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    
    -- Datos dinámicos
    dxDrawText(scoreboardData.totalPlayers .. '/' .. scoreboardData.maxPlayers, centerX + 350 * scale.base, centerY - 332 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    dxDrawText(staticDataCache.ping .. ' MS', centerX + 100 * scale.base, centerY - 272 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    dxDrawText(staticDataCache.colombiaTime, centerX + 360 * scale.base, centerY - 272 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'left', 'top')
    
    -- Posiciones de columnas calculadas responsivamente (definir aquí para usar en headers)
    local colPosX = {
        id = centerX - 423 * scale.base,
        name = centerX - 331 * scale.base,
        fps = centerX - 140 * scale.base,
        time = centerX - 10 * scale.base
    }
    
    -- Headers de tabla con mejor escalado (todos con font12)
    local headerY = centerY - 192 * scale.base
    dxDrawText('ID', colPosX.id, headerY, nil, nil, whiteColorFull, scale.textScale, font12, 'left', 'top')
    dxDrawText('NOMBRE', colPosX.name, headerY, nil, nil, whiteColorFull, scale.textScale, font12, 'left', 'top')
    dxDrawText('FPS', colPosX.fps, headerY, nil, nil, whiteColorFull, scale.textScale, font12, 'left', 'top')
    dxDrawText('TIEMPO', colPosX.time, headerY, nil, nil, whiteColorFull, scale.textScale, font12, 'left', 'top')
    
    -- Lista de jugadores con scrollbar optimizada
    local listStartY = centerY - 156 * scale.base
    local listEndY = centerY + 230 * scale.base
    local rowHeight = 20 * scale.base
    local maxVisiblePlayers = math.floor((listEndY - listStartY) / rowHeight)
    local totalPlayers = #scoreboardData.playersData
    
    -- Optimización: solo dibujar scrollbar si hay más jugadores de los visibles
    local needsScrollbar = totalPlayers > maxVisiblePlayers
    if needsScrollbar then
        -- Limitar scrollOffset
        local maxScroll = totalPlayers - maxVisiblePlayers
        scrollOffset = math.max(0, math.min(scrollOffset, maxScroll))
        
        -- Scrollbar optimizado
        local scrollbarX = centerX - 80 * scale.base
        local scrollbarY = listStartY
        local scrollbarHeight = listEndY - listStartY
        local scrollbarWidth = 8 * scale.base
        
        -- Fondo del scrollbar
        dxDrawRectangle(scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight, tocolor(50, 50, 50, 180), false)
        
        -- Barra de scroll
        local scrollRatio = maxVisiblePlayers / totalPlayers
        local scrollBarHeight = scrollbarHeight * scrollRatio
        local scrollBarY = scrollbarY + (scrollOffset / maxScroll) * (scrollbarHeight - scrollBarHeight)
        
        dxDrawRectangle(scrollbarX, scrollBarY, scrollbarWidth, scrollBarHeight, tocolor(100, 150, 255, 200), false)
    else
        scrollOffset = 0  -- Reset scroll si no es necesario
    end
    
    -- Renderizado ultra optimizado de jugadores con colores y texto mejorado
    local startIndex = 1 + scrollOffset
    local endIndex = math.min(scrollOffset + maxVisiblePlayers, totalPlayers)
    
    local localPlayerName = getPlayerName(localPlayer)
    
    for i = startIndex, endIndex do
        local player = scoreboardData.playersData[i]
        if not player then break end
        
        local yPos = listStartY + (i - scrollOffset - 1) * rowHeight
        if yPos > listEndY - rowHeight then break end
        
        -- Usar colores del nametag enviados desde el servidor
        local playerColor = whiteColorFull  -- Color por defecto
        
        -- Si tenemos datos de color del servidor, usarlos
        if player.nametagColor then
            playerColor = tocolor(player.nametagColor.r, player.nametagColor.g, player.nametagColor.b, 200)
        else
            -- Fallback: intentar obtener del jugador real
            local realPlayer = getPlayerFromName(player.name:gsub(" ", "_"))
            if realPlayer and isElement(realPlayer) then
                playerColor = getPlayerNametagColorWithAlpha(realPlayer, 200)
            end
        end
        
        -- Datos optimizados
        local isLocal = (player.name:gsub(" ", "_") == localPlayerName)
        local fps = isLocal and playerFPS or (player.fps or 60)
        local fpsColor = getFPSColor(fps, 200)
        
        -- Truncar nombre inteligentemente basado en el ancho disponible
        local maxNameWidth = scale.columnWidths.name - 10  -- Margen de 10px
        local displayName = sanitizeAndTruncateText(player.name, maxNameWidth, font12, scale.textScale)
        
        -- Renderizado con colores mejorados (volver a font12 para nombres)
        dxDrawText(tostring(player.id), colPosX.id, yPos, nil, nil, playerColor, scale.textScale, font12, 'left', 'center')
        dxDrawText(displayName, colPosX.name, yPos, nil, nil, playerColor, scale.textScale, font12, 'left', 'center')
        dxDrawText(tostring(fps), colPosX.fps, yPos, nil, nil, fpsColor, scale.textScale, font12, 'left', 'center')
        dxDrawText(player.connectedTime or "00:00", colPosX.time, yPos, nil, nil, playerColor, scale.textScale, font12, 'left', 'center')
    end
    
    -- Contadores de funcionarios ultra optimizados (sin bucle)
    local factionCounts = scoreboardData.factionCounts
    dxDrawText(tostring(factionCounts.police or 0), centerX + 245 * scale.base, centerY - 105 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'center', 'center')
    dxDrawText(tostring(factionCounts.military or 0), centerX + 415 * scale.base, centerY - 105 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'center', 'center')
    dxDrawText(tostring(factionCounts.medic or 0), centerX + 245 * scale.base, centerY + 24 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'center', 'center')
    dxDrawText(tostring(factionCounts.mechanic or 0), centerX + 415 * scale.base, centerY + 24 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'center', 'center')
    dxDrawText(tostring(factionCounts.transit or 0), centerX + 245 * scale.base, centerY + 153 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'center', 'center')
    dxDrawText(tostring(factionCounts.mechanic_ilegal or 0), centerX + 415 * scale.base, centerY + 153 * scale.base, nil, nil, whiteColorFull, scale.base, font16, 'center', 'center')
    
    -- No limpiamos fuentes aquí ya que están pre-cargadas globalmente
end


function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler
    eventCallback('onClientRender', root, renderUI)
    interfaceVisible = visible
    
    if visible then
        -- Cargar fuentes si no están cargadas o recargarlas si cambió la resolución
        if not preloadedFonts.font18 or not preloadedFonts.font16 or not preloadedFonts.font12 then
            loadPreloadedFonts()
        end
        
        -- Resetear scroll al abrir
        scrollOffset = 0
        
        -- Solicitar datos actualizados al servidor inmediatamente
        triggerServerEvent("requestScoreboardData", localPlayer)
        
        -- Forzar actualización de datos estáticos si están disponibles
        if staticDataCache then
            staticDataCache.lastUpdate = 0
        end
        
        -- Iniciar actualizaciones en tiempo real cuando se abre por comando
        startRealtimeUpdates()
    else
        -- Detener actualizaciones en tiempo real cuando se cierra
        stopRealtimeUpdates()
    end
end

-- Recepción de datos optimizada
addEvent("receiveScoreboardData", true)
addEventHandler("receiveScoreboardData", root, function(data)
    scoreboardData = data
end)

-- Actualizar datos automáticamente (optimizado para tiempo real)
setTimer(function()
    if interfaceVisible then
        triggerServerEvent("requestScoreboardData", localPlayer)
        -- Forzar actualización de datos estáticos si están disponibles
        if staticDataCache then
            staticDataCache.lastUpdate = 0
        end
    end
end, 2000, 0)  -- Reducido de 5000ms a 2000ms para mejor responsividad

-- Comando para mostrar/ocultar la interfaz (sin debug)
addCommandHandler('interface', function()
    interfaceVisible = not interfaceVisible
    toggleUI(interfaceVisible)
end)

-- Soporte para TAB (scoreboard tradicional) con actualizaciones en tiempo real
bindKey("tab", "both", function(key, keyState)
    local showScoreboard = (keyState == "down")
    
    -- Solo cambiar si el estado es diferente
    if showScoreboard ~= interfaceVisible then
        interfaceVisible = showScoreboard
        toggleUI(interfaceVisible)
        
        -- Iniciar o detener actualizaciones en tiempo real
        if showScoreboard then
            startRealtimeUpdates()
        else
            stopRealtimeUpdates()
        end
    end
end)

-- Scroll optimizado con menos validaciones
bindKey("mouse_wheel_up", "down", function()
    if interfaceVisible and scoreboardData and #scoreboardData.playersData > 18 then
        scrollOffset = math.max(0, scrollOffset - 1)
    end
end)

bindKey("mouse_wheel_down", "down", function()
    if interfaceVisible and scoreboardData and #scoreboardData.playersData > 18 then
        scrollOffset = math.min(#scoreboardData.playersData - 18, scrollOffset + 1)
    end
end)

-- Optimización para cambio de resolución
addEventHandler("onClientRestore", root, function()
    scaleCache.lastScreenSize = {0, 0}
    scaleCache.cachedScale = nil
    loadPreloadedFonts()
    if interfaceVisible then
        toggleUI(false)
        setTimer(function() toggleUI(true) end, 100, 1)
    end
end)

-- Inicialización silenciosa y optimizada
addEventHandler('onClientResourceStart', resourceRoot, function()
    -- Cargar fuentes inmediatamente
    loadPreloadedFonts()
    
    -- Inicializar datos estáticos si están disponibles
    if staticDataCache then
        staticDataCache.lastUpdate = 0
        updateStaticData()
    end
    
    -- Solicitar datos iniciales (reducido el delay)
    setTimer(function()
        triggerServerEvent("requestScoreboardData", localPlayer)
    end, 500, 1)
end)

-- Limpieza optimizada
addEventHandler('onClientResourceStop', resourceRoot, function()
    for _, font in pairs(preloadedFonts) do
        if font and isElement(font) then destroyElement(font) end
    end
    
    -- Limpiar timer de actualizaciones en tiempo real
    stopRealtimeUpdates()
end)