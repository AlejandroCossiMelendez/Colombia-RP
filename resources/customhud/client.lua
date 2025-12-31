-- HUD Personalizado Moderno para Colombia RP
local screenWidth, screenHeight = guiGetScreenSize()
local money = 0
local health = 100
local armor = 0

-- Cargar imágenes
local healthImage = nil
local healthImageLoaded = false
local moneyImage = nil
local moneyImageLoaded = false

-- Datos del personaje
local characterName = ""
local characterSurname = ""
local playerID = 0

-- Colores modernos y profesionales
local colors = {
    -- Fondos
    bgPrimary = {15, 15, 20, 240},      -- Fondo principal oscuro
    bgSecondary = {25, 25, 35, 220},   -- Fondo secundario
    bgCard = {30, 30, 40, 230},        -- Fondo de tarjetas
    
    -- Acentos
    accent = {74, 144, 226, 255},      -- Azul moderno
    accentDark = {54, 104, 176, 255},  -- Azul oscuro
    
    -- Estados
    money = {52, 211, 153, 255},       -- Verde esmeralda
    health = {239, 68, 68, 255},       -- Rojo moderno
    healthGood = {34, 197, 94, 255},  -- Verde saludable
    armor = {59, 130, 246, 255},       -- Azul armadura
    
    -- Texto
    textPrimary = {255, 255, 255, 255},    -- Texto principal
    textSecondary = {200, 200, 210, 255},   -- Texto secundario
    textMuted = {150, 150, 160, 255},      -- Texto atenuado
    
    -- Bordes y líneas
    border = {60, 60, 75, 255},        -- Borde sutil
    divider = {40, 40, 50, 255}        -- Divisor
}

-- Tamaños
local healthImageSize = 48  -- Reducido para que se vea mejor
local moneyImageSize = 32
local cardPadding = 16
local cardSpacing = 12

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
    
    -- Cargar imágenes
    healthImage = dxCreateTexture("images/health_icon.png", "argb", true, "clamp")
    healthImageLoaded = healthImage ~= nil
    
    moneyImage = dxCreateTexture("images/dolar.png", "argb", true, "clamp")
    moneyImageLoaded = moneyImage ~= nil
    
    playerID = getElementData(localPlayer, "playerID") or 0
end)

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

-- Función para dibujar tarjeta con sombra
function drawCard(x, y, width, height, color, postGUI)
    postGUI = postGUI or true  -- Por defecto dibujar encima de todo
    -- Sombra
    dxDrawRectangle(x + 2, y + 2, width, height, tocolor(0, 0, 0, 100), postGUI)
    -- Tarjeta
    dxDrawRectangle(x, y, width, height, tocolor(color[1], color[2], color[3], color[4]), postGUI)
    -- Borde superior sutil
    dxDrawRectangle(x, y, width, 1, tocolor(255, 255, 255, 30), postGUI)
end

-- Función para dibujar barra de progreso moderna
function drawProgressBar(x, y, width, height, progress, color, bgColor, postGUI)
    postGUI = postGUI or true
    progress = math.max(0, math.min(100, progress))
    local barWidth = (width * progress) / 100
    
    -- Fondo
    dxDrawRectangle(x, y, width, height, tocolor(bgColor[1], bgColor[2], bgColor[3], bgColor[4] or 200), postGUI)
    -- Barra
    if barWidth > 0 then
        dxDrawRectangle(x, y, barWidth, height, tocolor(color[1], color[2], color[3], color[4] or 255), postGUI)
        -- Brillo superior
        dxDrawRectangle(x, y, barWidth, 1, tocolor(255, 255, 255, 80), postGUI)
    end
end

