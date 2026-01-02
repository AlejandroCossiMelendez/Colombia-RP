-- Sistema de Freecam para Admins y Staff
-- Permite moverse con la cámara libremente sin mover el personaje

local freecamEnabled = false
local freecamX, freecamY, freecamZ = 0, 0, 0
local freecamRotX, freecamRotY = 0, 0
local freecamSpeed = 0.5
local mouseSensitivity = 0.15
local screenW, screenH = guiGetScreenSize()

-- Función para verificar si el jugador es admin o staff
function canUseFreecam()
    if not getElementData(localPlayer, "character:selected") then
        return false
    end
    
    local role = getElementData(localPlayer, "account:role")
    return role == "admin" or role == "staff" or role == "moderator"
end

-- Función para activar freecam
function enableFreecam()
    if not canUseFreecam() then
        outputChatBox("No tienes permiso para usar el freecam.", 255, 0, 0)
        return false
    end
    
    if freecamEnabled then
        return false
    end
    
    -- Obtener posición actual del jugador
    local px, py, pz = getElementPosition(localPlayer)
    local camX, camY, camZ, lx, ly, lz = getCameraMatrix()
    
    -- Inicializar posición de freecam
    if camX and camY and camZ then
        freecamX, freecamY, freecamZ = camX, camY, camZ
    else
        freecamX, freecamY, freecamZ = px, py, pz + 2
    end
    
    -- Inicializar rotación
    freecamRotX = 0
    freecamRotY = 0
    
    freecamEnabled = true
    showCursor(true)
    setElementFrozen(localPlayer, true) -- Congelar al jugador
    
    -- Centrar el cursor
    screenW, screenH = guiGetScreenSize()
    setCursorPosition(screenW / 2, screenH / 2)
    
    outputChatBox("Freecam activado. Usa WASD para moverte, mouse para rotar, Shift para velocidad rápida, Ctrl para lenta.", 0, 255, 0)
    outputChatBox("Presiona F11 o usa el panel para desactivar el freecam.", 0, 255, 0)
    
    return true
end

-- Función para desactivar freecam
function disableFreecam()
    if not freecamEnabled then
        return false
    end
    
    freecamEnabled = false
    showCursor(false)
    setElementFrozen(localPlayer, false) -- Descongelar al jugador
    
    -- Restaurar cámara al jugador
    setCameraTarget(localPlayer)
    
    outputChatBox("Freecam desactivado.", 255, 255, 0)
    
    return true
end

-- Función para actualizar la posición de la cámara
function updateFreecam()
    if not freecamEnabled then
        return
    end
    
    -- Obtener teclas presionadas
    local moveX, moveY, moveZ = 0, 0, 0
    
    -- Movimiento hacia adelante/atrás (W/S)
    if getKeyState("w") then
        moveX = moveX + math.sin(math.rad(freecamRotY)) * freecamSpeed
        moveY = moveY + math.cos(math.rad(freecamRotY)) * freecamSpeed
    end
    if getKeyState("s") then
        moveX = moveX - math.sin(math.rad(freecamRotY)) * freecamSpeed
        moveY = moveY - math.cos(math.rad(freecamRotY)) * freecamSpeed
    end
    
    -- Movimiento lateral (A/D)
    if getKeyState("a") then
        moveX = moveX - math.cos(math.rad(freecamRotY)) * freecamSpeed
        moveY = moveY + math.sin(math.rad(freecamRotY)) * freecamSpeed
    end
    if getKeyState("d") then
        moveX = moveX + math.cos(math.rad(freecamRotY)) * freecamSpeed
        moveY = moveY - math.sin(math.rad(freecamRotY)) * freecamSpeed
    end
    
    -- Movimiento vertical (Q/E o Space/Ctrl)
    if getKeyState("space") then
        moveZ = moveZ + freecamSpeed
    end
    if getKeyState("lctrl") or getKeyState("rctrl") then
        moveZ = moveZ - freecamSpeed
    end
    
    -- Ajustar velocidad según teclas modificadoras
    local currentSpeed = freecamSpeed
    if getKeyState("lshift") or getKeyState("rshift") then
        currentSpeed = freecamSpeed * 3 -- Velocidad rápida
    elseif getKeyState("lctrl") or getKeyState("rctrl") then
        if not getKeyState("space") then
            currentSpeed = freecamSpeed * 0.3 -- Velocidad lenta
        end
    end
    
    -- Aplicar movimiento
    freecamX = freecamX + moveX * (currentSpeed / freecamSpeed)
    freecamY = freecamY + moveY * (currentSpeed / freecamSpeed)
    freecamZ = freecamZ + moveZ * (currentSpeed / freecamSpeed)
    
    -- Calcular dirección de la cámara
    local camX = freecamX
    local camY = freecamY
    local camZ = freecamZ
    
    local lookX = freecamX + math.sin(math.rad(freecamRotY)) * math.cos(math.rad(freecamRotX))
    local lookY = freecamY + math.cos(math.rad(freecamRotY)) * math.cos(math.rad(freecamRotX))
    local lookZ = freecamZ + math.sin(math.rad(freecamRotX))
    
    -- Establecer matriz de cámara
    setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
end

-- Manejar movimiento del mouse para rotar la cámara
addEventHandler("onClientCursorMove", root, function(relX, relY, absX, absY)
    if not freecamEnabled then
        return
    end
    
    -- Usar movimiento relativo del mouse
    local deltaX = relX * mouseSensitivity
    local deltaY = relY * mouseSensitivity
    
    freecamRotY = freecamRotY + deltaX
    freecamRotX = freecamRotX - deltaY
    
    -- Limitar rotación vertical
    if freecamRotX > 90 then
        freecamRotX = 90
    elseif freecamRotX < -90 then
        freecamRotX = -90
    end
end)

-- Renderizar freecam
addEventHandler("onClientPreRender", root, function()
    if freecamEnabled then
        updateFreecam()
    end
end)

-- El freecam solo se activa desde el panel F10, no hay bind de tecla

-- Desactivar freecam si el jugador muere o se desconecta
addEventHandler("onClientPlayerWasted", localPlayer, function()
    if freecamEnabled then
        disableFreecam()
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    if freecamEnabled then
        disableFreecam()
    end
end)

-- Exportar funciones para el panel
function isFreecamEnabled()
    return freecamEnabled
end

function toggleFreecam()
    if freecamEnabled then
        disableFreecam()
    else
        enableFreecam()
    end
end

