addEventHandler('onClientRender', getRootElement(), function()
    --Base Fundo
    --dxDrawImageSection( sx*1315, sy*611, sx*48, sy*-(35), 0, 35.6, 43, -(35), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.fundofome)), false)
    ---dxDrawImageSection( sx*1315, sy*649, sx*48, sy*-(35), 0, 35.6, 43, -(35), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.fundosede)), false)
    --dxDrawImageSection( sx*1315, sy*687, sx*48, sy*-(35), 0, 35.6, 43, -(35), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.fundovida)), false)
    --dxDrawImageSection( sx*1315, sy*724, sx*48, sy*-(35), 0, 35.6, 43, -(35), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.fundocolete)), false)
    -- --Base Frente
    local Vida = interpolateBetween (cache.tabela.tickOldVida, 0, 0, getElementHealth(localPlayer), 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    local Colete = interpolateBetween (cache.tabela.tickOldColete, 0, 0, getPedArmor(localPlayer) , 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    local Sede = interpolateBetween (cache.tabela.tickOldSede, 0, 0, (getElementData(localPlayer, Hyper_Confgs['ElementData']['Sede']) or 100), 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    local Fome = interpolateBetween (cache.tabela.tickOldFome, 0, 0, (getElementData(localPlayer, Hyper_Confgs['ElementData']['Fome']) or 100), 0, 0, (getTickCount ( ) - cache.tabela.tickNew) / 500, 'Linear')
    if getElementData(localPlayer, 'Mic') then
        ColorVoice = tocolor(unpack(Hyper_Confgs.Cores.voiceenable))
    else
        ColorVoice = tocolor (unpack(Hyper_Confgs.Cores.voiceDisable))
    end

    dxDrawImageSection( sx*1314, sy*562+10, sx*48, sy*-(35), 0, 35, 47, -(34), cache['Images']['fundo'], 0, 0, 0, ColorVoice, false)
 
    dxDrawImageSection( sx*1314, sy*601+10, sx*48, sy*-(35*Fome/100), 0, 35, 47, -(34*Fome/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentefome)), false)
    dxDrawImageSection( sx*1314, sy*639+10, sx*48, sy*-(35*Sede/100), 0, 35, 47, -(34*Sede/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentesede)), false)
    dxDrawImageSection( sx*1314, sy*677+10, sx*48, sy*-(35*Vida/100), 0, 35, 47, -(34*Vida/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentevida)), false)
    dxDrawImageSection( sx*1314, sy*714+10, sx*48, sy*-(35*Colete/100), 0, 35, 47, -(34*Colete/100), cache['Images']['fundo'], 0, 0, 0, tocolor(unpack(Hyper_Confgs.Cores.frentecolete)), false)
    
    cache.Dx.Image(1330, 534+10, 18, 21, cache['Images']['mic'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Image(1330, 570+10, 19, 30, cache['Images']['comida'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Image(1330, 613+10, 18, 18, cache['Images']['agua'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Image(1330, 651+10, 18, 18, cache['Images']['vida'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Image(1330, 686+10, 21, 21, cache['Images']['colete'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    
    local hours, minutes  = cache.functions.timerR()
    cache.Dx.Image(1268, 69, 20, 20, cache['Images']['relogio'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Text(hours..':'..minutes, 1285, 70, 51, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "center", "top", false, false, false, true, false)
    
    cache.Dx.Image(1167, 69, 20, 20, cache['Images']['freq'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Text((getElementData(localPlayer, Hyper_Confgs['ElementData']['Radinho']) or 0)..' Htz', 1200, 70, 51, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    
    local weaponClip = getPedAmmoInClip(getLocalPlayer(), getPedWeaponSlot(getLocalPlayer()))
    local weaponAmmo = getPedTotalAmmo(getLocalPlayer()) - getPedAmmoInClip(getLocalPlayer())
    cache.Dx.Image(1167-100, 69, 20, 20, cache['Images']['muni'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Text(weaponClip.." / "..weaponAmmo, 1200-100, 70, 51, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)

    local x, y, z = getElementPosition(localPlayer)
    local city = getZoneName(x, y, z)
    cache.Dx.Image(1127.15, 36, 22, 22, cache['Images']['gps'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    cache.Dx.Text(city, 1155, 38, 200, 23, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "left", "top", false, false, false, true, false)
    
    cache.tabela.tickOldVida = Vida
    cache.tabela.tickOldColete = Colete
    cache.tabela.tickOldFome = Fome
    cache.tabela.tickOldSede = Sede
    
    cache.tabela.tickNew = getTickCount ( )

    if getPedOccupiedVehicle(getLocalPlayer()) then
        local veh = cache.functions.getElementSpeed(getPedOccupiedVehicle(getLocalPlayer()), "kmh") 
        cache.Dx.Text(tostring ( cache.functions.getFormatSpeed ( veh ) ), 1175, 673, 103, 43, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Itali Bold velo"], "center", "top", false, false, false, true, false)
        cache.Dx.Text('KMH', 1223, 690, 103, 43, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 10"], "center", "top", false, false, false, true, false)
        
        cache.Dx.Image(1158, 660+10, 157, 50, cache['Images']['velocimetro'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        cache.Dx.Image(1283, 725, 18, 17, cache['Images']['gas'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        cache.Dx.Image(1155, 683, 44, 38, cache['Images']['cinto'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
        cache.Dx.Text(math.floor((getElementData(getPedOccupiedVehicle(getLocalPlayer()), Hyper_Confgs['ElementData']['Gasolina']) or 100))..'%', 1210, 725, 103, 43, tocolor(255, 255, 255, 255), 1, cache.Fonts["Fonte Mont Bold 12"], "center", "top", false, false, false, true, false)
    end
end)