-- Sistema de HUD para muerte y cuenta regresiva
local deathTimeRemaining = 0 -- Tiempo restante en segundos
local isDead = false
local screenWidth, screenHeight = guiGetScreenSize()

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

-- Renderizar el HUD de muerte
addEventHandler("onClientRender", root, function()
    if isDead and deathTimeRemaining > 0 then
        -- Calcular minutos y segundos
        local minutes = math.floor(deathTimeRemaining / 60)
        local seconds = math.floor(deathTimeRemaining % 60)
        
        -- Texto principal
        local mainText = "HAS MUERTO"
        local timeText = ""
        
        if minutes > 0 then
            timeText = string.format("Serás trasladado al hospital en %d:%02d", minutes, seconds)
        else
            timeText = string.format("Serás trasladado al hospital en %d segundos", seconds)
        end
        
        -- Dibujar fondo semi-transparente
        dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 180), false)
        
        -- Dibujar texto principal (HAS MUERTO)
        dxDrawText(mainText, 
            screenWidth / 2, screenHeight / 2 - 80, 
            screenWidth / 2, screenHeight / 2 - 80,
            tocolor(255, 0, 0, 255), 
            3.0, "default-bold", "center", "center", false, false, false, false, false)
        
        -- Dibujar cuenta regresiva
        dxDrawText(timeText, 
            screenWidth / 2, screenHeight / 2 - 20, 
            screenWidth / 2, screenHeight / 2 - 20,
            tocolor(255, 255, 0, 255), 
            2.0, "default-bold", "center", "center", false, false, false, false, false)
        
        -- Dibujar barra de progreso
        local progress = 1 - (deathTimeRemaining / 360) -- 360 segundos = 6 minutos
        local barWidth = screenWidth * 0.4
        local barHeight = 20
        local barX = (screenWidth - barWidth) / 2
        local barY = screenHeight / 2 + 20
        
        -- Fondo de la barra
        dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(50, 50, 50, 200), false)
        
        -- Barra de progreso
        dxDrawRectangle(barX, barY, barWidth * progress, barHeight, tocolor(255, 0, 0, 200), false)
        
        -- Borde de la barra
        dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(255, 255, 255, 100), false)
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

