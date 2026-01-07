-- Sistema de Necesidades (Hambre, Sed, Salud)
local needsTimer = nil

function updatePlayerNeeds(player)
    if not isElement(player) then
        return
    end
    
    local characterId = getElementData(player, "character:id")
    if not characterId then
        return
    end
    
    local hunger = getElementData(player, "character:hunger") or Config.Server.defaultHunger
    local thirst = getElementData(player, "character:thirst") or Config.Server.defaultThirst
    local health = getElementHealth(player)
    
    -- Disminuir hambre y sed
    hunger = math.max(0, hunger - Config.Needs.hungerDecreaseAmount)
    thirst = math.max(0, thirst - Config.Needs.thirstDecreaseAmount)
    
    -- Si hambre o sed están muy bajas, reducir salud
    if hunger <= 0 or thirst <= 0 then
        health = math.max(1, health - 5)
        setElementHealth(player, health)
        if hunger <= 0 then
            outputChatBox("¡Tienes mucha hambre! Busca comida.", player, 255, 0, 0)
        end
        if thirst <= 0 then
            outputChatBox("¡Tienes mucha sed! Busca agua.", player, 255, 0, 0)
        end
    end
    
    -- Actualizar datos
    setElementData(player, "character:hunger", hunger)
    setElementData(player, "character:thirst", thirst)
    setElementData(player, "character:health", health)
    
    -- Guardar en base de datos
    executeDatabase("UPDATE characters SET hunger = ?, thirst = ?, health = ? WHERE id = ?", 
        hunger, thirst, health, characterId)
    
    -- Enviar actualización al cliente
    triggerClientEvent(player, "updateNeeds", resourceRoot, hunger, thirst, health)
end

function feedPlayer(player, amount)
    local hunger = getElementData(player, "character:hunger") or 0
    hunger = math.min(100, hunger + (amount or 20))
    setElementData(player, "character:hunger", hunger)
    
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET hunger = ? WHERE id = ?", hunger, characterId)
    end
    
    triggerClientEvent(player, "updateNeeds", resourceRoot, hunger, getElementData(player, "character:thirst") or 100, getElementHealth(player))
end

function hydratePlayer(player, amount)
    local thirst = getElementData(player, "character:thirst") or 0
    thirst = math.min(100, thirst + (amount or 20))
    setElementData(player, "character:thirst", thirst)
    
    local characterId = getElementData(player, "character:id")
    if characterId then
        executeDatabase("UPDATE characters SET thirst = ? WHERE id = ?", thirst, characterId)
    end
    
    triggerClientEvent(player, "updateNeeds", resourceRoot, getElementData(player, "character:hunger") or 100, thirst, getElementHealth(player))
end

-- Iniciar sistema de necesidades
function startNeedsSystem()
    if needsTimer then
        killTimer(needsTimer)
    end
    
    needsTimer = setTimer(function()
        for _, player in ipairs(getElementsByType("player")) do
            if getElementData(player, "character:selected") then
                updatePlayerNeeds(player)
            end
        end
    end, Config.Needs.updateInterval, 0)
end

-- Detener sistema de necesidades
function stopNeedsSystem()
    if needsTimer then
        killTimer(needsTimer)
        needsTimer = nil
    end
end

-- Comandos de prueba
addCommandHandler("comer", function(player)
    feedPlayer(player, 30)
    outputChatBox("Has comido. Hambre: " .. (getElementData(player, "character:hunger") or 0), player, 0, 255, 0)
end)

addCommandHandler("beber", function(player)
    hydratePlayer(player, 30)
    outputChatBox("Has bebido. Sed: " .. (getElementData(player, "character:thirst") or 0), player, 0, 255, 0)
end)

-- Iniciar al cargar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    startNeedsSystem()
end)

-- Detener al descargar el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    stopNeedsSystem()
end)

