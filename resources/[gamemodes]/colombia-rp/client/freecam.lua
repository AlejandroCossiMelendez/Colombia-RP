-- Sistema de Freecam para Admins y Staff
-- Permite moverse con la cámara libremente sin mover el personaje

local freecamEnabled = false
local freecamX, freecamY, freecamZ = 0, 0, 0
local freecamRotX, freecamRotY = 0, 0
local freecamSpeed = 0.5
local mouseSensitivity = 0.3 -- Aumentada para mejor respuesta
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
    showCursor(true) -- Mostrar cursor pero lo centraremos
    setElementFrozen(localPlayer, true) -- Congelar al jugador
    
    -- Centrar el cursor inicialmente
    screenW, screenH = guiGetScreenSize()
    setCursorPosition(screenW / 2, screenH / 2)
    lastMouseX, lastMouseY = screenW / 2, screenH / 2
    mouseInitialized = false
    
    -- Obtener rotación inicial de la cámara actual
    local camX, camY, camZ, lx, ly, lz = getCameraMatrix()
    if camX and camY and camZ and lx and ly and lz then
        -- Calcular rotación inicial basada en la dirección de la cámara
        local dx = lx - camX
        local dy = ly - camY
        local dz = lz - camZ
        local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
        if dist > 0 then
            freecamRotX = math.deg(math.asin(dz / dist))
            freecamRotY = math.deg(math.atan2(dx, dy))
        end
    end
    
    outputChatBox("Freecam activado. Usa WASD para moverte, mouse para rotar, Shift para velocidad rápida, Ctrl para lenta.", 0, 255, 0)
    outputChatBox("Usa el panel F10 para desactivar el freecam.", 0, 255, 0)
    
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
local lastMouseX, lastMouseY = 0, 0
local mouseInitialized = false
local centerX, centerY = 0, 0

addEventHandler("onClientCursorMove", root, function(relX, relY, absX, absY)
    if not freecamEnabled then
        mouseInitialized = false
        return
    end
    
    -- Obtener centro de la pantalla
    screenW, screenH = guiGetScreenSize()
    centerX, centerY = screenW / 2, screenH / 2
    
    if not mouseInitialized then
        lastMouseX, lastMouseY = centerX, centerY
        mouseInitialized = true
        setCursorPosition(centerX, centerY)
        return
    end
    
    -- Calcular diferencia desde el centro
    local deltaX = (absX - centerX) * mouseSensitivity
    local deltaY = (absY - centerY) * mouseSensitivity
    
    -- Solo actualizar si hay movimiento significativo
    if math.abs(deltaX) > 0.01 or math.abs(deltaY) > 0.01 then
        freecamRotY = freecamRotY + deltaX
        freecamRotX = freecamRotX - deltaY
        
        -- Limitar rotación vertical
        if freecamRotX > 90 then
            freecamRotX = 90
        elseif freecamRotX < -90 then
            freecamRotX = -90
        end
        
        -- Centrar el cursor de nuevo
        setCursorPosition(centerX, centerY)
        lastMouseX, lastMouseY = centerX, centerY
    end
end)

-- Renderizar freecam (movimiento del mouse se maneja en otro handler)
addEventHandler("onClientRender", root, function()
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

