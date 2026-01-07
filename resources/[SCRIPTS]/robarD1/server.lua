local ultimoRobo = 0
local cooldown = 15 * 60 * 1000 -- 15 minutos en milisegundos

local function getPolicias()
    local n = 0
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 10) then
            n = n + 1
        end
    end
    return n
end

local d1zone = createMarker(254.96875, -54.833984375, 1.5703125 -1, "cylinder", 1.3, 255, 0, 0, 100)

local function d1robo(player)
    local tiempoActual = getTickCount()
    
    if tiempoActual - ultimoRobo < cooldown then
        exports.infobox:addNotification(player, "Debes esperar antes de volver a robar la tienda", "error")
        return
    end

    if getPolicias() >= 2 then
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

            local dinero = math.random(10000000, 30000000) -- Cantidad de dinero sucio
            
            if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 10) then
            	exports.factions:createFactionBlip2(254.96875, -54.833984375, 1.5703125, 0, 3)
                outputChatBox("[ALERTA] Se informa que la Tienda D1 MEDELLIN está siendo robada, ¡Acude ahora!", root, 200, 255, 18)
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
                    exports.items:give(player, 36, dinero) -- Ahora da dinero sucio
                    exports.infobox:addNotification(player, "Ya tienes el botín, has robado "..dinero.. " en dinero sucio, ¡Escapa!", "success")
                    removeElementData(player, "RobandoD1")
                    
                    -- Se actualiza el tiempo del último robo
                    ultimoRobo = getTickCount()
                else
                    exports.infobox:addNotification(player, "No estás en la zona para robar la tienda", "error")
                    removeElementData(player, "RobandoD1")
                end
            end, 60000, 1)
        else
            exports.infobox:addNotification(player, "Debes estar en la zona para robar el D1", "error")
        end
    else
        exports.infobox:addNotification(player, "Para robar La Tienda D1 MEDELLIN deben haber al menos 2 policías en servicio", "error")
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
