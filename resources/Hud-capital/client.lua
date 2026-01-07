local sx, sy = guiGetScreenSize()
local scale_x = sx/1920
local scale_y = sy/1080

-- Cache de texturas y layout para reducir trabajo por frame
local textures = {}
local function loadTexture(path)
    local tx = textures[path]
    if tx and isElement(tx) then return tx end
    tx = dxCreateTexture(path)
    if tx then textures[path] = tx end
    return tx
end

-- Texturas estáticas del HUD
local TX = {
    bg_ext_efectivo = nil,
    bg_ext_bank = nil,
    bg_int_efectivo = nil,
    bg_int_bank = nil,
    icon_efectivo = nil,
    icon_bank = nil,
    icon_vida = nil,
    icon_armour = nil,
    icon_hambre = nil,
    icon_agua = nil,
}

-- Texturas de armas cargadas bajo demanda
local function getWeaponTexture(id)
    local file = iconos_armas and iconos_armas[id]
    if not file then return nil end
    return loadTexture('weapons/'..file)
end

-- Layout precalculado
local layout = {}
local function recalcLayout()
    local hudScale = math.min(sx/1920, sy/1080) * 0.9
    layout.hudScale = hudScale
    layout.marginRight = sx * 0.01
    layout.marginTop = sy * 0.02
    layout.hudWidth = 310 * hudScale
    layout.baseX = sx - layout.hudWidth - layout.marginRight
    layout.circleSize = 50 * hudScale
    layout.statsTextY = math.max(5 + layout.circleSize/2, layout.marginTop + 25*hudScale)
    layout.iconY = layout.statsTextY + 45*hudScale
    layout.statsRightOffset = sx * 0.005
    layout.iconOffsetX = layout.baseX - 15*hudScale + layout.statsRightOffset
    layout.statsIconSize = 40*hudScale
    layout.iconSpacing = 76*hudScale
    layout.dineroY = layout.iconY + 60*hudScale
    layout.bancoY = layout.dineroY + 80*hudScale
    layout.armasY = layout.bancoY + 90*hudScale
    layout.panelCenterX = layout.baseX + 5*hudScale + (300*hudScale)/2
    layout.dineroTextY = layout.dineroY + (54*hudScale)/2
    layout.bancoTextY = layout.bancoY + (54*hudScale)/2
    -- Posiciones precalculadas de stats y círculo
    local statsBaseX = layout.iconOffsetX + layout.statsIconSize/2
    layout.statsBaseX = statsBaseX
    layout.posVida = {statsBaseX, layout.statsTextY}
    layout.posArmadura = {statsBaseX + layout.iconSpacing, layout.statsTextY}
    layout.posHambre = {statsBaseX + layout.iconSpacing*2, layout.statsTextY}
    layout.posSed = {statsBaseX + layout.iconSpacing*3, layout.statsTextY}
    layout.circleOffset = layout.circleSize/2
end
-- OPTIMIZACIÓN: Valores optimizados con mejor control
local valores = {
    health = 100,
    armor = 100,  
    hungry = 100,
    thrist = 100
}
local lastUpdate = 0
local updateInterval = 300 -- OPTIMIZACIÓN: 200ms para menos trabajo por frame sin afectar fluidez

-- CORRECCIÓN FINAL: Sin cache de renderizado para evitar parpadeo

-- Fuentes del HUD con verificación optimizada
local fuente_orbitron_28, fuente_orbitron_19, fuente_balas
local fuentesCargadas = false

function cargarFuentes()
    -- Fuentes adaptativas basadas en resolución
    local fontScale = math.min(sx/1920, sy/1080)
    
    fuente_orbitron_28 = dxCreateFont("files/fonts/Orbitron-Medium.ttf", math.max(12, 28 * fontScale))
    fuente_orbitron_19 = dxCreateFont("files/fonts/Orbitron-Medium.ttf", math.max(10, 19 * fontScale))
    fuente_balas = dxCreateFont("files/fonts/sfprodisplay-heavy.ttf", math.max(8, 12 * fontScale))
    
    -- Verificar si las fuentes se cargaron correctamente
    if not fuente_orbitron_28 then
        outputChatBox("[HUD] Error: No se pudo cargar Orbitron-Medium", 255, 100, 100)
        fuente_orbitron_28 = "default-bold"
    end
    if not fuente_orbitron_19 then
        outputChatBox("[HUD] Error: No se pudo cargar Orbitron-Medium", 255, 100, 100)
        fuente_orbitron_19 = "default"
    end
    if not fuente_balas then
        fuente_balas = "default-bold"
    end
    
    -- Inicializar shaders después de cargar fuentes
    inicializarShaders()
