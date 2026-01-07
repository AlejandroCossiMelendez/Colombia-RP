-- alcohol_c.lua - Sistema de efectos de embriaguez
-- Efectos: Mareo, animaciones, bloqueo de teclas, borrachera

local localPlayer = getLocalPlayer()

-- Variables para controlar la embriaguez
local nivelEmbriaguez = 0  -- 0 = Sobrio, 100 = Muy borracho
local efectoActivo = false
local ultimoNivelMostrado = 0  -- Para evitar spam de mensajes
local timers = {}
local handlers = {}

-- Función para aplicar efecto de mareo visual
function aplicarMareoVisual()
    if nivelEmbriaguez > 20 then
        -- Efecto de cámara tambaleante (más intenso cuando está muy borracho)
        local intensidad = nivelEmbriaguez / 100
        
        if nivelEmbriaguez >= 80 then
            -- Muy borracho: movimiento extremo de cámara
            setCameraShakeLevel(math.floor(intensidad * 120)) -- Mucho más intenso
        elseif nivelEmbriaguez >= 60 then
            -- Borracho: movimiento medio-alto
            setCameraShakeLevel(math.floor(intensidad * 80))
        else
            -- Mareado: movimiento normal
            setCameraShakeLevel(math.floor(intensidad * 50))
        end
        
        -- Cambiar color de pantalla ligeramente
        local blur = nivelEmbriaguez / 200
        setColorFilter(255 - blur * 50, 255 - blur * 30, 255 - blur * 100, 255 - blur * 20, 255 - blur * 30, 255 - blur * 100, 255 - blur * 20, 255 - blur * 30, 255 - blur * 100)
        
        -- Parpadeo negro cuando está muy borracho (80%+)
        if nivelEmbriaguez >= 80 then
            aplicarParpadeoNegro()
        end
    end
end

-- Función para crear efecto de parpadeo negro
function aplicarParpadeoNegro()
    -- Solo aplicar si no hay ya un parpadeo activo
    if not timers.parpadeo then
        timers.parpadeo = setTimer(function()
            -- Parpadeo aleatorio cada 3-8 segundos
            if math.random(1, 100) <= 30 then -- 30% de probabilidad
                -- Fade a negro por un momento
                fadeCamera(false, 0.3, 0, 0, 0)
                
                -- Volver a la normalidad después de 0.5-1 segundo
                setTimer(function()
                    fadeCamera(true, 0.5)
                end, math.random(500, 1000), 1)
            end
        end, math.random(3000, 8000), 0) -- Cada 3-8 segundos
    end
end

-- Función para detener el parpadeo negro
function detenerParpadeoNegro()
    if timers.parpadeo and isTimer(timers.parpadeo) then
        killTimer(timers.parpadeo)
        timers.parpadeo = nil
        fadeCamera(true, 0.5) -- Asegurar que la cámara esté normal
    end
end

-- Función para bloquear teclas de cancelar animación
function bloquearTeclas()
    if nivelEmbriaguez > 30 then
        -- Bloquear Space (cancelar animación)
        bindKey("space", "down", function() 
            cancelEvent()
            -- Sin mensaje para evitar spam cuando presiona space
        end)
        
        -- Bloquear algunas teclas de movimiento cuando está muy borracho
        if nivelEmbriaguez > 70 then
            bindKey("lshift", "down", function() cancelEvent() end) -- Correr
            bindKey("rshift", "down", function() cancelEvent() end)
        end
    end
end

-- Función para liberar todas las teclas bloqueadas
function liberarTeclas()
    unbindKey("space", "down")
    unbindKey("lshift", "down")
    unbindKey("rshift", "down")
end

