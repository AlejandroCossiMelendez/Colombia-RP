-- Sistema de Control de AK-47 - Servidor
-- Desarrollado por Puma, optimizado por Claude

-- Configuración
local CONFIG = {
    FACCIONES_PERMITIDAS = {1, 10}, -- IDs de facciones policiales (Policía y otra facción autorizada)
    MENSAJES = {
        ACTIVADO = "AK-47 Habilitada | Ahora Podrás Usarla Para Crímenes",
        DESACTIVADO = "AK-47 Suspendida | Evita Ser Sancionado",
        SIN_PERMISO = "No eres miembro de la Policía"
    },
    TIPOS_NOTIFICACION = {
        ACTIVADO = "info",
        DESACTIVADO = "danger"
    },
    SINCRONIZACION = 2000 -- Nuevo valor para la sincronización
}

-- Variable global para el estado (debe estar al inicio del archivo)
local estadoAK = false  -- Inicializado como desactivado por defecto

-- Funciones auxiliares
local function tienePermisoPolicia(jugador)
    if not isElement(jugador) then return false end
    
    for _, faccionID in ipairs(CONFIG.FACCIONES_PERMITIDAS) do
        if exports.factions:isPlayerInFaction(jugador, faccionID) then
            return true
        end
    end
    return false
end

local function notificarATodos(mensaje, tipo, jugador)
    if not isElement(jugador) then return end
    
    local nombreJugador = getPlayerName(jugador) or "Desconocido"
    triggerClientEvent("dxInfoAddBox", root, mensaje, tipo, nombreJugador.." cambió el estado de AK-47", 7)
end

local function actualizarEstadoAK(nuevoEstado, jugador)
    -- Actualizar estado
    estadoAK = nuevoEstado
    
    -- Sincronizar con todos los clientes
    triggerClientEvent("ak47:actualizarEstado", root, estadoAK)
    
    -- Notificar según el estado
    if estadoAK then
        notificarATodos(CONFIG.MENSAJES.ACTIVADO, CONFIG.TIPOS_NOTIFICACION.ACTIVADO, jugador)
    else
        notificarATodos(CONFIG.MENSAJES.DESACTIVADO, CONFIG.TIPOS_NOTIFICACION.DESACTIVADO, jugador)
    end
    
    return true
end

-- Comandos
addCommandHandler("akon", function(jugador)
    if not tienePermisoPolicia(jugador) then
        outputChatBox(CONFIG.MENSAJES.SIN_PERMISO, jugador, 255, 0, 0)
        return false
    end
    
    actualizarEstadoAK(true, jugador)
end)

addCommandHandler("akoff", function(jugador)
    if not tienePermisoPolicia(jugador) then
        outputChatBox(CONFIG.MENSAJES.SIN_PERMISO, jugador, 255, 0, 0)
        return false
    end
    
    actualizarEstadoAK(false, jugador)
end)

-- Eventos
addEventHandler("onPlayerJoin", root, function()
    -- Sincronizar estado inmediatamente y con un retraso para asegurar
    triggerClientEvent(source, "ak47:actualizarEstado", source, estadoAK)
    
    -- Segunda sincronización con retraso para asegurar que el cliente esté listo
    setTimer(function(jugador)
        if isElement(jugador) then
            triggerClientEvent(jugador, "ak47:actualizarEstado", jugador, estadoAK)
        end
    end, 2000, 1, source)
end)

addEvent("ak47:solicitarEstado", true)
addEventHandler("ak47:solicitarEstado", root, function()
    if isElement(client) then
        triggerClientEvent(client, "ak47:actualizarEstado", client, estadoAK)
    end
end)

-- Mantener compatibilidad con eventos antiguos
addEvent("ActosOnPuma", true)
addEventHandler("ActosOnPuma", root, function()
    if client and tienePermisoPolicia(client) then
        actualizarEstadoAK(true, client)
    end
end)

addEvent("ActosOffPuma", true)
addEventHandler("ActosOffPuma", root, function()
    if client and tienePermisoPolicia(client) then
        actualizarEstadoAK(false, client)
    end
end)

-- Funciones exportadas
function getAKState()
    return estadoAK
end