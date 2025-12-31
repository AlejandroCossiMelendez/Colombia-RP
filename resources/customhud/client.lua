-- HUD Personalizado para Colombia RP
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

-- Colores del tema
local colors = {
    background = {0, 0, 0, 180},        -- Fondo semi-transparente
    money = {46, 204, 113, 255},        -- Verde para dinero
    health = {231, 76, 60, 255},         -- Rojo para salud
    armor = {52, 152, 219, 255},        -- Azul para armadura
    text = {236, 240, 241, 255},        -- Texto claro
    border = {41, 128, 185, 255}        -- Borde azul
}

-- Tamaños de las imágenes
local healthImageSize = 80 -- Tamaño en píxeles (ancho y alto)
local moneyImageSize = 40 -- Tamaño de la imagen del dólar

-- Ocultar HUD por defecto de MTA
addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("money", false)
    setPlayerHudComponentVisible("health", false)
    setPlayerHudComponentVisible("armour", false)
    setPlayerHudComponentVisible("ammo", false)
    setPlayerHudComponentVisible("weapon", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("vehicle_name", false)
    
    -- Cargar imagen de salud
    healthImage = dxCreateTexture("images/health_icon.png", "argb", true, "clamp")
    if healthImage then
        healthImageLoaded = true
    else
        healthImageLoaded = false
    end
    
    -- Cargar imagen del dólar
    moneyImage = dxCreateTexture("images/dolar.png", "argb", true, "clamp")
    if moneyImage then
        moneyImageLoaded = true
    else
        moneyImageLoaded = false
    end
    
    -- Obtener ID del jugador (se establece desde el servidor)
    playerID = getElementData(localPlayer, "playerID") or 0
end)

