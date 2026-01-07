--[[
    Nametag Profesional para La Capital Roleplay
    Desarrollado para MTA San Andreas
    Características:
    - Muestra ID del jugador
    - Sistema /yo para rasgos físicos
    - Diseño profesional y moderno
    - Efectos visuales suaves
    - Compatible con sistema de máscaras y staff
]]

local sW, sH = guiGetScreenSize()
local escala = sW / 1920

-- Fuentes personalizadas Roboto (activadas)
local fuenteRobotoBold = dxCreateFont("fuentes/Roboto-Bold.ttf", 14 * escala)
local fuenteRobotoRegular = dxCreateFont("fuentes/Roboto-Regular.ttf", 12 * escala)

-- Fuentes con fallback a default si Roboto no carga
local fuentePrincipal = fuenteRobotoBold or "default-bold"
local fuenteSecundaria = fuenteRobotoRegular or "default"

-- Configuración visual
local CONFIG = {
    DISTANCIA_MAXIMA = 10,
    ALTURA_NOMBRE = 0.4,
    MOSTRAR_SALUD = true,
    EFECTOS_VISUALES = true
}

-- Colores del servidor "La Capital Roleplay"
local COLORES = {
    PRINCIPAL = {r = 41, g = 128, b = 185},      -- Azul profesional
    SECUNDARIO = {r = 52, g = 152, b = 219},     -- Azul claro
    ACENTO = {r = 230, g = 126, b = 34},         -- Naranja elegante
    TEXTO_PRINCIPAL = {r = 255, g = 255, b = 255}, -- Blanco
    TEXTO_SECUNDARIO = {r = 189, g = 195, b = 199}, -- Gris claro
    YO_COLOR = {r = 46, g = 204, b = 113},       -- Verde menta
    SALUD_BUENA = {r = 46, g = 204, b = 113},    -- Verde
    SALUD_MEDIA = {r = 241, g = 196, b = 15},    -- Amarillo
    SALUD_BAJA = {r = 231, g = 76, b = 60},      -- Rojo
    SOMBRA = {r = 0, g = 0, b = 0, a = 180},     -- Sombra suave
    FONDO = {r = 44, g = 62, b = 80, a = 200}    -- Fondo semi-transparente
}

-- Variables de control
local localPlayer = getLocalPlayer()
local mostrarNombres = false
local tiempoAnimacion = 0

-- Funciones de utilidad
function esStaff()
    return getElementData(localPlayer, "account:gmduty") or false
end

function obtenerColorSalud(salud)
    if salud >= 75 then
        return COLORES.SALUD_BUENA
    elseif salud >= 35 then
        return COLORES.SALUD_MEDIA
    else
        return COLORES.SALUD_BAJA
    end
end

-- Función eliminada - ya no usamos fondos

-- Función principal de renderizado
function dibujarNametags()
    if getElementData(localPlayer, 'JailOpen') then return end
    
    -- Control de visibilidad
    if not esStaff() and not mostrarNombres then return end
    
    tiempoAnimacion = tiempoAnimacion + 0.02
    local px, py, pz = getCameraMatrix()
    local tx, ty, tz = getElementPosition(localPlayer)
    local jugadores = getElementsByType('player')

    for _, jugador in ipairs(jugadores) do
        if isElement(jugador) and jugador ~= localPlayer then
            procesarJugador(jugador, px, py, pz, tx, ty, tz)
        end
    end
end

function procesarJugador(jugador, px, py, pz, tx, ty, tz)
    setPlayerNametagShowing(jugador, false)
    
    local jx, jy, jz = getElementPosition(jugador)
    local distancia = getDistanceBetweenPoints3D(tx, ty, tz, jx, jy, jz)
    
    if distancia <= CONFIG.DISTANCIA_MAXIMA then
        if isLineOfSightClear(px, py, pz, jx, jy, jz, true, false, false, true, false, false, false, localPlayer) then
            local sx, sy, sz = getPedBonePosition(jugador, 6)
            local x, y = getScreenFromWorldPosition(sx, sy, sz + CONFIG.ALTURA_NOMBRE)

            if x and y and not getElementData(jugador, "spec") then
                dibujarInformacionJugador(jugador, x, y, distancia)
            end
        end
    end
end

