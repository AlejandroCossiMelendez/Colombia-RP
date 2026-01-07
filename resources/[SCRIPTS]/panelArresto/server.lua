-- Variables globales
local markerPD = createMarker(1605.9339599609, -1663.8874511719, 8.0309371948242 - 1, "cylinder", 1.5, 255, 0, 0, 150)
local timerLiberacion = {}
local arrestStartTimes = {} -- Nueva tabla para almacenar tiempos de inicio

-- Variable para almacenar los minutos totales por jugador
local totalMinutes = {}

-- Definir las celdas
local celdas = {
    {-307.9296875, 1565.091796875, 77.254875183105},     -- celda1
    {-298.8662109375, 1565.263671875, 77.254875183105},  -- celda2
    {-290.3154296875, 1564.8125, 77.254875183105},       -- celda3
    {-280.9892578125, 1565.00390625, 77.254875183105},   -- celda4
    {-309.8388671875, 1574.6171875, 77.254875183105},    -- celda5
    {-306.42578125, 1582.673828125, 77.254875183105},    -- celda6
    {-302.685546875, 1590.623046875, 77.254875183105},   -- celda7
    {-281.3154296875, 1565.0556640625, 82.911125183105}, -- celda8
    {-290.6767578125, 1565.078125, 82.911125183105},     -- celda9
    {-299.3271484375, 1564.97265625, 82.911125183105}    -- celda10
}

-- Añadir las coordenadas de liberación
local puntoLiberacion = {
    x = -430.2822265625,  -- Ajusta estas coordenadas al punto donde quieres que salgan
    y = 1437.0673828125,  -- Estas son coordenadas de ejemplo, ajústalas
    z = 34.224815368652,        -- a la salida de la comisaría
    rot = 75             -- Rotación al salir
}

-- Verificar y crear columnas necesarias al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    -- Verificar si la columna last_arrest_time existe
    local result = exports.sql:query_assoc("SHOW COLUMNS FROM characters LIKE 'last_arrest_time'")
    if #result == 0 then
        exports.sql:query_free("ALTER TABLE characters ADD COLUMN last_arrest_time TIMESTAMP NULL DEFAULT NULL")
        outputDebugString("[POLICIA] Columna last_arrest_time añadida a la tabla characters")
    end
    
    -- Limpiar cualquier arresto que haya quedado colgado
    exports.sql:query_free("UPDATE characters SET ajail = 0, last_arrest_time = NULL WHERE ajail > 0 AND (last_arrest_time IS NULL OR TIMESTAMPDIFF(MINUTE, last_arrest_time, CURRENT_TIMESTAMP) >= ajail)")
end)

-- Función que se ejecuta cuando un jugador entra al marker
function onMarkerHit(hitElement, matchingDimension)
    if not (exports.factions:isPlayerInFaction(hitElement, 1) or exports.factions:isPlayerInFaction(hitElement, 4)) then
        exports.infoSirilo:addBox(hitElement, "No tienes acceso a este panel", "error")
    else
        if getElementType(hitElement) == "player" and matchingDimension then
            triggerClientEvent(hitElement, "onOpenPanelPD", hitElement)
        end
    end
end

addEventHandler("onMarkerHit", markerPD, onMarkerHit)

-- Añadir esta función para manejar la búsqueda de jugadores
function handlePlayerInfoRequest(targetID)
    -- Usar el mismo sistema que bancolombia
    local targetPlayer = exports.players:getFromName(source, targetID)
    if targetPlayer then
        local targetName = getPlayerName(targetPlayer):gsub("_", " ")
        triggerClientEvent(source, "onReceivePlayerInfo", source, targetName, true)
    else
        triggerClientEvent(source, "onReceivePlayerInfo", source, "", false)
    end
end
addEvent("onRequestPlayerInfo", true)
addEventHandler("onRequestPlayerInfo", root, handlePlayerInfoRequest)

function handleAtribuirCodigo(codigoID, descripcion, minutes)
    -- Inicializar los minutos totales si no existen
    if not totalMinutes[source] then
        totalMinutes[source] = 0
    end
    
    -- Sumar los minutos
    totalMinutes[source] = totalMinutes[source] + minutes
    
    -- Enviar mensaje al chat
    if minutes > 0 then
        outputChatBox("[Panel PD] Código " .. codigoID .. " atribuido. Minutos: " .. minutes, source, 0, 255, 0)
        outputChatBox("[Panel PD] Total minutos acumulados: " .. totalMinutes[source], source, 0, 255, 0)
    end
end
addEvent("onAtribuirCodigo", true)
addEventHandler("onAtribuirCodigo", root, handleAtribuirCodigo)

-- Resetear los minutos cuando se cierra el panel
function resetMinutes()
    totalMinutes[source] = 0
end
addEvent("onResetMinutes", true)
addEventHandler("onResetMinutes", root, resetMinutes)