-- Función para aplicar animaciones de borracho
function aplicarAnimacionBorracho()
    if nivelEmbriaguez >= 40 then
        -- Diferentes niveles de borrachera
        if nivelEmbriaguez >= 80 then
            -- Muy borracho - Se tambalea y cae
            setPedAnimation(localPlayer, "PED", "WALK_drunk", -1, true, true, true, false)
            
            -- Posibilidad de caerse cada cierto tiempo
            if math.random(1, 100) <= 10 then -- 10% de posibilidad (menos frecuente)
                setPedAnimation(localPlayer, "PED", "KO_skid_front", 3000, false, false, false, false)
                -- Sin mensaje para evitar spam
            end
            
        elseif nivelEmbriaguez >= 60 then
            -- Moderadamente borracho - Camina raro
            setPedAnimation(localPlayer, "PED", "WALK_drunk", -1, true, true, true, false)
            
        elseif nivelEmbriaguez >= 40 then
            -- Ligeramente borracho - Animación sutil
            if math.random(1, 100) <= 8 then -- 8% de posibilidad de tambaleo
                setPedAnimation(localPlayer, "PED", "WALK_shuffle", 2000, false, false, false, false)
            end
        end
    end
end

-- Función principal para consumir cerveza (efecto ligero)
function consumirCerveza()
    nivelEmbriaguez = math.min(100, nivelEmbriaguez + 8)
    outputChatBox("[CERVEZA] Bebes cerveza - Embriaguez: " .. nivelEmbriaguez .. "%", 255, 200, 100)
    activarEfectosEmbriaguez()
end

-- Función principal para consumir whisky (efecto medio)
function consumirWhisky()
    nivelEmbriaguez = math.min(100, nivelEmbriaguez + 15)
    outputChatBox("[WHISKY] Bebes whisky - Embriaguez: " .. nivelEmbriaguez .. "%", 255, 150, 50)
    activarEfectosEmbriaguez()
end

-- Función principal para consumir ron (efecto medio-alto)
function consumirRon()
    nivelEmbriaguez = math.min(100, nivelEmbriaguez + 18)
    outputChatBox("[RON] Bebes ron - Embriaguez: " .. nivelEmbriaguez .. "%", 200, 100, 50)
    activarEfectosEmbriaguez()
end

-- Función principal para consumir vodka (efecto alto)
function consumirVodka()
    nivelEmbriaguez = math.min(100, nivelEmbriaguez + 22)
    outputChatBox("[VODKA] Bebes vodka - Embriaguez: " .. nivelEmbriaguez .. "%", 150, 150, 255)
    activarEfectosEmbriaguez()
end

-- Función principal para consumir tequila (efecto muy alto)
function consumirTequila()
    nivelEmbriaguez = math.min(100, nivelEmbriaguez + 25)
    outputChatBox("[TEQUILA] Bebes tequila - Embriaguez: " .. nivelEmbriaguez .. "%", 255, 100, 100)
    activarEfectosEmbriaguez()
end

-- Función para activar todos los efectos según el nivel
function activarEfectosEmbriaguez()
    if not efectoActivo then
        efectoActivo = true
        iniciarEfectosContinuos()
        iniciarSobriedad() -- Solo iniciar una vez
    end
    
    aplicarMareoVisual()
    bloquearTeclas()
    aplicarAnimacionBorracho()
    
    -- Solo mostrar cambios significativos de estado (cada 20%)
    local nivelActual = math.floor(nivelEmbriaguez / 20) * 20
    if nivelActual ~= ultimoNivelMostrado then
        ultimoNivelMostrado = nivelActual
        
        if nivelEmbriaguez >= 80 then
            outputChatBox("[ALCOHOL] Estas completamente borracho.", 255, 50, 50)
        elseif nivelEmbriaguez >= 60 then
            outputChatBox("[ALCOHOL] Estas muy borracho.", 255, 100, 50)
        elseif nivelEmbriaguez >= 40 then
            outputChatBox("[ALCOHOL] Estas moderadamente borracho.", 255, 150, 50)
        elseif nivelEmbriaguez >= 20 then
            outputChatBox("[ALCOHOL] Te sientes alegre.", 200, 200, 100)
        end
    end
