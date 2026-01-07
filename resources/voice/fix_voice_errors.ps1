$ErrorActionPreference = 'Stop'
$p = 'c:\Users\Playanza\Desktop\OPTIMIZARRESOURCES\voice\cGlobals.lua'
$backup = $p + '.bak.fix.' + (Get-Date).ToString('yyyyMMddHHmmss')
Copy-Item $p $backup

# Restaurar desde backup anterior (antes de la optimización ultra que falló)
$prevBackup = 'c:\Users\Playanza\Desktop\OPTIMIZARRESOURCES\voice\cGlobals.lua.bak.optimize.20250927134721'
if (Test-Path $prevBackup) {
    Copy-Item $prevBackup $p
    Write-Host "Restored from previous backup: $prevBackup"
} else {
    Write-Host "Previous backup not found, working with current file"
}

$c = Get-Content -Raw -Encoding UTF8 $p

# Aplicar solo optimizaciones seguras y simples
# 1) Intervalos más largos (seguro)
$c = $c.Replace('voiceUpdateInterval = 200', 'voiceUpdateInterval = 600') # 600ms
$c = $c.Replace('radioUpdateInterval = 1000', 'radioUpdateInterval = 1500') # 1.5s
$c = $c.Replace('updateInterval = 500', 'updateInterval = 1000') # 1s
$c = $c.Replace('boneInterval = 200', 'boneInterval = 300') # 300ms

# 2) Limitador de FPS simple y seguro
$c = $c.Replace('addEventHandler("onClientRender", root, function()
    if not exports.players:isLoggedIn(localPlayer) then return end', 'local lastVoiceRender = 0
local voiceRenderInterval = 25 -- 40 FPS para suavidad

addEventHandler("onClientRender", root, function()
    local currentTime = getTickCount()
    if currentTime - lastVoiceRender < voiceRenderInterval then
        return
    end
    lastVoiceRender = currentTime
    
    if not exports.players:isLoggedIn(localPlayer) then return end')

# 3) Optimizar SETTINGS_REFRESH
$c = $c.Replace('SETTINGS_REFRESH = 5000', 'SETTINGS_REFRESH = 8000') # 8 segundos

# 4) Limitar jugadores en huesos de forma segura
$c = $c.Replace('    -- OPTIMIZACIÓN: Aplicar huesos solo a jugadores cacheados
    for i = 1, #bonesCache.players do', '    -- OPTIMIZACIÓN: Aplicar huesos con límite (máximo 2 por frame)
    local maxBones = math.min(#bonesCache.players, 2)
    for i = 1, maxBones do')

Set-Content -Encoding UTF8 $p $c
Write-Host "Safe voice optimization applied. Backup: $backup"
