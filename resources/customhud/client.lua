-- HUD Personalizado Moderno para Colombia RP
local screenWidth, screenHeight = guiGetScreenSize()
local money = 0
local health = 100
local armor = 0
local hunger = 100  -- Hambre (0-100)
local thirst = 100  -- Sed (0-100)
local oxygen = 100  -- Oxígeno/Respiración (0-100)

-- Cargar imágenes
local healthImage = nil
local healthImageLoaded = false
local moneyImage = nil
local moneyImageLoaded = false
local waterImage = nil
local waterImageLoaded = false
local foodImage = nil
local foodImageLoaded = false

-- Datos del personaje
local characterName = ""
local characterSurname = ""
local playerID = 0

-- Colores profesionales y modernos con más contraste
local colors = {
    -- Fondos con más profundidad
    bgPrimary = {10, 10, 15, 250},        -- Fondo principal muy oscuro
    bgSecondary = {20, 20, 28, 240},      -- Fondo secundario
    bgCard = {18, 18, 25, 245},          -- Fondo de tarjetas con más opacidad
    bgCardGlow = {25, 25, 35, 180},      -- Resplandor de tarjetas
    
    -- Acentos vibrantes
    accent = {99, 102, 241, 255},         -- Índigo vibrante
    accentGlow = {99, 102, 241, 100},    -- Resplandor del acento
    accentDark = {67, 56, 202, 255},      -- Índigo oscuro
    
    -- Estados con más saturación
    money = {16, 185, 129, 255},          -- Verde esmeralda brillante
    moneyGlow = {16, 185, 129, 80},      -- Resplandor verde
    health = {239, 68, 68, 255},          -- Rojo intenso
    healthGlow = {239, 68, 68, 80},       -- Resplandor rojo
    healthGood = {34, 197, 94, 255},      -- Verde saludable
    healthGoodGlow = {34, 197, 94, 80},   -- Resplandor verde salud
    armor = {59, 130, 246, 255},          -- Azul brillante
    armorGlow = {59, 130, 246, 80},        -- Resplandor azul
    hunger = {251, 146, 60, 255},          -- Naranja para hambre
    hungerGlow = {251, 146, 60, 80},       -- Resplandor naranja
    thirst = {56, 189, 248, 255},          -- Azul claro para sed
    thirstGlow = {56, 189, 248, 80},       -- Resplandor azul claro
    oxygen = {34, 211, 238, 255},          -- Cian para oxígeno
    oxygenGlow = {34, 211, 238, 80},       -- Resplandor cian
    
    -- Texto con mejor contraste
    textPrimary = {255, 255, 255, 255},   -- Texto principal blanco puro
    textSecondary = {220, 220, 230, 255}, -- Texto secundario más claro
    textMuted = {160, 160, 170, 255},     -- Texto atenuado
    
    -- Bordes y líneas más definidos
    border = {50, 50, 65, 255},           -- Borde más visible
    divider = {35, 35, 45, 255},          -- Divisor más marcado
    shadow = {0, 0, 0, 200}              -- Sombra profunda
}

-- Tamaños
local healthImageSize = 36  -- Más pequeño y profesional
local moneyImageSize = 28
local iconSize = 24  -- Tamaño para iconos de hambre, sed y oxígeno
local cardPadding = 18
local cardSpacing = 10

-- Ocultar HUD por defecto de MTA
addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("money", false)
    setPlayerHudComponentVisible("health", false)
    setPlayerHudComponentVisible("armour", false)
    setPlayerHudComponentVisible("ammo", false)
    setPlayerHudComponentVisible("weapon", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("vehicle_name", false)
    setPlayerHudComponentVisible("clock", false)  -- Ocultar reloj nativo del juego
    setPlayerHudComponentVisible("radar", false)  -- Opcional: ocultar radar también
    setPlayerHudComponentVisible("breath", false)  -- Ocultar respiración nativa
    
    -- Cargar imágenes
    healthImage = dxCreateTexture("images/health_icon.png", "argb", true, "clamp")
    healthImageLoaded = healthImage ~= nil
    
    moneyImage = dxCreateTexture("images/dolar.png", "argb", true, "clamp")
    moneyImageLoaded = moneyImage ~= nil
    
    waterImage = dxCreateTexture("images/botella-de-agua.png", "argb", true, "clamp")
    waterImageLoaded = waterImage ~= nil
    
    foodImage = dxCreateTexture("images/hamburguesa-con-queso.png", "argb", true, "clamp")
    foodImageLoaded = foodImage ~= nil
    
    playerID = getElementData(localPlayer, "playerID") or 0
    
    -- Obtener valores iniciales del servidor
    hunger = getElementData(localPlayer, "characterHunger") or 100
    thirst = getElementData(localPlayer, "characterThirst") or 100
end)