-- Función para liberar al jugador automáticamente
function liberarJugadorAutomatico(player)
    if not isElement(player) then return end
    
    local charID = exports.players:getCharacterID(player)
    
    -- Limpiar todos los datos
    setElementData(player, "ajail", nil)
    setElementData(player, "tiempoArrestoTotal", nil)
    setElementData(player, "skinOriginalPrision", nil)
    
    -- Limpiar tiempo de inicio
    arrestStartTimes[charID] = nil
    
    -- Limpiar timer si existe
    if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
        killTimer(timerLiberacion[charID])
        timerLiberacion[charID] = nil
    end
    
    -- Actualizar base de datos
    exports.sql:query_free("UPDATE characters SET ajail = 0, last_arrest_time = NULL WHERE characterID = ?", charID)
    
    -- Restaurar la skin original
    local skinOriginal = getElementData(player, "skinOriginalPrision")
    if skinOriginal then
        setElementModel(player, skinOriginal)
        setElementData(player, "skinOriginalPrision", nil)
    end
    
    -- Limpiar datos de arresto
    setElementData(player, "ajail", nil)
    setElementData(player, "tiempoArrestoTotal", nil)
    
    -- Detener el contador visual
    if isElement(player) then
        triggerClientEvent(player, "policia:detenerContadorArresto", player)
    end
    
    -- Notificar al jugador
    outputChatBox("Has sido liberado de la cárcel.", player, 0, 255, 0)
    
    -- Teletransportar al jugador al punto de liberación
    setElementPosition(player, puntoLiberacion.x, puntoLiberacion.y, puntoLiberacion.z)
    setElementRotation(player, 0, 0, puntoLiberacion.rot)
end

