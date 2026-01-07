-- Cancela todas las explosiones conocidas
addEventHandler("onClientExplosion", root, function(x, y, z, theType)
    -- Permitir explosiones provenientes del recurso carrobomba
    if getElementData(localPlayer, "_carbomb:lastExplodeTick") then
        local diff = getTickCount() - (getElementData(localPlayer, "_carbomb:lastExplodeTick") or 0)
        if diff <= 2000 then return end
    end
    cancelEvent() -- Cancela cualquier explosión
end)

-- Cancela todos los proyectiles creados
addEventHandler("onClientProjectileCreation", root, function(creator)
    cancelEvent() -- Cancela cualquier proyectil creado
end)

-- Cancela el daño causado por explosiones
addEventHandler("onClientDamage", root, function(attacker, weapon, bodypart, loss)
    if weapon == 16 or weapon == 17 or weapon == 18 or weapon == 19 or weapon == 35 or weapon == 51 then
        cancelEvent() -- Cancela el daño si es causado por armas explosivas
    end
end)