--[[
    Archivo de Configuración - La Capital Roleplay Nametags
    Modifica estos valores para personalizar el sistema según tus necesidades
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN VISUAL
-- ═══════════════════════════════════════════════════════════════════════════════

-- Distancias y posicionamiento
NAMETAG_CONFIG = {
    DISTANCIA_MAXIMA = 10,           -- Distancia máxima para ver nametags (metros)
    ALTURA_NOMBRE = 0.4,             -- Altura del nametag sobre la cabeza del jugador
    MOSTRAR_SALUD = true,            -- Mostrar barra de salud cuando esté herido
    EFECTOS_VISUALES = true,         -- Activar efectos visuales (brillos, animaciones)
    TECLA_MOSTRAR = "N"              -- Tecla para mostrar nametags (jugadores normales)
}

-- Colores del servidor (La Capital Roleplay)
COLORES_SERVIDOR = {
    -- Colores principales del servidor
    PRINCIPAL = {r = 41, g = 128, b = 185},      -- Azul profesional
    SECUNDARIO = {r = 52, g = 152, b = 219},     -- Azul claro
    ACENTO = {r = 230, g = 126, b = 34},         -- Naranja elegante
    
    -- Colores de texto
    TEXTO_PRINCIPAL = {r = 255, g = 255, b = 255},   -- Blanco
    TEXTO_SECUNDARIO = {r = 189, g = 195, b = 199},  -- Gris claro
    
    -- Colores de estado
    YO_COLOR = {r = 46, g = 204, b = 113},       -- Verde menta para /yo
    SALUD_BUENA = {r = 46, g = 204, b = 113},    -- Verde para salud alta
    SALUD_MEDIA = {r = 241, g = 196, b = 15},    -- Amarillo para salud media
    SALUD_BAJA = {r = 231, g = 76, b = 60},      -- Rojo para salud baja
    
    -- Colores de interfaz
    SOMBRA = {r = 0, g = 0, b = 0, a = 180},     -- Sombra suave
    FONDO = {r = 44, g = 62, b = 80, a = 200}    -- Fondo semi-transparente
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DEL SISTEMA /YO
-- ═══════════════════════════════════════════════════════════════════════════════

YO_CONFIG = {
    MAX_LONGITUD = 100,              -- Máximo de caracteres permitidos
    MIN_LONGITUD = 5,                -- Mínimo de caracteres requeridos
    COOLDOWN_TIEMPO = 3000,          -- Tiempo de espera entre usos (milisegundos)
    
    -- Palabras prohibidas en las descripciones /yo
    PALABRAS_PROHIBIDAS = {
        "admin", "staff", "moderador", "helper", "gm", "gamemaster",
        "hack", "cheat", "bug", "exploit", "script", "mod", "owner",
        "developer", "dev", "administrador", "mod", "moderator"
    },
    
    -- Configuración de persistencia
    GUARDAR_EN_DB = false,           -- Guardar /yo en base de datos (requiere implementación)
    RESETEAR_AL_DESCONECTAR = true   -- Limpiar /yo al desconectarse
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE PERMISOS
-- ═══════════════════════════════════════════════════════════════════════════════

PERMISOS_CONFIG = {
    -- Elemento de datos para detectar staff en servicio
    STAFF_DATA = "account:gmduty",
    
    -- Elemento de datos para ID del jugador
    PLAYER_ID_DATA = "playerid",
    
    -- Elemento de datos para máscaras/cascos
    MASCARA_DATA = "mascara",
    CASCO_DATA = "Cascos",
    
    -- Comandos disponibles para diferentes grupos
    COMANDOS_STAFF = {
        "veryo"                      -- Solo staff puede ver /yo de otros
    }
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN DE MENSAJES
-- ═══════════════════════════════════════════════════════════════════════════════

MENSAJES = {
    -- Prefijos de chat
    PREFIX_ERROR = "§[Error] §",
    PREFIX_INFO = "§[Info] §",
    PREFIX_YO = "§[/yo] §",
    PREFIX_STAFF = "§[Staff] §",
    PREFIX_SISTEMA = "§[Sistema] §",
    
    -- Mensajes del sistema
    NAMETAGS_CARGADOS = "Nametags de La Capital Roleplay cargados. Usa /infoyo para más información.",
    STAFF_NAMETAGS_ACTIVOS = "Nametags siempre visibles (Staff en servicio)",
    USAR_TECLA_INFO = "Mantén presionado '" .. (NAMETAG_CONFIG.TECLA_MOSTRAR or "N") .. "' para ver los nametags",
    
    -- Mensajes de /yo
    YO_ESTABLECIDO = "Características físicas establecidas: ",
    YO_ELIMINADO = "Características físicas eliminadas.",
    YO_SIN_DESCRIPCION = "Ninguna descripción establecida",
    YO_ACTUAL = "Actual: ",
    
    -- Mensajes de error
    ERROR_NO_LOGUEADO = "Debes estar logueado para usar este comando.",
    ERROR_SIN_PERMISOS = "No tienes permisos para usar este comando.",
    ERROR_JUGADOR_NO_ENCONTRADO = "Jugador no encontrado.",
    ERROR_COOLDOWN = "Debes esperar %d segundos antes de usar /yo nuevamente.",
    ERROR_TEXTO_CORTO = "La descripción debe tener al menos %d caracteres.",
    ERROR_TEXTO_LARGO = "La descripción no puede exceder %d caracteres.",
    ERROR_PALABRAS_PROHIBIDAS = "El texto contiene palabras no permitidas."
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONFIGURACIÓN AVANZADA
-- ═══════════════════════════════════════════════════════════════════════════════

AVANZADO_CONFIG = {
    -- Optimización de rendimiento
    CACHE_JUGADORES = true,          -- Usar cache para datos de jugadores
    LIMITE_FPS = 60,                 -- Límite de FPS para efectos visuales
    
    -- Logging y debugging
    LOG_COMANDOS_YO = true,          -- Registrar uso de comandos /yo en logs
    NOTIFICAR_STAFF_YO = true,       -- Notificar a staff cuando alguien usa /yo
    DEBUG_MODE = false,              -- Activar mensajes de debug
    
    -- Compatibilidad
    COMPATIBLE_DOWNTOWN = true,      -- Compatibilidad con Downtown GM
    USAR_FUENTES_CUSTOM = false,     -- Usar fuentes personalizadas (requiere archivos)
    
    -- Efectos visuales avanzados
    ANIMACION_RESPIRACION = 0.1,     -- Intensidad del efecto de respiración
    VELOCIDAD_BRILLO = 0.002,        -- Velocidad de animación de brillos
    TRANSPARENCIA_DISTANCIA = true   -- Transparencia basada en distancia
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- FUNCIONES DE CONFIGURACIÓN
-- ═══════════════════════════════════════════════════════════════════════════════

-- Función para obtener configuración
function obtenerConfig(seccion, clave)
    local secciones = {
        nametag = NAMETAG_CONFIG,
        colores = COLORES_SERVIDOR,
        yo = YO_CONFIG,
        permisos = PERMISOS_CONFIG,
        mensajes = MENSAJES,
        avanzado = AVANZADO_CONFIG
    }
    
    if secciones[seccion] and secciones[seccion][clave] then
        return secciones[seccion][clave]
    end
    
    return nil
end

-- Función para validar configuración
function validarConfiguracion()
    local errores = {}
    
    -- Validar distancia máxima
    if NAMETAG_CONFIG.DISTANCIA_MAXIMA < 1 or NAMETAG_CONFIG.DISTANCIA_MAXIMA > 50 then
        table.insert(errores, "DISTANCIA_MAXIMA debe estar entre 1 y 50")
    end
    
    -- Validar longitudes de /yo
    if YO_CONFIG.MIN_LONGITUD >= YO_CONFIG.MAX_LONGITUD then
        table.insert(errores, "MIN_LONGITUD debe ser menor que MAX_LONGITUD")
    end
    
    -- Validar cooldown
    if YO_CONFIG.COOLDOWN_TIEMPO < 1000 then
        table.insert(errores, "COOLDOWN_TIEMPO debe ser al menos 1000ms")
    end
    
    return #errores == 0, errores
end

-- Exportar configuración para uso en otros archivos
if not getResourceRootElement then
    -- Estamos en el servidor
    _G.NAMETAG_CONFIG = NAMETAG_CONFIG
    _G.COLORES_SERVIDOR = COLORES_SERVIDOR
    _G.YO_CONFIG = YO_CONFIG
    _G.PERMISOS_CONFIG = PERMISOS_CONFIG
    _G.MENSAJES = MENSAJES
    _G.AVANZADO_CONFIG = AVANZADO_CONFIG
end
