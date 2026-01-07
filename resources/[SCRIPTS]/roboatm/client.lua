-- Primero, registramos los eventos al inicio del archivo
addEvent("minijuego", true)
addEvent("minijuegoTerminal", true)
addEvent("progressBar", true)
addEvent("createFireEffect", true)
addEvent("eliminarFireEffect", true)
addEvent("mostrarTemporizadorAvanzado", true)
addEvent("eliminarTemporizador", true)

local screenW, screenH = guiGetScreenSize()
local juegoActivo = false
local cables = {}
local cableSeleccionado = nil
local resultado = {}

-- 🇨🇴 COLORES ELÉCTRICOS COLOMBIANOS REALISTAS 🇨🇴
local colores = {
    tocolor(220, 38, 127),   -- Magenta vibrante (cable de alta tensión)
    tocolor(255, 220, 0),    -- Amarillo bandera Colombia (cable neutro)
    tocolor(200, 16, 46),    -- Rojo bandera Colombia (cable positivo)
    tocolor(0, 150, 255),    -- Azul bandera Colombia (cable negativo)
    tocolor(0, 200, 83),     -- Verde colombiano (cable tierra)
    tocolor(255, 140, 0)     -- Naranja cálido (cable de señal)
}

-- Nombres de cables en español colombiano
local nombresCables = {
    "FASE PRINCIPAL",
    "NEUTRO SEGURO", 
    "POSITIVO +12V",
    "NEGATIVO MASA",
    "TIERRA FÍSICA",
    "SEÑAL CONTROL"
}

-- Posiciones aleatorias de los conectores
local conectoresIzq = {}
local conectoresDer = {}

-- Sonidos
local sonidoExito = "correcto.mp3"
local sonidoError = "incorrecto.mp3"

-- ====================================
-- 🔥 SISTEMA HACKER TERMINAL ÉPICO 🔥
-- ====================================

-- Variables del terminal
local terminalActivo = false
local terminalLineas = {}
local comandoActual = ""
local cursorVisible = true
local tiempoRespuesta = 0
local etapaHacking = 1
local maxEtapas = 5
local sistemaDeteccion = 0
local maxDeteccion = 100
local hackingCompletado = false

-- ========================================
-- 🎨 CONFIGURACIÓN VISUAL HD ÉPICA 🎨
-- ========================================

-- Configuración visual del terminal HD OPTIMIZADA
local terminalConfig = {
    width = screenW * 0.85,  -- Ligeramente más ancho para mejor aprovechamiento
    height = screenH * 0.85, -- Ligeramente más alto
    x = screenW * 0.075,     -- Centrado mejorado
    y = screenH * 0.075,     -- Centrado mejorado
    backgroundColor = tocolor(0, 0, 0, 245),    -- Más opaco para mejor contraste
    borderColor = tocolor(0, 255, 0, 255),
    textColor = tocolor(0, 255, 0, 255),
    cursorColor = tocolor(0, 255, 0, 200),
    
    -- 🚀 CONFIGURACIÓN HD RESPONSIVA BALANCEADA
    fontSize = math.max(1.0, screenH / 900),     -- Escalado más conservador
    titleFontSize = math.max(1.2, screenH / 800), -- Títulos balanceados
    headerFontSize = math.max(1.0, screenH / 1000), -- Headers más pequeños
    
    lineHeight = math.max(22, screenH / 40),     -- Espaciado dinámico para mejor legibilidad
    padding = math.max(18, screenW / 80),        -- Padding responsivo
    maxLines = math.floor(screenH / 45),         -- Líneas dinámicas según resolución
    
    -- 🎯 FUENTES PERSONALIZADAS HD (se cargan dinámicamente)
    mainFont = nil,          -- Se cargará una fuente personalizada
    titleFont = nil,         -- Se cargará una fuente personalizada
    codeFont = nil,          -- Se cargará una fuente personalizada
    
    -- Fuentes de fallback (built-in de MTA)
    fallbackMainFont = "default-bold",
    fallbackTitleFont = "bankgothic", 
    fallbackCodeFont = "console",
    
    -- 🌈 COLORES HD MEJORADOS
    successColor = tocolor(50, 255, 50, 255),    -- Verde más vibrante
    warningColor = tocolor(255, 200, 0, 255),    -- Amarillo más claro
    errorColor = tocolor(255, 80, 80, 255),      -- Rojo más suave pero visible
    infoColor = tocolor(100, 200, 255, 255),     -- Azul información más claro
    highlightColor = tocolor(255, 255, 255, 255) -- Blanco puro para destacar
}

-- Variables de caché para optimización
local lastBorderGlow = 0
local cachedGlowColor = tocolor(0, 255, 0, 255)
local lastGlowUpdate = 0
local glowUpdateInterval = 100 -- Actualizar brillo cada 100ms
local efectosMatrixDeshabilitados = false

-- ==========================================
-- 🎨 SISTEMA DE FUENTES PERSONALIZADAS HD 🎨  
-- ==========================================

-- Configuración de fuentes personalizadas
local fontConfig = {
    -- 📁 RUTAS DE FUENTES (coloca tus archivos .ttf aquí)
    paths = {
        main = "fonts/Roboto-Medium.ttf",        -- Fuente principal (legible y moderna)
        title = "fonts/Orbitron-Bold.ttf",       -- Fuente para títulos (futurista)
        code = "fonts/JetBrainsMono-Regular.ttf" -- Fuente monospace para código
    },
    
    -- 📏 TAMAÑOS DINÁMICOS (se calculan según resolución)
    sizes = {
        small = 0,   -- Se calculará dinámicamente
        medium = 0,  -- Se calculará dinámicamente  
        large = 0,   -- Se calculará dinámicamente
        xlarge = 0   -- Se calculará dinámicamente
    },
    
    -- 💾 CACHE DE FUENTES (para evitar recargas)
    cache = {
        main = {},
        title = {},
        code = {}
    },
    
    -- 🔄 ESTADO DE CARGA
    loaded = false,
    fallbackMode = false
}

-- Función para calcular tamaños de fuente dinámicos BALANCEADOS
local function calcularTamanosFuente()
    local baseSize = math.max(10, screenH / 80)  -- Tamaño base más conservador
    
    fontConfig.sizes.small = math.floor(baseSize * 0.8)   -- ~8-12px
    fontConfig.sizes.medium = math.floor(baseSize)        -- ~10-15px  
    fontConfig.sizes.large = math.floor(baseSize * 1.2)   -- ~12-18px
    fontConfig.sizes.xlarge = math.floor(baseSize * 1.4)  -- ~14-21px
end

-- Función para cargar fuente personalizada con cache
local function cargarFuentePersonalizada(tipo, tamano)
    if not fontConfig.cache[tipo] then
        fontConfig.cache[tipo] = {}
    end
    
    local cacheKey = tamano
    if fontConfig.cache[tipo][cacheKey] then
        return fontConfig.cache[tipo][cacheKey] -- Ya está en cache
    end
    
    local ruta = fontConfig.paths[tipo]
    if fileExists(ruta) then
        local font = dxCreateFont(ruta, tamano, false, "antialiased")
        if font then
            fontConfig.cache[tipo][cacheKey] = font
            return font
        end
    end
    
    return false -- No se pudo cargar
end

-- Función para obtener fuente (con fallback automático)
local function obtenerFuente(tipo, tamano)
    if not fontConfig.fallbackMode then
        local customFont = cargarFuentePersonalizada(tipo, tamano)
        if customFont then
            return customFont
        end
    end
    
    -- Usar fuente de fallback
    local fallbackMap = {
        main = terminalConfig.fallbackMainFont,
        title = terminalConfig.fallbackTitleFont, 
        code = terminalConfig.fallbackCodeFont
    }
    
    return fallbackMap[tipo] or "default"
end

-- Función para inicializar sistema de fuentes
local function inicializarSistemaFuentes()
    calcularTamanosFuente()
    
    local fuentesDisponibles = 0
    local fuentesTotales = 3
    
    -- Verificar disponibilidad de fuentes
    for tipo, ruta in pairs(fontConfig.paths) do
        if fileExists(ruta) then
            fuentesDisponibles = fuentesDisponibles + 1
        end
    end
    
    if fuentesDisponibles == 0 then
        fontConfig.fallbackMode = true
    end
    
    -- Actualizar configuraciones del terminal con las fuentes correctas
    terminalConfig.mainFont = obtenerFuente("main", fontConfig.sizes.medium)
    terminalConfig.titleFont = obtenerFuente("title", fontConfig.sizes.xlarge)  
    terminalConfig.codeFont = obtenerFuente("code", fontConfig.sizes.medium)
    
    fontConfig.loaded = true