end

local mostrar_hud = true

-- Datos del arma actual (cachear para evitar llamadas constantes)
local arma_actual = 0
local municion_actual = 0
local municion_total = 0
local lastWeaponUpdate = 0

-- Cache de textos para evitar conversiones constantes
local textoCache = {
    vida = "100",
    armadura = "100", 
    hambre = "100",
    sed = "100",
    dinero = "0",
    banco = "0",
}

-- Colores precomputados para evitar tocolor() por frame
local COLOR_WHITE = tocolor(255, 255, 255, 255)
local COLOR_BLACK_220 = tocolor(0, 0, 0, 220)
local COLOR_BG_GREY = tocolor(220, 220, 220, 60)
local COLOR_RING_VIDA = tocolor(255, 75, 75, 230)
local COLOR_RING_ARMADURA = tocolor(255, 255, 255, 230)
local COLOR_RING_HAMBRE = tocolor(255, 193, 7, 230)
local COLOR_RING_SED = tocolor(33, 150, 243, 230)

-- Sistema de shaders para círculos progresivos estilo FiveM
local circuloShader = nil

function inicializarShaders()
    circuloShader = dxCreateShader("files/shader.fx")
    
    if not circuloShader then
        outputChatBox("[HUD] Error: No se pudo cargar el shader de círculos", 255, 100, 100)
    else
        -- Configuración del shader adaptativa a la resolución
        local shaderSize = math.min(sx/1920, sy/1080) * 50  -- Basado en circleSize
        dxSetShaderValue(circuloShader, "sCircleHeightInPixel", shaderSize)
        dxSetShaderValue(circuloShader, "sCircleWidthInPixel", shaderSize)
        dxSetShaderValue(circuloShader, "sBorderWidthInPixel", math.max(2, shaderSize * 0.06))  -- Borde proporcional
    end
end

-- Función para dibujar círculo progresivo estilo FiveM alrededor de valores (optimizada)
function dibujarCirculoProgresivo(x, y, size, valor, colorParam)
    if not circuloShader then return end
    
    -- Normalizar valor (0-100)
    local porcentaje = math.max(0, math.min(100, valor))
    
    -- Configurar el ángulo del círculo basado en el porcentaje
    local anguloInicio = -1.57  -- -90 grados (arriba)
    local anguloFin = anguloInicio + (porcentaje / 100 * 6.28)  -- Círculo completo = 2*PI
    
    -- Círculo de fondo (gris muy claro y sutil)
    dxSetShaderValue(circuloShader, "sAngleStart", 0)
    dxSetShaderValue(circuloShader, "sAngleEnd", 6.28)  -- Círculo completo
    dxDrawImage(x, y, size, size, circuloShader, 0, 0, 0, COLOR_BG_GREY)
    
    -- Círculo progresivo principal
    dxSetShaderValue(circuloShader, "sAngleStart", anguloInicio)
    dxSetShaderValue(circuloShader, "sAngleEnd", anguloFin)
    local ringColor = (type(colorParam) == 'number') and colorParam or tocolor(colorParam[1], colorParam[2], colorParam[3], 230)
    dxDrawImage(x, y, size, size, circuloShader, 0, 0, 0, ringColor)
end

