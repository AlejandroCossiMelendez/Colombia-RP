--[[
    Sistema de Control de Actos Ilegales - Servidor
    Autor: Puma
    Versión: 3.0
    Descripción: Control avanzado de permisos para actos ilegales
]]

-- Configuración del sistema
local CONFIG = {
    -- Facciones con permiso para cambiar el estado
    FACCIONES = {
        POLICIA = 1,
        SWAT = 10
    },
    -- Mensajes del sistema
    MENSAJES = {
        ACTIVADO = "Robos Activados | Actos Ilegales Activados",
        DESACTIVADO = "Actos Ilegales Suspendidos | Evita Ser Sancionado",
        SIN_PERMISO = "No eres miembro de la Policía",
        ESTADO_ACTUAL = "Estado actual de Actos: %s"
    },
    -- Tipos de notificaciones
    NOTIFICACION = {
        ACTIVADO = "info",
        DESACTIVADO = "danger"
    },
    -- Duración de notificaciones
    DURACION = 7
}

-- Estado global del sistema
local estadoActos = false
local ultimaNotificacion = 0

-- Funciones auxiliares
local function tienePermisoPolicia(jugador)
    if not isElement(jugador) then return false end
    
    return exports.factions:isPlayerInFaction(jugador, CONFIG.FACCIONES.POLICIA) or 
           exports.factions:isPlayerInFaction(jugador, CONFIG.FACCIONES.SWAT)

end

local function notificarATodos(mensaje, tipo, jugador)
    if not isElement(jugador) then return end
    
    -- Evitar notificaciones duplicadas usando un tiempo mínimo entre notificaciones
    local ahora = getTickCount()
    if ahora - ultimaNotificacion < 1000 then
        return false
    end
    
    local nombreJugador = getPlayerName(jugador) or "Desconocido"
    triggerClientEvent("dxInfoAddBox", root, mensaje, tipo, nombreJugador.." cambió el estado de Actos", CONFIG.DURACION)
    
    ultimaNotificacion = ahora
    return true
end

-- Comandos
addCommandHandler("actoson", function(jugador)
    if not tienePermisoPolicia(jugador) then
        outputChatBox(CONFIG.MENSAJES.SIN_PERMISO, jugador, 255, 0, 0)
        return false
    end
    
    -- Evitar actualizaciones innecesarias
    if estadoActos == true then
        return false
    end
    
    -- Actualizar estado
    estadoActos = true
    
    -- Sincronizar con todos los clientes
    triggerClientEvent("actos:actualizarEstado", root, estadoActos)
    
    -- Notificar
    notificarATodos(CONFIG.MENSAJES.ACTIVADO, CONFIG.NOTIFICACION.ACTIVADO, jugador)
end)

addCommandHandler("actosoff", function(jugador)
    if not tienePermisoPolicia(jugador) then
        outputChatBox(CONFIG.MENSAJES.SIN_PERMISO, jugador, 255, 0, 0)
        return false
    end
    
    -- Evitar actualizaciones innecesarias
    if estadoActos == false then
        return false
    end
    
    -- Actualizar estado
    estadoActos = false
    
    -- Sincronizar con todos los clientes
    triggerClientEvent("actos:actualizarEstado", root, estadoActos)
    
    -- Notificar
    notificarATodos(CONFIG.MENSAJES.DESACTIVADO, CONFIG.NOTIFICACION.DESACTIVADO, jugador)
end)

-- Comando para verificar estado
addCommandHandler("actosstatus", function(jugador)
    local estadoTexto = estadoActos and "ACTIVADOS" or "DESACTIVADOS"
    outputChatBox(string.format(CONFIG.MENSAJES.ESTADO_ACTUAL, estadoTexto), jugador, 255, 255, 0)
end)

-- Eventos
addEventHandler("onPlayerJoin", root, function()
    -- Sincronizar estado cuando un jugador se conecta
    triggerClientEvent(source, "actos:actualizarEstado", source, estadoActos)
    
    -- Segunda sincronización con retraso para asegurar que el cliente esté listo
    setTimer(function(jugador)
        if isElement(jugador) then
            triggerClientEvent(jugador, "actos:actualizarEstado", jugador, estadoActos)
        end
    end, 2000, 1, source)
end)

-- Evento para solicitar estado (desde el cliente)
addEvent("actos:solicitarEstado", true)
addEventHandler("actos:solicitarEstado", root, function()
    if isElement(client) then
        triggerClientEvent(client, "actos:actualizarEstado", client, estadoActos)
    end
end)

-- REEMPLAZAR los eventos antiguos (en lugar de mantener compatibilidad)
addEvent("ActosOnByPuma", true)
addEventHandler("ActosOnByPuma", root, function()
    if client and tienePermisoPolicia(client) then
        -- Solo actualizar el estado del cliente sin enviar notificación
        estadoActos = true
        triggerClientEvent("actos:actualizarEstado", root, estadoActos)
    end
end)

addEvent("ActosOffByPuma", true)
addEventHandler("ActosOffByPuma", root, function()
    if client and tienePermisoPolicia(client) then
        -- Solo actualizar el estado del cliente sin enviar notificación
        estadoActos = false
        triggerClientEvent("actos:actualizarEstado", root, estadoActos)
    end
end)

-- Funciones exportadas
function getActosState()
    return estadoActos
end