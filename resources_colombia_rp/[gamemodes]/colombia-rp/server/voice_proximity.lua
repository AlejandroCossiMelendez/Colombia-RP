-- Sistema de Voz por Proximidad Limitada
-- Limita la voz a 5 metros de distancia

local PROXIMITY_DISTANCE = 5 -- Metros

-- Exportar función para que otros scripts puedan usarla
function updatePlayerProximityVoice(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    -- Verificar si está en una llamada (no aplicar proximidad si está en llamada)
    if getElementData(player, "phone:inCall") then
        return
    end
    
    -- Verificar si está en una frecuencia (no aplicar proximidad si está en frecuencia)
    local frecuencia = getElementData(player, "frecuencia.voz")
    if frecuencia and tonumber(frecuencia) and tonumber(frecuencia) ~= -1 and tonumber(frecuencia) < 2000 then
        return
    end
    
    -- Obtener posición del jugador
    local x, y, z = getElementPosition(player)
    
    -- Lista de jugadores a ignorar (los que están lejos)
    local playersToIgnore = {}
    
    -- Revisar todos los jugadores
    for _, otherPlayer in ipairs(getElementsByType("player")) do
        if otherPlayer ~= player and isElement(otherPlayer) then
            -- Verificar que el otro jugador tenga personaje seleccionado
            if getElementData(otherPlayer, "character:selected") then
                local ox, oy, oz = getElementPosition(otherPlayer)
                local distance = getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)
                
                -- Si está a más de 5 metros, agregarlo a la lista de ignorados
                if distance > PROXIMITY_DISTANCE then
                    table.insert(playersToIgnore, otherPlayer)
                end
            end
        end
    end
    
    -- Configurar para ignorar jugadores lejanos
    -- Esto permite que MTA use proximidad por defecto para los cercanos
    setPlayerVoiceIgnoreFrom(player, playersToIgnore)
end

-- Actualizar voz de proximidad periódicamente
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) and getElementData(player, "character:selected") then
            updatePlayerProximityVoice(player)
        end
    end
end, 500, 0) -- Actualizar cada 500ms

-- No hay evento onPlayerMove en MTA, se actualiza mediante el timer principal

-- Actualizar cuando un jugador spawnea
addEventHandler("onPlayerSpawn", root, function()
    setTimer(function()
        if isElement(source) then
            updatePlayerProximityVoice(source)
        end
    end, 1000, 1)
end)

-- Actualizar cuando se selecciona un personaje
addEvent("onCharacterSelected", true)
addEventHandler("onCharacterSelected", root, function()
    if isElement(source) then
        setTimer(function()
            if isElement(source) then
                updatePlayerProximityVoice(source)
            end
        end, 1000, 1)
    end
end)

