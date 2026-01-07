--[[
    Sistema de Control de Actos Ilegales - Cliente
    Autor: Puma
    Versión: 3.0
    Descripción: Interfaz visual para el sistema de control de actos ilegales
]]

-- Configuración del sistema
local CONFIG = {
    -- Posición del indicador en pantalla (porcentaje)
    -- Modificado para colocar el indicador debajo del radar/minimapa
    POSICION = {
        X = 0.05, -- Posicionado en la esquina superior izquierda, debajo del radar
        Y = 0.95  -- Debajo del radar (el radar suele terminar alrededor de 0.30)
    },
    -- Textos del sistema
    TEXTO = {
        PREFIJO = "Robos: ",
        ESTADOS = {
            ACTIVADO = "ON",
            DESACTIVADO = "OFF",
            DESCONOCIDO = "N/A"
        }
    },
    -- Colores del sistema (R, G, B, A)
    COLORES = {
        ACTIVADO = {5, 255, 0, 255},      -- Verde brillante
        DESACTIVADO = {255, 0, 0, 255},   -- Rojo
        DESCONOCIDO = {255, 255, 255, 255}, -- Blanco
        CONTORNO = {0, 0, 0, 255},        -- Negro
        SOMBRA = {50, 50, 50, 255}        -- Gris oscuro
    },
    -- Estilo del texto
    ESTILO = {
        FUENTE = "arial",
        ESCALA = 1.20
    }
}

-- Variables locales
local screenW, screenH = guiGetScreenSize()
local estadoActos = nil -- nil = desconocido, true = activado, false = desactivado
local ultimaActualizacion = 0 -- Para evitar actualizaciones duplicadas

-- Función para crear color a partir de tabla
local function crearColor(colorTable)
    return tocolor(colorTable[1], colorTable[2], colorTable[3], colorTable[4])
end

-- Función para dibujar texto con efectos
local function dibujarTextoConEfectos(texto, x, y, escala, fuente, color)
    -- Contorno
    local colorContorno = crearColor(CONFIG.COLORES.CONTORNO)
    dxDrawText(texto, x - 1, y - 1, _, _, colorContorno, escala, fuente, "left", "top", false, false, false, false, false)
    dxDrawText(texto, x + 1, y - 1, _, _, colorContorno, escala, fuente, "left", "top", false, false, false, false, false)
    dxDrawText(texto, x - 1, y + 1, _, _, colorContorno, escala, fuente, "left", "top", false, false, false, false, false)
    dxDrawText(texto, x + 1, y + 1, _, _, colorContorno, escala, fuente, "left", "top", false, false, false, false, false)
    
    -- Sombra
    local colorSombra = crearColor(CONFIG.COLORES.SOMBRA)
    dxDrawText(texto, x + 2, y + 2, _, _, colorSombra, escala, fuente, "left", "top", false, false, false, false, false)
    
    -- Texto principal
    dxDrawText(texto, x, y, _, _, color, escala, fuente, "left", "top", false, false, false, false, false)
end

-- Función para actualizar el estado con protección contra duplicados
local function actualizarEstado(estado)
    local ahora = getTickCount()
    
    -- Evitar actualizaciones duplicadas en un corto período de tiempo
    if ahora - ultimaActualizacion < 500 then
        return
    end
    
    if estado ~= nil then
        estadoActos = estado
        ultimaActualizacion = ahora
    end
end

-- Renderizado del estado de Actos
addEventHandler("onClientRender", root, function()
    -- Determinar texto y color según estado
    local texto = CONFIG.TEXTO.PREFIJO
    local colorTabla
    
    if estadoActos == nil then
        texto = texto .. CONFIG.TEXTO.ESTADOS.DESCONOCIDO
        colorTabla = CONFIG.COLORES.DESCONOCIDO
    elseif estadoActos == true then
        texto = texto .. CONFIG.TEXTO.ESTADOS.ACTIVADO
        colorTabla = CONFIG.COLORES.ACTIVADO
    else -- estadoActos == false
        texto = texto .. CONFIG.TEXTO.ESTADOS.DESACTIVADO
        colorTabla = CONFIG.COLORES.DESACTIVADO
    end
    
    -- Posición y estilo
    local x, y = screenW * CONFIG.POSICION.X, screenH * CONFIG.POSICION.Y
    local color = crearColor(colorTabla)
    
    -- Dibujar indicador
    dibujarTextoConEfectos(texto, x, y, CONFIG.ESTILO.ESCALA, CONFIG.ESTILO.FUENTE, color)
end)

-- Eventos
addEvent("actos:actualizarEstado", true)
addEventHandler("actos:actualizarEstado", root, function(estado)
    actualizarEstado(estado)
end)

-- Mantener compatibilidad con eventos antiguos
addEvent("ActosOnByPuma", true)
addEventHandler("ActosOnByPuma", root, function()
    actualizarEstado(true)
end)

addEvent("ActosOffByPuma", true)
addEventHandler("ActosOffByPuma", root, function()
    actualizarEstado(false)
end)

-- Comando para verificar estado localmente
addCommandHandler("actosinfo", function()
    local estadoTexto = "DESCONOCIDO"
    if estadoActos == true then
        estadoTexto = "ACTIVADOS"
    elseif estadoActos == false then
        estadoTexto = "DESACTIVADOS"
    end
    
    outputChatBox("Estado actual de Actos: " .. estadoTexto, 255, 255, 0)
end)

-- Inicialización
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Solicitar estado actual al servidor
    triggerServerEvent("actos:solicitarEstado", localPlayer)
    
    -- Solicitar nuevamente después de un breve retraso (por si acaso)
    setTimer(function()
        triggerServerEvent("actos:solicitarEstado", localPlayer)
    end, 2000, 1)
end)