-- Mapeo de IDs de armas a nombres de archivos
local iconos_armas = {
    [0] = false, -- Puños (Fist)
    [1] = "1.png",  -- Puño americano (Brass knuckle)
    [2] = "2.png",  -- Palo de golf (Golf club)
    [3] = "3.png",  -- Porra policial (Nightstick)
    [4] = "4.png",  -- Cuchillo (Knife)
    [5] = "5.png",  -- Bate (Bat)
    [6] = "6.png",  -- Pala (Shovel)
    [7] = "7.png",  -- Taco de billar (Poolstick)
    [8] = "8.png",  -- Katana
    [9] = "9.png",  -- Motosierra (Chainsaw)
    [10] = "10.png", -- Dildo morado
    [11] = "11.png", -- Dildo
    [12] = "12.png", -- Vibrador
    [14] = "14.png", -- Flores (Flower)
    [15] = "15.png", -- Bastón (Cane)
    [16] = "16.png", -- Granada (Grenade)
    [17] = "17.png", -- Gas lacrimógeno (Teargas)
    [18] = "18.png", -- Cóctel molotov (Molotov)
    [22] = "22.png", -- Pistola 9mm (Colt 45)
    [23] = "23.png", -- Pistola con silenciador (Silenced)
    [24] = "24.png", -- Desert Eagle
    [25] = "25.png", -- Escopeta (Shotgun)
    [26] = "26.png", -- Escopeta recortada (Sawed-off)
    [27] = "27.png", -- Escopeta de combate (Combat Shotgun)
    [28] = "28.png", -- Micro SMG/Uzi
    [29] = "29.png", -- MP5
    [30] = "30.png", -- AK-47
    [31] = "31.png", -- M4
    [32] = "32.png", -- Tec-9
    [33] = "33.png", -- Rifle de caza (Rifle)
    [34] = "34.png", -- Rifle de francotirador (Sniper)
    [35] = "35.png", -- Lanzacohetes (Rocket Launcher)
    [36] = "36.png", -- Lanzacohetes teledirigido (Rocket Launcher HS)
    [37] = "37.png", -- Lanzallamas (Flamethrower)
    [38] = "38.png", -- Minigun
    [39] = "39.png", -- Cargas explosivas (Satchel)
    [40] = "40.png", -- Detonador (Bomb)
    [41] = "41.png", -- Spray (Spraycan)
    [42] = "42.png", -- Extintor (Fire Extinguisher)
    [43] = "43.png", -- Cámara (Camera)
    [44] = "44.png", -- Gafas visión nocturna (Nightvision)
    [45] = "45.png", -- Gafas de infrarrojos (Infrared)
    [46] = "46.png", -- Paracaídas (Parachute)
}



-- =====================================================
-- OPTIMIZACIÓN APLICADA: Sistema de actualización super optimizado
-- =====================================================

function actualizarValores()
    local currentTime = getTickCount()
    if currentTime - lastUpdate < updateInterval then
        return
    end
    
    lastUpdate = currentTime
    
    -- OPTIMIZACIÓN: Obtener valores con cache simple
    local health = getElementHealth(localPlayer) or 0
    local armor = getPedArmor(localPlayer) or 0
    local hungry = getElementData(localPlayer, "hambre") or getElementData(localPlayer, "hungry") or 100
    local thrist = getElementData(localPlayer, "sed") or 100
    
    -- OPTIMIZACIÓN: Interpolación más eficiente (sin interpolateBetween costoso)
    local lerp = function(a, b, t) return a + (b - a) * t end
    local lerpFactor = 0.2 -- Más rápido y menos costoso que interpolateBetween
    
    valores.health = lerp(valores.health, health, lerpFactor)
    valores.armor = lerp(valores.armor, armor, lerpFactor)  
    valores.hungry = lerp(valores.hungry, hungry, lerpFactor)
    valores.thrist = lerp(valores.thrist, thrist, lerpFactor)
    
    -- OPTIMIZACIÓN: Actualizar cache solo si cambió significativamente
    local newVida = tostring(math.floor(valores.health))
    local newArmadura = tostring(math.floor(valores.armor))
    local newHambre = tostring(math.floor(valores.hungry))
    local newSed = tostring(math.floor(valores.thrist))
    
    if newVida ~= textoCache.vida then textoCache.vida = newVida end
    if newArmadura ~= textoCache.armadura then textoCache.armadura = newArmadura end
    if newHambre ~= textoCache.hambre then textoCache.hambre = newHambre end
    if newSed ~= textoCache.sed then textoCache.sed = newSed end
    
    -- OPTIMIZACIÓN: Dinero solo si cambió
    local dinero = getPlayerMoney(localPlayer) or 0
    local nuevoDinero = formatear(dinero)
    if nuevoDinero ~= textoCache.dinero then
        textoCache.dinero = nuevoDinero
    end
end

function formatear(cantidad)
  if not cantidad or cantidad == 0 then
    return "0"
  end
  
  -- Convertir a número positivo para evitar problemas con números negativos
  local num = math.abs(math.floor(cantidad))
  
  -- Formatear según la cantidad de cifras
  if num >= 1000000000 then -- 10 cifras o más (mil millones o más)
    local valMM = num / 1000000000
    return string.format("%.1f", valMM) .. "MM"
  else -- 9 cifras o menos - mostrar número completo con separadores
    local formateado = tostring(num):reverse():gsub("(%d%d%d)", "%1."):reverse()
    if formateado:sub(1, 1) == "." then
      return formateado:sub(2)
    end
    return formateado
  end
