-- Scoreboard mejorado con IDs
local playerIDs = {} -- Almacenar IDs de jugadores
local nextID = 1 -- Contador de IDs

-- Asignar ID cuando el jugador se conecta
addEventHandler("onPlayerJoin", root, function()
    -- Asignar ID único
    playerIDs[source] = nextID
    setElementData(source, "playerID", nextID)
    nextID = nextID + 1
    
    outputServerLog("[Scoreboard] ID asignado a " .. getPlayerName(source) .. ": " .. tostring(playerIDs[source]))
end)

-- Limpiar ID cuando el jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    if playerIDs[source] then
        playerIDs[source] = nil
    end
end)

-- Función para obtener jugador por ID
function getPlayerByID(id)
    for player, playerID in pairs(playerIDs) do
        if isElement(player) and playerID == tonumber(id) then
            return player
        end
    end
    return false
end

-- Exportar función para otros recursos
function getPlayerID(player)
    return playerIDs[player] or false
end