end

-- Función para efectos continuos mientras está borracho
function iniciarEfectosContinuos()
    -- Timer para efectos visuales continuos (sin mensajes)
    timers.efectosVisuales = setTimer(function()
        if nivelEmbriaguez > 0 then
            aplicarMareoVisual()
            aplicarAnimacionBorracho()
        else
            -- Si ya no está borracho, detener parpadeo
            detenerParpadeoNegro()
        end
    end, 3000, 0) -- Cada 3 segundos para mejor respuesta de efectos visuales
end

-- Función para recuperarse gradualmente de la borrachera
function iniciarSobriedad()
    -- Limpiar timer anterior si existe
    if timers.sobriedad then
        killTimer(timers.sobriedad)
    end
    
    -- Timer para reducir embriaguez gradualmente
    timers.sobriedad = setTimer(function()
        if nivelEmbriaguez > 0 then
            local nivelAnterior = nivelEmbriaguez
            nivelEmbriaguez = nivelEmbriaguez - 5 -- Reducir 5% cada 20 segundos (recuperación en 6-7 min)
            
            if nivelEmbriaguez <= 0 then
                nivelEmbriaguez = 0
                terminarEfectosEmbriaguez()
            else
                -- Solo mostrar mensaje cada 25% de reducción
                if math.floor(nivelAnterior / 25) > math.floor(nivelEmbriaguez / 25) then
                    if nivelEmbriaguez <= 25 then
                        outputChatBox("[ALCOHOL] Te estas recuperando de la borrachera... (" .. nivelEmbriaguez .. "%)", 150, 200, 150)
                    end
                end
                
                -- Actualizar efectos según nuevo nivel
                aplicarMareoVisual()
                if nivelEmbriaguez < 30 then
                    liberarTeclas()
                end
                
                -- Detener parpadeo si baja de 80%
                if nivelEmbriaguez < 80 then
                    detenerParpadeoNegro()
                end
            end
        end
    end, 20000, 0) -- Cada 20 segundos se reduce el nivel (recuperación completa en 6-7 min)
end

-- Función para terminar todos los efectos de embriaguez
function terminarEfectosEmbriaguez()
    efectoActivo = false
    nivelEmbriaguez = 0
    ultimoNivelMostrado = 0
    
    -- Limpiar efectos visuales
    setCameraShakeLevel(0)
    resetColorFilter()
    detenerParpadeoNegro()
    
    -- Liberar teclas
    liberarTeclas()
    
    -- Parar animaciones
    setPedAnimation(localPlayer)
    
    -- Limpiar timers
    for nombre, timer in pairs(timers) do
        if isTimer(timer) then
            killTimer(timer)
        end
    end
    timers = {}
    
    -- Mensaje claro de recuperación completa
    outputChatBox("[ALCOHOL] Ya no estas borracho. Te has recuperado completamente.", 100, 255, 100)
end

-- Eventos para cada tipo de alcohol
addEvent("alcohol.cerveza", true)
addEventHandler("alcohol.cerveza", getRootElement(), consumirCerveza)

addEvent("alcohol.whisky", true)
addEventHandler("alcohol.whisky", getRootElement(), consumirWhisky)

addEvent("alcohol.ron", true)
addEventHandler("alcohol.ron", getRootElement(), consumirRon)

addEvent("alcohol.vodka", true)
addEventHandler("alcohol.vodka", getRootElement(), consumirVodka)

addEvent("alcohol.tequila", true)
addEventHandler("alcohol.tequila", getRootElement(), consumirTequila)

-- Limpiar efectos al desconectarse o parar resource
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
    terminarEfectosEmbriaguez()
end)

-- Comando para verificar nivel de embriaguez (debug)
addCommandHandler("embriaguez", function()
    outputChatBox("Nivel actual de embriaguez: " .. nivelEmbriaguez .. "%", 255, 255, 255)
end)
