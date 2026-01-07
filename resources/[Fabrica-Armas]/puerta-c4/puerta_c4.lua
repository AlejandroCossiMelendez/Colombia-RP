local puerta
local markerC4
local tiempoRespawn = 1800000 -- 30 minutos en milisegundos
local explosionRadio = 20 -- Radio del sonido aumentado
local sonidoExplosion = "explosion.mp3"
local tiempoExplosion = 5000 -- 5 segundos para la explosión
local c4Activo = false
local jugadoresNotificados = {}
local tiempoDestruccion = 0
local puertaDestruida = false

-- Coordenadas y configuración de la puerta
local puertaPos = {412.39999389648, 2552.3999023438, 26.10000038147}
local puertaModel = 2930
local interior = 10
local dimension = 14

function crearPuerta()
    if isElement(puerta) then destroyElement(puerta) end
    if isElement(markerC4) then destroyElement(markerC4) end
    
    c4Activo = false
    jugadoresNotificados = {}
    puertaDestruida = false

    -- Crear la puerta
    puerta = createObject(puertaModel, puertaPos[1], puertaPos[2], puertaPos[3])
    setElementDimension(puerta, dimension)
    setElementInterior(puerta, interior)
    setObjectBreakable(puerta, false) -- Evita que se rompa con armas normales

    -- Crear marker para colocar el C4
    markerC4 = createMarker(puertaPos[1], puertaPos[2], puertaPos[3] - 2.5, "cylinder", 1.5, 255, 0, 0, 150)
    setElementDimension(markerC4, dimension)
    setElementInterior(markerC4, interior)

    outputDebugString("🔹 Puerta creada en el interior " .. interior .. " y dimensión " .. dimension)
end
addEventHandler("onResourceStart", resourceRoot, crearPuerta)

-- Función para notificar a los jugadores que entran al interior
function notificarJugadoresNuevos(player)
    if not c4Activo then return end
    
    local dim = getElementDimension(player) or 0
    local int = getElementInterior(player) or 0
    
    -- Si el jugador entra al interior/dimensión donde está el C4 activo
    if dim == dimension and int == interior and not jugadoresNotificados[player] then
        outputChatBox("⚠️ ¡Cuidado! Hay un C4 activo en este lugar.", player, 255, 0, 0)
        jugadoresNotificados[player] = true
    end
end
addEventHandler("onElementDimensionChange", root, function(oldDim, newDim)
    if getElementType(source) == "player" and newDim == dimension then
        notificarJugadoresNuevos(source)
    end
end)
addEventHandler("onElementInteriorChange", root, function(oldInt, newInt)
    if getElementType(source) == "player" and newInt == interior then
        notificarJugadoresNuevos(source)
    end
end)

function colocarC4EnMarker(player)
    if not isElement(puerta) then return end
    if c4Activo then
        outputChatBox("❌ Ya hay un C4 colocado en la puerta.", player, 255, 0, 0)
        return
    end

    -- Verifica si el jugador tiene el C4 (ID 90)
    local tieneC4, slotC4 = exports.items:has(player, 90) 
    if not tieneC4 then
        outputChatBox("❌ No tienes C4 para colocar en la puerta.", player, 255, 0, 0)
        return
    end

    -- Inicia la animación de colocar el C4
    setPedAnimation(player, "bomb", "bomb_arm", 5000, false, false, false, false)

    -- Mensaje solo para jugadores cercanos (5m)
    local playersCercanos = getElementsWithinRange(puertaPos[1], puertaPos[2], puertaPos[3], 5, "player")
    for _, jugador in ipairs(playersCercanos) do
        outputChatBox("* " .. getPlayerName(player) .. " coloca una carga de C4 en la puerta.", jugador, 255, 150, 0)
    end

    -- Remover el C4 del inventario
    exports.items:take(player, slotC4)
    
    -- Marcar el C4 como activo
    c4Activo = true
    
    -- Registrar al jugador que colocó el C4
    jugadoresNotificados[player] = true
    
    -- Crear temporizador visual para todos los jugadores en el interior
    local jugadoresEnInterior = getPlayersInInterior(interior, dimension)
    for _, jugador in ipairs(jugadoresEnInterior) do
        if isElement(jugador) then
            triggerClientEvent(jugador, "crearTemporizadorC4", jugador, puertaPos[1], puertaPos[2], puertaPos[3], tiempoExplosion, dimension, interior)
            jugadoresNotificados[jugador] = true
        end
    end

    -- Reproducir el sonido de la explosión justo antes de destruir la puerta
    setTimer(function()
        local jugadoresEnInteriorSonido = getPlayersInInterior(interior, dimension)
        for _, jugador in ipairs(jugadoresEnInteriorSonido) do
            if isElement(jugador) then
                triggerClientEvent(jugador, "reproducirSonidoExplosion", jugador, puertaPos[1], puertaPos[2], puertaPos[3], sonidoExplosion, dimension, interior)
            end
        end
    end, tiempoExplosion - 500, 1) -- El sonido se reproduce 0.5 segundos antes de la explosión

    -- Espera para destruir la puerta y crear efectos de explosión
    setTimer(function()
        if isElement(puerta) then
            -- Registrar el tiempo de destrucción
            tiempoDestruccion = getTickCount()
            puertaDestruida = true
            
            -- Mensaje de explosion y efectos para todos los jugadores en el interior
            local jugadoresEnInteriorExplosion = getPlayersInInterior(interior, dimension)
            for _, jugador in ipairs(jugadoresEnInteriorExplosion) do
                outputChatBox("💥 ¡El C4 explotó y destruyó la puerta!", jugador, 255, 0, 0)
                
                -- Crear efectos visuales de explosion
                triggerClientEvent(jugador, "crearEfectoExplosion", jugador, puertaPos[1], puertaPos[2], puertaPos[3], dimension, interior)
                
                -- Crear temporizador visual de respawn
                triggerClientEvent(jugador, "crearTemporizadorRespawn", jugador, puertaPos[1], puertaPos[2], puertaPos[3], tiempoRespawn, dimension, interior)
            end

            -- Destruir puerta y marker
            destroyElement(puerta)
            destroyElement(markerC4)
            
            -- Resetear variables
            c4Activo = false
            jugadoresNotificados = {}

            -- Programar reaparecimiento de la puerta
            setTimer(function()
                crearPuerta()
                tiempoDestruccion = 0
                puertaDestruida = false
            end, tiempoRespawn, 1)
        end
    end, tiempoExplosion, 1) -- Se destruye exactamente cuando termina el temporizador
