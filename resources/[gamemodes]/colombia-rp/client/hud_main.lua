-- HUD Principal para Colombia RP
-- Adaptado de ice_hud

local hudVisible = false

function showHUD()
    hudVisible = true
    outputChatBox("[HUD] HUD activado", 0, 255, 0)
end

function hideHUD()
    hudVisible = false
    outputChatBox("[HUD] HUD desactivado", 255, 0, 0)
end

addEvent("showHUD", true)
addEventHandler("showHUD", resourceRoot, function()
    showHUD()
end)

addEvent("hideHUD", true)
addEventHandler("hideHUD", resourceRoot, function()
    hideHUD()
end)

-- Mostrar HUD automáticamente cuando el personaje está seleccionado
setTimer(function()
    if getElementData(localPlayer, "character:selected") and not hudVisible then
        showHUD()
    elseif not getElementData(localPlayer, "character:selected") and hudVisible then
        hideHUD()
    end
end, 1000, 0)

-- Solo mostrar HUD si el personaje está seleccionado
addEventHandler("onClientRender", root, function()
    -- Verificar que el personaje esté seleccionado
    if not getElementData(localPlayer, "character:selected") then
        return
    end
    
    -- Verificar que cache y Hyper_Confgs estén cargados
    if not cache or not Hyper_Confgs then
        return
    end
    
    -- Verificar que sx y sy estén definidos
    if not sx or not sy then
        return
    end
    
    -- Verificar que cache.tabela exista
    if not cache.tabela then
        return
    end
    
    -- Obtener valores
    local Vida = interpolateBetween (cache.tabela.tickOldVida, 0, 0, getElementHealth(localPlayer), 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    local Colete = interpolateBetween (cache.tabela.tickOldColete, 0, 0, getPedArmor(localPlayer) , 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    local Sede = interpolateBetween (cache.tabela.tickOldSede, 0, 0, (getElementData(localPlayer, Hyper_Confgs['ElementData']['Sede']) or 100), 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    local Fome = interpolateBetween (cache.tabela.tickOldFome, 0, 0, (getElementData(localPlayer, Hyper_Confgs['ElementData']['Fome']) or 100), 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    
    -- Color del micrófono
    local ColorVoice
    if getElementData(localPlayer, 'Mic') then
        ColorVoice = tocolor(unpack(Hyper_Confgs.Cores.voiceenable))
    else
        ColorVoice = tocolor (unpack(Hyper_Confgs.Cores.voiceDisable))
    end

    -- Dibujar barras de fondo y frente
    if cache.Images['fundo'] then
        dxDrawImageSection( sx*1314, sy*562+10, sx*48, sy*-(35), 0, 35, 47, -(34), cache['Images']['fundo'], 0, 0, 0, ColorVoice, false)
        dxDrawImageSection( sx*1314, sy*601+10, sx*48, sy*-(35*Fome/100), 0, 35, 47, -(34*Fome/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentefome)), false)
        dxDrawImageSection( sx*1314, sy*639+10, sx*48, sy*-(35*Sede/100), 0, 35, 47, -(34*Sede/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentesede)), false)
        dxDrawImageSection( sx*1314, sy*677+10, sx*48, sy*-(35*Vida/100), 0, 35, 47, -(34*Vida/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentevida)), false)
        dxDrawImageSection( sx*1314, sy*714+10, sx*48, sy*-(35*Colete/100), 0, 35, 47, -(34*Colete/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentecolete)), false)
    else
        -- Fallback: dibujar barras simples si no hay imágenes
        local barX = sx*1314
        local barY = sy*600
        local barW = sx*48
        local barH = sy*35
        
        -- Fondo de las barras
        dxDrawRectangle(barX, barY, barW, barH * 5, tocolor(0, 0, 0, 150), false)
        
        -- Barras de progreso
        dxDrawRectangle(barX, barY, barW, barH * (Fome/100), tocolor(255, 165, 0, 255), false) -- Hambre
        dxDrawRectangle(barX, barY + barH, barW, barH * (Sede/100), tocolor(0, 100, 255, 255), false) -- Sed
        dxDrawRectangle(barX, barY + barH*2, barW, barH * (Vida/100), tocolor(255, 0, 0, 255), false) -- Vida
        dxDrawRectangle(barX, barY + barH*3, barW, barH * (Colete/100), tocolor(255, 255, 255, 255), false) -- Armadura
    end
    
    -- Dibujar iconos (si existen)
    if cache.Images['mic'] then
        cache.Dx.Image(1330, 534+10, 18, 21, cache['Images']['mic'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if cache.Images['comida'] then
        cache.Dx.Image(1330, 570+10, 19, 30, cache['Images']['comida'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if cache.Images['agua'] then
        cache.Dx.Image(1330, 613+10, 18, 18, cache['Images']['agua'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if cache.Images['vida'] then
        cache.Dx.Image(1330, 651+10, 18, 18, cache['Images']['vida'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if cache.Images['colete'] then
        cache.Dx.Image(1330, 686+10, 21, 21, cache['Images']['colete'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    
    -- Texto de valores (siempre visible)
    cache.Dx.Text("H: " .. math.floor(Fome) .. "%", 1330, 570+10, 200, 30, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    cache.Dx.Text("S: " .. math.floor(Sede) .. "%", 1330, 613+10, 200, 30, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    cache.Dx.Text("V: " .. math.floor(Vida) .. "%", 1330, 651+10, 200, 30, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    cache.Dx.Text("A: " .. math.floor(Colete) .. "%", 1330, 686+10, 200, 30, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    
    -- Reloj
    local hours, minutes  = cache.functions.timerR()
    if cache.Images['relogio'] then
        cache.Dx.Image(1268, 69, 20, 20, cache['Images']['relogio'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    cache.Dx.Text(hours..':'..minutes, 1285, 70, 51, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "center", "top", false, false, false, true, false)
    
    -- Radio/Frecuencia
    if cache.Images['freq'] then
        cache.Dx.Image(1167, 69, 20, 20, cache['Images']['freq'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    cache.Dx.Text((getElementData(localPlayer, Hyper_Confgs['ElementData']['Radinho']) or 0)..' Htz', 1200, 70, 51, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    
    -- Munición
    local weaponSlot = getPedWeaponSlot(localPlayer)
    local weaponClip = 0
    local weaponAmmo = 0
    if weaponSlot >= 0 then
        weaponClip = getPedAmmoInClip(localPlayer, weaponSlot)
        weaponAmmo = getPedTotalAmmo(localPlayer) - weaponClip
    end
    if cache.Images['muni'] then
        cache.Dx.Image(1167-100, 69, 20, 20, cache['Images']['muni'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    cache.Dx.Text(weaponClip.." / "..weaponAmmo, 1200-100, 70, 51, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)

    -- GPS/Zona
    local x, y, z = getElementPosition(localPlayer)
    local city = getZoneName(x, y, z)
    if cache.Images['gps'] then
        cache.Dx.Image(1127.15, 36, 22, 22, cache['Images']['gps'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    cache.Dx.Text(city, 1155, 38, 200, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    
    -- Actualizar valores antiguos
    cache.tabela.tickOldVida = Vida
    cache.tabela.tickOldColete = Colete
    cache.tabela.tickOldFome = Fome
    cache.tabela.tickOldSede = Sede
    cache.tabela.tickNew = getTickCount ( )

    -- Velocímetro y gasolina (solo si está en vehículo)
    if getPedOccupiedVehicle(localPlayer) then
        local veh = getPedOccupiedVehicle(localPlayer)
        local vehSpeed = cache.functions.getElementSpeed(veh, "kmh") 
        cache.Dx.Text(tostring ( cache.functions.getFormatSpeed ( vehSpeed ) ), 1175, 673, 103, 43, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Itali Bold velo"], "center", "top", false, false, false, true, false)
        cache.Dx.Text('KMH', 1223, 690, 103, 43, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "center", "top", false, false, false, true, false)
        
        if cache.Images['velocimetro'] then
            cache.Dx.Image(1158, 660+10, 157, 50, cache['Images']['velocimetro'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        end
        if cache.Images['gas'] then
            cache.Dx.Image(1283, 725, 18, 17, cache['Images']['gas'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        end
        if cache.Images['cinto'] then
            cache.Dx.Image(1155, 683, 44, 38, cache['Images']['cinto'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        end
        cache.Dx.Text(math.floor((getElementData(veh, Hyper_Confgs['ElementData']['Gasolina']) or 100))..'%', 1210, 725, 103, 43, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 12"], "center", "top", false, false, false, true, false)
    end
end)

