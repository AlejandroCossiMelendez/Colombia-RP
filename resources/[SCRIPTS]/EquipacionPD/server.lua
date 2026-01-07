local marker = createMarker(1591.5355224609, -1656.2351074219, 19.007499694824 -1, "cylinder", 1.5, 0, 0, 255, 150)
setElementDimension(marker, 0)
setElementInterior(marker, 0)

addEventHandler("onMarkerHit", marker, function(player)
    if exports.factions:isPlayerInFaction(player, 1) then
        if getElementType(player) == "player" then
            triggerClientEvent(player, "showUI", resourceRoot)
        end
    else
        exports.infoSirilo:addBoxSiri(player, "No tienes acceso a esta zona", "error")
    end
end)

addEventHandler("onMarkerLeave", marker, function(player)
    if getElementType(player) == "player" then
        triggerClientEvent(player, "hideUI", resourceRoot)
    end
end)

-- Alternar el estado de servicio
addEvent("toggleDutySirilo", true)
addEventHandler("toggleDutySirilo", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 1) then
        exports.infoSirilo:addBoxSiri(player, "No eres policía.", "error")
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
addEvent("givePDWeaponsSirilo", true)
addEventHandler("givePDWeaponsSirilo", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 1) then
        exports.infoSirilo:addBoxSiri(player, "No eres policía.", "error")
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
addEvent("givePDAmmoSirilo", true)
addEventHandler("givePDAmmoSirilo", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 1) then
        exports.infoSirilo:addBoxSiri(player, "No eres policía.", "error")
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
addEvent("givePDUtilsSirilo", true)
addEventHandler("givePDUtilsSirilo", root, function()
    local player = client
    if not player then return end

    if not exports.factions:isPlayerInFaction(player, 1) then
        exports.infoSirilo:addBoxSiri(player, "No eres policía.", "error")
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
