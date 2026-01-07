--[[
============================================
SISTEMA DE TERRITORIOS - CLIENTE
============================================
Maneja radar y efectos visuales
============================================
]]

-- ==========================================
-- CONFIGURACIÓN CLIENTE
-- ==========================================

-- Colores por facción (fácil modificar)
local COLORES = {
    NEUTRAL = {100, 200, 255},    -- Azul claro
    ATAQUE = {255, 0, 0},         -- Rojo
    MULTIPLE = {255, 255, 0},     -- Amarillo
    
    -- Facciones ilegales
    [5] = {150, 0, 150},   -- CDM - Morado
    [10] = {255, 140, 0},  -- RUSA - Naranja
    [11] = {0, 150, 150},  -- CDC - Turquesa
    [12] = {150, 150, 0},  -- TRECE - Amarillo
    [13] = {255, 0, 100},  -- MECAIL - Rosa
    [14] = {139, 69, 19},  -- ELN - Marrón
    [15] = {0, 100, 255},  -- CDJ - Azul
    [16] = {100, 255, 0},  -- CDG - Verde
}

-- Variables
local territorios = {}
local radarAreas = {}

-- ==========================================
-- FUNCIONES DE RADAR
-- ==========================================

function crearZonaRadar(territID, color, parpadeo)
    if radarAreas[territID] and isElement(radarAreas[territID]) then
        destroyElement(radarAreas[territID])
    end
    
    local territorio = territorios[territID]
    if not territorio then return end
    
    local area = createRadarArea(territorio.x1, territorio.y1, 
                                territorio.x2 - territorio.x1, 
                                territorio.y2 - territorio.y1, 
                                color[1], color[2], color[3], 120)
    
    if area then
        radarAreas[territID] = area
        setRadarAreaFlashing(area, parpadeo or false)
    end
end

function actualizarZona(territID, tipo, faction)
    local color = COLORES.NEUTRAL
    local parpadeo = false
    
    if tipo == "neutral" then
        color = COLORES.NEUTRAL
    elseif tipo == "rojo" then
        color = COLORES.ATAQUE
        parpadeo = true
    elseif tipo == "amarillo" then
        color = COLORES.MULTIPLE
        parpadeo = true
    elseif tipo == "conquistado" and faction then
        color = COLORES[faction] or COLORES.NEUTRAL
    elseif tipo == "restaurado" and faction then
        color = COLORES[faction] or COLORES.NEUTRAL
    end
    
    crearZonaRadar(territID, color, parpadeo)
end

-- ==========================================
-- EVENTOS DE RED
-- ==========================================

addEvent("territorios:sync", true)
addEventHandler("territorios:sync", resourceRoot, function(territoriosData)
    territorios = territoriosData
    
    -- Limpiar áreas anteriores
    for territID, area in pairs(radarAreas) do
        if isElement(area) then destroyElement(area) end
    end
    radarAreas = {}
    
    -- Crear todas las zonas
    for territID, territorio in pairs(territorios) do
        if territorio.enAtaque then
            actualizarZona(territID, "rojo")
        elseif territorio.factionID then
            actualizarZona(territID, "conquistado", territorio.factionID)
        else
            actualizarZona(territID, "neutral")
        end
    end
end)

addEvent("territorios:rojo", true)
addEventHandler("territorios:rojo", resourceRoot, function(territID)
    actualizarZona(territID, "rojo")
end)

addEvent("territorios:amarillo", true)
addEventHandler("territorios:amarillo", resourceRoot, function(territID)
    actualizarZona(territID, "amarillo")
end)

addEvent("territorios:conquistado", true)
addEventHandler("territorios:conquistado", resourceRoot, function(territID, faction)
    actualizarZona(territID, "conquistado", faction)
end)

addEvent("territorios:neutral", true)
addEventHandler("territorios:neutral", resourceRoot, function(territID)
    actualizarZona(territID, "neutral")
end)

addEvent("territorios:restaurado", true)
addEventHandler("territorios:restaurado", resourceRoot, function(territID, faction)
    actualizarZona(territID, "restaurado", faction)
end)

-- ==========================================
-- INICIALIZACIÓN Y LIMPIEZA
-- ==========================================

addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        if territorios and next(territorios) then
            for territID, territorio in pairs(territorios) do
                if territorio.factionID then
                    actualizarZona(territID, "conquistado", territorio.factionID)
                else
                    actualizarZona(territID, "neutral")
                end
            end
        end
    end, 3000, 1)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for territID, area in pairs(radarAreas) do
        if isElement(area) then destroyElement(area) end
    end
end)
