local marker = createMarker(1577.7080078125, 1323.7080078125, 10.972893714905 -1, "cylinder", 1.5, 0, 0, 255, 150)
setElementDimension(marker, 33)
setElementInterior(marker, 18)

addEventHandler("onMarkerHit", marker, function(player)
    if exports.factions:isPlayerInFaction(player, 4) then
        if getElementType(player) == "player" then
            triggerClientEvent(player, "showUIs", resourceRoot)
        end
    else
        exports.infoSirilo:addBoxSiri(player, "No tienes acceso a esta zona", "error")
    end
end)

addEventHandler("onMarkerLeave", marker, function(player)
    if getElementType(player) == "player" then
        triggerClientEvent(player, "hideUIs", resourceRoot)
    end
end)

-- Alternar el estado de servicio
addEvent("EJC_toggleDutySiri", true)
addEventHandler("EJC_toggleDutySiri", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 4) then
        exports.infoSirilo:addBoxSiri(player, "No eres militar.", "error")
        return
    end

    if getElementData(player, "duty") then
        exports.infoSirilo:addBoxSiri(player, "Has salido de servicio.", "info")
        setPedArmor(player, 0)
        removeElementData(player, "duty")
    else
        exports.infoSirilo:addBoxSiri(player, "Estás en servicio.", "success")
        setElementData(player, "duty", true)
        setPedArmor(player, 100)
    end
end)

-- Entregar todas las armas con balas iniciales
addEvent("EJC_givePDWeaponsSiri", true)
addEventHandler("EJC_givePDWeaponsSiri", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 4) then
        exports.infoSirilo:addBoxSiri(player, "No eres militar.", "error")
        return
    end

    if not getElementData(player, "duty") then
        exports.infoSirilo:addBoxSiri(player, "Debes estar en servicio para obtener armas.", "error")
        return
    end

    for weaponID, ammo in pairs({[24] = 7, [29] = 30, [31] = 50}) do
        exports.items:give(player, 29, weaponID, "Arma con balas", ammo)
        outputChatBox("Has recibido tu " .. getWeaponNameFromID(weaponID) .. " con " .. ammo .. " balas.", player, 0, 255, 0)
    end

    exports.infoSirilo:addBoxSiri(player, "Todas las armas han sido entregadas con balas iniciales.", "success")
end)

-- Entregar todos los cargadores
addEvent("EJC_givePDAmmoSiri", true)
addEventHandler("EJC_givePDAmmoSiri", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 4) then
        exports.infoSirilo:addBoxSiri(player, "No eres militar.", "error")
        return
    end

    if not getElementData(player, "duty") then
        exports.infoSirilo:addBoxSiri(player, "Debes estar en servicio para obtener cargadores.", "error")
        return
    end

    for weaponID, ammo in pairs({[24] = 7, [29] = 30, [31] = 50}) do
        exports.items:give(player, 43, weaponID, "Cargador", ammo)
    end

    exports.infoSirilo:addBoxSiri(player, "Todos los cargadores han sido entregados.", "success")
end)

-- Entregar útiles policiales
addEvent("EJC_givePDUtilsSiri", true)
addEventHandler("EJC_givePDUtilsSiri", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 4) then
        exports.infoSirilo:addBoxSiri(player, "No eres militar.", "error")
        return
    end

    if not getElementData(player, "duty") then
        exports.infoSirilo:addBoxSiri(player, "Debes estar en servicio para obtener útiles.", "error")
        return
    end

    for _, uid in ipairs({1, 2, 3, 4}) do
        exports.items:give(player, 35, uid)
    end

    exports.infoSirilo:addBoxSiri(player, "Todos los útiles han sido entregados correctamente.", "success")
end)