end

-- Función para probar directamente desde la consola del juego
function testFormatear(valor)
  outputChatBox("Valor original: " .. tostring(valor))
  outputChatBox("Formateado: " .. formatear(valor))
end
addCommandHandler("testFormat", testFormatear)

-- Función auxiliar para la depuración del dinero actual
function mostrarDineroActual()
  local dinero = getPlayerMoney(localPlayer) or 0
  outputChatBox("Dinero actual: " .. tostring(dinero))
  outputChatBox("Formateado: " .. formatear(dinero))
end
addCommandHandler("verDinero", mostrarDineroActual)

-- =====================================================
-- OPTIMIZACIÓN APLICADA: Sistema de armas super optimizado
-- =====================================================

function actualizarDatosArma()
    local currentTime = getTickCount()
    if currentTime - lastWeaponUpdate < 400 then -- OPTIMIZACIÓN: Reducido frecuencia
        return
    end
    
    lastWeaponUpdate = currentTime
    
    if not isElement(localPlayer) then return end
    
    -- OPTIMIZACIÓN: Cache del arma anterior para evitar actualizaciones innecesarias
    local nuevaArma = getPedWeapon(localPlayer)
    
    if nuevaArma ~= arma_actual then
        arma_actual = nuevaArma
    end
    
    if arma_actual and arma_actual > 0 then
        -- OPTIMIZACIÓN: Solo obtener munición si es necesario mostrarla
        if arma_actual > 21 and arma_actual ~= 40 and arma_actual ~= 41 and arma_actual ~= 42 then
            local clip = getPedAmmoInClip(localPlayer) or 0
            local total = getPedTotalAmmo(localPlayer) or 0
            
            municion_actual = clip
            municion_total = math.max(0, total - clip)
            local newAmmoText = tostring(municion_actual) .. " / " .. tostring(municion_total)
            if textoCache.municion ~= newAmmoText then
                textoCache.municion = newAmmoText
            end
        else
            municion_actual = 0
            municion_total = 0
            textoCache.municion = nil
        end
    else
        municion_actual = 0
        municion_total = 0
            textoCache.municion = nil
    end
end

-- Variable para almacenar el saldo bancario actualizado
local banco = 0

-- Evento para recibir el saldo bancario del servidor
addEvent("onClientRequestBalance", true)
addEventHandler("onClientRequestBalance", root, function(currentBalance)
    if currentBalance then
        banco = currentBalance

        textoCache.banco = formatear(banco)
    end
end)

-- =====================================================
-- OPTIMIZACIÓN APLICADA: onClientRender super optimizado
-- =====================================================