-- Función para obtener hora de Bogotá, Colombia (UTC-5)
function getBogotaTime()
    local time = getRealTime()
    local hour = time.hour - 5  -- UTC-5 para Bogotá
    if hour < 0 then
        hour = hour + 24
    end
    local minute = time.minute
    local second = time.second
    
    -- Formatear con ceros a la izquierda
    local hourStr = string.format("%02d", hour)
    local minuteStr = string.format("%02d", minute)
    local secondStr = string.format("%02d", second)
    
    return hourStr, minuteStr, secondStr, time.monthday, time.month + 1, time.year + 1900
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
    
    -- Posición del HUD (esquina superior derecha para no interferir con el chat)
    local cardWidth = 320
    local hudX = screenWidth - cardWidth - 20
    local hudY = 20
    
    -- ========== TARJETA DE RELOJ (BOGOTÁ, COLOMBIA) ==========
    -- Dibujar con postGUI = true para que se vea delante de todo
    local clockCardHeight = 80
    drawCard(hudX, hudY, cardWidth, clockCardHeight, colors.bgCard, true)
    
    -- Línea de acento superior
    dxDrawRectangle(hudX, hudY, cardWidth, 3,
        tocolor(colors.accent[1], colors.accent[2], colors.accent[3], colors.accent[4]), true)
    
    -- Obtener hora de Bogotá
    local hour, minute, second, day, month, year = getBogotaTime()
    local dayName, monthName = getDayName(day, month, year)
    
    -- Hora grande
    local timeText = hour .. ":" .. minute .. ":" .. second
    dxDrawModernText(timeText, hudX + cardPadding, hudY + 12, hudX + cardWidth - cardPadding, hudY + 40,
        tocolor(colors.textPrimary[1], colors.textPrimary[2], colors.textPrimary[3], colors.textPrimary[4]),
        1.1, "default-bold", "left", "top", false, false, true)
    
    -- Fecha y ubicación
    local dateText = dayName .. ", " .. day .. " de " .. monthName .. " " .. year
    dxDrawModernText(dateText, hudX + cardPadding, hudY + 38, hudX + cardWidth - cardPadding, hudY + 55,
        tocolor(colors.textSecondary[1], colors.textSecondary[2], colors.textSecondary[3], colors.textSecondary[4]),
        0.6, "default", "left", "top", false, false, true)
    
    -- Ubicación
    dxDrawModernText("🕐 Bogotá, Colombia (UTC-5)", hudX + cardPadding, hudY + 55, hudX + cardWidth - cardPadding, hudY + 75,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.55, "default", "left", "top", false, false, true)
    
    local currentY = hudY + clockCardHeight + cardSpacing
    
    -- ========== TARJETA DE INFORMACIÓN DEL JUGADOR ==========
    local playerCardHeight = 70
    drawCard(hudX, currentY, cardWidth, playerCardHeight, colors.bgCard, true)
    
    -- Línea de acento superior
    dxDrawRectangle(hudX, currentY, cardWidth, 3, tocolor(colors.accent[1], colors.accent[2], colors.accent[3], colors.accent[4]), true)
    
    -- Título del servidor
    dxDrawModernText("COLOMBIA RP", hudX + cardPadding, currentY + 12, hudX + cardWidth - cardPadding, currentY + 30,
        tocolor(colors.textPrimary[1], colors.textPrimary[2], colors.textPrimary[3], colors.textPrimary[4]),
        0.85, "default-bold", "left", "top", false, false, true)
    
    -- Información del jugador
    local playerInfo = ""
    if characterName ~= "" and characterSurname ~= "" then
        playerInfo = characterName .. "_" .. characterSurname
    else
        playerInfo = getPlayerName(localPlayer) or "Jugador"
    end
    playerInfo = playerInfo .. " • ID: " .. playerID
    
    dxDrawModernText(playerInfo, hudX + cardPadding, currentY + 35, hudX + cardWidth - cardPadding, currentY + 55,
        tocolor(colors.textSecondary[1], colors.textSecondary[2], colors.textSecondary[3], colors.textSecondary[4]),
        0.65, "default", "left", "top", false, false, true)
    
    -- Divisor
    dxDrawRectangle(hudX + cardPadding, currentY + playerCardHeight - 1, cardWidth - (cardPadding * 2), 1,
        tocolor(colors.divider[1], colors.divider[2], colors.divider[3], colors.divider[4]), true)
    
    currentY = currentY + playerCardHeight + cardSpacing
    
    -- ========== TARJETA DE DINERO ==========
    local moneyCardHeight = 60
    drawCard(hudX, currentY, cardWidth, moneyCardHeight, colors.bgCard, true)
    
    -- Línea de acento izquierda
    dxDrawRectangle(hudX, currentY, 3, moneyCardHeight,
        tocolor(colors.money[1], colors.money[2], colors.money[3], colors.money[4]), true)
    
    -- Imagen del dólar
    local moneyImageX = hudX + cardPadding
    local moneyImageY = currentY + (moneyCardHeight / 2) - (moneyImageSize / 2)
    
    if moneyImageLoaded and moneyImage then
        dxDrawImage(moneyImageX, moneyImageY, moneyImageSize, moneyImageSize, moneyImage, 0, 0, 0,
            tocolor(255, 255, 255, 255), true)
    end
    
    -- Texto del dinero
    local moneyTextX = moneyImageX + moneyImageSize + 12
    dxDrawModernText("DINERO", moneyTextX, currentY + 10, hudX + cardWidth - cardPadding, currentY + 25,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.6, "default", "left", "top", false, false, true)
    
    dxDrawModernText("$" .. formatNumber(money), moneyTextX, currentY + 28, hudX + cardWidth - cardPadding, currentY + 50,
        tocolor(colors.money[1], colors.money[2], colors.money[3], colors.money[4]),
        0.9, "default-bold", "left", "top", false, false, true)
    
    currentY = currentY + moneyCardHeight + cardSpacing
    
    -- ========== TARJETA DE SALUD ==========
    local healthCardHeight = 75  -- Reducido porque la imagen es más pequeña
    drawCard(hudX, currentY, cardWidth, healthCardHeight, colors.bgCard, true)
    
    -- Línea de acento izquierda
    local healthPercent = math.max(0, math.min(100, health))
    local healthColor = healthPercent > 30 and colors.healthGood or colors.health
    dxDrawRectangle(hudX, currentY, 3, healthCardHeight,
        tocolor(healthColor[1], healthColor[2], healthColor[3], healthColor[4]), true)
    
    -- Imagen de salud
    local healthImageX = hudX + cardPadding
    local healthImageY = currentY + (healthCardHeight / 2) - (healthImageSize / 2)
    
    if healthImageLoaded and healthImage then
        -- Imagen
        dxDrawImage(healthImageX, healthImageY, healthImageSize, healthImageSize, healthImage, 0, 0, 0,
            tocolor(255, 255, 255, 255), true)
        
        -- Borde circular de salud
        local borderThickness = 5
        local centerX = healthImageX + (healthImageSize / 2)
        local centerY = healthImageY + (healthImageSize / 2)
        local radius = (healthImageSize / 2) + 3
        
        -- Fondo del borde (gris oscuro)
        for i = 0, 360, 3 do
            local angle = math.rad(i - 90)
            local x1 = centerX + (radius * math.cos(angle))
            local y1 = centerY + (radius * math.sin(angle))
            local x2 = centerX + ((radius + borderThickness) * math.cos(angle))
            local y2 = centerY + ((radius + borderThickness) * math.sin(angle))
            dxDrawLine(x1, y1, x2, y2, tocolor(30, 30, 40, 200), borderThickness, true)
        end
        
        -- Borde de salud (color dinámico)
        local startAngle = -90
        local endAngle = startAngle + (360 * (healthPercent / 100))
        for i = startAngle, endAngle, 3 do
            local angle = math.rad(i)
            local x1 = centerX + (radius * math.cos(angle))
            local y1 = centerY + (radius * math.sin(angle))
            local x2 = centerX + ((radius + borderThickness) * math.cos(angle))
            local y2 = centerY + ((radius + borderThickness) * math.sin(angle))
            dxDrawLine(x1, y1, x2, y2,
                tocolor(healthColor[1], healthColor[2], healthColor[3], healthColor[4]),
                borderThickness, true)
        end
    end
    
    -- Información de salud a la derecha
    local healthInfoX = healthImageX + healthImageSize + 12
    dxDrawModernText("SALUD", healthInfoX, currentY + 12, hudX + cardWidth - cardPadding, currentY + 26,
        tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
        0.6, "default", "left", "top", false, false, true)
    
    dxDrawModernText(math.floor(healthPercent) .. "%", healthInfoX, currentY + 28, hudX + cardWidth - cardPadding, currentY + 48,
        tocolor(healthColor[1], healthColor[2], healthColor[3], healthColor[4]),
        0.95, "default-bold", "left", "top", false, false, true)
    
    -- Barra de salud debajo
    local barY = currentY + healthCardHeight - 18
    local barWidth = cardWidth - (cardPadding * 2) - healthImageSize - 12
    local barX = healthInfoX
    drawProgressBar(barX, barY, barWidth, 5, healthPercent, healthColor, {40, 40, 50, 255}, true)
    
    currentY = currentY + healthCardHeight + cardSpacing
    
    -- ========== TARJETA DE ARMADURA (solo si tiene) ==========
    if armor > 0 then
        local armorCardHeight = 60
        local armorPercent = math.max(0, math.min(100, armor))
        
        drawCard(hudX, currentY, cardWidth, armorCardHeight, colors.bgCard, true)
        
        -- Línea de acento izquierda
        dxDrawRectangle(hudX, currentY, 3, armorCardHeight,
            tocolor(colors.armor[1], colors.armor[2], colors.armor[3], colors.armor[4]), true)
        
        -- Texto de armadura
        dxDrawModernText("ARMADURA", hudX + cardPadding, currentY + 10, hudX + cardWidth - cardPadding, currentY + 25,
            tocolor(colors.textMuted[1], colors.textMuted[2], colors.textMuted[3], colors.textMuted[4]),
            0.6, "default", "left", "top", false, false, true)
        
        dxDrawModernText(math.floor(armorPercent) .. "%", hudX + cardPadding, currentY + 28, hudX + cardWidth - cardPadding, currentY + 50,
            tocolor(colors.armor[1], colors.armor[2], colors.armor[3], colors.armor[4]),
            0.9, "default-bold", "left", "top", false, false, true)
        
        -- Barra de armadura
        local armorBarY = currentY + armorCardHeight - 15
        local armorBarWidth = cardWidth - (cardPadding * 2)
        drawProgressBar(hudX + cardPadding, armorBarY, armorBarWidth, 6, armorPercent, colors.armor, {40, 40, 50, 255}, true)
    end
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

-- Actualizar cuando cambia la armadura
setTimer(function()
    if isElement(localPlayer) then
        armor = getPedArmor(localPlayer)
        health = getElementHealth(localPlayer)
    end
end, 100, 0)
