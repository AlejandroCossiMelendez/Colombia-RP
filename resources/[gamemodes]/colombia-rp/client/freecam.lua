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
    -- No mostrar cursor automáticamente, se mostrará cuando sea necesario
    setElementFrozen(localPlayer, true) -- Congelar al jugador
    
    -- Hacer invisible al jugador mientras usa freecam
    setElementAlpha(localPlayer, 0)
    setPlayerNametagShowing(localPlayer, false)
    
    -- Inicializar variables del mouse
    screenW, screenH = guiGetScreenSize()
    lastMouseX, lastMouseY = screenW / 2, screenH / 2
    mouseInitialized = false
    cursorManuallyReleased = false
    
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
    
    -- Restaurar visibilidad del jugador
    setElementAlpha(localPlayer, 255)
    setPlayerNametagShowing(localPlayer, true)
    
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
    
    -- Movimiento vertical (Space para subir, Ctrl para bajar)
    if getKeyState("space") then
        moveZ = moveZ + freecamSpeed
    end
    if getKeyState("lctrl") or getKeyState("rctrl") then
        -- Bajar más rápido que subir
        moveZ = moveZ - freecamSpeed * 1.5
    end
    
    -- Ajustar velocidad según teclas modificadoras
    local currentSpeed = freecamSpeed
    if getKeyState("lshift") or getKeyState("rshift") then
        currentSpeed = freecamSpeed * 3 -- Velocidad rápida
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

-- Variable para rastrear si el cursor fue liberado manualmente (tecla M)
local cursorManuallyReleased = false

-- Función para verificar si hay un GUI abierto
function isGUIOpen()
    -- Verificar si hay ventanas GUI activas en el recurso
    local windows = getElementsByType("gui-window", resourceRoot)
    for _, window in ipairs(windows) do
        if isElement(window) and guiGetVisible(window) then
            return true
        end
    end
    
    -- Verificar si hay otros elementos GUI visibles
    local buttons = getElementsByType("gui-button", resourceRoot)
    for _, button in ipairs(buttons) do
        if isElement(button) and guiGetVisible(button) then
            local parent = guiGetParent(button)
            if parent and isElement(parent) and getElementType(parent) == "gui-window" and guiGetVisible(parent) then
                return true
            end
        end
    end
    
    return false
end

-- Detectar cuando se presiona M para liberar/ocultar el cursor
addEventHandler("onClientKey", root, function(key, press)
    if freecamEnabled and key == "m" and press then
        -- Toggle: si el cursor está liberado, ocultarlo; si está oculto, liberarlo
        if cursorManuallyReleased then
            -- Segunda vez: ocultar cursor y volver al modo de control de cámara
            cursorManuallyReleased = false
            showCursor(false)
            outputChatBox("Cursor ocultado. Modo de control de cámara activado.", 0, 255, 0)
        else
            -- Primera vez: liberar cursor
            cursorManuallyReleased = true
            showCursor(true)
            outputChatBox("Cursor liberado. Presiona M de nuevo para ocultarlo.", 255, 255, 0)
        end
    end
end)

addEventHandler("onClientCursorMove", root, function(relX, relY, absX, absY)
    if not freecamEnabled then
        mouseInitialized = false
        return
    end
    
    -- Si hay un GUI abierto o el cursor fue liberado manualmente, no centrar el cursor ni rotar la cámara
    if isGUIOpen() or cursorManuallyReleased then
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
        
        -- Centrar el cursor de nuevo solo si no hay GUI abierto y no fue liberado manualmente
        if not isGUIOpen() and not cursorManuallyReleased then
            setCursorPosition(centerX, centerY)
            lastMouseX, lastMouseY = centerX, centerY
        end
    end
end)

-- Renderizar freecam (movimiento del mouse se maneja en otro handler)
addEventHandler("onClientRender", root, function()
    if freecamEnabled then
        -- Solo actualizar la cámara si no hay GUI abierto
        if not isGUIOpen() and not cursorManuallyReleased then
            updateFreecam()
            
            -- Si el cursor no está visible, mostrarlo y centrarlo para el control de la cámara
            if not isCursorShowing() then
                showCursor(true)
                screenW, screenH = guiGetScreenSize()
                local centerX, centerY = screenW / 2, screenH / 2
                setCursorPosition(centerX, centerY)
            end
        else
            -- Si hay GUI abierto o cursor liberado, solo actualizar la posición de la cámara sin centrar el cursor
            updateFreecam()
        end
    end
end)

-- Sistema de teleport con click derecho
local rightClickPressed = false

-- Detectar cuando se presiona click derecho
addEventHandler("onClientClick", root, function(button, state, absX, absY, worldX, worldY, worldZ, clickedElement)
    if not freecamEnabled then
        return
    end
    
    if button == "right" then
        rightClickPressed = (state == "down")
        
        if state == "down" then
            -- Verificar permisos
            if not canUseFreecam() then
                return
            end
            
            -- Obtener posición de la cámara
            local camX, camY, camZ, lx, ly, lz = getCameraMatrix()
            if not camX or not camY or not camZ then
                return
            end
            
            -- Obtener posición del cursor en el mundo usando getWorldFromScreenPosition
            local screenW, screenH = guiGetScreenSize()
            local centerX, centerY = screenW / 2, screenH / 2
            
            -- Convertir posición del cursor a coordenadas del mundo
            local worldX, worldY, worldZ = getWorldFromScreenPosition(centerX, centerY, 1000)
            
            if worldX and worldY and worldZ then
                -- Usar processLineOfSight desde la cámara hasta el punto calculado
                local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(
                    camX, camY, camZ,
                    worldX, worldY, worldZ,
                    true, true, false, true, false, false, false, false, localPlayer
                )
                
                if hit then
                    -- Ajustar altura para estar sobre el suelo
                    hitZ = hitZ + 2.0
                else
                    -- Si no hay hit, buscar el suelo debajo del punto calculado
                    local groundHit, groundX, groundY, groundZ = processLineOfSight(
                        worldX, worldY, worldZ + 50,
                        worldX, worldY, worldZ - 200,
                        true, true, false, true, false, false, false, false, localPlayer
                    )
                    
                    if groundHit then
                        hitX, hitY, hitZ = groundX, groundY, groundZ + 2.0
                    else
                        -- Si no se encuentra suelo, usar el punto calculado directamente
                        hitX, hitY, hitZ = worldX, worldY, worldZ
                    end
                end
                
                -- Teleportar al admin
                triggerServerEvent("admin:freecamTeleport", localPlayer, hitX, hitY, hitZ)
                
                outputChatBox("Te has teleportado a la posición seleccionada.", 0, 255, 0)
            end
        end
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

