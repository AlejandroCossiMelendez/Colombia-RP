local MarkerLavarDinero = createMarker(-563.3232421875, -176.927734375, 78.40625 -1, "cylinder", 1.50, 0, 255, 0, 100)
local int = 0
local dim = 0
setElementInterior(MarkerLavarDinero, int)
setElementDimension(MarkerLavarDinero, dim)

local cooldownMensajes = {} -- Cooldown para mensajes de error
local cooldownLavar = {} -- Cooldown por jugador para el lavado de dinero
local COOLDOWN_TIEMPO = 10000 -- 10 segundos para mensajes de error
local COOLDOWN_LAVADO = 600000 -- 20 minutos de cooldown entre lavados

function getPolicias()
    local count = 0
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 10) then
            count = count + 1
        end
    end
    return count
end

function iniciarLavado(playerSource, cantidad)
    local currentTime = getTickCount()
    
    -- **Comprobar cooldown del jugador**
    if cooldownLavar[playerSource] and currentTime - cooldownLavar[playerSource] < COOLDOWN_LAVADO then
        exports.a_infobox:addBox(playerSource, "Debes esperar 10 minutos antes de volver a lavar dinero", "error")
        return
    end

    -- **Aplicar cooldown inmediatamente para evitar spam**
    cooldownLavar[playerSource] = getTickCount()

    if getPolicias() < 0 then
        exports.a_infobox:addBox(playerSource, "Debe haber al menos 2 policías en servicio para lavar dinero", "error")
        return
    end

    local tieneDineroSucio, slot, itemData = exports.items:has(playerSource, 36)
    local cantidadDineroSucio = itemData and itemData.value or 0
    if not tieneDineroSucio or cantidadDineroSucio < cantidad then
        exports.a_infobox:addBox(playerSource, "No tienes suficiente dinero sucio para lavar", "error")
        return
    end

    if cantidad <= 0 then
        exports.a_infobox:addBox(playerSource, "Cantidad inválida", "error")
        return
    end

    local tiempoTotal = 30000 -- 30 segundos fijos

    setElementFrozen(playerSource, true)
    toggleAllControls(playerSource, false, true, false)
    setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
    
    -- Enviar solo una vez el evento de barra de progreso al cliente
    triggerClientEvent(playerSource, "startProgressBar", playerSource, tiempoTotal, "Lavando Dinero")
    exports.a_infobox:addBox(playerSource, "Lavando dinero, por favor espera...", "info")

    -- Alerta a la policía y ejército
    local name = getPlayerName(playerSource)
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) then
            outputChatBox("#FFFFFF[#FF0000Alerta#FFFFFF] (#FF0000"..name.."#FFFFFF) está lavando dinero en una ubicación sospechosa.", v, 255, 255, 255, true)
        end
    end

    -- Crear blip en el mapa para policías y ejército
    if getElementDimension(playerSource) == 0 then
        local x, y, z = getElementPosition(playerSource)
        exports.factions:createFactionBlip2(x, y, z, 1)
    else
        local x, y, z = exports.interiors:getPos(getElementDimension(playerSource))
        exports.factions:createFactionBlip2(x, y, z, 1)
    end

    setTimer(function()
        setElementFrozen(playerSource, false)
        toggleAllControls(playerSource, true)
        setPedAnimation(playerSource, nil)
        exports.items:take(playerSource, slot, cantidad)
        exports.players:giveMoney(playerSource, cantidad) -- Convertir el dinero sucio según su cantidad exacta
        exports.a_infobox:addBox(playerSource, "Has lavado $"..cantidad.." en dinero limpio", "success")
    end, tiempoTotal, 1)
end

addCommandHandler("lavar", function(playerSource, _, cantidad)
    cantidad = tonumber(cantidad)
    if not cantidad then
        exports.a_infobox:addBox(playerSource, "Uso: /lavar [cantidad]", "info")
        return
    end

    if isElementWithinMarker(playerSource, MarkerLavarDinero) then
        iniciarLavado(playerSource, cantidad)
    else
        local currentTime = getTickCount()
        local lastMessageTime = cooldownMensajes[playerSource] or 0
        
        if currentTime - lastMessageTime >= COOLDOWN_TIEMPO then
            exports.a_infobox:addBox(playerSource, "Debes estar en el punto de lavado para usar este comando", "error")
            cooldownMensajes[playerSource] = currentTime
        end
    end
end)