end

-- Función para obtener todos los jugadores en un interior específico
function getPlayersInInterior(interiorID, dimensionID)
    local jugadores = {}
    for _, jugador in ipairs(getElementsByType("player")) do
        local int = getElementInterior(jugador) or 0
        local dim = getElementDimension(jugador) or 0
        
        if int == interiorID and dim == dimensionID then
            table.insert(jugadores, jugador)
        end
    end
    return jugadores
end

addEventHandler("onMarkerHit", resourceRoot, function(hitElement)
    if hitElement and getElementType(hitElement) == "player" then
        if source == markerC4 then
            colocarC4EnMarker(hitElement)
        end
    end
end)

-- Añadir esta función para sincronizar con jugadores que se conectan
function sincronizarEstadoPuerta(player)
    -- Si la puerta está destruida, mostrar el temporizador de regeneración
    if puertaDestruida then
        local tiempoTranscurrido = getTickCount() - tiempoDestruccion
        local tiempoRestante = tiempoRespawn - tiempoTranscurrido
        
        -- Solo si queda tiempo suficiente para mostrar el temporizador
        if tiempoRestante > 5000 then
            setTimer(function()
                if isElement(player) then
                    local dim = getElementDimension(player) or 0
                    local int = getElementInterior(player) or 0
                    
                    -- Enviar información al cliente para crear el temporizador
                    triggerClientEvent(player, "crearTemporizadorRespawn", player, puertaPos[1], puertaPos[2], puertaPos[3], tiempoRestante, dimension, interior)
                    
                    -- Notificar al jugador
                    local minutos = math.floor(tiempoRestante / 60000)
                    local segundos = math.floor((tiempoRestante % 60000) / 1000)
                    outputChatBox("SISTEMA: La puerta fue destruida y se regenerara en " .. minutos .. " minutos y " .. segundos .. " segundos.", player, 0, 200, 255)
                end
            end, 2000, 1) -- Pequeño retraso para asegurar que el cliente esté listo
        end
    end
end

-- Añadir estos event handlers para detectar jugadores que se conectan
addEventHandler("onPlayerJoin", root, function()
    setTimer(function()
        if isElement(source) then
            sincronizarEstadoPuerta(source)
        end
    end, 5000, 1) -- Dar tiempo al jugador para cargar completamente
end)

addEventHandler("onPlayerSpawn", root, function()
    setTimer(function()
        if isElement(source) then
            sincronizarEstadoPuerta(source)
        end
    end, 3000, 1)
end)

-- Modificar la función notificarJugadoresRespawn para usar el nuevo sistema
function notificarJugadoresRespawn(player)
    if not puertaDestruida then return end -- Si la puerta no está destruida, no hay necesidad de notificar
    
    local dim = getElementDimension(player) or 0
    local int = getElementInterior(player) or 0
    
    -- Si el jugador entra al interior/dimensión donde debería estar la puerta
    if dim == dimension and int == interior and not jugadoresNotificados[player] then
        -- Calcular tiempo restante
        local tiempoTranscurrido = getTickCount() - tiempoDestruccion
        local tiempoRestante = tiempoRespawn - tiempoTranscurrido
        
        if tiempoRestante > 5000 then
            -- Crear temporizador visual para el nuevo jugador
            triggerClientEvent(player, "crearTemporizadorRespawn", player, puertaPos[1], puertaPos[2], puertaPos[3], tiempoRestante, dimension, interior)
            
            -- Notificar al jugador
            local minutos = math.floor(tiempoRestante / 60000)
            local segundos = math.floor((tiempoRestante % 60000) / 1000)
            outputChatBox("SISTEMA: La puerta fue destruida y se regenerara en " .. minutos .. " minutos y " .. segundos .. " segundos.", player, 0, 200, 255)
            
            jugadoresNotificados[player] = true
        end
    end
end

-- Función para responder a la solicitud del cliente
function enviarEstadoPuertaAlCliente()
    if puertaDestruida then
        local tiempoTranscurrido = getTickCount() - tiempoDestruccion
        local tiempoRestante = tiempoRespawn - tiempoTranscurrido
        
        if tiempoRestante > 5000 then
            triggerClientEvent(client, "crearTemporizadorRespawn", client, puertaPos[1], puertaPos[2], puertaPos[3], tiempoRestante, dimension, interior)
        end
    end
end
addEvent("solicitarEstadoPuerta", true)
addEventHandler("solicitarEstadoPuerta", root, enviarEstadoPuertaAlCliente)
