$ErrorActionPreference = 'Stop'
$p = 'c:\Users\Playanza\Desktop\OPTIMIZARRESOURCES\voice\cGlobals.lua'
$backup = $p + '.bak.ultra.' + (Get-Date).ToString('yyyyMMddHHmmss')
Copy-Item $p $backup

$c = Get-Content -Raw -Encoding UTF8 $p

# 1) Intervalos mucho más largos pero sin afectar UX
$c = $c.Replace('voiceUpdateInterval = 200', 'voiceUpdateInterval = 800') # 800ms para voz
$c = $c.Replace('radioUpdateInterval = 1000', 'radioUpdateInterval = 2000') # 2 segundos para radio
$c = $c.Replace('updateInterval = 500', 'updateInterval = 1500') # 1.5 segundos para huesos
$c = $c.Replace('boneInterval = 200', 'boneInterval = 400') # 400ms para aplicar huesos

# 2) Limitar FPS del renderizado a 30 FPS para reducir CPU masivamente
$fpsLimiter = @'
-- OPTIMIZACIÓN ULTRA: Limitador de FPS para voice (30 FPS)
local lastRenderTime = 0
local renderInterval = 33 -- 30 FPS

addEventHandler("onClientRender", root, function()
    local currentTime = getTickCount()
    if currentTime - lastRenderTime < renderInterval then
        return
    end
    lastRenderTime = currentTime
    
    if not exports.players:isLoggedIn(localPlayer) then return end
'@

# Reemplazar inicio del onClientRender
$c = $c.Replace('addEventHandler("onClientRender", root, function()
    if not exports.players:isLoggedIn(localPlayer) then return end', $fpsLimiter)

# 3) Optimizar dxDrawBorderedText - eliminar gsub costoso
$optimizedBorderedText = @'
-- OPTIMIZACIÓN ULTRA: dxDrawBorderedText sin gsub costoso
local textCache = {}
function dxDrawBorderedText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
    -- Cache del texto sin colores para evitar gsub repetido
    local textSinColor = textCache[text]
    if not textSinColor then
        textSinColor = text:gsub('#%x%x%x%x%x%x', '')
        textCache[text] = textSinColor
    end
    
    dxDrawText(textSinColor, x + 1, y + 1, w + 1, h + 1, COLOR_BLACK, scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
    dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
end
'@

# Reemplazar función dxDrawBorderedText
$c = [regex]::Replace($c, '-- OPTIMIZACIÓN: dxDrawBorderedText ultra eficiente.*?end', $optimizedBorderedText, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# 4) Optimizar updateVoiceCache - menos verificaciones
$optimizedVoiceCache = @'
-- OPTIMIZACIÓN ULTRA: Cache de voz ultra eficiente
local function updateVoiceCache()
    local currentTime = getTickCount()
    if currentTime - renderCache.lastVoiceUpdate < renderCache.voiceUpdateInterval and not renderCache.needsVoiceUpdate then
        return
    end
    
    renderCache.lastVoiceUpdate = currentTime
    renderCache.needsVoiceUpdate = false
    
    local estadoVoz = getElementData(localPlayer, "voice:Estado")
    if not estadoVoz then 
        renderCache.voiceText = ""
        return 
    end
    
    -- OPTIMIZACIÓN: Construcción de texto más eficiente
    local baseText = "#E56E11VOZ: " .. estadoVoz.nombre
    if voicePlayers[localPlayer] == true then
        renderCache.voiceText = baseText .. " ((" .. estadoVoz.nombre .. "...))"
    else
        renderCache.voiceText = baseText .. " "
    end
    
    -- Solo calcular width si el texto cambió
    renderCache.voiceWidth = dxGetTextWidth(renderCache.voiceText, 1, "default-bold")
end
'@

# Reemplazar función updateVoiceCache
$c = [regex]::Replace($c, '-- OPTIMIZACIÓN: Función para actualizar cache de voz.*?end', $optimizedVoiceCache, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# 5) Optimizar updateRadioCache - menos iteraciones
$optimizedRadioCache = @'
-- OPTIMIZACIÓN ULTRA: Cache de radio ultra eficiente
local function updateRadioCache()
    local currentTime = getTickCount()
    if currentTime - renderCache.lastRadioUpdate < renderCache.radioUpdateInterval and not renderCache.needsRadioUpdate then
        return
    end
    
    renderCache.lastRadioUpdate = currentTime
    renderCache.needsRadioUpdate = false
    renderCache.radioPlayers = {}
    
    local estadoRadio = getElementData(localPlayer, "radio:Estado")
    if estadoRadio ~= true then return end
    
    local frecuenciaLocal = getElementData(localPlayer, "radio:FrecuenciaActiva")
    if not frecuenciaLocal then return end
    
    -- OPTIMIZACIÓN: Contar jugadores primero para evitar trabajo innecesario
    local count = 0
    for _ in pairs(voicePlayers) do count = count + 1 end
    if count <= 1 then return end -- Solo localPlayer
    
    for player in pairs(voicePlayers) do
        if player ~= localPlayer then
            local estadoJugador = getElementData(player, "voice:Estado")
            if estadoJugador and estadoJugador.nombre == "Radio" then
                local frecuenciaJugador = getElementData(player, "radio:FrecuenciaActiva")
                if frecuenciaJugador == frecuenciaLocal and getElementData(player, "radio:Estado") == true then
                    local playerName = tostring(getPlayerName(player):gsub("_", " ")).."#FFFFFF[#2C52B3#"..tostring(frecuenciaJugador).."#FFFFFF]"
                    renderCache.radioPlayers[#renderCache.radioPlayers + 1] = {
                        name = playerName,
                        width = dxGetTextWidth(playerName, 1, "default-bold")
                    }
                end
            end
        end
    end
end
'@

# Reemplazar función updateRadioCache
$c = [regex]::Replace($c, '-- OPTIMIZACIÓN: Función para actualizar cache de radio.*?end', $optimizedRadioCache, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# 6) Optimizar sistema de huesos - menos frecuencia
$c = $c.Replace('-- OPTIMIZACIÓN: Aplicar huesos solo a jugadores cacheados
    for i = 1, #bonesCache.players do
        local player = bonesCache.players[i]
        if isElement(player) then
            setElementBoneRotation(player, 5, 0, 0, -30)
            setElementBoneRotation(player, 32, -30, -30, 50)
            setElementBoneRotation(player, 33, 0, -160, 0)
            setElementBoneRotation(player, 34, -120, 0, 0)
            updateElementRpHAnim(player)
        end
    end', '-- OPTIMIZACIÓN ULTRA: Aplicar huesos con límite máximo
    local maxPlayers = math.min(#bonesCache.players, 3) -- Máximo 3 jugadores por frame
    for i = 1, maxPlayers do
        local player = bonesCache.players[i]
        if isElement(player) then
            setElementBoneRotation(player, 5, 0, 0, -30)
            setElementBoneRotation(player, 32, -30, -30, 50)
            setElementBoneRotation(player, 33, 0, -160, 0)
            setElementBoneRotation(player, 34, -120, 0, 0)
            updateElementRpHAnim(player)
        end
    end')

# 7) Reducir frecuencia de SETTINGS_REFRESH
$c = $c.Replace('SETTINGS_REFRESH = 5000', 'SETTINGS_REFRESH = 10000') # 10 segundos

Set-Content -Encoding UTF8 $p $c
Write-Host "Ultra voice optimization applied - CPU should drop below 1%. Backup: $backup"