addEventHandler("onClientRender", root, function()
    if not mostrar_hud then return end
    
    -- CORRECCIÓN FINAL: Sin limitación de framerate para evitar parpadeo
    
    -- Actualizar valores solo cuando sea necesario
    actualizarValores()
    
    -- Seguridad: asegúrate de que el layout esté inicializado
    if not layout.hudScale then
        recalcLayout()
    end
    
    -- OPTIMIZACIÓN: Cache de cálculos costosos (usando layout precalculado)
    local hudScale = layout.hudScale
    
    -- Posicionamiento restaurado a posiciones originales pero con sistema adaptativo
    local marginRight = layout.marginRight   -- Margen derecho mínimo
    local marginTop = layout.marginTop       -- Margen superior mínimo (como estaba originalmente)
    local hudWidth = layout.hudWidth
    local baseX = layout.baseX
    
    -- Posicionamiento vertical compacto como estaba al principio
    local circleSize = layout.circleSize
    
    -- Posiciones originales adaptadas (compactas en esquina superior derecha)
    local statsTextY = layout.statsTextY  -- Círculos y valores en la parte superior
    local iconY = layout.iconY            -- Iconos debajo de los valores
    
    -- Espaciado correcto entre paneles como estaba originalmente
    local dineroY = layout.dineroY      -- Panel dinero con más espacio
    local bancoY = layout.bancoY        -- Panel banco con separación adecuada
    local armasY = layout.armasY        -- Armas con espacio suficiente
    
    -- Fondos exteriores para dinero y banco (posicionamiento adaptativo)
    dxDrawImage(baseX, dineroY - 8*hudScale, 310*hudScale, 70*hudScale, TX.bg_ext_efectivo or 'files/newinterface2/bgexterior-efectivo.png')
    dxDrawImage(baseX, bancoY - 8*hudScale, 310*hudScale, 70*hudScale, TX.bg_ext_bank or 'files/newinterface2/bgexterior-bank.png')
    
    -- Fondos interiores (adaptativos)
    dxDrawImage(baseX + 5*hudScale, dineroY, 300*hudScale, 54*hudScale, TX.bg_int_efectivo or 'files/newinterface2/bginterior-efectivo.png')
    dxDrawImage(baseX + 5*hudScale, bancoY, 300*hudScale, 54*hudScale, TX.bg_int_bank or 'files/newinterface2/bginterior-bank.png')
    
    -- Iconos de dinero y banco (adaptativos)
    dxDrawImage(baseX + 13*hudScale, dineroY + 11*hudScale, 32*hudScale, 32*hudScale, TX.icon_efectivo or 'files/newinterface2/icon-efectivo.png')
    dxDrawImage(baseX + 13*hudScale, bancoY + 11*hudScale, 32*hudScale, 32*hudScale, TX.icon_bank or 'files/newinterface2/icon-bank.png')
    
    -- Iconos de estadísticas (posicionamiento original compacto)
    local statsRightOffset = layout.statsRightOffset  -- Offset mínimo
    local iconOffsetX = layout.iconOffsetX
    local statsIconSize = layout.statsIconSize   -- Tamaño original
    local iconSpacing = layout.iconSpacing       -- Espaciado fijo como estaba originalmente
    
    dxDrawImage(iconOffsetX, iconY, statsIconSize, statsIconSize, TX.icon_vida or 'files/newinterface2/icon-vida.png')
    dxDrawImage(iconOffsetX + iconSpacing, iconY, statsIconSize, statsIconSize, TX.icon_armour or 'files/newinterface2/icon-armour.png')
    dxDrawImage(iconOffsetX + iconSpacing*2, iconY, statsIconSize, statsIconSize, TX.icon_hambre or 'files/newinterface2/icon-hambre.png')
    dxDrawImage(iconOffsetX + iconSpacing*3, iconY, statsIconSize, statsIconSize, TX.icon_agua or 'files/newinterface2/icon-agua.png')
    
    -- Círculos progresivos estilo FiveM (posicionamiento original restaurado)
    -- circleSize ya definido arriba
    
    -- Colores para cada estadística  
    local colorVida = {255, 75, 75}      -- Rojo
    local colorArmadura = {255, 255, 255} -- Blanco brillante (mejor visibilidad)
    local colorHambre = {255, 193, 7}     -- Amarillo
    local colorSed = {33, 150, 243}       -- Azul
    
    -- Posiciones centradas de los valores (alineadas con iconos como estaba originalmente)
    local statsBaseX = iconOffsetX + statsIconSize/2  -- Centrado en los iconos
    -- statsTextY ya definido arriba con verificación de seguridad
    
    local posVida = layout.posVida
    local posArmadura = layout.posArmadura
    local posHambre = layout.posHambre
    local posSed = layout.posSed
    
    -- Dibujar círculos progresivos alrededor de cada valor
    local circleOffset = layout.circleOffset
    dibujarCirculoProgresivo(posVida[1] - circleOffset, posVida[2] - circleOffset, circleSize, valores.health, COLOR_RING_VIDA)
    dibujarCirculoProgresivo(posArmadura[1] - circleOffset, posArmadura[2] - circleOffset, circleSize, valores.armor, COLOR_RING_ARMADURA)
    dibujarCirculoProgresivo(posHambre[1] - circleOffset, posHambre[2] - circleOffset, circleSize, valores.hungry, COLOR_RING_HAMBRE)
    dibujarCirculoProgresivo(posSed[1] - circleOffset, posSed[2] - circleOffset, circleSize, valores.thrist, COLOR_RING_SED)
    
    -- Textos de estadísticas más pequeños y centrados en los círculos
    dxDrawText(textoCache.vida, posVida[1], posVida[2], nil, nil, COLOR_WHITE, 0.8*hudScale, fuente_orbitron_19, 'center', 'center')
    dxDrawText(textoCache.armadura, posArmadura[1], posArmadura[2], nil, nil, COLOR_WHITE, 0.8*hudScale, fuente_orbitron_19, 'center', 'center')
    dxDrawText(textoCache.hambre, posHambre[1], posHambre[2], nil, nil, COLOR_WHITE, 0.8*hudScale, fuente_orbitron_19, 'center', 'center')
    dxDrawText(textoCache.sed, posSed[1], posSed[2], nil, nil, COLOR_WHITE, 0.8*hudScale, fuente_orbitron_19, 'center', 'center')
    
    -- Dinero y banco perfectamente centrados (sistema adaptativo)
    local panelCenterX = layout.panelCenterX  -- Centro horizontal del panel interior
    
    -- Dinero - centrado perfectamente en el panel interior de efectivo
    local dineroTextX = panelCenterX
    local dineroTextY = layout.dineroTextY  -- Centro vertical del panel
    dxDrawText(textoCache.dinero, dineroTextX, dineroTextY, dineroTextX, dineroTextY, COLOR_WHITE, 0.6*hudScale, fuente_orbitron_28, "center", "center")
    
    -- Banco - centrado perfectamente en el panel interior de banco
    local bancoTexto = textoCache.banco or formatear(banco)
    local bancoTextX = panelCenterX
    local bancoTextY = layout.bancoTextY  -- Centro vertical del panel
    dxDrawText(bancoTexto, bancoTextX, bancoTextY, bancoTextX, bancoTextY, COLOR_WHITE, 0.6*hudScale, fuente_orbitron_28, "center", "center")
    
    -- Mostrar arma actual debajo de bgexterior-bank
    actualizarDatosArma()
    
    if arma_actual > 0 and iconos_armas[arma_actual] then
        -- Arma centrada, más grande y con máxima resolución HD
        local armaWidth = 310*hudScale   -- Ancho completo del panel para mejor centrado
        local armaX = baseX              -- Alineado con el panel
        local armaY = armasY
        
        -- Área de la imagen del arma (centrada y más grande para mejor resolución)
        local armaImageSize = 130*hudScale  -- Mucho más grande para HD
        local armaImageX = armaX + (armaWidth - armaImageSize) / 2  -- Centrado horizontalmente
        local armaImageY = armaY
        
        local armaImagePath = "weapons/" .. iconos_armas[arma_actual]
        
        -- Icono del arma centrado con máxima calidad HD (SIN recuadro de fondo)
        dxDrawImage(armaImageX, armaImageY, armaImageSize, armaImageSize, (getWeaponTexture(arma_actual) or armaImagePath), 0, 0, 0, COLOR_WHITE, true)
        
        -- Mostrar munición centrada y mejorada debajo del arma
        if arma_actual > 21 and arma_actual ~= 40 and arma_actual ~= 41 and arma_actual ~= 42 then
            local municionTexto = textoCache.municion or (municion_actual .. " / " .. municion_total)
            local municionX = armaX + armaWidth/2  -- Centrado en el panel
            local municionY = armaImageY + armaImageSize - 15*hudScale  -- Superpuesto sobre la parte inferior de la imagen
            
            -- Contorno mejorado del texto de munición (más visible)
            local municionScale = 1.3*hudScale  -- Más grande para mejor legibilidad
            -- Contorno optimizado
            dxDrawText(municionTexto, municionX+1, municionY+1, municionX+1, municionY+1, COLOR_BLACK_220, municionScale, fuente_balas, "center", "center")
            -- Texto principal: blanco brillante
            dxDrawText(municionTexto, municionX, municionY, municionX, municionY, COLOR_WHITE, municionScale, fuente_balas, "center", "center")
        end
    end
  
  -- Sistema de nivel de búsqueda (wanted level) - DESACTIVADO - No necesario según indicaciones del usuario
  --[[
  if getPlayerWantedLevel(localPlayer) > 0 then
    -- Posición en la esquina inferior derecha, ajustar según necesidad
    local wantedX = 1870 * scale_x
    local wantedY = 270 * scale_y
    
    -- Fondo para el nivel de búsqueda
    dxDrawImage(wantedX - 35, wantedY, 35 * scale_x, 35 * scale_y, "files/wanted_back.png")
    
    -- Dibuja estrellas activas basadas en el nivel de búsqueda actual
    for i = 1, getPlayerWantedLevel(localPlayer) do
      dxDrawImage(wantedX + (-i-1)*30*scale_x, wantedY + 5*scale_y, 27 * scale_x, 29 * scale_y, "weapons/star.png")
    end
    
    -- Estrellas inactivas para completar las 6 posibles
    for i = getPlayerWantedLevel(localPlayer) + 1, 6 do
      dxDrawImage(wantedX + (-i-1)*30*scale_x, wantedY + 10*scale_y, 19 * scale_x, 17 * scale_y, "weapons/star.png", 0, 0, 0, tocolor(50, 50, 50, 120))
    end
  end
  ]]--
  
  -- Nivel de oxígeno cuando el jugador está en el agua - DESACTIVADO - No necesario según indicaciones del usuario
  --[[
  if isElementInWater(localPlayer) then
    -- Posicionamos el indicador de oxígeno debajo del indicador de sed
    local oxygenX = 1820 * scale_x
    local oxygenY = 85 * scale_y
    
    -- Opción 1: Usar el mismo estilo de círculo shader que los otros indicadores
    if circuloShader then
      local oxygenLevel = getPedOxygenLevel(localPlayer) / 10  -- Normalizar a rango 0-100
      aplicarShaderCirculo(oxygenX, oxygenY, 60 * scale_x, 60 * scale_y, tocolor(0, 150, 255, 255), oxygenLevel)
      -- Necesitarías un ícono para el oxígeno, puedes usar uno existente o crear uno nuevo
      -- dxDrawImage(oxygenX + 15 * scale_x, oxygenY + 15 * scale_y, 30 * scale_x, 30 * scale_y, "files/breath_icon.png")
    end
  end
  ]]--
  
  lastTick = getTickCount()
end)

