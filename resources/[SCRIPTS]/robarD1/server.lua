local function getPolicias()
    local n = 0
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) then
            n = n + 1
        end
    end
    return n
end

local d1zone = createMarker(252.572, -54.638, 0.577, "cylinder", 1.3, 255, 0, 0, 100)

local function d1robo(player)
    if getPolicias() >= 4 then
        if isElementWithinMarker(player, d1zone) then
            if getElementData(player, "RobandoD1") then
                exports.infobox:addNotification(player, "Ya estás robando la tienda", "error")
                return
            end
            
            local maletin, maletin1 = exports.items:has(player, 79)
            if not maletin then
                exports.infobox:addNotification(player, "Necesitas un maletín para guardar el dinero", "error")
                return
            end

            local dinero = math.random(10000000, 30000000)
            
            if exports.factions:isPlayerInFaction(player, 1) then
            	exports.factions:createFactionBlip2(252.572, -54.638, 0.577, 0, 3)
                outputChatBox("[ALERTA] Se informa que el D1 de Medellín está sufriendo un saqueo, ¡Acude ahora!", root, 200, 255, 18)
            end
            
            setElementData(player, "RobandoD1", true)
            setElementFrozen(player, true)
            setPedAnimation(player, "CASINO", "Slot_bet_01", -1, true)
            triggerClientEvent(player, "progressBar", player, 60000)
            exports.items:take(player, maletin1)
            
            setTimer(function()
                if isElementWithinMarker(player, d1zone) then
                    setElementFrozen(player, false)
                    setPedAnimation(player)
                    exports.players:giveMoney(player, dinero)
                    exports.infobox:addNotification(player, "Ya tienes el botin, has robado "..dinero.. ", ¡Escapa!", "success")
                    removeElementData(player, "RobandoD1")
                else
                    exports.infobox:addNotification(player, "No estás en la zona para robar un D1", "error")
                    removeElementData(player, "RobandoD1")
                end
            end, 60000, 1)
        else
            exports.infobox:addNotification(player, "Debes estar en la zona para robar el D1", "error")
        end
    else
        exports.infobox:addNotification(player, "Para robar el D1 deben haber al menos 4 policías en servicio", "error")
    end
end

local function onPlayerMarkerHit(marker, matchingDimension)
    if matchingDimension and marker == d1zone then
        bindKey(source, "p", "down", d1robo)
    end
end
addEventHandler("onPlayerMarkerHit", root, onPlayerMarkerHit)

local function onPlayerMarkerLeave(marker, matchingDimension)
    if matchingDimension and marker == d1zone then
        unbindKey(source, "p", "down", d1robo)
    end
end
addEventHandler("onPlayerMarkerLeave", root, onPlayerMarkerLeave)