-- Función para formatear números con separadores de miles
function formatNumber(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Función para dibujar texto con sombra
function dxDrawShadowText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    local shadowColor = tocolor(0, 0, 0, 200)
    dxDrawText(text, x + 2, y + 2, w + 2, h + 2, shadowColor, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

-- Función para dibujar el HUD
function drawCustomHUD()
    if not getElementData(localPlayer, "characterSelected") then
        return -- No mostrar HUD si no hay personaje seleccionado
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
    
    -- Obtener ID del jugador (se establece desde el servidor)
    playerID = getElementData(localPlayer, "playerID") or 0
    
    -- Posición del HUD (esquina superior derecha)
    local hudX = screenWidth - 280
    local hudY = 20
    local hudWidth = 260
    local itemHeight = 40
    local spacing = 8
    
    -- Calcular altura total del HUD
    local totalHeight = 50 + (itemHeight * 2) + spacing + healthImageSize + 20
    if armor > 0 then
        totalHeight = totalHeight + itemHeight + spacing
    end
    
    -- Fondo del HUD
    dxDrawRectangle(hudX, hudY, hudWidth, totalHeight, tocolor(colors.background[1], colors.background[2], colors.background[3], colors.background[4]))
    
    -- Borde superior
    dxDrawRectangle(hudX, hudY, hudWidth, 3, tocolor(colors.border[1], colors.border[2], colors.border[3], colors.border[4]))
    
    -- Título y información del jugador
    local titleY = hudY + 8
    dxDrawShadowText("COLOMBIA RP", hudX + 10, titleY, hudX + hudWidth - 10, titleY + 15, 
        tocolor(colors.text[1], colors.text[2], colors.text[3], colors.text[4]), 0.8, "default-bold", "left", "top")
    
    -- Nombre del personaje e ID
    local playerInfo = ""
    if characterName ~= "" and characterSurname ~= "" then
        playerInfo = characterName .. "_" .. characterSurname
    else
        playerInfo = getPlayerName(localPlayer) or "Jugador"
    end
    playerInfo = playerInfo .. " [ID: " .. playerID .. "]"
    
    dxDrawShadowText(playerInfo, hudX + 10, titleY + 18, hudX + hudWidth - 10, titleY + 33, 
        tocolor(colors.text[1], colors.text[2], colors.text[3], 180), 0.6, "default", "left", "top")
    
    local currentY = hudY + 45
    
    -- Dinero con imagen
    local moneyBoxHeight = itemHeight
    dxDrawRectangle(hudX + 10, currentY, hudWidth - 20, moneyBoxHeight, tocolor(30, 30, 30, 200))
    dxDrawRectangle(hudX + 10, currentY, 3, moneyBoxHeight, tocolor(colors.money[1], colors.money[2], colors.money[3], colors.money[4]))
    
    -- Imagen del dólar
    local moneyImageX = hudX + 20
    local moneyImageY = currentY + (moneyBoxHeight / 2) - (moneyImageSize / 2)
    
    if moneyImageLoaded and moneyImage then
        dxDrawImage(moneyImageX, moneyImageY, moneyImageSize, moneyImageSize, moneyImage, 0, 0, 0, tocolor(255, 255, 255, 255))
    end
    
    -- Texto del dinero
    local moneyTextX = moneyImageX + moneyImageSize + 10
    dxDrawShadowText("Dinero", moneyTextX, currentY + 5, hudX + hudWidth - 10, currentY + 20, 
        tocolor(colors.text[1], colors.text[2], colors.text[3], 200), 0.6, "default", "left", "top")
    dxDrawShadowText("$" .. formatNumber(money), moneyTextX, currentY + 20, hudX + hudWidth - 10, currentY + moneyBoxHeight, 
        tocolor(colors.money[1], colors.money[2], colors.money[3], colors.money[4]), 0.75, "default-bold", "left", "top")
    
    currentY = currentY + moneyBoxHeight + spacing
    
    -- Salud con imagen PNG
    local healthPercent = math.max(0, math.min(100, health))
    local healthImageX = hudX + 10
    local healthImageY = currentY + 5
    
    if healthImageLoaded and healthImage then
        -- Dibujar la imagen de salud
        dxDrawImage(healthImageX, healthImageY, healthImageSize, healthImageSize, healthImage, 0, 0, 0, tocolor(255, 255, 255, 255))
        
        -- Dibujar borde de vida alrededor de la imagen
        -- El borde cambia de color según la salud (rojo cuando está bajo, verde cuando está alto)
        local borderColor = tocolor(colors.health[1], colors.health[2], colors.health[3], 255)
        if healthPercent > 50 then
            -- Verde cuando está por encima del 50%
            local greenValue = math.floor(255 * (healthPercent / 100))
            borderColor = tocolor(0, greenValue, 0, 255)
        end
        
        -- Dibujar borde circular alrededor de la imagen
        local borderThickness = 4
        local centerX = healthImageX + (healthImageSize / 2)
        local centerY = healthImageY + (healthImageSize / 2)
        local radius = (healthImageSize / 2) + 2
        
        -- Dibujar arco de vida alrededor de la imagen (360 grados según la salud)
        local startAngle = -90 -- Empezar desde arriba
        local endAngle = startAngle + (360 * (healthPercent / 100))
        
        -- Dibujar círculo completo de fondo (gris)
        for i = 0, 360, 2 do
            local angle = math.rad(i - 90)
            local x1 = centerX + (radius * math.cos(angle))
            local y1 = centerY + (radius * math.sin(angle))
            local x2 = centerX + ((radius + borderThickness) * math.cos(angle))
            local y2 = centerY + ((radius + borderThickness) * math.sin(angle))
            dxDrawLine(x1, y1, x2, y2, tocolor(50, 50, 50, 200), borderThickness)
        end
        
        -- Dibujar arco de vida (verde/rojo según salud)
        for i = startAngle, endAngle, 2 do
            local angle = math.rad(i)
            local x1 = centerX + (radius * math.cos(angle))
            local y1 = centerY + (radius * math.sin(angle))
            local x2 = centerX + ((radius + borderThickness) * math.cos(angle))
            local y2 = centerY + ((radius + borderThickness) * math.sin(angle))
            dxDrawLine(x1, y1, x2, y2, borderColor, borderThickness)
        end
        
        -- Texto de porcentaje debajo de la imagen
        dxDrawShadowText("❤ " .. math.floor(healthPercent) .. "%", healthImageX, healthImageY + healthImageSize + 5, 
            healthImageX + healthImageSize, healthImageY + healthImageSize + 20, 
            borderColor, 0.7, "default-bold", "center", "top")
    else
        -- Diseño por defecto si no hay imagen
        dxDrawRectangle(hudX + 10, currentY, hudWidth - 20, itemHeight, tocolor(30, 30, 30, 200))
        dxDrawRectangle(hudX + 10, currentY, 3, itemHeight, tocolor(colors.health[1], colors.health[2], colors.health[3], colors.health[4]))
        
        local healthBarWidth = (hudWidth - 30) * (healthPercent / 100)
        dxDrawRectangle(hudX + 20, currentY + 20, hudWidth - 30, 8, tocolor(50, 50, 50, 200))
        dxDrawRectangle(hudX + 20, currentY + 20, healthBarWidth, 8, tocolor(colors.health[1], colors.health[2], colors.health[3], colors.health[4]))
        
        dxDrawShadowText("❤ Salud", hudX + 20, currentY + 5, hudX + hudWidth - 10, currentY + itemHeight, 
            tocolor(colors.text[1], colors.text[2], colors.text[3], 200), 0.6, "default", "left", "top")
        dxDrawShadowText(math.floor(healthPercent) .. "%", hudX + hudWidth - 30, currentY + 5, hudX + hudWidth - 10, currentY + itemHeight, 
            tocolor(colors.health[1], colors.health[2], colors.health[3], colors.health[4]), 0.7, "default-bold", "right", "top")
    end
    
    currentY = currentY + healthImageSize + 15 + spacing
    
    -- Armadura (solo si tiene)
    if armor > 0 then
        local armorPercent = math.max(0, math.min(100, armor))
        dxDrawRectangle(hudX + 10, currentY, hudWidth - 20, itemHeight, tocolor(30, 30, 30, 200))
        dxDrawRectangle(hudX + 10, currentY, 3, itemHeight, tocolor(colors.armor[1], colors.armor[2], colors.armor[3], colors.armor[4]))
        
        -- Barra de armadura
        local armorBarWidth = (hudWidth - 30) * (armorPercent / 100)
        dxDrawRectangle(hudX + 20, currentY + 20, hudWidth - 30, 8, tocolor(50, 50, 50, 200))
        dxDrawRectangle(hudX + 20, currentY + 20, armorBarWidth, 8, tocolor(colors.armor[1], colors.armor[2], colors.armor[3], colors.armor[4]))
        
        dxDrawShadowText("🛡 Armadura", hudX + 20, currentY + 5, hudX + hudWidth - 10, currentY + itemHeight, 
            tocolor(colors.text[1], colors.text[2], colors.text[3], 200), 0.6, "default", "left", "top")
        dxDrawShadowText(math.floor(armorPercent) .. "%", hudX + hudWidth - 30, currentY + 5, hudX + hudWidth - 10, currentY + itemHeight, 
            tocolor(colors.armor[1], colors.armor[2], colors.armor[3], colors.armor[4]), 0.7, "default-bold", "right", "top")
    end
end

-- Renderizar el HUD cada frame
addEventHandler("onClientRender", root, drawCustomHUD)

-- Actualizar cuando cambia el dinero
addEventHandler("onClientPlayerMoneyChange", localPlayer, function(newAmount, oldAmount, instant)
    money = newAmount
    -- Notificar al servidor para guardar en la base de datos
    triggerServerEvent("onPlayerMoneyChanged", localPlayer, newAmount)
end)

-- Actualizar datos del personaje cuando se selecciona
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Esperar a que el recurso de login esté listo
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

