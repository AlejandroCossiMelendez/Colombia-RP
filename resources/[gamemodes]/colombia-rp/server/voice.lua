-- Sistema de Voz - Frecuencias y gestión de voz
-- Adaptado para Colombia RP

local venFrecAb = {}
local tablasBroadcast = {}

-- Función para obtener las facciones del jugador (simplificado para Colombia RP)
function getPlayerFactions(player)
    -- Por ahora retornar un array vacío, se puede expandir después
    -- Esto se puede conectar con un sistema de facciones si existe
    local job = getElementData(player, "character:job") or "Desempleado"
    
    -- Mapear trabajos a IDs de facción (se puede expandir)
    local factionMap = {
        ["Policía"] = 1,
        ["Médico"] = 2,
        ["Mecánico"] = 3,
        ["Periodista"] = 4,
        ["Gobierno"] = 5,
        ["Juez"] = 6,
        ["Transportista"] = 7,
        ["Conductor"] = 8
    }
    
    local factions = {}
    if factionMap[job] then
        table.insert(factions, factionMap[job])
    end
    
    return factions
end

-- Comando para abrir/cerrar el menú de frecuencias
function abrirMisFrecuencias(player)
    if not getElementData(player, "character:selected") then
        outputChatBox("No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    if not venFrecAb[player] then
        local factions = getPlayerFactions(player)
        triggerClientEvent(player, "onAbrirMisFrecuencias", resourceRoot, factions)
        venFrecAb[player] = true
    else
        triggerClientEvent(player, "onCerrarMisFrecuencias", resourceRoot)
        venFrecAb[player] = nil
    end
end
addCommandHandler("misf", abrirMisFrecuencias)
addCommandHandler("misfrecuencias", abrirMisFrecuencias)

-- Evento para conectar a una frecuencia
addEvent("onConectarAFrecuencia", true)
addEventHandler("onConectarAFrecuencia", root, function(frecuenciaID, frecuenciaName)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    if not getElementData(source, "character:selected") then
        outputChatBox("No tienes un personaje seleccionado.", source, 255, 0, 0)
        return
    end
    
    if not frecuenciaID then
        return
    end
    
    venFrecAb[source] = nil
    
    if tonumber(frecuenciaID) >= 100 and tonumber(frecuenciaID) < 2000 then
        if conectarJugadorAFrecuencia(source, frecuenciaID) then
            outputChatBox("Canal de voz conectado a ["..tostring(frecuenciaID).."] '"..tostring(frecuenciaName).."'.", source, 0, 255, 0)
            outputChatBox("Ahora hablas en la frecuencia. Presiona 'Z' para hablar en la frecuencia.", source, 255, 255, 0)
        end
    elseif tonumber(frecuenciaID) == -1 then
        if conectarJugadorAFrecuencia(source, -1) then
            outputChatBox("Te has desconectado de la frecuencia. Ahora hablas por proximidad.", source, 255, 255, 0)
        end
    end
end)

-- Función para conectar jugador a frecuencia
function conectarJugadorAFrecuencia(jugador, frecuencia, ignoreAviso)
    if not isElement(jugador) or not tonumber(frecuencia) then
        return false
    end
    
    -- Obtener frecuencia anterior
    local frecuencia_old = getElementData(jugador, "frecuencia.voz")
    
    -- Si se desconecta de la frecuencia (frecuencia = -1 o >= 2000), volver a voz por proximidad
    if tonumber(frecuencia) == -1 or tonumber(frecuencia) >= 2000 then
        setElementData(jugador, "frecuencia.voz", tonumber(frecuencia))
        -- Restaurar voz por proximidad (no configurar broadcast)
        setPlayerVoiceBroadcastTo(jugador, {})
        removeElementData(jugador, "frecuencia.voz.whisper")
        
        -- Notificar a otros jugadores si salió de una frecuencia
        if frecuencia_old and tonumber(frecuencia_old) and tonumber(frecuencia_old) ~= -1 and tonumber(frecuencia_old) < 2000 then
            -- Reconstruir la tabla de broadcast para los que quedan en la frecuencia
            local tablaBroadcast = {}
            for _, v in ipairs(getElementsByType("player")) do
                if isElement(v) and getElementData(v, "character:selected") and v ~= jugador then
                    if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia_old) then
                        table.insert(tablaBroadcast, v)
                    end
                end
            end
            -- Actualizar broadcast para los que quedan
            for _, v in ipairs(getElementsByType("player")) do
                if isElement(v) and getElementData(v, "character:selected") and v ~= jugador then
                    if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia_old) then
                        setPlayerVoiceBroadcastTo(v, tablaBroadcast)
                    end
                end
            end
        end
        return true
    end
    
    -- Si se conecta a una frecuencia válida (100-999)
    setElementData(jugador, "frecuencia.voz", tonumber(frecuencia))
    
    -- Notificar a otros jugadores si cambió de frecuencia
    if frecuencia_old and tonumber(frecuencia_old) and tonumber(frecuencia_old) ~= tonumber(frecuencia) and tonumber(frecuencia_old) ~= -1 and tonumber(frecuencia_old) < 2000 then
        -- Reconstruir tabla para la frecuencia anterior
        local tablaBroadcastOld = {}
        for _, v in ipairs(getElementsByType("player")) do
            if isElement(v) and getElementData(v, "character:selected") and v ~= jugador then
                if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia_old) then
                    table.insert(tablaBroadcastOld, v)
                end
            end
        end
        -- Actualizar broadcast para los que quedan en la frecuencia anterior
        for _, v in ipairs(getElementsByType("player")) do
            if isElement(v) and getElementData(v, "character:selected") and v ~= jugador then
                if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia_old) then
                    setPlayerVoiceBroadcastTo(v, tablaBroadcastOld)
                end
            end
        end
    end
    
    -- Configurar whisper si es necesario
    if tonumber(frecuencia) ~= -1 and tonumber(frecuencia) < 2000 then
        setElementData(jugador, "frecuencia.voz.whisper", math.floor(tonumber(frecuencia)/100))
    else
        removeElementData(jugador, "frecuencia.voz.whisper")
    end
    
    -- Construir tabla de broadcast con todos los jugadores en la misma frecuencia
    local tablaBroadcast = {}
    for _, v in ipairs(getElementsByType("player")) do
        if isElement(v) and getElementData(v, "character:selected") then
            if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia) then
                table.insert(tablaBroadcast, v)
                if ignoreAviso ~= true and jugador ~= v then
                    local charName = getElementData(jugador, "character:name") or getPlayerName(jugador)
                    local charSurname = getElementData(jugador, "character:surname") or ""
                    outputChatBox((charName .. " " .. charSurname) .. " se ha unido a tu frecuencia.", v, 0, 255, 0)
                end
            end
        end
    end
    
    -- Asignar tabla de broadcast a todos los jugadores en la frecuencia
    for _, v in ipairs(getElementsByType("player")) do
        if isElement(v) and getElementData(v, "character:selected") then
            if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia) then
                setPlayerVoiceBroadcastTo(v, tablaBroadcast)
            end
        end
    end
    
    return true
