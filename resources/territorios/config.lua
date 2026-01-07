--[[
============================================
CONFIGURACIÓN SIMPLE - TERRITORIOS
============================================
Todas las configuraciones en un solo lugar
============================================
]]

-- ==========================================
-- CONFIGURACIÓN PRINCIPAL
-- ==========================================

-- Facciones que pueden participar (agregar más IDs aquí)
FACCIONES_ILEGALES = {5, 10, 11, 12, 13, 14, 15, 16}
-- CDM, RUSA, CDC, TRECE, MECAIL, ELN, CDJ, CDG

-- Configuración de batalla
JUGADORES_MIN_ONLINE = 3        -- Mínimo jugadores online para atacar
JUGADORES_MIN_ZONA = 3          -- Mínimo jugadores en zona para mantener
MAX_FACCIONES_POR_BATALLA = 4   -- Máximo facciones por territorio
TIEMPO_BATALLA_MULTIPLE = 900   -- 15 minutos para batallas múltiples
COOLDOWN_ATAQUE_SEGUNDOS = 1800 -- 30 minutos entre ataques

-- Configuración económica
SOLO_CON_JUGADORES_ONLINE = true  -- Solo generar dinero si hay jugadores online
INTERVALO_GANANCIAS_HORAS = 1     -- Cada cuántas horas generar dinero

-- Configuración del sistema
VERIFICAR_BATALLAS_SEGUNDOS = 10  -- Verificar batallas cada 10 segundos
REDUCIR_SPAM_CHAT = true          -- Menos mensajes en chat

-- ==========================================
-- COLORES EN RADAR (RGB)
-- ==========================================

COLORES_RADAR = {
    NEUTRAL = {100, 200, 255},    -- Azul claro para territorios libres
    ATAQUE_INDIVIDUAL = {255, 0, 0},      -- Rojo para 1 facción atacando
    BATALLA_MULTIPLE = {255, 255, 0},     -- Amarillo para múltiples facciones
    
    -- Colores por facción (cambiar aquí para personalizar)
    [5] = {150, 0, 150},   -- CDM - Morado
    [10] = {255, 140, 0},  -- RUSA - Naranja
    [11] = {0, 150, 150},  -- CDC - Turquesa
    [12] = {150, 150, 0},  -- TRECE - Amarillo oscuro
    [13] = {255, 0, 100},  -- MECAIL - Rosa
    [14] = {139, 69, 19},  -- ELN - Marrón
    [15] = {0, 100, 255},  -- CDJ - Azul
    [16] = {100, 255, 0},  -- CDG - Verde
}

-- ==========================================
-- CONFIGURACIÓN DE TERRITORIOS POR DEFECTO
-- ==========================================

-- Ganancias por defecto al crear territorios nuevos
GANANCIA_TERRITORIO_DEFAULT = 5000000  -- $5M por territorio base
TIEMPO_CONQUISTA_DEFAULT = 600         -- 10 minutos

-- Ganancias de negocios por tipo
GANANCIAS_NEGOCIOS = {
    comercio = 2000000,      -- $2M/hora
    industrial = 2500000,    -- $2.5M/hora
    financiero = 3000000,    -- $3M/hora
    turismo = 2000000,       -- $2M/hora
    servicio = 1800000,      -- $1.8M/hora
    especial = 2500000,      -- $2.5M/hora
}

-- ==========================================
-- FUNCIONES DE CONFIGURACIÓN
-- ==========================================

function obtenerConfiguracion()
    return {
        facciones = FACCIONES_ILEGALES,
        jugadores_min = JUGADORES_MIN_ONLINE,
        cooldown = COOLDOWN_ATAQUE_SEGUNDOS,
        ganancias_solo_online = SOLO_CON_JUGADORES_ONLINE,
        colores = COLORES_RADAR
    }
end

function esFactcionPermitida(factionID)
    for _, permitida in ipairs(FACCIONES_ILEGALES) do
        if factionID == permitida then return true end
    end
    return false
end

function obtenerColorFaccion(factionID)
    return COLORES_RADAR[factionID] or COLORES_RADAR.NEUTRAL
end

-- ==========================================
-- CONFIGURACIÓN PARA EXPANSION
-- ==========================================

--[[
PARA AGREGAR NUEVA FACCIÓN:
1. Agregar ID a FACCIONES_ILEGALES
2. Agregar color a COLORES_RADAR

PARA CAMBIAR GANANCIAS:
1. Modificar GANANCIA_TERRITORIO_DEFAULT
2. Modificar valores en GANANCIAS_NEGOCIOS

PARA CAMBIAR TIEMPOS:
1. Modificar TIEMPO_CONQUISTA_DEFAULT
2. Modificar TIEMPO_BATALLA_MULTIPLE

PARA CAMBIAR REQUISITOS:
1. Modificar JUGADORES_MIN_ONLINE
2. Modificar JUGADORES_MIN_ZONA
]]