end

-- Base de comandos épicos de hacking con sistema mejorado
local comandosHacking = {
    [1] = {
        descripcion = "🔍 ESCANEANDO RED DEL CAJERO...",
        titulo = "ESCANEO DE RED",
        comando = "1",
        respuesta = {
            ">>> Iniciando protocolo de escaneo...",
            ">>> Detectando dispositivos en red 192.168.1.0...",
            "    [ENCONTRADO] 192.168.1.1 - ROUTER_PRINCIPAL",
            "    [ENCONTRADO] 192.168.1.45 - ATM_CORE_SYSTEM", 
            "    [ENCONTRADO] 192.168.1.46 - SECURITY_CAMERA",
            "    [ENCONTRADO] 192.168.1.47 - ALARM_MODULE",
            ">>> Mapeando puertos y servicios...",
            "✓ ESCANEO COMPLETO - 4 dispositivos identificados"
        },
        tiempo = 3000
    },
    [2] = {
        descripcion = "🛡️ DESACTIVANDO CORTAFUEGOS...",
        titulo = "BYPASS DE FIREWALL",
        comando = "2",
        respuesta = {
            ">>> Analizando reglas del cortafuegos...",
            "    REGLA #001: BLOCK ALL - Puerto 22 [SSH]",
            "    REGLA #002: BLOCK ALL - Puerto 23 [TELNET]",
            "    REGLA #003: ALLOW - Puerto 80 [HTTP]",
            ">>> Inyectando payload de evasión...",
            ">>> Creando túnel cifrado...",
            ">>> Escalando privilegios de red...",
            "✓ CORTAFUEGOS DESACTIVADO - Acceso total obtenido"
        },
        tiempo = 4000
    },
    [3] = {
        descripcion = "🔓 CRACKEANDO AUTENTICACIÓN...",
        titulo = "ROMPER CONTRASEÑAS",
        comando = "3",
        respuesta = {
            ">>> Iniciando ataque de fuerza bruta...",
            ">>> Cargando diccionario: rockyou.txt",
            "    Probando: admin123... [FALLIDO]",
            "    Probando: password... [FALLIDO]",
            "    Probando: 123456789... [FALLIDO]",
            "    Probando: BANK_SECURE_2024... [ÉXITO!]",
            ">>> Hash MD5 descifrado exitosamente",
            "✓ ACCESO ADMINISTRATIVO CONCEDIDO"
        },
        tiempo = 5000
    },
    [4] = {
        descripcion = "💰 INFILTRANDO CAJA FUERTE...",
        titulo = "ACCESO A BÓVEDA",
        comando = "4",
        respuesta = {
            ">>> Conectando con módulo de dispensación...",
            ">>> Verificando inventario de billetes...",
            "    DISPONIBLE: $1,247,350 en efectivo",
            "    BILLETES DE $100: 8,947 unidades",
            "    BILLETES DE $50: 4,521 unidades",
            ">>> Deshabilitando sensores de cantidad...",
            ">>> Configurando dispensación silenciosa...",
            "✓ BÓVEDA COMPROMETIDA - Lista para extracción"
        },
        tiempo = 4000
    },
    [5] = {
        descripcion = "🚨 ELIMINANDO RASTROS...",
        titulo = "BORRADO DE EVIDENCIAS",
        comando = "5",
        respuesta = {
            ">>> Accediendo a logs del sistema...",
            ">>> Sobrescribiendo registros de transacciones...",
            ">>> Eliminando grabaciones de cámaras...",
            ">>> Limpiando caché de red...",
            ">>> Insertando entradas falsas en bitácora...",
            ">>> Restableciendo contadores a valores normales...",
            "✓ EVIDENCIAS ELIMINADAS - Sistema limpio"
        },
        tiempo = 3000
    }
}

-- Efectos Matrix OPTIMIZADOS (menos gotas, mejor rendimiento)
local matrixChars = {"0", "1", "ア", "カ", "サ", "タ", "ナ", "ハ"}
local matrixDrops = {}
local lastMatrixUpdate = 0
local matrixUpdateInterval = 50 -- Actualizar cada 50ms en lugar de cada frame