-- Variables para detectar cambios de resolución
local lastSX, lastSY = sx, sy

-- Función para detectar y manejar cambios de resolución
function manejarCambioResolucion()
    local newSX, newSY = guiGetScreenSize()
    if newSX ~= lastSX or newSY ~= lastSY then
        -- La resolución cambió, actualizar variables globales
        sx, sy = newSX, newSY
        scale_x = sx/1920
        scale_y = sy/1080
        lastSX, lastSY = sx, sy
        
        -- Recargar fuentes y shaders con nueva escala
        cargarFuentes()  -- Esto también recarga los shaders
        recalcLayout()
        
        -- Verificar que todo esté dentro de límites seguros (posicionamiento compacto)
        local hudScale = math.min(sx/1920, sy/1080) * 0.9
        local marginTop = sy * 0.02  -- Margen mínimo como estaba originalmente
        local circleSize = 50*hudScale
        local minDistance = marginTop + 25*hudScale - circleSize/2
        
        if minDistance < 5 then
            outputChatBox("[HUD] ⚠️ Resolución pequeña - Ajuste mínimo aplicado", 255, 255, 0)
        else
            outputChatBox("[HUD] ✅ " .. sx .. "x" .. sy .. " - Posición original restaurada", 100, 255, 100)
        end
    end
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
    -- Ocultar HUD original de MTA
    local componentes_hud = {"weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted"}
    for _, componente in ipairs(componentes_hud) do
        setPlayerHudComponentVisible(componente, false)
    end
    
    -- Cargar fuentes y shaders
    cargarFuentes()
    -- Preload HUD textures (TX) para evitar cargar rutas cada frame
    TX.bg_ext_efectivo = dxCreateTexture("files/newinterface2/bgexterior-efectivo.png")
    TX.bg_ext_bank      = dxCreateTexture("files/newinterface2/bgexterior-bank.png")
    TX.bg_int_efectivo = dxCreateTexture("files/newinterface2/bginterior-efectivo.png")
    TX.bg_int_bank     = dxCreateTexture("files/newinterface2/bginterior-bank.png")
    TX.icon_efectivo   = dxCreateTexture("files/newinterface2/icon-efectivo.png")
    TX.icon_bank       = dxCreateTexture("files/newinterface2/icon-bank.png")
    TX.icon_vida       = dxCreateTexture("files/newinterface2/icon-vida.png")
    TX.icon_armour     = dxCreateTexture("files/newinterface2/icon-armour.png")
    TX.icon_hambre     = dxCreateTexture("files/newinterface2/icon-hambre.png")
    TX.icon_agua       = dxCreateTexture("files/newinterface2/icon-agua.png")
    recalcLayout()
    
    -- Inicializar valores
    lastUpdate = getTickCount()
    lastWeaponUpdate = getTickCount()
    
    -- Timer para detectar cambios de resolución cada 2 segundos
    setTimer(manejarCambioResolucion, 5000, 0)
    
    -- Solicitar el saldo bancario al iniciar
    triggerServerEvent("onRequestBalance", localPlayer, localPlayer)
    
    -- Solicitar actualizaciones periódicas del saldo
    setTimer(function()
        triggerServerEvent("onRequestBalance", localPlayer, localPlayer)
    end, 10000, 0)  -- Cada 10 segundos
    
    outputChatBox("[HUD] HUD Capital cargado - Posición original + Sistema adaptativo - " .. sx .. "x" .. sy, 100, 255, 100)
