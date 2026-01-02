-- Sistema de HUD para muerte y cuenta regresiva - RESPONSIVE
local deathTimeRemaining = 0
local isDead = false

-- Función para iniciar la cuenta regresiva de muerte
function startDeathCountdown(seconds)
    deathTimeRemaining = seconds
    isDead = true
end

-- Función para detener la cuenta regresiva
function stopDeathCountdown()
    deathTimeRemaining = 0
    isDead = false
end

-- Función para actualizar el tiempo restante
function updateDeathTime(seconds)
    deathTimeRemaining = seconds
end

-- Renderizar el HUD de muerte - RESPONSIVE
addEventHandler("onClientRender", root, function()
    if isDead and deathTimeRemaining > 0 then
        -- Obtener dimensiones de pantalla
        local sw, sh = guiGetScreenSize()
        
        -- Calcular minutos y segundos
        local minutes = math.floor(deathTimeRemaining / 60)
        local seconds = math.floor(deathTimeRemaining % 60)
        
        -- Fondo semi-transparente (responsivo)
        dxDrawRectangle(0, 0, sw, sh, tocolor(0, 0, 0, 180), false)
        
        -- Tamaño de fuente responsivo
        local titleSize = math.max(2.0, math.min(3.5, sw / 400))
        local countdownSize = math.max(4.0, math.min(7.0, sw / 250))
        
        -- Texto principal "HAS MUERTO" (centrado, responsivo)
        dxDrawText("HAS MUERTO", 
                   sw / 2, sh / 2 - (sh * 0.15), 
                   sw / 2, sh / 2 - (sh * 0.15),
                   tocolor(255, 0, 0, 255), 
                   titleSize, "default-bold", "center", "center", 
                   false, false, false, false, false)
        
        -- Contador grande (solo números) - RESPONSIVE
        local timeText = ""
        if minutes > 0 then
            timeText = string.format("%d:%02d", minutes, seconds)
        else
            timeText = string.format("%d", seconds)
        end
        
        -- Contador grande en el centro (responsivo)
        dxDrawText(timeText, 
                   sw / 2, sh / 2 - (sh * 0.05), 
                   sw / 2, sh / 2 - (sh * 0.05),
                   tocolor(255, 255, 0, 255), 
                   countdownSize, "default-bold", "center", "center", 
                   false, false, false, false, false)
    end
end)

-- Variables para la cámara de muerte
local deathCameraPos = nil
local deathCameraTarget = nil

-- Mantener la cámara fija cuando está muerto
addEventHandler("onClientPreRender", root, function()
    if isDead and deathCameraPos and deathCameraTarget then
        setCameraMatrix(deathCameraPos[1], deathCameraPos[2], deathCameraPos[3], 
                       deathCameraTarget[1], deathCameraTarget[2], deathCameraTarget[3])
    end
end)

-- Eventos del servidor
addEvent("onClientPlayerDeath", true)
addEventHandler("onClientPlayerDeath", resourceRoot, function(seconds)
    startDeathCountdown(seconds)
    
    -- Fijar cámara en el lugar de la muerte
    setTimer(function()
        if isDead then
            local x, y, z = getElementPosition(localPlayer)
            -- Guardar posición de la cámara
            deathCameraPos = {x, y, z + 3} -- 3 metros arriba del cuerpo
            deathCameraTarget = {x, y, z} -- Mirar hacia el cuerpo
            
            -- Configurar cámara fija
            setCameraMatrix(deathCameraPos[1], deathCameraPos[2], deathCameraPos[3], 
                           deathCameraTarget[1], deathCameraTarget[2], deathCameraTarget[3])
        end
    end, 200, 1)
end)

addEvent("updateDeathTime", true)
addEventHandler("updateDeathTime", resourceRoot, function(seconds)
    updateDeathTime(seconds)
end)

addEvent("onClientPlayerRevived", true)
addEventHandler("onClientPlayerRevived", resourceRoot, function()
    stopDeathCountdown()
    -- Limpiar posición de cámara
    deathCameraPos = nil
    deathCameraTarget = nil
    -- Restaurar cámara normal
    setCameraTarget(localPlayer, localPlayer)
end)