-- Timer para asegurar que el HUD nativo siempre esté oculto
setTimer(function()
    if getElementData(localPlayer, "characterSelected") then
        setPlayerHudComponentVisible("breath", false)  -- Ocultar respiración nativa siempre
    end
end, 500, 0)  -- Verificar cada 500ms

-- Función para formatear números
function formatNumber(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Función para dibujar texto con sombra suave
function dxDrawModernText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    postGUI = postGUI or true  -- Por defecto dibujar encima de todo
    local shadowColor = tocolor(0, 0, 0, 150)
    dxDrawText(text, x + 1, y + 1, w + 1, h + 1, shadowColor, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

-- Función para dibujar tarjeta profesional con sombra y resplandor
function drawCard(x, y, width, height, color, postGUI, glowColor)
    postGUI = postGUI or true
    glowColor = glowColor or nil
    
    -- Sombra profunda (múltiples capas para efecto profesional)
    dxDrawRectangle(x + 3, y + 3, width, height, tocolor(0, 0, 0, 120), postGUI)
    dxDrawRectangle(x + 2, y + 2, width, height, tocolor(0, 0, 0, 80), postGUI)
    dxDrawRectangle(x + 1, y + 1, width, height, tocolor(0, 0, 0, 60), postGUI)
    
    -- Resplandor sutil (si se especifica)
    if glowColor then
        dxDrawRectangle(x - 1, y - 1, width + 2, height + 2, 
            tocolor(glowColor[1], glowColor[2], glowColor[3], glowColor[4] or 60), postGUI)
    end
    
    -- Tarjeta principal
    dxDrawRectangle(x, y, width, height, tocolor(color[1], color[2], color[3], color[4]), postGUI)
    
    -- Borde superior brillante (efecto de luz)
    dxDrawRectangle(x, y, width, 2, tocolor(255, 255, 255, 40), postGUI)
    
    -- Borde inferior sutil
    dxDrawRectangle(x, y + height - 1, width, 1, tocolor(0, 0, 0, 100), postGUI)
end

-- Función para dibujar barra de progreso profesional con efectos
function drawProgressBar(x, y, width, height, progress, color, bgColor, postGUI, glowColor)
    postGUI = postGUI or true
    progress = math.max(0, math.min(100, progress))
    local barWidth = (width * progress) / 100
    
    -- Sombra del fondo
    dxDrawRectangle(x + 1, y + 1, width, height, tocolor(0, 0, 0, 150), postGUI)
    
    -- Fondo de la barra
    dxDrawRectangle(x, y, width, height, tocolor(bgColor[1], bgColor[2], bgColor[3], bgColor[4] or 220), postGUI)
    
    -- Barra de progreso
    if barWidth > 0 then
        -- Resplandor sutil detrás de la barra
        if glowColor then
            dxDrawRectangle(x - 1, y - 1, barWidth + 2, height + 2, 
                tocolor(glowColor[1], glowColor[2], glowColor[3], glowColor[4] or 60), postGUI)
        end
        
        -- Barra principal
        dxDrawRectangle(x, y, barWidth, height, tocolor(color[1], color[2], color[3], color[4] or 255), postGUI)
        
        -- Brillo superior (efecto de luz)
        dxDrawRectangle(x, y, barWidth, 2, tocolor(255, 255, 255, 100), postGUI)
        
        -- Brillo inferior sutil
        dxDrawRectangle(x, y + height - 1, barWidth, 1, tocolor(0, 0, 0, 80), postGUI)
    end
end

-- Variables para almacenar hora de Bogotá recibida del servidor
local bogotaHour = 0
local bogotaMinute = 0
local bogotaSecond = 0
local bogotaDay = 1
local bogotaMonth = 1
local bogotaYear = 2024

-- Evento para recibir hora de Bogotá del servidor
addEvent("onBogotaTimeReceived", true)
addEventHandler("onBogotaTimeReceived", root, function(hour, minute, second, day, month, year)
    -- Asegurar que los valores sean números
    bogotaHour = tonumber(hour) or 0
    bogotaMinute = tonumber(minute) or 0
    bogotaSecond = tonumber(second) or 0
    bogotaDay = tonumber(day) or 1
    bogotaMonth = tonumber(month) or 1
    bogotaYear = tonumber(year) or 2024
    
    -- Debug: mostrar en consola (comentar en producción)
    -- outputChatBox("Hora recibida: " .. bogotaHour .. ":" .. bogotaMinute .. ":" .. bogotaSecond)
end)

-- Solicitar hora al servidor cuando el recurso inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Solicitar hora inmediatamente
    setTimer(function()
        triggerServerEvent("onRequestBogotaTime", localPlayer)
    end, 500, 1)  -- Pequeño delay para asegurar que el servidor esté listo
    
    -- Y luego cada segundo para mantener sincronizado (más frecuente)
    setTimer(function()
        if isElement(localPlayer) then
            triggerServerEvent("onRequestBogotaTime", localPlayer)
        end
    end, 1000, 0)  -- Cada segundo
end)

-- Función para obtener hora de Bogotá, Colombia (UTC-5)
function getBogotaTime()
    -- Usar la hora recibida del servidor (más confiable)
    -- Si no hay hora del servidor aún, usar hora local como fallback
    if bogotaHour == 0 and bogotaMinute == 0 then
        local time = getRealTime()
        local hour = time.hour - 5
        if hour < 0 then
            hour = hour + 24
        end
        bogotaHour = hour
        bogotaMinute = time.minute
        bogotaSecond = time.second
        bogotaDay = time.monthday
        bogotaMonth = time.month + 1
        bogotaYear = time.year + 1900
    end
    
    -- Formatear con ceros a la izquierda
    local hourStr = string.format("%02d", bogotaHour)
    local minuteStr = string.format("%02d", bogotaMinute)
    local secondStr = string.format("%02d", bogotaSecond)
    
    return hourStr, minuteStr, secondStr, bogotaDay, bogotaMonth, bogotaYear
end

-- Función para obtener nombre del día y mes
function getDayName(day, month, year)
    local days = {"Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"}
    local months = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", 
                    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"}
    
    -- Obtener día de la semana usando getRealTime
    local time = getRealTime()
    -- weekdayday en MTA: 0 = Domingo, 1 = Lunes, ..., 6 = Sábado
    local wday = time.weekday
    if wday < 0 or wday > 6 then wday = 0 end
    
    return days[wday + 1] or "Domingo", months[month] or "Enero"
end

-- Variables para FPS
local lastTick = getTickCount()
local currentFPS = 0

-- Actualizar FPS
setTimer(function()
    if isElement(localPlayer) then
        local tick = getTickCount()
        local delta = tick - lastTick
        if delta > 0 then
            currentFPS = math.floor(1000 / delta)
        end
        lastTick = tick
    end
end, 100, 0)

-- Función principal para dibujar el HUD
function drawCustomHUD()
    if not getElementData(localPlayer, "characterSelected") then
        return
    end
    
    -- Obtener datos actualizados
    money = getPlayerMoney(localPlayer)
    health = getElementHealth(localPlayer)
    armor = getPedArmor(localPlayer)
    
    -- Obtener nombre del personaje
    local charName = getElementData(localPlayer, "characterName") or ""
    local charSurname = getElementData(localPlayer, "characterSurname") or ""
    characterName = charName
    characterSurname = charSurname
    playerID = getElementData(localPlayer, "playerID") or 0
    
    -- Verificar si está bajo el agua para mostrar respiración
    local x, y, z = getElementPosition(localPlayer)
    local isUnderwater = isElementInWater(localPlayer) or (z < 0.5)
    if isUnderwater then
        local pedOxygen = getPedOxygenLevel(localPlayer)
        oxygen = math.max(0, math.min(100, (pedOxygen / 1000) * 100))
    else
        oxygen = 100
    end
    
    -- ========== PARTE SUPERIOR: VIDA, RESPIRACIÓN, COMIDA, AGUA Y DINERO ==========
    local topCardWidth = 280
    local topHudX = screenWidth - topCardWidth - 20
    local topHudY = 20
    local topCardHeight = 60
    local topSpacing = 8
    local currentTopY = topHudY
    
    -- ========== TARJETA DE SALUD (PRIMERA) ==========
    local healthPercent = math.max(0, math.min(100, health))
    local healthColor = healthPercent > 30 and colors.healthGood or colors.health
    local healthGlow = healthPercent > 30 and colors.healthGoodGlow or colors.healthGlow
    
    drawCard(topHudX, currentTopY, topCardWidth, topCardHeight, colors.bgCard, true, healthGlow)
    dxDrawRectangle(topHudX, currentTopY, 4, topCardHeight, tocolor(healthColor[1], healthColor[2], healthColor[3], healthColor[4]), true)
    dxDrawRectangle(topHudX + 1, currentTopY, 2, topCardHeight, tocolor(255, 255, 255, 50), true)
    
    local healthImageX = topHudX + cardPadding
    local healthImageY = currentTopY + (topCardHeight / 2) - (healthImageSize / 2)
    
    if healthImageLoaded and healthImage then
        dxDrawImage(healthImageX, healthImageY, healthImageSize, healthImageSize, healthImage, 0, 0, 0, tocolor(255, 255, 255, 255), true)
        
        local borderThickness = 4
        local centerX = healthImageX + (healthImageSize / 2)
        local centerY = healthImageY + (healthImageSize / 2)
        local radius = (healthImageSize / 2) + 2
        
        for i = 0, 360, 3 do
            local angle = math.rad(i - 90)
            local x1 = centerX + (radius * math.cos(angle))
            local y1 = centerY + (radius * math.sin(angle))
            local x2 = centerX + ((radius + borderThickness) * math.cos(angle))
            local y2 = centerY + ((radius + borderThickness) * math.sin(angle))
            dxDrawLine(x1, y1, x2, y2, tocolor(30, 30, 40, 200), borderThickness, true)
        end
        
        local startAngle = -90
        local endAngle = startAngle + (360 * (healthPercent / 100))
        for i = startAngle, endAngle, 3 do
            local angle = math.rad(i)
            local x1 = centerX + (radius * math.cos(angle))
            local y1 = centerY + (radius * math.sin(angle))
            local x2 = centerX + ((radius + borderThickness) * math.cos(angle))
            local y2 = centerY + ((radius + borderThickness) * math.sin(angle))
            dxDrawLine(x1, y1, x2, y2, tocolor(healthColor[1], healthColor[2], healthColor[3], healthColor[4]), borderThickness, true)
        end
    end
    
    local healthInfoX = healthImageX + healthImageSize + 12
    dxDrawModernText("SALUD", healthInfoX, currentTopY + 8, topHudX + topCardWidth - cardPadding, currentTopY + 22,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.55, "default", "left", "top", false, false, true)
    dxDrawModernText(math.floor(healthPercent) .. "%", healthInfoX, currentTopY + 24, topHudX + topCardWidth - cardPadding, currentTopY + 42,
        tocolor(healthColor[1], healthColor[2], healthColor[3], healthColor[4]),
        0.85, "default-bold", "left", "top", false, false, true)
    
    local barY = currentTopY + topCardHeight - 14
    local barWidth = topCardWidth - (cardPadding * 2) - healthImageSize - 12
    drawProgressBar(healthInfoX, barY, barWidth, 5, healthPercent, healthColor, {25, 25, 35, 255}, true, healthGlow)
    
    currentTopY = currentTopY + topCardHeight + topSpacing
    
    -- ========== TARJETA DE RESPIRACIÓN (solo si está bajo el agua) ==========
    if isUnderwater then
        local oxygenPercent = math.max(0, math.min(100, oxygen))
        local oxygenColor = oxygenPercent > 30 and colors.oxygen or colors.health
        local oxygenGlow = oxygenPercent > 30 and colors.oxygenGlow or colors.healthGlow
        
        drawCard(topHudX, currentTopY, topCardWidth, topCardHeight, colors.bgCard, true, oxygenGlow)
        dxDrawRectangle(topHudX, currentTopY, 4, topCardHeight, tocolor(oxygenColor[1], oxygenColor[2], oxygenColor[3], oxygenColor[4]), true)
        dxDrawRectangle(topHudX + 1, currentTopY, 2, topCardHeight, tocolor(255, 255, 255, 50), true)
        
        dxDrawModernText("RESPIRACIÓN", topHudX + cardPadding, currentTopY + 8, topHudX + topCardWidth - cardPadding, currentTopY + 22,
            tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
            0.55, "default", "left", "top", false, false, true)
        dxDrawModernText(math.floor(oxygenPercent) .. "%", topHudX + cardPadding, currentTopY + 24, topHudX + topCardWidth - cardPadding, currentTopY + 42,
            tocolor(oxygenColor[1], oxygenColor[2], oxygenColor[3], oxygenColor[4]),
            0.85, "default-bold", "left", "top", false, false, true)
        
        local oxygenBarY = currentTopY + topCardHeight - 14
        local oxygenBarWidth = topCardWidth - (cardPadding * 2)
        drawProgressBar(topHudX + cardPadding, oxygenBarY, oxygenBarWidth, 5, oxygenPercent, oxygenColor, {25, 25, 35, 255}, true, oxygenGlow)
        
        currentTopY = currentTopY + topCardHeight + topSpacing
    end
    
    -- ========== TARJETA DE HAMBRE ==========
    local hungerPercent = math.max(0, math.min(100, hunger))
    local hungerColor = hungerPercent > 30 and colors.hunger or colors.health
    local hungerGlow = hungerPercent > 30 and colors.hungerGlow or colors.healthGlow
    
    drawCard(topHudX, currentTopY, topCardWidth, topCardHeight, colors.bgCard, true, hungerGlow)
    dxDrawRectangle(topHudX, currentTopY, 4, topCardHeight, tocolor(hungerColor[1], hungerColor[2], hungerColor[3], hungerColor[4]), true)
    dxDrawRectangle(topHudX + 1, currentTopY, 2, topCardHeight, tocolor(255, 255, 255, 50), true)
    
    local foodImageX = topHudX + cardPadding
    local foodImageY = currentTopY + (topCardHeight / 2) - (iconSize / 2)
    
    if foodImageLoaded and foodImage then
        dxDrawImage(foodImageX, foodImageY, iconSize, iconSize, foodImage, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
    
    local foodTextX = foodImageX + iconSize + 12
    dxDrawModernText("HAMBRE", foodTextX, currentTopY + 8, topHudX + topCardWidth - cardPadding, currentTopY + 22,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.55, "default", "left", "top", false, false, true)
    dxDrawModernText(math.floor(hungerPercent) .. "%", foodTextX, currentTopY + 24, topHudX + topCardWidth - cardPadding, currentTopY + 42,
        tocolor(hungerColor[1], hungerColor[2], hungerColor[3], hungerColor[4]),
        0.85, "default-bold", "left", "top", false, false, true)
    
    local hungerBarY = currentTopY + topCardHeight - 14
    local hungerBarWidth = topCardWidth - (cardPadding * 2) - iconSize - 12
    drawProgressBar(foodTextX, hungerBarY, hungerBarWidth, 5, hungerPercent, hungerColor, {25, 25, 35, 255}, true, hungerGlow)
    
    currentTopY = currentTopY + topCardHeight + topSpacing
    
    -- ========== TARJETA DE SED/HIDRATACIÓN ==========
    local thirstPercent = math.max(0, math.min(100, thirst))
    local thirstColor = thirstPercent > 30 and colors.thirst or colors.health
    local thirstGlow = thirstPercent > 30 and colors.thirstGlow or colors.healthGlow
    
    drawCard(topHudX, currentTopY, topCardWidth, topCardHeight, colors.bgCard, true, thirstGlow)
    dxDrawRectangle(topHudX, currentTopY, 4, topCardHeight, tocolor(thirstColor[1], thirstColor[2], thirstColor[3], thirstColor[4]), true)
    dxDrawRectangle(topHudX + 1, currentTopY, 2, topCardHeight, tocolor(255, 255, 255, 50), true)
    
    local waterImageX = topHudX + cardPadding
    local waterImageY = currentTopY + (topCardHeight / 2) - (iconSize / 2)
    
    if waterImageLoaded and waterImage then
        dxDrawImage(waterImageX, waterImageY, iconSize, iconSize, waterImage, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
    
    local waterTextX = waterImageX + iconSize + 12
    dxDrawModernText("HIDRATACIÓN", waterTextX, currentTopY + 8, topHudX + topCardWidth - cardPadding, currentTopY + 22,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.55, "default", "left", "top", false, false, true)
    dxDrawModernText(math.floor(thirstPercent) .. "%", waterTextX, currentTopY + 24, topHudX + topCardWidth - cardPadding, currentTopY + 42,
        tocolor(thirstColor[1], thirstColor[2], thirstColor[3], thirstColor[4]),
        0.85, "default-bold", "left", "top", false, false, true)
    
    local thirstBarY = currentTopY + topCardHeight - 14
    local thirstBarWidth = topCardWidth - (cardPadding * 2) - iconSize - 12
    drawProgressBar(waterTextX, thirstBarY, thirstBarWidth, 5, thirstPercent, thirstColor, {25, 25, 35, 255}, true, thirstGlow)
    
    currentTopY = currentTopY + topCardHeight + topSpacing
    
    -- ========== TARJETA DE DINERO (ÚLTIMA EN ARRIBA) ==========
    drawCard(topHudX, currentTopY, topCardWidth, topCardHeight, colors.bgCard, true, colors.moneyGlow)
    dxDrawRectangle(topHudX, currentTopY, 4, topCardHeight, tocolor(colors.money[1], colors.money[2], colors.money[3], colors.money[4]), true)
    dxDrawRectangle(topHudX + 1, currentTopY, 2, topCardHeight, tocolor(255, 255, 255, 50), true)
    
    local moneyImageX = topHudX + cardPadding
    local moneyImageY = currentTopY + (topCardHeight / 2) - (moneyImageSize / 2)
    
    if moneyImageLoaded and moneyImage then
        dxDrawImage(moneyImageX, moneyImageY, moneyImageSize, moneyImageSize, moneyImage, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
    
    local moneyTextX = moneyImageX + moneyImageSize + 12
    dxDrawModernText("DINERO", moneyTextX, currentTopY + 8, topHudX + topCardWidth - cardPadding, currentTopY + 22,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.55, "default", "left", "top", false, false, true)
    dxDrawModernText("$" .. formatNumber(money), moneyTextX, currentTopY + 24, topHudX + topCardWidth - cardPadding, currentTopY + 42,
        tocolor(colors.money[1], colors.money[2], colors.money[3], colors.money[4]),
        0.85, "default-bold", "left", "top", false, false, true)
    
    -- ========== PARTE INFERIOR DERECHA: FPS, PING, FECHA/HORA, NOMBRE, ID, SERVIDOR ==========
    local bottomCardWidth = 350
    local bottomHudX = screenWidth - bottomCardWidth - 20
    local bottomHudY = screenHeight - 180
    local bottomCardHeight = 45
    local bottomSpacing = 6
    local currentBottomY = bottomHudY
    
    -- Obtener FPS y ping
    local playerPing = getPlayerPing(localPlayer) or 0
    
    -- Obtener hora de Bogotá
    local hour, minute, second, day, month, year = getBogotaTime()
    local dayName, monthName = getDayName(day, month, year)
    
    -- ========== TARJETA DE INFORMACIÓN DEL SERVIDOR Y JUGADOR ==========
    local infoCardHeight = 70
    drawCard(bottomHudX, currentBottomY, bottomCardWidth, infoCardHeight, colors.bgCard, true, colors.accentGlow)
    
    -- Línea de acento superior
    dxDrawRectangle(bottomHudX, currentBottomY, bottomCardWidth, 4, tocolor(colors.accent[1], colors.accent[2], colors.accent[3], colors.accent[4]), true)
    dxDrawRectangle(bottomHudX, currentBottomY, bottomCardWidth, 2, tocolor(255, 255, 255, 60), true)
    
    -- Nombre del servidor
    dxDrawModernText("COLOMBIA RP", bottomHudX + cardPadding, currentBottomY + 8, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 22,
        tocolor(colors.textPrimary[1], colors.textPrimary[2], colors.textPrimary[3], colors.textPrimary[4]),
        0.75, "default-bold", "left", "top", false, false, true)
    
    -- Información del jugador
    local playerInfo = ""
    if characterName ~= "" and characterSurname ~= "" then
        playerInfo = characterName .. "_" .. characterSurname
    else
        playerInfo = getPlayerName(localPlayer) or "Jugador"
    end
    playerInfo = playerInfo .. " • ID: " .. playerID
    
    dxDrawModernText(playerInfo, bottomHudX + cardPadding, currentBottomY + 26, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 42,
        tocolor(colors.textSecondary[1], colors.textSecondary[2], colors.textSecondary[3], colors.textSecondary[4]),
        0.6, "default", "left", "top", false, false, true)
    
    -- FPS y Ping
    local fpsColor = currentFPS >= 30 and colors.healthGood or (currentFPS >= 15 and colors.hunger or colors.health)
    local pingColor = playerPing <= 100 and colors.healthGood or (playerPing <= 200 and colors.hunger or colors.health)
    
    dxDrawModernText("FPS: " .. currentFPS, bottomHudX + bottomCardWidth - 120, currentBottomY + 8, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 22,
        tocolor(fpsColor[1], fpsColor[2], fpsColor[3], fpsColor[4]),
        0.65, "default-bold", "right", "top", false, false, true)
    
    dxDrawModernText("PING: " .. playerPing .. "ms", bottomHudX + bottomCardWidth - 120, currentBottomY + 26, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 42,
        tocolor(pingColor[1], pingColor[2], pingColor[3], pingColor[4]),
        0.65, "default-bold", "right", "top", false, false, true)
    
    currentBottomY = currentBottomY + infoCardHeight + bottomSpacing
    
    -- ========== TARJETA DE FECHA Y HORA ==========
    drawCard(bottomHudX, currentBottomY, bottomCardWidth, bottomCardHeight, colors.bgCard, true, colors.accentGlow)
    
    -- Hora
    local timeText = hour .. ":" .. minute .. ":" .. second
    dxDrawModernText(timeText, bottomHudX + cardPadding, currentBottomY + 8, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 28,
        tocolor(colors.textPrimary[1], colors.textPrimary[2], colors.textPrimary[3], colors.textPrimary[4]),
        0.9, "default-bold", "left", "top", false, false, true)
    
    -- Fecha
    local dateText = dayName .. ", " .. day .. " de " .. monthName .. " " .. year
    dxDrawModernText(dateText, bottomHudX + cardPadding, currentBottomY + 30, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 45,
        tocolor(colors.textSecondary[1], colors.textSecondary[2], colors.textSecondary[3], colors.textSecondary[4]),
        0.55, "default", "left", "top", false, false, true)
    
    -- Ubicación
    dxDrawModernText("🕐 Bogotá, Colombia (UTC-5)", bottomHudX + bottomCardWidth - 200, currentBottomY + 30, bottomHudX + bottomCardWidth - cardPadding, currentBottomY + 45,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.5, "default", "right", "top", false, false, true)
end

-- Renderizar el HUD cada frame
addEventHandler("onClientRender", root, drawCustomHUD)

-- Actualizar cuando cambia el dinero
addEventHandler("onClientPlayerMoneyChange", localPlayer, function(newAmount, oldAmount, instant)
    money = newAmount
    triggerServerEvent("onPlayerMoneyChanged", localPlayer, newAmount)
end)

-- Actualizar datos del personaje cuando se selecciona
addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        if getElementData(localPlayer, "characterSelected") then
            characterName = getElementData(localPlayer, "characterName") or ""
            characterSurname = getElementData(localPlayer, "characterSurname") or ""
            playerID = getElementData(localPlayer, "playerID") or 0
        end
    end, 1000, 1)
end)

-- Escuchar cuando se selecciona un personaje
addEvent("onCharacterSelectResult", true)
addEventHandler("onCharacterSelectResult", root, function(success, message)
    if success then
        setTimer(function()
            characterName = getElementData(localPlayer, "characterName") or ""
            characterSurname = getElementData(localPlayer, "characterSurname") or ""
            playerID = getElementData(localPlayer, "playerID") or 0
        end, 500, 1)
    end
end)

-- Actualizar cuando cambia la salud
addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon, bodypart, loss)
    health = getElementHealth(localPlayer)
end)

-- Actualizar cuando cambia la armadura, salud, hambre y sed
setTimer(function()
    if isElement(localPlayer) and getElementData(localPlayer, "characterSelected") then
        armor = getPedArmor(localPlayer)
        health = getElementHealth(localPlayer)
        
        -- Obtener hambre y sed del servidor
        local serverHunger = getElementData(localPlayer, "characterHunger")
        local serverThirst = getElementData(localPlayer, "characterThirst")
        
        if serverHunger then
            hunger = tonumber(serverHunger) or hunger
        end
        
        if serverThirst then
            thirst = tonumber(serverThirst) or thirst
        end
        
        -- Actualizar oxígeno si está bajo el agua
        local x, y, z = getElementPosition(localPlayer)
        if isElementInWater(localPlayer) or (z < 0.5) then
            local pedOxygen = getPedOxygenLevel(localPlayer)
            oxygen = math.max(0, math.min(100, (pedOxygen / 1000) * 100))
        else
            oxygen = 100  -- Lleno cuando no está bajo el agua
        end
    end
end, 100, 0)