-- Añadir esta función para manejar el arresto
function handleArrestarJugador(targetID, tiempo, razon)
    local player = source
    if not (exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 4)) then
        exports.infoSirilo:addBox(player, "No tienes permiso para arrestar", "error")
        return
    end

    -- Verificar si el jugador está dentro del marcador de arresto
    if not isElementWithinMarker(player, markerPD) then
        exports.infoSirilo:addBox(player, "Solo puedes arrestar en la zona designada", "error")
        return
    end

    local targetPlayer = exports.players:getFromName(player, targetID)
    if not targetPlayer then
        exports.infoSirilo:addBox(player, "Jugador no encontrado", "error")
        return
    end

    -- Verificar si el otro jugador está cerca
    local x1, y1, z1 = getElementPosition(player)
    local x2, y2, z2 = getElementPosition(targetPlayer)
    local distancia = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
    
    if distancia > 5 then
        exports.infoSirilo:addBox(player, "El sospechoso está demasiado lejos", "error")
        return
    end

    -- Asegurarse de que el tiempo sea válido
    local tiempoArresto = math.max(1, math.min(tonumber(tiempo), 60))
    
    -- Obtener el CharacterID del jugador
    local charID = exports.players:getCharacterID(targetPlayer)
    
    -- Guardar la skin original
    setElementData(targetPlayer, "skinOriginalPrision", getElementModel(targetPlayer))
    
    -- Cambiar a skin de prisionero
    setElementModel(targetPlayer, 111)
    
    -- Seleccionar una celda aleatoria y teleportar
    local celdaRandom = math.random(1, #celdas)
    local celdaPos = celdas[celdaRandom]
    setElementPosition(targetPlayer, celdaPos[1], celdaPos[2], celdaPos[3])
    
    -- Establecer el tiempo de arresto
    local tiempoArrestoSegundos = tiempoArresto * 60
    setElementData(targetPlayer, "ajail", tiempoArresto)
    setElementData(targetPlayer, "tiempoArrestoTotal", tiempoArrestoSegundos)
    
    -- Iniciar el contador visual para el jugador
    if isElement(targetPlayer) then
        triggerClientEvent(targetPlayer, "policia:iniciarContadorArresto", targetPlayer, tiempoArrestoSegundos)
    end
    
    -- Obtener el nombre del agente y del arrestado (sin guiones bajos)
    local nombreAgente = getPlayerName(player):gsub("_", " ")
    local nombreArrestado = getPlayerName(targetPlayer):gsub("_", " ")
    
    -- Notificar a todos los policías
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
            outputChatBox(nombreArrestado .. " ha sido arrestado por " .. nombreAgente, v, 255, 0, 0)
            outputChatBox("Tiempo: ((" .. tiempoArresto .. " minutos)) Razón: " .. razon, v, 255, 0, 0)
        end
    end
    
    -- Notificar al arrestado
    outputChatBox("Has sido arrestado por " .. nombreAgente .. " durante " .. tiempoArresto .. " minutos.", targetPlayer, 255, 0, 0)
    outputChatBox("Razón: " .. razon, targetPlayer, 255, 0, 0)
    
    -- Guardar en la base de datos
    exports.sql:query_free("UPDATE characters SET ajail = ?, last_arrest_time = CURRENT_TIMESTAMP WHERE characterID = ?", 
        tiempoArresto, charID)
    
    -- Insertar en el historial
    local sql = exports.sql:query_insertid("INSERT INTO `historiales` (`historialID`, `nombre`, `dni`, `residencia`, `profesion`, `delitos`, `agente`, `fecha`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP);",
        nombreArrestado,
        tostring(20000000 + charID),
        "No Procede",
        "No Procede",
        tostring(razon) .. " (( " .. tostring(tiempoArresto) .. " minutos.))",
        nombreAgente
    )
    
    -- Guardar el tiempo de inicio del arresto
    arrestStartTimes[charID] = getTickCount()
    
    -- Crear temporizador para la liberación
    if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
        killTimer(timerLiberacion[charID])
    end
    
    timerLiberacion[charID] = setTimer(function()
        if isElement(targetPlayer) and getElementData(targetPlayer, "ajail") then
            liberarJugadorAutomatico(targetPlayer)
        end
    end, tiempoArrestoSegundos * 1000, 1)
end
addEvent("onArrestarJugador", true)
addEventHandler("onArrestarJugador", root, handleArrestarJugador)

-- Función para manejar la desconexión de jugadores arrestados
function handlePlayerQuit()
    if getElementData(source, "ajail") then
        local charID = exports.players:getCharacterID(source)
        local tiempoRestante = getElementData(source, "ajail")
        local tiempoTranscurrido = getTickCount() - (arrestStartTimes[charID] or 0)
        local tiempoActualizado = math.max(0, tiempoRestante - math.floor(tiempoTranscurrido/60000))
        
        -- Guardar el tiempo exacto y el momento de desconexión
        exports.sql:query_free("UPDATE characters SET ajail = ?, last_arrest_time = CURRENT_TIMESTAMP WHERE characterID = ?", 
            tiempoActualizado, charID)
            
        -- Limpiar el timer si existe
        if timerLiberacion[charID] and isTimer(timerLiberacion[charID]) then
            killTimer(timerLiberacion[charID])
            timerLiberacion[charID] = nil
        end
        
        -- Limpiar el tiempo de inicio
        arrestStartTimes[charID] = nil
    end
end
addEventHandler("onPlayerQuit", root, handlePlayerQuit)

-- Función para verificar el estado de arresto al conectar
function checkArrestStatusOnSpawn()
    local player = source
    local charID = exports.players:getCharacterID(player)
    if not charID then return end
    
    local result = exports.sql:query_assoc_single("SELECT ajail, last_arrest_time FROM characters WHERE characterID = ?", charID)
    if not result then return end
    
    if result.ajail and tonumber(result.ajail) > 0 then
        -- Calcular tiempo transcurrido desde la última actualización
        local tiempoTranscurrido = 0
        if result.last_arrest_time then
            local timestampUltimaActualizacion = exports.sql:query_assoc_single("SELECT UNIX_TIMESTAMP(?) as timestamp", result.last_arrest_time).timestamp
            local tiempoActual = exports.sql:query_assoc_single("SELECT UNIX_TIMESTAMP(CURRENT_TIMESTAMP) as timestamp").timestamp
            tiempoTranscurrido = math.floor((tiempoActual - timestampUltimaActualizacion) / 60)
        end
        
        -- Actualizar tiempo restante
        local tiempoRestante = math.max(0, tonumber(result.ajail) - tiempoTranscurrido)
        
        if tiempoRestante <= 0 then
            -- Si ya cumplió la condena, liberarlo
            exports.sql:query_free("UPDATE characters SET ajail = 0, last_arrest_time = NULL WHERE characterID = ?", charID)
            outputChatBox("Tu condena ha sido cumplida durante tu ausencia.", player, 0, 255, 0)
        else
            -- Reiniciar el arresto con el tiempo restante
            setElementData(player, "ajail", tiempoRestante)
            setElementData(player, "tiempoArrestoTotal", tiempoRestante * 60)
            
            -- Guardar el nuevo tiempo de inicio
            arrestStartTimes[charID] = getTickCount()
            
            -- Seleccionar celda y teleportar
            local celdaRandom = math.random(1, #celdas)
            local celdaPos = celdas[celdaRandom]
            setElementPosition(player, celdaPos[1], celdaPos[2], celdaPos[3])
            
            -- Cambiar a skin de prisionero
            setElementModel(player, 111)
            
            -- Iniciar contador visual
            if isElement(player) then
                triggerClientEvent(player, "policia:iniciarContadorArresto", player, tiempoRestante * 60)
            end
            
            -- Crear nuevo timer de liberación
            timerLiberacion[charID] = setTimer(function()
                if isElement(player) and getElementData(player, "ajail") then
                    liberarJugadorAutomatico(player)
                end
            end, tiempoRestante * 60 * 1000, 1)
            
            outputChatBox("Continúas cumpliendo tu condena. Te quedan " .. tiempoRestante .. " minutos.", player, 255, 0, 0)
        end
    end
end
addEventHandler("onPlayerSpawn", root, checkArrestStatusOnSpawn)