-- Inicializar gotas Matrix (REDUCIDAS para mejor FPS)
for i = 1, 12 do  -- Reducido de 50 a 12 gotas
    matrixDrops[i] = {
        x = math.random(0, screenW),
        y = math.random(-screenH, 0),
        speed = math.random(3, 6),  -- Velocidad más consistente
        char = matrixChars[math.random(1, #matrixChars)],
        alpha = math.random(100, 255)  -- Alpha mínimo más alto
    }
end

-- ===============================================
-- 🇨🇴 CONFIGURACIÓN ESTILO COLOMBIANO ÉPICO 🇨🇴
-- ===============================================

-- ========================================
-- 🇨🇴 CONFIGURACIÓN CABLES HD COLOMBIANA 🇨🇴
-- ========================================

-- Configuración del panel COLOMBIANO HD optimizado
local panelConfig = {
    width = screenW * 0.75,        -- Más ancho para aprovechar HD
    height = screenH * 0.75,       -- Más alto para mejor experiencia
    x = screenW * 0.125,           -- Centrado perfecto
    y = screenH * 0.125,           -- Centrado perfecto
    
    -- 🇨🇴 COLORES COLOMBIANOS HD ÉPICOS
    backgroundColor = tocolor(25, 25, 45, 240),     -- Azul oscuro más sólido
    borderColor = tocolor(255, 220, 0, 255),        -- Amarillo bandera Colombia
    accentColor = tocolor(200, 16, 46, 255),        -- Rojo bandera Colombia
    successColor = tocolor(0, 220, 100, 255),       -- Verde éxito más vibrante
    dangerColor = tocolor(220, 38, 127, 255),       -- Magenta peligro
    
    title = "🔌 SISTEMA DE CONEXIONES ELÉCTRICAS HD - CAJERO BANCOLOMBIA",
    titleColor = tocolor(255, 255, 255, 255),
    subtitleColor = tocolor(255, 220, 0, 220),      -- Amarillo más visible
    
    -- 🎨 CONFIGURACIONES HD RESPONSIVAS BALANCEADAS
    titleHeight = math.max(35, screenH * 0.04),     -- Títulos balanceados
    fontSize = math.max(1.0, screenH / 800),        -- Escalado más conservador
    headerFontSize = math.max(1.1, screenH / 700),  -- Headers balanceados
    labelFontSize = math.max(0.9, screenH / 900),   -- Labels más pequeños
    
    -- 🎯 FUENTES HD PARA CABLES
    titleFont = "bankgothic",        -- Títulos épicos
    headerFont = "default-bold",     -- Headers claros
    labelFont = "default-bold",      -- Labels legibles
    
    -- 🇨🇴 CONFIGURACIONES COLOMBIANAS HD
    headerGradient = true,
    electricEffects = false,         -- Desactivado por defecto para rendimiento
    colombianStyle = true,
    hdMode = true                    -- Nueva bandera HD
}

-- Variables de efectos eléctricos ULTRA-OPTIMIZADOS
local electricSparks = {}
local lastSparkUpdate = 0
local sparkUpdateInterval = 200  -- AUMENTADO: Cada 200ms para mejor FPS
local connectionPulse = 0
local lastPulseUpdate = 0
local efectosElectricosHabilitados = false  -- DESACTIVADOS por defecto para mejor FPS

-- Función para generar posiciones aleatorias
local function generarPosiciones()
    -- Calcular posiciones dentro del panel
    local panelContentX = panelConfig.x + 40
    local panelContentWidth = panelConfig.width - 80
    local panelContentY = panelConfig.y + panelConfig.titleHeight + 20
    local panelContentHeight = panelConfig.height - panelConfig.titleHeight - 40
    
    local startX = panelContentX
    local endX = panelContentX + panelContentWidth - 30
    local startY = panelContentY
    local spacing = panelContentHeight / (#colores + 1)  -- Espacio entre conectores

    conectoresIzq = {}
    conectoresDer = {}

    -- Crear conectores izquierdos
    for i = 1, #colores do
        local xIzq = startX
        local yIzq = startY + i * spacing
        conectoresIzq[i] = {x = xIzq, y = yIzq, color = colores[i]}
    end
    
    -- Crear array de índices para los conectores derechos
    local indices = {}
    for i = 1, #colores do
        indices[i] = i
    end
    
    -- Mezclar los índices hasta que ninguno esté en su posición original
    local mezclaValida = false
    while not mezclaValida do
        -- Mezclar índices
        for i = #indices, 2, -1 do
            local j = math.random(1, i)
            indices[i], indices[j] = indices[j], indices[i]
        end
        
        -- Verificar que ningún índice esté en su posición original
        mezclaValida = true
        for i = 1, #indices do
            if indices[i] == i then
                mezclaValida = false
                break
            end
        end
    end
    
    -- Crear conectores derechos con el orden mezclado
    for i = 1, #colores do
        local xDer = endX
        local yDer = startY + i * spacing
        local colorIndex = indices[i]
        conectoresDer[i] = {x = xDer, y = yDer, color = colores[colorIndex]}
    end
end

-- ========================================================
-- 🔌 FUNCIONES DE EFECTOS ELÉCTRICOS COLOMBIANOS 🔌
-- ========================================================

-- Función ULTRA-SIMPLIFICADA para mejor FPS
function dibujarConectorElectrico(x, y, r, color, tipo, nombre)
    -- Solo el fondo básico - SIN efectos pesados
    dxDrawRectangle(x - r - 2, y - r - 2, (r + 2) * 2, (r + 2) * 2, tocolor(60, 60, 60, 180))
    
    -- Conector principal - SIN múltiples círculos
    dxDrawCircle(x, y, r, color, true)
    
    -- Etiqueta simplificada - SIN efectos
    if nombre and efectosElectricosHabilitados then
        -- 🏷️ ETIQUETA HD DEL CABLE CON MEJOR FUENTE
        local labelY = y + r + 8  -- Más espacio
        dxDrawText(nombre, x - 45, labelY, x + 45, labelY + 18, 
                  panelConfig.titleColor, panelConfig.labelFontSize, panelConfig.labelFont, "center", "center")
    end
end

-- Función para dibujar un círculo OPTIMIZADA
function dxDrawCircle(x, y, r, color, filled)
    local segments = filled and 16 or 12  -- Menos segmentos para mejor FPS
    local step = math.pi * 2 / segments
    for i = 0, segments do
        local angle1 = i * step
        local angle2 = (i + 1) * step
        local x1, y1 = x + math.cos(angle1) * r, y + math.sin(angle1) * r
        local x2, y2 = x + math.cos(angle2) * r, y + math.sin(angle2) * r
        dxDrawLine(x1, y1, x2, y2, color, filled and 3 or 2)
        if filled then
            dxDrawLine(x, y, x1, y1, color, 1)
        end
    end
end

-- Función ULTRA-LIGERA para crear chispas (solo si está habilitado)
function crearChispaElectrica(x, y)
    if not efectosElectricosHabilitados then return end -- Skip si deshabilitado
    
    local currentTime = getTickCount()
    if currentTime - lastSparkUpdate > sparkUpdateInterval and #electricSparks < 3 then -- Reducido a máximo 3
        table.insert(electricSparks, {
            x = x + math.random(-5, 5),  -- Rango reducido
            y = y + math.random(-5, 5),
            life = 400,  -- Vida fija más corta
            created = currentTime,
            size = 2  -- Tamaño fijo para optimización
        })
        lastSparkUpdate = currentTime
    end
end

-- Función OPTIMIZADA para dibujar efectos eléctricos
function dibujarEfectosElectricos()
    if not efectosElectricosHabilitados then return end -- Skip si deshabilitado
    
    local currentTime = getTickCount()
    
    -- Actualizar chispas (muy simple)
    for i = #electricSparks, 1, -1 do
        local spark = electricSparks[i]
        if currentTime - spark.created > spark.life then
            table.remove(electricSparks, i)
        else
            -- Dibujar chispa simple - SIN cálculos complejos
            local sparkColor = tocolor(255, 255, 100, 200)
            dxDrawRectangle(spark.x, spark.y, spark.size, spark.size, sparkColor) -- Rectángulo en lugar de círculo
        end
    end
    
    -- Actualizar pulso (menos frecuente)
    if currentTime - lastPulseUpdate > 300 then  -- Cada 300ms en lugar de 100ms
        connectionPulse = (connectionPulse + 1) % 360
        lastPulseUpdate = currentTime
    end
end

-- Función SIMPLIFICADA para cables (SIN efectos pesados)
function dibujarCableElectrico(x1, y1, x2, y2, color, grosor, conectado)
    if conectado and efectosElectricosHabilitados then
        -- Cable conectado CON efectos (solo si están habilitados)
        local pulse = connectionPulse > 180 and 30 or 0  -- Pulso simple
        local r, g, b, a = color.r or 255, color.g or 255, color.b or 255, 255
        local pulsedColor = tocolor(math.min(255, r + pulse), math.min(255, g + pulse), math.min(255, b + pulse), a)
        
        dxDrawLine(x1, y1, x2, y2, pulsedColor, grosor)
        
        -- Crear chispas MUY raramente
        if math.random(1, 50) == 1 then
            crearChispaElectrica((x1 + x2) / 2, (y1 + y2) / 2)
        end
    else
        -- Cable normal (sin efectos)
        dxDrawLine(x1, y1, x2, y2, color, grosor)
    end
end

-- =======================================================
-- 🇨🇴 MINIJUEGO DE CABLES ESTILO COLOMBIANO ÉPICO 🇨🇴
-- =======================================================

-- MINIJUEGO ULTRA-OPTIMIZADO para mejor FPS y funcionalidad
function dibujarMinijuego()
    -- FONDO PRINCIPAL simple
    dxDrawRectangle(panelConfig.x, panelConfig.y, panelConfig.width, panelConfig.height, panelConfig.backgroundColor)
    
    -- HEADER SIMPLIFICADO (solo si efectos están habilitados)
    local headerHeight = panelConfig.titleHeight
    if efectosElectricosHabilitados then
        dxDrawRectangle(panelConfig.x, panelConfig.y, panelConfig.width, headerHeight * 0.4, panelConfig.borderColor)
        dxDrawRectangle(panelConfig.x, panelConfig.y + headerHeight * 0.4, panelConfig.width, headerHeight * 0.6, tocolor(0, 150, 255, 255))
    else
        -- Header simple sin gradientes
        dxDrawRectangle(panelConfig.x, panelConfig.y, panelConfig.width, headerHeight, panelConfig.borderColor)
    end
    
    -- BORDE SIMPLE (sin efectos de brillo para mejor FPS)
    local borderThickness = 2
    local borderColor = panelConfig.borderColor
    dxDrawLine(panelConfig.x - 1, panelConfig.y - 1, panelConfig.x + panelConfig.width + 1, panelConfig.y - 1, borderColor, borderThickness)
    dxDrawLine(panelConfig.x - 1, panelConfig.y - 1, panelConfig.x - 1, panelConfig.y + panelConfig.height + 1, borderColor, borderThickness)
    dxDrawLine(panelConfig.x + panelConfig.width + 1, panelConfig.y - 1, panelConfig.x + panelConfig.width + 1, panelConfig.y + panelConfig.height + 1, borderColor, borderThickness)
    dxDrawLine(panelConfig.x - 1, panelConfig.y + panelConfig.height + 1, panelConfig.x + panelConfig.width + 1, panelConfig.y + panelConfig.height + 1, borderColor, borderThickness)
    
    -- 🏛️ TÍTULO HD ÉPICO CON FUENTE MEJORADA
    local titulo = panelConfig.hdMode and panelConfig.title or "🔌 SISTEMA DE CONEXIONES ELÉCTRICAS HD"
    dxDrawText(titulo, panelConfig.x + 10, panelConfig.y + 8, 
               panelConfig.x + panelConfig.width - 10, panelConfig.y + headerHeight - 8, 
               panelConfig.titleColor, panelConfig.headerFontSize, panelConfig.titleFont, "center", "center")
    
    -- 📋 INSTRUCCIONES HD MÁS CLARAS Y LEGIBLES
    local instruccion = "⚡ Conecta los cables del mismo color arrastrando con el mouse ⚡"
    dxDrawText(instruccion, panelConfig.x + 15, panelConfig.y + headerHeight + 8, 
               panelConfig.x + panelConfig.width - 15, panelConfig.y + headerHeight + 28, 
               panelConfig.subtitleColor, panelConfig.labelFontSize, panelConfig.headerFont, "center", "center")
    
    -- TAMAÑO de conectores optimizado
    local connectorSize = math.max(10, screenW / 180)  -- Más pequeños para mejor rendimiento
    
    -- EFECTOS ELÉCTRICOS (solo si están habilitados)
    dibujarEfectosElectricos()
    
    -- CONECTORES IZQUIERDOS con fondo básico
    for i, conector in ipairs(conectoresIzq) do
        local boxSize = connectorSize * 2.5
        dxDrawRectangle(conector.x - boxSize/2, conector.y - boxSize/2, boxSize, boxSize, tocolor(20, 20, 20, 160))
        dibujarConectorElectrico(conector.x, conector.y, connectorSize, conector.color, "entrada", 
                               efectosElectricosHabilitados and nombresCables[i] or nil)
    end

    -- CONECTORES DERECHOS con fondo básico
    for i, conector in ipairs(conectoresDer) do
        local boxSize = connectorSize * 2.5
        dxDrawRectangle(conector.x - boxSize/2, conector.y - boxSize/2, boxSize, boxSize, tocolor(20, 20, 20, 160))
        
        -- Encontrar índice del color
        local colorIndex = 1
        for j, color in ipairs(colores) do
            if color == conector.color then
                colorIndex = j
                break
            end
        end
        dibujarConectorElectrico(conector.x, conector.y, connectorSize, conector.color, "salida",
                               efectosElectricosHabilitados and nombresCables[colorIndex] or nil)
    end

    -- CABLES CONECTADOS (simplificados)
    local cableThickness = math.max(3, screenW / 400)
    for _, cable in ipairs(cables) do
        if cable.origen and cable.destino then
            dibujarCableElectrico(cable.origen.x, cable.origen.y, cable.destino.x, cable.destino.y, cable.color, cableThickness, true)
        end
    end

    -- CABLE EN ARRASTRE (simplificado, SIN efectos pesados)
    if cableSeleccionado then
        local mouseX, mouseY = getCursorPosition()
        if mouseX and mouseY then
            mouseX, mouseY = mouseX * screenW, mouseY * screenH
            dibujarCableElectrico(cableSeleccionado.x, cableSeleccionado.y, mouseX, mouseY, cableSeleccionado.color, cableThickness, false)
        end
    end
    
    -- INFORMACIÓN DEL PROGRESO
    local progreso = #cables .. "/" .. #colores .. " CONEXIONES"
    local progressColor = #cables == #colores and tocolor(0, 255, 0, 255) or tocolor(255, 255, 255, 200)
    
    dxDrawText(progreso, panelConfig.x, panelConfig.y + panelConfig.height - 30, 
               panelConfig.x + panelConfig.width, panelConfig.y + panelConfig.height - 10, 
               progressColor, panelConfig.fontSize * 0.8, "default-bold", "center", "center")
    
    -- MENSAJE MOTIVACIONAL (solo si efectos habilitados)
    if efectosElectricosHabilitados and #cables > 0 and #cables < #colores then
        local mensajes = {"¡Venga!", "¡Dale!", "¡Así va!", "¡Éxito!"}
        local mensaje = mensajes[math.min(#cables, #mensajes)]
        dxDrawText(mensaje, panelConfig.x, panelConfig.y + panelConfig.height - 10, 
                   panelConfig.x + panelConfig.width, panelConfig.y + panelConfig.height, 
                   tocolor(255, 220, 0, 180), panelConfig.fontSize * 0.6, "default", "center", "center")
    end
end

-- Detectar clics para conectar los cables con área de detección adaptativa
function manejarClic(button, state, x, y)
    if not juegoActivo then return end
    
    -- Verificar si el clic está dentro del panel
    if x < panelConfig.x or x > panelConfig.x + panelConfig.width or 
       y < panelConfig.y or y > panelConfig.y + panelConfig.height then
        return
    end
    
    -- Calcular radio de detección adaptativo
    local detectionRadius = math.max(15, screenW / 128)  -- Radio mínimo 15px o adaptativo
    
    if button == "left" and state == "down" then
        -- Verificar si ya hay un cable seleccionado
        if cableSeleccionado then return end
        
        for _, conector in ipairs(conectoresIzq) do
            if getDistanceBetweenPoints2D(x, y, conector.x, conector.y) < detectionRadius then
                -- Verificar si este conector ya está conectado
                local yaConectado = false
                for _, cable in ipairs(cables) do
                    if cable.origen == conector then
                        yaConectado = true
                        break
                    end
                end
                
                if not yaConectado then
                    cableSeleccionado = conector
                    return
                end
            end
        end
    elseif button == "left" and state == "up" then
        if cableSeleccionado then
            for _, conector in ipairs(conectoresDer) do
                if getDistanceBetweenPoints2D(x, y, conector.x, conector.y) < detectionRadius then
                    -- Verificar si este conector ya está conectado
                    local yaConectado = false
                    for _, cable in ipairs(cables) do
                        if cable.destino == conector then
                            yaConectado = true
                            break
                        end
                    end
                    
                    if not yaConectado then
                        if cableSeleccionado.color == conector.color then
                            table.insert(resultado, true)
                            table.insert(cables, {origen = cableSeleccionado, destino = conector, color = cableSeleccionado.color})
                            playSound(sonidoExito)
                            
                            -- MENSAJES COLOMBIANOS SIMPLIFICADOS
                            if efectosElectricosHabilitados then
                                local mensajesExito = {
                                    "✅ ¡Esa sí quedó bacana, parcero!",
                                    "⚡ ¡Conexión perfecta!",
                                    "✅ ¡Dale que vas re bien!",
                                    "🔌 ¡Circuito activado!"
                                }
                                local mensajeExito = mensajesExito[math.random(1, #mensajesExito)]
                                outputChatBox(mensajeExito, 0, 255, 100)
                                -- Solo crear chispa si efectos están habilitados
                                crearChispaElectrica(conector.x, conector.y)
                            else
                                outputChatBox("✅ ¡Conexión correcta!", 0, 255, 0)
                            end
                            
                        else
                            playSound(sonidoError)
                            
                            -- MENSAJES DE ERROR SIMPLIFICADOS
                            if efectosElectricosHabilitados then
                                local mensajesError = {
                                    "❌ ¡Ese cable no va ahí, parce!",
                                    "⚠️ ¡Conexión incorrecta!",
                                    "❌ ¡Revisa los colores!"
                                }
                                local mensajeError = mensajesError[math.random(1, #mensajesError)]
                                outputChatBox(mensajeError, 255, 100, 100)
                            else
                                outputChatBox("❌ ¡Cable incorrecto!", 255, 0, 0)
                            end
                        end

                        -- Verificar si todos los cables están conectados correctamente
                        if #cables == #colores then
                            -- CELEBRACIÓN SIMPLIFICADA
                            if efectosElectricosHabilitados then
                                outputChatBox("🎉 ¡HERMANO, LO LOGRASTE! ¡Sistema activado! 🎉", 255, 255, 0)
                                outputChatBox("⚡ ¡Todos los circuitos funcionando! ¡Crack!", 0, 255, 255)
                                
                                -- Solo 2 chispas de celebración (mucho menos pesado)
                                setTimer(function()
                                    crearChispaElectrica(panelConfig.x + panelConfig.width/2, panelConfig.y + panelConfig.height/2)
                                    crearChispaElectrica(panelConfig.x + panelConfig.width/3, panelConfig.y + panelConfig.height/3)
                                end, 500, 1)
                            else
                                outputChatBox("🎉 ¡Minijuego completado exitosamente!", 0, 255, 0)
                                outputChatBox("⚡ ¡Todos los cables conectados correctamente!", 0, 255, 255)
                            end
                            
                            finalizarMinijuego()
                        end
                    end
                    
                    cableSeleccionado = nil
                    return
                end
            end

            cableSeleccionado = nil
        end
    end
end

-- 🇨🇴 FINALIZAR MINIJUEGO ULTRA-OPTIMIZADO 🇨🇴
function finalizarMinijuego()
    juegoActivo = false
    removeEventHandler("onClientRender", root, dibujarMinijuego)
    removeEventHandler("onClientClick", root, manejarClic)
    
    -- OCULTAR cursor para evitar problemas
    showCursor(false)
    
    -- LIMPIAR todos los efectos eléctricos
    electricSparks = {}
    connectionPulse = 0
    

    
    -- Notificar al servidor que el minijuego ha sido completado
    triggerServerEvent("minijuegoCompletado", localPlayer)
end

-- ===============================================
-- 🚀 FUNCIONES DEL TERMINAL HACKER ÉPICO 🚀
-- ===============================================

-- Función para dibujar efectos Matrix de fondo OPTIMIZADA
function dibujarMatrixEffect()
    local currentTime = getTickCount()
    
    -- Solo actualizar posiciones cada cierto intervalo para mejor FPS
    if currentTime - lastMatrixUpdate > matrixUpdateInterval then
        for i, drop in ipairs(matrixDrops) do
            -- Actualizar posición
            drop.y = drop.y + drop.speed
            drop.alpha = drop.alpha - 3  -- Desvanecimiento más rápido
            
            -- Resetear cuando sale de pantalla o se desvanece
            if drop.y > screenH or drop.alpha <= 50 then
                drop.y = math.random(-100, -20)
                drop.x = math.random(50, screenW - 50)  -- Evitar bordes
                drop.alpha = math.random(150, 255)  -- Alpha más alto
                drop.char = matrixChars[math.random(1, #matrixChars)]
            end
        end
        lastMatrixUpdate = currentTime
    end
    
    -- Dibujar las gotas (esto sí se hace cada frame pero es más ligero)
    for i, drop in ipairs(matrixDrops) do
        if drop.alpha > 50 then  -- Solo dibujar si es visible
            dxDrawText(drop.char, drop.x, drop.y, drop.x + 15, drop.y + 15, 
                       tocolor(0, 255, 0, drop.alpha), 0.7, "default-bold", 
                       "left", "top", false, false, false, false, false)
        end
    end
end

-- Función Matrix optimizada con opción de desactivación
function dibujarMatrixOptimizado()
    if efectosMatrixDeshabilitados then return end -- Skip si está desactivado
    dibujarMatrixEffect()
end

-- Función para agregar línea al terminal con efecto de escritura
function agregarLineaTerminal(texto, color, esComando)
    color = color or terminalConfig.textColor
    local nuevaLinea = {
        texto = texto,
        color = color,
        timestamp = getTickCount(),
        esComando = esComando or false,
        escribiendose = true,
        caracteresVisibles = 0,
        textoCompleto = texto
    }
    
    table.insert(terminalLineas, nuevaLinea)
    
    -- Limitar número de líneas
    if #terminalLineas > terminalConfig.maxLines then
        table.remove(terminalLineas, 1)
    end
    
    -- Efecto de sonido de escritura
    if esComando then
        playSound("https://www.soundjay.com/misc/sounds/typewriter-key-1.wav", false)
    end
end

-- Función para mostrar texto de forma progresiva
function actualizarEscritura()
    for i, linea in ipairs(terminalLineas) do
        if linea.escribiendose then
            local tiempoTranscurrido = getTickCount() - linea.timestamp
            local velocidadEscritura = 50 -- ms por carácter
            
            linea.caracteresVisibles = math.min(
                math.floor(tiempoTranscurrido / velocidadEscritura),
                #linea.textoCompleto
            )
            
            linea.texto = string.sub(linea.textoCompleto, 1, linea.caracteresVisibles)
            
            if linea.caracteresVisibles >= #linea.textoCompleto then
                linea.escribiendose = false
            end
        end
    end
end

-- Función principal para dibujar el terminal épico OPTIMIZADA
function dibujarTerminalHacker()
    -- Fondo Matrix épico (ya optimizado + opción de desactivación)
    dibujarMatrixOptimizado()
    
    -- Fondo del terminal
    dxDrawRectangle(terminalConfig.x, terminalConfig.y, 
                    terminalConfig.width, terminalConfig.height, 
                    terminalConfig.backgroundColor)
    
    -- BORDE OPTIMIZADO - Solo actualizar brillo cada 100ms
    local currentTime = getTickCount()
    if currentTime - lastGlowUpdate > glowUpdateInterval then
        lastBorderGlow = math.sin(currentTime / 500) * 50 + 205
        cachedGlowColor = tocolor(0, lastBorderGlow, 0, 255)
        lastGlowUpdate = currentTime
    end
    
    -- Borde simple pero efectivo (menos líneas para mejor FPS)
    local thickness = 2
    dxDrawLine(terminalConfig.x - thickness, terminalConfig.y - thickness, 
              terminalConfig.x + terminalConfig.width + thickness, terminalConfig.y - thickness, 
              cachedGlowColor, thickness)
    dxDrawLine(terminalConfig.x - thickness, terminalConfig.y - thickness, 
              terminalConfig.x - thickness, terminalConfig.y + terminalConfig.height + thickness, 
              cachedGlowColor, thickness)
    dxDrawLine(terminalConfig.x + terminalConfig.width + thickness, terminalConfig.y - thickness, 
              terminalConfig.x + terminalConfig.width + thickness, terminalConfig.y + terminalConfig.height + thickness, 
              cachedGlowColor, thickness)
    dxDrawLine(terminalConfig.x - thickness, terminalConfig.y + terminalConfig.height + thickness, 
              terminalConfig.x + terminalConfig.width + thickness, terminalConfig.y + terminalConfig.height + thickness, 
              cachedGlowColor, thickness)
    
    -- Header épico del terminal (SIMPLIFICADO)
    local headerHeight = 35  -- Reducido
    dxDrawRectangle(terminalConfig.x, terminalConfig.y, 
                    terminalConfig.width, headerHeight, 
                    tocolor(0, 40, 0, 180))  -- Menos opaco
    
    -- 🎨 TÍTULO HD ÉPICO CON MEJOR FUENTE
    local tituloTerminal = "💻 CYBER-BREACH TERMINAL v3.0 HD"
    dxDrawText(tituloTerminal, 
              terminalConfig.x + terminalConfig.padding, terminalConfig.y + 5, 
              terminalConfig.x + terminalConfig.width - terminalConfig.padding, terminalConfig.y + headerHeight, 
              terminalConfig.highlightColor, terminalConfig.titleFontSize, terminalConfig.titleFont, "center", "center")  -- Centrado y más grande
    
    -- 🔍 INFORMACIÓN HD DEL SISTEMA DE SEGURIDAD 
    local statusText = sistemaDeteccion > 75 and "🚨 CRÍTICO" or "✅ STEALTH"
    local statusColor = sistemaDeteccion > 75 and terminalConfig.errorColor or terminalConfig.successColor
    
    local infoSeguridad = string.format("🛡️ SEGURIDAD: %d%% | 📊 ETAPA: %d/%d | %s", 
                                       sistemaDeteccion, etapaHacking, maxEtapas, statusText)
    dxDrawText(infoSeguridad, 
              terminalConfig.x + terminalConfig.padding, terminalConfig.y + headerHeight + 5, 
              terminalConfig.x + terminalConfig.width - terminalConfig.padding, terminalConfig.y + headerHeight + 25, 
              statusColor, terminalConfig.headerFontSize, terminalConfig.mainFont, "center", "center")  -- Centrado y más legible
    
    -- Actualizar efectos de escritura
    actualizarEscritura()
    
    -- 📝 DIBUJAR LÍNEAS DEL TERMINAL EN HD SÚPER CLARO
    local startY = terminalConfig.y + headerHeight + 35  -- Más espacio para el header mejorado
    for i, linea in ipairs(terminalLineas) do
        local y = startY + (i - 1) * terminalConfig.lineHeight
        
        -- Solo dibujar si la línea está visible en pantalla
        if y >= terminalConfig.y and y <= terminalConfig.y + terminalConfig.height - 100 then
            -- 🎨 COLORES HD MEJORADOS SEGÚN TIPO
            local textColor = linea.color
            local font = terminalConfig.mainFont
            local fontSize = terminalConfig.fontSize
            
            -- Tipo de línea específico para mejor legibilidad
            if linea.esComando then
                textColor = terminalConfig.infoColor  -- Azul para comandos
                font = terminalConfig.codeFont         -- Fuente monospace para código
                fontSize = terminalConfig.fontSize * 1.1  -- Ligeramente más grande para comandos
                
                -- Efecto de glitch MÍNIMO para no afectar FPS
                if math.random(1, 2000) < 1 then  -- 0.05% chance
                    textColor = terminalConfig.errorColor -- Glitch rojo muy ocasional
                end
            end
            
            -- 🎯 RENDERIZADO HD OPTIMIZADO CON ANTIALIASING
            dxDrawText(linea.texto, 
                      terminalConfig.x + terminalConfig.padding, y,
                      terminalConfig.x + terminalConfig.width - terminalConfig.padding, y + terminalConfig.lineHeight,
                      textColor, fontSize, font, "left", "center")
        end
    end
    
    -- Área de opciones OPTIMIZADA (menos efectos costosos)
    local opcionesY = terminalConfig.y + terminalConfig.height - 110  -- Reducido
    
    -- Mostrar opciones disponibles con formato optimizado
    if comandosHacking[etapaHacking] then
        -- Fondo para las opciones (más simple)
        dxDrawRectangle(terminalConfig.x + 10, opcionesY - 8, 
                        terminalConfig.width - 20, 90,  -- Reducido
                        tocolor(0, 40, 0, 120))  -- Menos opaco
        
        -- 🎮 TÍTULO DE OPCIONES HD MÁS CLARO
        dxDrawText("🎯 SELECCIONA OPCIÓN (PRESIONA NÚMERO 1-5):", 
                  terminalConfig.x + terminalConfig.padding, opcionesY - 5,
                  terminalConfig.x + terminalConfig.width - terminalConfig.padding, opcionesY + 20,
                  terminalConfig.warningColor, terminalConfig.headerFontSize, terminalConfig.mainFont, "center", "center")
        
        -- Mostrar todas las opciones (EFECTO PULSACIÓN CACHEADO)
        local yOffset = 20  -- Reducido
        for i = 1, maxEtapas do
            local color, texto, prefijo
            
            if i < etapaHacking then
                -- Etapa completada
                color = tocolor(0, 200, 0, 180)
                prefijo = "✓"
                texto = comandosHacking[i].titulo .. " [OK]"
            elseif i == etapaHacking then
                -- Etapa actual (pulsación CACHEADA para mejor FPS)
                local pulso = lastBorderGlow > 180 and 255 or 150  -- Usar el brillo cacheado
                color = tocolor(255, pulso, 0, 255)
                prefijo = "►"
                texto = comandosHacking[i].titulo .. " [PULSA " .. i .. "]"
            else
                -- Etapa pendiente
                color = tocolor(120, 120, 120, 150)
                prefijo = "◯"
                texto = "?????????  [BLOQUEADO]"
            end
            
            dxDrawText(prefijo .. " [" .. i .. "] " .. texto, 
                      terminalConfig.x + terminalConfig.padding, opcionesY + yOffset,
                      terminalConfig.x + terminalConfig.width - terminalConfig.padding, opcionesY + yOffset + 13,
                      color, 0.75, "default", "left", "center")  -- Default font más rápido
            
            yOffset = yOffset + 14  -- Reducido
        end
    end
    
    -- Barra de progreso de detección
    local barraWidth = terminalConfig.width - 40
    local barraHeight = 10
    local barraX = terminalConfig.x + 20
    local barraY = terminalConfig.y + terminalConfig.height - 25
    
    -- Fondo de la barra
    dxDrawRectangle(barraX, barraY, barraWidth, barraHeight, tocolor(50, 50, 50, 200))
    
    -- Barra de progreso de detección
    local porcentajeDeteccion = sistemaDeteccion / maxDeteccion
    local colorBarra = tocolor(
        math.min(255, sistemaDeteccion * 2.55),
        math.max(0, 255 - sistemaDeteccion * 2.55),
        0, 200
    )
    
    if porcentajeDeteccion > 0 then
        dxDrawRectangle(barraX, barraY, barraWidth * porcentajeDeteccion, barraHeight, colorBarra)
    end
    
    -- Texto de la barra
    dxDrawText("DETECTION PROBABILITY", 
              barraX, barraY - 15, barraX + barraWidth, barraY,
              tocolor(200, 200, 200, 255), 0.7, "default", "center", "center")
end

-- Función para procesar opción seleccionada (mucho más fácil)
function procesarOpcionTerminal(opcion)
    if not comandosHacking[etapaHacking] then
        return false
    end
    
    local opcionEsperada = comandosHacking[etapaHacking].comando
    
    -- Agregar la opción al terminal con mejor formato
    agregarLineaTerminal(">>> OPCIÓN SELECCIONADA: [" .. opcion .. "] " .. comandosHacking[etapaHacking].titulo, tocolor(0, 255, 255, 255), true)
    
    -- Verificar si la opción es correcta
    if opcion == opcionEsperada then
        -- Comando correcto
        playSound(sonidoExito)
        
        -- Mostrar descripción de la etapa
        agregarLineaTerminal("", tocolor(0, 255, 0, 255))
        agregarLineaTerminal(">>> " .. comandosHacking[etapaHacking].descripcion, tocolor(0, 255, 255, 255))
        agregarLineaTerminal("", tocolor(0, 255, 0, 255))
        
        -- Simular respuesta del sistema después de un delay
        setTimer(function()
            for _, respuesta in ipairs(comandosHacking[etapaHacking].respuesta) do
                setTimer(function()
                    agregarLineaTerminal(respuesta, tocolor(0, 255, 0, 255))
                end, _ * 200, 1) -- Delay progresivo para cada línea
            end
            
            -- Avanzar a la siguiente etapa después de mostrar todas las respuestas
            setTimer(function()
                etapaHacking = etapaHacking + 1
                
                -- Verificar si se completaron todas las etapas
                if etapaHacking > maxEtapas then
                    completarHackingTerminal()
                else
                    -- Preparar siguiente etapa
                    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
                    agregarLineaTerminal("=== ETAPA " .. etapaHacking .. " DE " .. maxEtapas .. " ===", tocolor(255, 255, 0, 255))
                    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
                    
                    -- Aumentar ligeramente la detección
                    sistemaDeteccion = sistemaDeteccion + math.random(5, 15)
                    
                    -- Efectos de alerta si la detección es alta
                    if sistemaDeteccion > 60 then
                        agregarLineaTerminal("⚠️ ADVERTENCIA: Sistema de seguridad activándose...", tocolor(255, 165, 0, 255))
                    end
                    
                    if sistemaDeteccion > 85 then
                        agregarLineaTerminal("🚨 ALERTA CRÍTICA: Detección inmiente, acelerar proceso!", tocolor(255, 0, 0, 255))
                    end
                end
            end, #comandosHacking[etapaHacking].respuesta * 200 + 500, 1)
            
        end, 800, 1)
        
        return true
    else
        -- Opción incorrecta
        playSound(sonidoError)
        agregarLineaTerminal("❌ ERROR: Opción inválida para esta etapa", tocolor(255, 100, 100, 255))
        agregarLineaTerminal("🚨 SISTEMAS DE SEGURIDAD DETECTARON LA INTRUSIÓN", tocolor(255, 0, 0, 255))
        agregarLineaTerminal("⚠️ Nivel de detección aumentado significativamente", tocolor(255, 165, 0, 255))
        
        -- Aumentar significativamente la detección por error
        sistemaDeteccion = sistemaDeteccion + math.random(15, 25)
        
        -- Verificar si se alcanzó el límite de detección
        if sistemaDeteccion >= maxDeteccion then
            fallarHackingTerminal()
        end
        
        return false
    end
end

-- Función para completar el hacking exitosamente
function completarHackingTerminal()
    hackingCompletado = true
    
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("🎉 ======= HACKING COMPLETADO EXITOSAMENTE ======= 🎉", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("💰 Acceso total al sistema ATM obtenido", tocolor(255, 255, 0, 255))
    agregarLineaTerminal("🔓 Procediendo con la extracción física...", tocolor(0, 255, 255, 255))
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    
    -- Efectos visuales de éxito
    for i = 1, 5 do
        setTimer(function()
            -- Efecto de parpadeo verde
            for j, linea in ipairs(terminalLineas) do
                if math.random(1, 3) == 1 then
                    linea.color = tocolor(0, 255, 0, 255)
                end
            end
        end, i * 200, 1)
    end
    
    -- Finalizar el terminal después de 3 segundos
    setTimer(function()
        finalizarTerminalHacker()
        -- Notificar al servidor que el hacking fue completado
        triggerServerEvent("hackingCompletado", localPlayer)
    end, 3000, 1)
end

-- Función para fallar el hacking
function fallarHackingTerminal()
    agregarLineaTerminal("", tocolor(255, 0, 0, 255))
    agregarLineaTerminal("🚨 === SISTEMA DE SEGURIDAD ACTIVADO === 🚨", tocolor(255, 0, 0, 255))
    agregarLineaTerminal("❌ Acceso denegado - Alertando autoridades...", tocolor(255, 0, 0, 255))
    agregarLineaTerminal("🚔 Coordenadas transmitidas a la policía", tocolor(255, 0, 0, 255))
    agregarLineaTerminal("💀 MISIÓN FALLIDA - Abortar inmediatamente", tocolor(255, 0, 0, 255))
    
    -- Efectos visuales de fallo
    for i = 1, 10 do
        setTimer(function()
            -- Efecto de parpadeo rojo
            for j, linea in ipairs(terminalLineas) do
                if math.random(1, 2) == 1 then
                    linea.color = tocolor(255, 0, 0, 255)
                end
            end
        end, i * 100, 1)
    end
    
    -- Finalizar el terminal después de 2 segundos
    setTimer(function()
        finalizarTerminalHacker()
        -- Notificar al servidor que el hacking falló
        triggerServerEvent("hackingFallado", localPlayer)
    end, 2000, 1)
end

-- Función para finalizar el terminal hacker (con restauración completa)
function finalizarTerminalHacker()
    if not terminalActivo then return end -- Evitar doble ejecución
    
    terminalActivo = false
    
    -- 🔓 RESTAURACIÓN COMPLETA Y SEGURA DE CONTROLES
    
    -- 1. Remover TODOS los event handlers correctos
    removeEventHandler("onClientRender", root, dibujarTerminalHacker)
    removeEventHandler("onClientKey", root, bloquearTeclasMTA)
    removeEventHandler("onClientKey", root, manejarNumeroTerminal)
    
    -- 2. RESTAURAR FUNCIONALIDAD COMPLETA DE MTA
    showChat(true)     -- Restaurar chat
    showCursor(false)  -- Asegurar que el cursor esté oculto
    
    -- 3. FORZAR DESBLOQUEADO DE CONTROLES (por si acaso)
    setTimer(function()
        showChat(true)  -- Segunda verificación del chat
    end, 100, 1)
    
    -- 4. Limpiar todas las variables
    terminalLineas = {}
    comandoActual = ""
    etapaHacking = 1
    sistemaDeteccion = 0
    hackingCompletado = false
    
    -- 5. Detener todos los timers
    if cursorTimer and isTimer(cursorTimer) then 
        killTimer(cursorTimer) 
        cursorTimer = nil
    end
    if deteccionTimer and isTimer(deteccionTimer) then 
        killTimer(deteccionTimer) 
        deteccionTimer = nil
    end
    

end

-- Variables para timers
local cursorTimer = nil
local deteccionTimer = nil

-- 🚫 BLOQUEO TOTAL DE BINDS DE MTA MIENTRAS EL TERMINAL ESTÁ ACTIVO
function bloquearTeclasMTA(key, press)
    if not terminalActivo then return end
    
    -- Bloquear TODAS las teclas que interfieren con el terminal
    local teclasProhibidas = {
        "t", "T", "y", "Y", -- Chat general y team
        "f6", "F6", "f7", "F7", "f8", "F8", -- Menús
        "tab", "Tab", "TAB", -- Scoreboard  
        "m", "M", -- Mapa
        "n", "N", -- Nametagas
        "f", "F", -- Enter/exit vehicle
        "g", "G", -- Horn
        "h", "H", -- Lights
        "l", "L", -- Locks
        "k", "K", -- Locks
        "j", "J", -- Jump
        "p", "P", -- Pause
        "i", "I", -- Inventory (si existe)
        "o", "O", -- Otro menu
        "u", "U", -- Otro menu
        "b", "B", -- Otro menu
        "v", "V", -- Cámara view
        "c", "C", -- Crouch
        "z", "Z", -- Other action
        "x", "X", -- Other action
        "q", "Q", -- Previous weapon
        "e", "E", -- Next weapon
        "r", "R", -- Reload
        "space", -- Jump/handbrake
        "lshift", "rshift", -- Run
        "lctrl", "rctrl", -- Crouch
        "lalt", "ralt" -- Walk
    }
    
    for _, tecla in ipairs(teclasProhibidas) do
        if key:lower() == tecla:lower() then
            cancelEvent() -- Bloquear completamente la tecla
            
            -- Mensaje informativo solo para teclas importantes
            if key:lower() == "t" or key:lower() == "y" then
                agregarLineaTerminal("⚠️ Chat deshabilitado durante hackeo - Usa números 1-5 solamente", tocolor(255, 165, 0, 200))
            end
            return
        end
    end
end

-- Función simplificada para manejar SOLO números 1-5
function manejarNumeroTerminal(key, press)
    if not terminalActivo or not press then return end
    
    -- Solo permitir números 1-5 y algunas teclas especiales
    if key >= "1" and key <= "5" then
        local numero = tonumber(key)
        if numero and numero >= 1 and numero <= 5 then
            procesarOpcionTerminal(key)
        end
    elseif key == "escape" then
        -- Permitir cancelar el terminal INMEDIATAMENTE
        agregarLineaTerminal("⚠️ ABORTANDO HACKEO - RESTAURANDO CONTROLES...", tocolor(255, 165, 0, 255))
        
        -- 🚨 CANCELACIÓN INMEDIATA SEGURA
        setTimer(function()
            -- Primero notificar al servidor para liberar el freeze
            triggerServerEvent("hackingCancelado", localPlayer)
            
            -- Luego finalizar el terminal en el cliente
            setTimer(function()
                finalizarTerminalHacker()
                outputChatBox("🔓 HACKEO CANCELADO - Movimiento restaurado", 255, 255, 0)
            end, 250, 1) -- Delay pequeño para asegurar sincronización
        end, 500, 1) -- Reducido el delay total
    end
end

-- Función para iniciar el terminal hacker épico (SIN BUGS)
function iniciarTerminalHacker()
    if terminalActivo then
        return
    end
    
    -- 🚫 OCULTAR CHAT COMPLETAMENTE PARA EVITAR CONFLICTOS
    showChat(false)
    
    -- Inicializar variables del terminal
    terminalActivo = true
    terminalLineas = {}
    comandoActual = ""
    etapaHacking = 1
    sistemaDeteccion = 0
    hackingCompletado = false
    
    -- 🎨 ACTUALIZAR CONFIGURACIÓN HD SEGÚN RESOLUCIÓN ACTUAL
    screenW, screenH = guiGetScreenSize()
    terminalConfig.width = screenW * 0.85
    terminalConfig.height = screenH * 0.85
    terminalConfig.x = screenW * 0.075
    terminalConfig.y = screenH * 0.075
    
    -- Recalcular tamaños responsivos HD BALANCEADOS
    terminalConfig.fontSize = math.max(1.0, screenH / 900)
    terminalConfig.titleFontSize = math.max(1.2, screenH / 800)
    terminalConfig.headerFontSize = math.max(1.0, screenH / 1000)
    terminalConfig.lineHeight = math.max(18, screenH / 50)
    terminalConfig.padding = math.max(15, screenW / 100)
    terminalConfig.maxLines = math.floor(screenH / 35)
    
    -- Mensajes de inicio más claros y útiles
    agregarLineaTerminal("🔌 [INICIANDO] Conexión cifrada establecida...", tocolor(0, 255, 255, 255))
    agregarLineaTerminal("🌐 [ÉXITO] Túnel VPN activo - Identidad oculta", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("🛡️ [ÉXITO] Sistemas de defensa personal activados", tocolor(255, 255, 0, 255))
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("💻 ======= TERMINAL DE HACKEO AVANZADO ======= 💻", tocolor(0, 255, 255, 255))
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("🎯 OBJETIVO: Infiltrar sistema bancario del cajero automático", tocolor(255, 255, 255, 255))
    agregarLineaTerminal("⚡ MÉTODO: Completar 5 etapas de penetración cibernética", tocolor(255, 255, 255, 255))
    agregarLineaTerminal("📱 CONTROLES: Usa números 1-5 para seleccionar opciones", tocolor(0, 255, 255, 255))
    agregarLineaTerminal("⚠️ ADVERTENCIA: Los errores activan sistemas de seguridad", tocolor(255, 165, 0, 255))
    agregarLineaTerminal("🚨 PELIGRO: 100% detección = Fallo de misión y alerta policial", tocolor(255, 100, 100, 255))
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("▼▼▼ PULSA ESC PARA ABORTAR MISIÓN ▼▼▼", tocolor(255, 255, 0, 200))
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    agregarLineaTerminal("=== INICIANDO ETAPA 1 DE 5 ===", tocolor(255, 255, 0, 255))
    agregarLineaTerminal("", tocolor(0, 255, 0, 255))
    
    -- 🎮 CONFIGURAR EVENT HANDLERS MEJORADOS (SIN CONFLICTOS)
    addEventHandler("onClientRender", root, dibujarTerminalHacker)
    addEventHandler("onClientKey", root, bloquearTeclasMTA) -- Bloquea TODAS las teclas problemáticas
    addEventHandler("onClientKey", root, manejarNumeroTerminal) -- Solo acepta números 1-5
    
    -- Timer para cursor parpadeante (aunque ya no lo usamos)
    cursorTimer = setTimer(function()
        cursorVisible = not cursorVisible
    end, 500, 0)
    
    -- Timer para sistema de detección progresiva (más balanceado)
    deteccionTimer = setTimer(function()
        if terminalActivo and not hackingCompletado then
            -- Aumentar detección muy lentamente para dar tiempo
            sistemaDeteccion = sistemaDeteccion + math.random(1, 2)
            
            -- Advertencias progresivas
            if sistemaDeteccion >= 70 and sistemaDeteccion < 85 then
                if math.random(1, 3) == 1 then -- No spam
                    agregarLineaTerminal("⚠️ ALERTA: Sistemas de seguridad detectando actividad sospechosa", tocolor(255, 165, 0, 255))
                end
            elseif sistemaDeteccion >= 85 then
                if math.random(1, 2) == 1 then -- Más frecuente
                    agregarLineaTerminal("🚨 CRÍTICO: ¡Detección inmiente! ¡Acelerar proceso!", tocolor(255, 50, 50, 255))
                end
            end
            
            -- Verificar si se alcanzó el límite
            if sistemaDeteccion >= maxDeteccion then
                fallarHackingTerminal()
            end
        end
    end, 8000, 0) -- Cada 8 segundos (más tiempo)
    
    showCursor(false)
end

function iniciarMinijuego()
    if juegoActivo then 
        return 
    end
    
    -- INICIALIZAR variables del juego
    juegoActivo = true
    cables = {}
    resultado = {}
    electricSparks = {}  -- Limpiar chispas anteriores
    connectionPulse = 0  -- Reset pulso
    
    -- ACTUALIZAR configuración optimizada según la resolución
    -- 🇨🇴 ACTUALIZAR CONFIGURACIÓN HD COLOMBIANA SEGÚN LA RESOLUCIÓN
    screenW, screenH = guiGetScreenSize()
    panelConfig.width = screenW * 0.75
    panelConfig.height = screenH * 0.75
    panelConfig.x = screenW * 0.125
    panelConfig.y = screenH * 0.125
    
    -- Recalcular tamaños HD responsivos para cables BALANCEADOS
    panelConfig.titleHeight = math.max(35, screenH * 0.04)   -- Títulos balanceados
    panelConfig.fontSize = math.max(1.0, screenH / 800)      -- Escalado más conservador
    panelConfig.headerFontSize = math.max(1.1, screenH / 700) -- Headers balanceados
    panelConfig.labelFontSize = math.max(0.9, screenH / 900) -- Labels más pequeños
    
    -- 🎨 ACTUALIZAR FUENTES HD DEL PANEL (solo si el sistema está cargado)
    if fontConfig.loaded then
        panelConfig.titleFont = obtenerFuente("title", fontConfig.sizes.large)
        panelConfig.headerFont = obtenerFuente("main", fontConfig.sizes.large)
        panelConfig.labelFont = obtenerFuente("main", fontConfig.sizes.medium)
    end
    
    generarPosiciones()

    -- ACTIVAR renderizado y controles
    addEventHandler("onClientRender", root, dibujarMinijuego)
    addEventHandler("onClientClick", root, manejarClic)
    
    -- ASEGURAR que el cursor esté visible para el arrastre
    showCursor(true)
end

-- Tabla para almacenar los efectos de fuego activos
local efectosFuego = {}

-- Tabla para almacenar los temporizadores activos
local temporizadoresActivos = {}

-- Función para formatear el tiempo en MM:SS
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

-- Registrar los manejadores de eventos
addEventHandler("minijuego", root, iniciarMinijuego)
addEventHandler("minijuegoTerminal", root, iniciarTerminalHacker)

addEventHandler("createFireEffect", root, function(x, y, z, id)
    -- Si ya existe un efecto en esta posición, eliminarlo
    if efectosFuego[id] and isElement(efectosFuego[id]) then
        destroyElement(efectosFuego[id])
    end
    
    -- Crear el nuevo efecto de fuego
    local efecto = createEffect("fire", x, y, z)
    efectosFuego[id] = efecto
end)

addEventHandler("eliminarFireEffect", root, function(id)
    if efectosFuego[id] and isElement(efectosFuego[id]) then
        destroyElement(efectosFuego[id])
        efectosFuego[id] = nil
    end
end)

addEventHandler("mostrarTemporizadorAvanzado", root, function(x, y, z, tiempoTotal)
    -- Crear un identificador único para este temporizador basado en su posición
    local id = tostring(x) .. "_" .. tostring(y) .. "_" .. tostring(z)
    
    -- Si ya existe un temporizador en esta posición, eliminarlo
    if temporizadoresActivos[id] then
        if isElement(temporizadoresActivos[id].texto) then
            destroyElement(temporizadoresActivos[id].texto)
        end
        if isElement(temporizadoresActivos[id].textoContorno) then
            destroyElement(temporizadoresActivos[id].textoContorno)
        end
        if isTimer(temporizadoresActivos[id].timer) then
            killTimer(temporizadoresActivos[id].timer)
        end
    end
    
    -- Crear el texto 3D con estilo avanzado
    local texto = createElement("text")
    setElementPosition(texto, x, y, z)
    
    -- Configurar el estilo visual del texto con contornos más visibles
    setElementData(texto, "scale", 4.0)  -- Tamaño más grande
    setElementData(texto, "color", {0, 255, 255, 255})  -- Color cian brillante
    setElementData(texto, "outline", true)  -- Activar contorno
    setElementData(texto, "outlineColor", {0, 0, 0, 255})  -- Contorno negro
    setElementData(texto, "shadow", {4, 4, 0, 0, 0, 255})  -- Sombra más pronunciada
    setElementData(texto, "font", "pricedown")  -- Fuente más estilizada y visible
    
    -- Crear un segundo texto para el efecto de doble contorno
    local textoContorno = createElement("text")
    setElementPosition(textoContorno, x, y, z)
    setElementData(textoContorno, "scale", 4.2)  -- Ligeramente más grande que el texto principal
    setElementData(textoContorno, "color", {0, 0, 0, 200})  -- Negro semi-transparente
    setElementData(textoContorno, "outline", false)
    
    -- Inicializar el tiempo restante
    local tiempoRestante = tiempoTotal
    
    -- Actualizar el texto inicialmente
    local textoBase = "REPARACIÓN EN: "
    setElementData(texto, "text", textoBase .. formatTime(tiempoRestante))
    setElementData(textoContorno, "text", textoBase .. formatTime(tiempoRestante))
    
    -- Crear un timer para actualizar el texto cada segundo
    local timer = setTimer(function()
        tiempoRestante = tiempoRestante - 1
        if tiempoRestante > 0 then
            -- Actualizar el texto con el tiempo restante
            setElementData(texto, "text", textoBase .. formatTime(tiempoRestante))
            setElementData(textoContorno, "text", textoBase .. formatTime(tiempoRestante))
            
            -- Efecto de parpadeo y cambio de color para los últimos 30 segundos
            if tiempoRestante <= 30 then
                local pulso = math.sin(getTickCount() / 200) * 0.5 + 0.5
                local r = 255 * pulso
                local g = 255 * (1 - pulso)
                local b = 0
                setElementData(texto, "color", {r, g, b, 255})
                setElementData(texto, "scale", 4.0 + pulso * 0.5)  -- Efecto de pulsación
            end
        else
            -- Eliminar el temporizador cuando llegue a cero
            if isElement(texto) then
                destroyElement(texto)
            end
            if isElement(textoContorno) then
                destroyElement(textoContorno)
            end
            if isTimer(timer) then
                killTimer(timer)
            end
            temporizadoresActivos[id] = nil
        end
    end, 1000, 0)
    
    -- Guardar referencia al temporizador
    temporizadoresActivos[id] = {
        texto = texto,
        textoContorno = textoContorno,
        timer = timer
    }
end)

addEventHandler("eliminarTemporizador", root, function(x, y, z)
    local id = tostring(x) .. "_" .. tostring(y) .. "_" .. tostring(z)
    if temporizadoresActivos[id] then
        if isElement(temporizadoresActivos[id].texto) then
            destroyElement(temporizadoresActivos[id].texto)
        end
        if isElement(temporizadoresActivos[id].textoContorno) then
            destroyElement(temporizadoresActivos[id].textoContorno)
        end
        if isTimer(temporizadoresActivos[id].timer) then
            killTimer(temporizadoresActivos[id].timer)
        end
        temporizadoresActivos[id] = nil
    end
end)

addEventHandler("progressBar", root, function(duracion, tipo)
    -- Aquí puedes implementar una barra de progreso visual si lo deseas
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    inicializarSistemaFuentes()
end)






