end)

-- Comandos del HUD
addCommandHandler("hideHud", function()
    mostrar_hud = not mostrar_hud
    outputChatBox("HUD "..(mostrar_hud and "visible" or "oculto"), 255, 255, 255)
end)

-- Comando de debug para el HUD restaurado a posición original
addCommandHandler("hudDebug", function()
    outputChatBox("=== HUD DEBUG - POSICIÓN ORIGINAL RESTAURADA ===", 255, 255, 0)
    outputChatBox("HUD Visible: " .. (mostrar_hud and "SI" or "NO"), 255, 255, 255)
    outputChatBox("Resolución actual: " .. sx .. "x" .. sy, 255, 255, 255)
    
    -- Información del sistema adaptativo
    local hudScale = math.min(sx/1920, sy/1080) * 0.9
    local fontScale = math.min(sx/1920, sy/1080)
    outputChatBox("Escala HUD: " .. string.format("%.3f", hudScale), 200, 200, 255)
    
    -- Información de posicionamiento compacto restaurado
    local marginRight = sx * 0.01
    local marginTop = sy * 0.02
    local circleSize = 50*hudScale
    outputChatBox("Margen derecho: " .. math.floor(marginRight) .. "px (1%)", 150, 255, 150)
    outputChatBox("Margen superior: " .. math.floor(marginTop) .. "px (2% - Original)", 150, 255, 150)
    outputChatBox("Posición: Esquina superior derecha compacta", 200, 255, 200)
    
    -- Estados
    outputChatBox("Vida: " .. textoCache.vida, 255, 100, 100)
    outputChatBox("Armadura: " .. textoCache.armadura, 200, 200, 200)
    outputChatBox("Hambre: " .. textoCache.hambre, 255, 255, 0)
    outputChatBox("Sed: " .. textoCache.sed, 100, 150, 255)
    outputChatBox("Dinero: " .. textoCache.dinero, 100, 255, 100)
    outputChatBox("Banco: " .. formatear(banco), 100, 255, 100)
    outputChatBox("Arma: ID " .. arma_actual, 255, 255, 255)
    outputChatBox("Sistema: Adaptativo + Posición Original", 100, 255, 200)
end)

