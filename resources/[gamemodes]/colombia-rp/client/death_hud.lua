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
        
        -- Dibujar fondo semi-transparente
        dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 180), false)
        
        -- Dibujar texto principal (HAS MUERTO)
        dxDrawText("HAS MUERTO", 
            screenWidth / 2, screenHeight / 2 - 120, 
            screenWidth / 2, screenHeight / 2 - 120,
            tocolor(255, 0, 0, 255), 
            3.0, "default-bold", "center", "center", false, false, false, false, false)
        
        -- Dibujar contador grande (solo números)
        local timeText = ""
        if minutes > 0 then
            timeText = string.format("%d:%02d", minutes, seconds)
        else
            timeText = string.format("%d", seconds)
        end
        
        -- Contador grande en el centro
        dxDrawText(timeText, 
            screenWidth / 2, screenHeight / 2 - 20, 
            screenWidth / 2, screenHeight / 2 - 20,
            tocolor(255, 255, 0, 255), 
            5.0, "default-bold", "center", "center", false, false, false, false, false)
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
    -- Debug: mostrar en chat cada 10 segundos
    if seconds % 10 == 0 or seconds <= 10 then
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60
        outputChatBox("[DEBUG] Tiempo restante: " .. string.format("%d:%02d", minutes, secs), 255, 255, 0)
    end
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