end

-- Comando para toggle whisper
addCommandHandler("whisper", function(player)
    if not getElementData(player, "character:selected") then
        outputChatBox("No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    if getElementData(player, "frecuencia.inWhisper") == true then
        if getElementData(player, "frecuencia.voz.whisper") then
            conectarJugadorAFrecuencia(player, tonumber(getElementData(player, "frecuencia.voz")), true)
            outputChatBox("Has desactivado el modo Whisper. Ahora hablas a los de tu frecuencia.", player, 0, 255, 0)
            removeElementData(player, "frecuencia.inWhisper")
        end
    else
        if getElementData(player, "frecuencia.voz.whisper") then
            local frecuencia = getElementData(player, "frecuencia.voz.whisper")
            local tablaBroadcast2 = {}
            
            for _, v in ipairs(getElementsByType("player")) do
                if isElement(v) and getElementData(v, "character:selected") then
                    if tonumber(getElementData(v, "frecuencia.voz.whisper")) == tonumber(frecuencia) then
                        table.insert(tablaBroadcast2, v)
                    end
                end
            end
            
            setPlayerVoiceBroadcastTo(player, tablaBroadcast2)
            outputChatBox("Has activado el modo Whisper. Ahora hablas a toda tu facción.", player, 255, 255, 0)
            setElementData(player, "frecuencia.inWhisper", true)
        end
    end
end)

-- Comando de ayuda
addCommandHandler("voz", function(player)
    outputChatBox("~~ Instrucciones del sistema de voz ~~", player, 255, 255, 255)
    outputChatBox(" - Por defecto, hablas por proximidad (todos los cercanos te escuchan)", player, 0, 255, 0)
    outputChatBox(" - Usa /misf para abrir el menú de frecuencias (opcional)", player, 255, 255, 255)
    outputChatBox(" - Si tienes frecuencia activa, presiona 'Z' para hablar en la frecuencia", player, 255, 255, 255)
    outputChatBox(" - Usa /whisper para hablar a toda tu facción (solo con frecuencia activa)", player, 0, 255, 0)
end)

-- Inicializar voz por proximidad cuando el jugador spawnea
addEventHandler("onPlayerSpawn", root, function()
    if getElementData(source, "character:selected") then
        -- Si no tiene frecuencia activa, asegurar voz por proximidad
        local frecuencia = getElementData(source, "frecuencia.voz")
        if not frecuencia or tonumber(frecuencia) == -1 or tonumber(frecuencia) >= 2000 then
            setPlayerVoiceBroadcastTo(source, {}) -- Voz por proximidad
        end
    end
end)

-- Inicializar voz por proximidad cuando el jugador selecciona un personaje
addEvent("onCharacterSelected", true)
addEventHandler("onCharacterSelected", root, function()
    if isElement(source) and getElementType(source) == "player" then
        -- Inicializar sin frecuencia (voz por proximidad)
        if not getElementData(source, "frecuencia.voz") then
            setElementData(source, "frecuencia.voz", -1)
            setPlayerVoiceBroadcastTo(source, {}) -- Voz por proximidad
        end
    end
end)

-- Desconectar al cambiar de personaje
addEventHandler("onPlayerQuit", root, function()
    venFrecAb[source] = nil
end)