function dibujarInformacionJugador(jugador, x, y, distancia)
    -- Obtener datos del jugador
    local playerID = getElementData(jugador, "playerid") or "?"
    local yo = getElementData(jugador, "yo") or ""
    local esStaffEnServicio = getElementData(jugador, "account:gmduty")
    
    -- Calcular transparencia basada en distancia
    local alpha = math.max(0, 255 - (distancia * 25))
    
    -- Solo mostrar ID (usando tamaños del script original)
    local textoID = "[" .. playerID .. "]"
    
    -- Usar fuentes personalizadas si están disponibles
    local fuenteNombre = fuentePrincipal or "default"
    local fuenteYo = fuenteSecundaria or "default"
    
    -- Dibujar ID con sombra (usando posiciones del script original: y - 7)
    -- Sombra del ID
    dxDrawText(textoID, x, y - 7 + 2, x, y, 
        tocolor(0, 0, 0, 255), 1, fuenteNombre, "center", "center")
    
    -- Texto principal del ID
    local colorTexto = esStaffEnServicio and COLORES.ACENTO or COLORES.TEXTO_PRINCIPAL
    dxDrawText(textoID, x, y - 7, x, y, 
        tocolor(colorTexto.r, colorTexto.g, colorTexto.b, 255), 1, fuenteNombre, "center", "center")
    
    -- Indicador de staff simple (solo estrella, sin fondo)
    if esStaffEnServicio then
        local anchoID = dxGetTextWidth(textoID, 1, fuenteNombre)
        local staffX = x + (anchoID / 2) + 10
        dxDrawText("★", staffX + 1, y - 7 + 2, staffX + 1, y - 7 + 2, 
            tocolor(0, 0, 0, 255), 0.8, fuenteYo, "center", "center")
        dxDrawText("★", staffX, y - 7, staffX, y - 7, 
            tocolor(COLORES.ACENTO.r, COLORES.ACENTO.g, COLORES.ACENTO.b, 255), 
            0.8, fuenteYo, "center", "center")
    end
    
    -- Mostrar /yo sin fondo (usando posiciones del script original: y + 40)
    if yo and yo ~= "" then
        -- Sombra del /yo
        dxDrawText(yo, x, y + 40 + 2, x, y, 
            tocolor(0, 0, 0, 255), 0.85, fuenteYo, "center", "center")
        
        -- Texto del /yo
        dxDrawText(yo, x, y + 40, x, y, 
            tocolor(COLORES.YO_COLOR.r, COLORES.YO_COLOR.g, COLORES.YO_COLOR.b, 255), 
            0.85, fuenteYo, "center", "center")
    end
end

-- Inicialización del sistema
addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("§[La Capital Roleplay] §Sistema de nametags cargado correctamente.", 0, 255, 0)
    
    -- Verificar si las fuentes Roboto se cargaron
    if fuenteRobotoBold and fuenteRobotoRegular then
        outputChatBox("§[Fuentes] §Roboto cargada correctamente - Nametags con diseño profesional", 100, 255, 100)
    else
        outputChatBox("§[Fuentes] §Usando fuentes por defecto - Considera agregar Roboto para mejor apariencia", 255, 200, 100)
    end
    
    if esStaff() then
        addEventHandler("onClientRender", root, dibujarNametags)
        outputChatBox("§[Staff] §Nametags siempre visibles (Staff en servicio)", 255, 165, 0)
    else
        -- Bind para jugadores normales
        bindKey("N", "down", function() 
            mostrarNombres = true
            addEventHandler("onClientRender", root, dibujarNametags)
        end)
        bindKey("N", "up", function() 
            mostrarNombres = false
            removeEventHandler("onClientRender", root, dibujarNametags)
        end)
        outputChatBox("§[Info] §Mantén presionado 'N' para ver los nametags", 100, 200, 255)
    end
end)

-- Manejo de cambios en el estado de staff
addEventHandler("onClientElementDataChange", root, function(dataName)
    if dataName == "account:gmduty" and source == localPlayer then
        local enServicio = getElementData(localPlayer, "account:gmduty")
        if enServicio then
            mostrarNombres = true
            addEventHandler("onClientRender", root, dibujarNametags)
            unbindKey("N", "down")
            unbindKey("N", "up")
            outputChatBox("§[Staff] §Nametags activados permanentemente", 255, 165, 0)
        else
            mostrarNombres = false
            removeEventHandler("onClientRender", root, dibujarNametags)
            bindKey("N", "down", function() 
                mostrarNombres = true
                addEventHandler("onClientRender", root, dibujarNametags)
            end)
            bindKey("N", "up", function() 
                mostrarNombres = false
                removeEventHandler("onClientRender", root, dibujarNametags)
            end)
            outputChatBox("§[Info] §Usa 'N' para ver nametags", 100, 200, 255)
        end
    end
end)

-- Información en pantalla para /yo (sin fondo, estilo original)
addEventHandler("onClientRender", root, function()
    local yo = getElementData(localPlayer, "yo")
    if not yo or yo == "" then
        local info = "Características: Nada. (Usa /yo para asignar)"
        local infoY = sH - 42
        
        -- Sombra del texto (estilo original)
        dxDrawText(info, 43, infoY, sW, sH, 
            tocolor(0, 0, 0, 220), 1, "default")
        
        -- Texto principal
        dxDrawText(info, 43, infoY - 1, sW, sH, 
            tocolor(255, 255, 255, 255), 1, "default")
    end
end)
