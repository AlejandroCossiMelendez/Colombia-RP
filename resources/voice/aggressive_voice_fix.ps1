$ErrorActionPreference = 'Stop'
$p = 'c:\Users\Playanza\Desktop\OPTIMIZARRESOURCES\voice\cGlobals.lua'
$backup = $p + '.bak.aggressive.' + (Get-Date).ToString('yyyyMMddHHmmss')
Copy-Item $p $backup

$c = Get-Content -Raw -Encoding UTF8 $p

# Estrategia: Reemplazar onClientRender con sistema de timers + render minimalista
$newRenderSystem = @'
-- =====================================================
-- SISTEMA ALTERNATIVO: Timers + Render minimalista
-- =====================================================

-- Variables de render estáticas
local staticRenderData = {
    voiceText = "",
    voiceWidth = 0,
    radioPlayers = {},
    needsRedraw = true
}

-- Timer para actualizar datos de voz (cada 1 segundo)
local function updateVoiceData()
    if not exports.players:isLoggedIn(localPlayer) then return end
    
    local estadoVoz = getElementData(localPlayer, "voice:Estado")
    if not estadoVoz then 
        staticRenderData.voiceText = ""
        return 
    end
    
    local baseText = "#E56E11VOZ: " .. estadoVoz.nombre
    if voicePlayers[localPlayer] == true then
        staticRenderData.voiceText = baseText .. " ((" .. estadoVoz.nombre .. "...))"
    else
        staticRenderData.voiceText = baseText .. " "
    end
    
    staticRenderData.voiceWidth = dxGetTextWidth(staticRenderData.voiceText, 1, "default-bold")
    staticRenderData.needsRedraw = true
end

-- Timer para actualizar datos de radio (cada 2 segundos)
local function updateRadioData()
    if not exports.players:isLoggedIn(localPlayer) then return end
    
    staticRenderData.radioPlayers = {}
    
    local estadoRadio = getElementData(localPlayer, "radio:Estado")
    if estadoRadio ~= true then return end
    
    local frecuenciaLocal = getElementData(localPlayer, "radio:FrecuenciaActiva")
    if not frecuenciaLocal then return end
    
    for player in pairs(voicePlayers) do
        if player ~= localPlayer then
            local estadoJugador = getElementData(player, "voice:Estado")
            if estadoJugador and estadoJugador.nombre == "Radio" then
                local frecuenciaJugador = getElementData(player, "radio:FrecuenciaActiva")
                if frecuenciaJugador == frecuenciaLocal and getElementData(player, "radio:Estado") == true then
                    local playerName = tostring(getPlayerName(player):gsub("_", " ")).."#FFFFFF[#2C52B3#"..tostring(frecuenciaJugador).."#FFFFFF]"
                    staticRenderData.radioPlayers[#staticRenderData.radioPlayers + 1] = {
                        name = playerName,
                        width = dxGetTextWidth(playerName, 1, "default-bold")
                    }
                end
            end
        end
    end
    staticRenderData.needsRedraw = true
end

-- onClientRender ULTRA minimalista - solo dibuja datos estáticos
addEventHandler("onClientRender", root, function()
    if not exports.players:isLoggedIn(localPlayer) then return end
    
    -- Solo dibujar si hay datos
    if staticRenderData.voiceText ~= "" then
        dxDrawBorderedText(staticRenderData.voiceText, textoVozX, textoVozBaseY, staticRenderData.voiceWidth, textoVozHeight, COLOR_WHITE, 1, "default-bold", "left", "top", false, false, false, true)
    end
    
    -- Dibujar radio
    if #staticRenderData.radioPlayers > 0 then
        local x, y = textoVozX, textoVozBaseY + textoVozHeight + 30
        for i = 1, #staticRenderData.radioPlayers do
            local radioPlayer = staticRenderData.radioPlayers[i]
            dxDrawBorderedText(radioPlayer.name, x, y, radioPlayer.width, textoVozHeight, COLOR_WHITE, 1, "default-bold", "left", "top", false, false, false, true)
            y = y + textoVozHeight
        end
    end
end)

-- Inicializar timers
setTimer(updateVoiceData, 1000, 0) -- Cada 1 segundo
setTimer(updateRadioData, 2000, 0) -- Cada 2 segundos

-- Actualizar inmediatamente al inicio
updateVoiceData()
updateRadioData()

-- Marcar para actualizar cuando cambien datos importantes
addEventHandler("onClientElementDataChange", localPlayer, function(dataName)
    if dataName == "voice:Estado" then
        setTimer(updateVoiceData, 50, 1) -- Actualizar rápido
    elseif dataName == "radio:Estado" or dataName == "radio:FrecuenciaActiva" then
        setTimer(updateRadioData, 50, 1) -- Actualizar rápido
    end
end)
'@

# Reemplazar todo el sistema de render actual
$oldRenderPattern = '-- OPTIMIZACIÓN: onClientRender ultra eficiente.*?end\)'
$c = [regex]::Replace($c, $oldRenderPattern, $newRenderSystem, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Optimizar sistema de huesos - reducir frecuencia drásticamente
$c = $c.Replace('updateInterval = 1000', 'updateInterval = 2000') # 2 segundos
$c = $c.Replace('boneInterval = 300', 'boneInterval = 500') # 500ms

# Reducir más el límite de jugadores con huesos
$c = $c.Replace('local maxBones = math.min(#bonesCache.players, 2)', 'local maxBones = math.min(#bonesCache.players, 1)') # Solo 1 jugador por frame

Set-Content -Encoding UTF8 $p $c
Write-Host "Aggressive voice optimization applied - should drop below 1%. Backup: $backup"
