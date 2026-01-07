-- Capital Scoreboard - Server Side
-- Sistema unificado de scoreboard y panel de funcionarios

local playerConnectTimes = {}
local scoreboardDummy

-- IDs de facciones (basado en tu sistema anterior)
local FACTION_IDS = {
    POLICE = 1,
    MEDIC = 2, 
    MECHANIC = 3,
    MILITARY = 4,
    MECHANIC_ILEGAL = 13,
    TRANSIT = 14
}

-- Función para obtener jugadores de una facción específica
local function getJugadoresFaccion(factionID)
    local players = {}
    for _, player in ipairs(getElementsByType("player")) do
        -- Usar el mismo sistema que tenías antes
        if exports.factions:isPlayerInFaction(player, factionID) or getElementData(player, "enc"..tostring(factionID)) then
            table.insert(players, player)
        end
    end
    return players
end

-- Función para inicializar tiempo de conexión de un jugador
local function initializePlayerConnectTime(player)
    if not isElement(player) then return end
    
    -- Si ya tiene tiempo registrado, no lo cambiamos
    if not playerConnectTimes[player] then
        playerConnectTimes[player] = getRealTime().timestamp
        setElementData(player, "connectTime", playerConnectTimes[player])
    end
end

-- Función para calcular tiempo conectado en segundos
local function getPlayerConnectedTime(player)
    if not playerConnectTimes[player] then
        initializePlayerConnectTime(player)
    end
    
    local currentTime = getRealTime().timestamp
    local connectTime = playerConnectTimes[player]
    return currentTime - connectTime
end

-- Función para formatear tiempo en hh:mm:ss o mm:ss
local function formatTime(seconds)
    if seconds < 0 then seconds = 0 end
    
    if seconds < 3600 then
        -- Menos de 1 hora: mm:ss
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%02d:%02d", mins, secs)
    else
        -- Más de 1 hora: hh:mm:ss
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        return string.format("%02d:%02d:%02d", hours, mins, secs)
    end
end

-- Evento para solicitar datos completos del scoreboard
addEvent("requestScoreboardData", true)
addEventHandler("requestScoreboardData", root, function()
    if source ~= client then return end
    
    -- Datos básicos del servidor
    local totalPlayers = #getElementsByType("player")
    local maxPlayers = getMaxPlayers()
    
    -- Contadores de funcionarios
    local factionCounts = {
        police = #getJugadoresFaccion(FACTION_IDS.POLICE),
        military = #getJugadoresFaccion(FACTION_IDS.MILITARY),
        medic = #getJugadoresFaccion(FACTION_IDS.MEDIC),
        mechanic = #getJugadoresFaccion(FACTION_IDS.MECHANIC),
        transit = #getJugadoresFaccion(FACTION_IDS.TRANSIT),
        mechanic_ilegal = #getJugadoresFaccion(FACTION_IDS.MECHANIC_ILEGAL)
    }
    
    -- Lista de jugadores con sus datos mejorados
    local playersData = {}
    for i, player in ipairs(getElementsByType("player")) do
        if isElement(player) then
            -- Obtener colores del nametag
            local r, g, b = getPlayerNametagColor(player)
            
            local playerData = {
                id = getElementData(player, "playerid") or i,
                name = getPlayerName(player):gsub("_", " "),
                ping = getPlayerPing(player),
                connectedTime = formatTime(getPlayerConnectedTime(player)),
                fps = getElementData(player, "FPS") or math.random(30, 100), -- FPS simulado para otros jugadores
                nametagColor = {r = r, g = g, b = b}, -- Colores del nametag para el cliente
                element = player -- Referencia al elemento para el cliente
            }
            table.insert(playersData, playerData)
        end
    end
    
    -- Ordenar jugadores por ID, con el local player primero
    table.sort(playersData, function(a, b)
        local playerA = getPlayerFromName(string.gsub(a.name, " ", "_"))
        local playerB = getPlayerFromName(string.gsub(b.name, " ", "_"))
        
        if playerA == client then
            return true
        elseif playerB == client then
            return false
        else
            return tonumber(a.id) < tonumber(b.id)
        end
    end)
    
    -- Enviar todos los datos al cliente
    triggerClientEvent(client, "receiveScoreboardData", client, {
        totalPlayers = totalPlayers,
        maxPlayers = maxPlayers,
        factionCounts = factionCounts,
        playersData = playersData
    })
end)

-- Evento para actualizar FPS de un jugador
addEvent("updatePlayerFPS", true)
addEventHandler("updatePlayerFPS", root, function(fps)
    if source ~= client then return end
    
    if fps and type(fps) == "number" and fps > 0 and fps < 500 then
        setElementData(client, "FPS", math.floor(fps))
    end
end)

-- Inicialización del recurso
addEventHandler("onResourceStart", resourceRoot, function()
    -- Crear elemento dummy para compatibilidad
    scoreboardDummy = createElement("scoreboard")
    setElementData(scoreboardDummy, "serverName", "LA CAPITAL ROLEPLAY")
    setElementData(scoreboardDummy, "maxPlayers", getMaxPlayers())
    setElementData(scoreboardDummy, "allow", true)
    
    -- Inicializar tiempos para jugadores ya conectados
    for _, player in ipairs(getElementsByType("player")) do
        initializePlayerConnectTime(player)
    end
    
    outputServerLog("Capital Scoreboard: Sistema inicializado correctamente")
end)

-- Cuando un jugador se conecta
addEventHandler("onPlayerJoin", root, function()
    initializePlayerConnectTime(source)
end)

-- Cuando un jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    playerConnectTimes[source] = nil
    lastDataUpdate[source] = nil  -- Limpiar cache de actualizaciones
end)

-- Limpiar datos al parar el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    if scoreboardDummy then
        destroyElement(scoreboardDummy)
    end
    playerConnectTimes = {}
    lastDataUpdate = {}  -- Limpiar cache de actualizaciones
end)

-- Optimización para actualizaciones más frecuentes
local lastDataUpdate = {}

-- Función para verificar si un jugador necesita actualización de datos
local function needsDataUpdate(player)
    local now = getTickCount()
    if not lastDataUpdate[player] then
        lastDataUpdate[player] = now
        return true
    end
    
    -- Solo actualizar datos específicos del jugador cada 5 segundos
    if now - lastDataUpdate[player] > 5000 then
        lastDataUpdate[player] = now
        return true
    end
    
    return false
end

-- Actualizar datos cada 30 segundos (optimizado para tiempo real)
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        initializePlayerConnectTime(player)
        -- Limpiar cache de actualizaciones para jugadores desconectados
        if not isElement(player) then
            lastDataUpdate[player] = nil
        end
    end
end, 30000, 0)