-- Comando para probar adaptabilidad
addCommandHandler("testAdaptativo", function()
    outputChatBox("=== PRUEBA DE ADAPTABILIDAD ===", 255, 255, 0)
    outputChatBox("Cambia la resolución o modo de ventana y el HUD se adaptará automáticamente", 255, 255, 255)
    outputChatBox("El sistema detecta cambios cada 2 segundos", 200, 200, 200)
    
    -- Mostrar información para diferentes resoluciones comunes
    local resoluciones = {
        {1920, 1080, "Full HD"},
        {1366, 768, "HD estándar"},
        {1280, 720, "HD 720p"},
        {1440, 900, "WXGA+"},
        {1600, 900, "HD+ 16:9"},
        {2560, 1440, "QHD"}
    }
    
    outputChatBox("Resoluciones soportadas:", 255, 255, 255)
    for _, res in ipairs(resoluciones) do
        local scale = math.min(res[1]/1920, res[2]/1080) * 0.9
        outputChatBox(res[3] .. " (" .. res[1] .. "x" .. res[2] .. ") - Escala: " .. string.format("%.2f", scale), 200, 255, 200)
    end
end)

-- Eventos adicionales para controlar visibilidad del HUD desde otros recursos
addEvent("hud:ocultar", true)
addEventHandler("hud:ocultar", root, function()
  mostrar_hud = false
end)

addEvent("hud:mostrar", true)
addEventHandler("hud:mostrar", root, function()
  mostrar_hud = true
end)

-- Eventos compatibles con CHUD
addEvent("hud:guaroSirilo", true)
addEventHandler("hud:guaroSirilo", root, function()
  mostrar_hud = false
   showChat(false)
end)

addEvent("mostrar:hudSirilo", true)
addEventHandler("mostrar:hudSirilo", root, function()
  mostrar_hud = true
   showChat(true)
end)






