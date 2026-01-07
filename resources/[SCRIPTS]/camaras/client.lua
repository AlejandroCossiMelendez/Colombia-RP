-- Sistema de resolución mejorado y adaptativo
local screenX, screenY = guiGetScreenSize()
local aspectRatio = screenX / screenY
local baseWidth, baseHeight = 1920, 1080
local scaleX = screenX / baseWidth
local scaleY = screenY / baseHeight
local scale = math.min(scaleX, scaleY)

-- Configuración responsiva para UI
local UI_CONFIG = {
    controlPanel = {
        x = 0.7,        -- 70% desde la izquierda
        y = 0.6,        -- 60% desde arriba
        width = 0.25,   -- 25% del ancho de pantalla
        height = 0.35   -- 35% del alto de pantalla
    },
    buttons = {
        size = math.max(60 * scale, 40),  -- Mínimo 40px
        spacing = math.max(10 * scale, 5)
    },
    fonts = {
        title = math.max(1.2 * scale, 0.8),
        normal = math.max(1.0 * scale, 0.7),
        small = math.max(0.8 * scale, 0.6)
    }
}

local fonts = {
    figmaFonts = {},
    system = {}
}

local camerasActive = false
local cameraLocations = {}
local currentLocation = nil
local currentCamera = 1

-- Variables para controlar la rotación continua
local isRotatingLeft = false
local isRotatingRight = false
local rotationSpeed = 50.0
local lastFrameTime = 0

-- Variables para efectos visuales
local scanLineOffset = 0
local noiseTimer = 0
local lastTick = getTickCount()

-- Estado de la interfaz
local showingLocationSelector = false

-- Variables para almacenar la posición original
local originalX, originalY, originalZ
local originalInt, originalDim

-- Variable para prevenir la reactivación inmediata
local exitCooldown = false

function unloadFonts()
    for k,v in pairs(fonts) do
        if v and isElement(v) then destroyElement(v) end
    end
    fonts = {
        figmaFonts = {},
    }
end

function loadFonts(array)
    unloadFonts()
    for _,v in pairs(array) do
        fonts[v[1]] = dxCreateFont(v[2], v[3], v[4], 'proof')
    end
end

function getFigmaFont(font, size)
    local figmaFonts = fonts.figmaFonts
    if not figmaFonts[font..size] then
        figmaFonts[font..size] = exports['figma']:getFont(font, size)
    end

    return figmaFonts[font..size]
end

-- Función optimizada para efectos CCTV responsivos
function applyCCTVEffect()
    -- Calcular tiempo delta para animaciones
    local currentTick = getTickCount()
    local delta = (currentTick - lastTick) / 1000
    lastTick = currentTick
    
    -- Actualizar desplazamiento de líneas de escaneo
    scanLineOffset = (scanLineOffset + delta * 25) % 15
    
    -- Actualizar timer de ruido
    noiseTimer = noiseTimer + delta
    
    -- Líneas de escaneo responsivas (más eficientes)
    local lineSpacing = math.max(3, math.floor(screenY / 200))
    for i = 0, screenY, lineSpacing do
        local yPos = (i + scanLineOffset) % screenY
        dxDrawRectangle(0, yPos, screenX, 1, tocolor(0, 255, 0, 3))
    end
    
    -- Viñeta adaptativa según resolución
    local borderSize = math.max(50 * scale, 30)
    local vignetteAlpha = math.min(100 * scale, 120)
    
    dxDrawRectangle(0, 0, screenX, borderSize, tocolor(0, 0, 0, vignetteAlpha))
    dxDrawRectangle(0, screenY - borderSize, screenX, borderSize, tocolor(0, 0, 0, vignetteAlpha))
    dxDrawRectangle(0, 0, borderSize, screenY, tocolor(0, 0, 0, vignetteAlpha))
    dxDrawRectangle(screenX - borderSize, 0, borderSize, screenY, tocolor(0, 0, 0, vignetteAlpha))
    
    -- Ruido aleatorio optimizado
    if math.random() > 0.985 then
        local noiseSize = math.random(10, 80) * scale
        local noiseX = math.random(0, screenX - noiseSize)
        local noiseY = math.random(0, screenY - noiseSize/2)
        dxDrawRectangle(noiseX, noiseY, noiseSize, noiseSize/4, tocolor(0, 255, 0, math.random(15, 35)))
    end
    
    -- Interferencia horizontal ocasional
    if math.random() > 0.975 then
        local interferenceY = math.random(0, screenY)
        dxDrawRectangle(0, interferenceY, screenX, math.random(1, 2), tocolor(255, 255, 255, 50))
    end
    
    -- Filtro verde muy sutil
    dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 255, 0, 2))
end

-- Función para renderizar información de cámara responsiva
local function renderCameraInfo()
    if not currentLocation then return end
    
    local fontSize = UI_CONFIG.fonts.normal
    local padding = 20 * scale
    
    -- Información de la cámara con fondo semi-transparente
    local textHeight = dxGetFontHeight(fontSize, "default-bold")
    local bgHeight = textHeight * 4 + padding * 2
    
    dxDrawRectangle(padding, padding, screenX * 0.3, bgHeight, tocolor(0, 0, 0, 150))
    
    local yOffset = padding * 1.5
    dxDrawText("UBICACIÓN: " .. currentLocation, padding * 1.5, yOffset, 
               screenX, screenY, tocolor(200, 255, 200, 255), fontSize, "default-bold")
    
    yOffset = yOffset + textHeight + 5
    local totalCameras = #(cameraLocations[currentLocation] or {})
    dxDrawText("CÁMARA #" .. currentCamera .. " de " .. totalCameras, 
               padding * 1.5, yOffset, screenX, screenY, tocolor(200, 255, 200, 255), fontSize, "default-bold")
    
    yOffset = yOffset + textHeight + 5
    dxDrawText("FECHA: " .. os.date("%d/%m/%Y %H:%M:%S"), 
               padding * 1.5, yOffset, screenX, screenY, tocolor(200, 255, 200, 255), fontSize, "default-bold")
end

-- Función para renderizar instrucciones de salida responsivas
local function renderExitInstructions()
    local fontSize = UI_CONFIG.fonts.normal
    local text = "PRESIONA LA TECLA BORRAR PARA SALIR"
    local textWidth = dxGetTextWidth(text, fontSize, "default-bold")
    local textHeight = dxGetFontHeight(fontSize, "default-bold")
    
    local bgWidth = textWidth + 40
    local bgHeight = textHeight + 20
    local bgX = (screenX - bgWidth) / 2
    local bgY = 20 * scale
    
    dxDrawRectangle(bgX, bgY, bgWidth, bgHeight, tocolor(0, 0, 0, 150))
    dxDrawText(text, screenX/2, bgY + bgHeight/2, screenX/2, bgY + bgHeight/2, 
               tocolor(255, 255, 0, 255), fontSize, "default-bold", "center", "center")
end

-- Función principal de renderizado mejorada
function renderCCTV()
    if not camerasActive then return end
    
    -- Aplicar efectos CCTV optimizados
    applyCCTVEffect()
    
    -- Actualizar rotación de la cámara
    updateCameraRotation()
    
    -- Renderizar información de la cámara
    renderCameraInfo()
    
    -- Renderizar instrucciones de salida
    renderExitInstructions()
    
    -- Renderizar interfaz según el estado
    if showingLocationSelector then
        renderLocationSelector()
    else
        renderUI()
    end
end

-- Función para renderizar el selector de ubicaciones
-- Variables para elementos del selector
currentLocationElements = {}

-- Función mejorada para renderizar selector de ubicaciones
function renderLocationSelector()
    if not showingLocationSelector then return end
    
    local selectorWidth = math.min(screenX * 0.6, 600)
    local selectorHeight = math.min(screenY * 0.7, 500)
    local selectorX = (screenX - selectorWidth) / 2
    local selectorY = (screenY - selectorHeight) / 2
    
    -- Fondo principal responsivo
    dxDrawRectangle(selectorX, selectorY, selectorWidth, selectorHeight, tocolor(0, 0, 0, 220))
    dxDrawRectangle(selectorX, selectorY, selectorWidth, 60 * scale, tocolor(0, 120, 0, 220))
    
    -- Título responsivo
    local titleY = selectorY + 30 * scale
    dxDrawText("SELECCIONAR UBICACIÓN", screenX/2, titleY, screenX/2, titleY, 
               tocolor(255, 255, 255, 255), UI_CONFIG.fonts.title, "default-bold", "center", "center")
    
    -- Lista de ubicaciones responsiva
    local listY = selectorY + 80 * scale
    local itemHeight = 50 * scale
    local itemPadding = 10 * scale
    
    currentLocationElements = {}
    
    for location, cameras in pairs(cameraLocations) do
        local isSelected = (currentLocation == location)
        local itemColor = isSelected and tocolor(0, 150, 0, 180) or tocolor(0, 80, 0, 120)
        
        local itemX = selectorX + itemPadding
        local itemWidth = selectorWidth - (itemPadding * 2)
        
        dxDrawRectangle(itemX, listY, itemWidth, itemHeight, itemColor)
        
        -- Información de la ubicación
        local textY = listY + itemHeight / 2
        local locationText = location .. " (" .. #cameras .. " cámaras)"
        dxDrawText(locationText, screenX/2, textY, screenX/2, textY, 
                   tocolor(255, 255, 255, 255), UI_CONFIG.fonts.normal, "default-bold", "center", "center")
        
        -- Almacenar para detección de clics
        currentLocationElements[location] = {
            x = itemX,
            y = listY,
            w = itemWidth,
            h = itemHeight
        }
        
        listY = listY + itemHeight + 5 * scale
    end
    
    -- Instrucciones responsivas
    local instructY = selectorY + selectorHeight - 60 * scale
    dxDrawText("Haz clic en una ubicación para ver sus cámaras", screenX/2, instructY, screenX/2, instructY, 
               tocolor(200, 255, 200, 200), UI_CONFIG.fonts.small, "default-bold", "center", "center")
    
    instructY = instructY + 25 * scale
    dxDrawText("Presiona TAB para volver a las cámaras", screenX/2, instructY, screenX/2, instructY, 
               tocolor(200, 255, 200, 200), UI_CONFIG.fonts.small, "default-bold", "center", "center")
end

-- Función mejorada para manejar clics en el selector de ubicaciones
function handleLocationSelectorClicks(button, state)
    if not showingLocationSelector or button ~= "left" or state ~= "down" then return end
    
    local cursorX, cursorY = getCursorPosition()
    if not cursorX or not cursorY then return end
    
    cursorX, cursorY = cursorX * screenX, cursorY * screenY
    
    -- Verificar clics en ubicaciones usando elementos almacenados
    if currentLocationElements then
        for location, element in pairs(currentLocationElements) do
            if isPointInRect(cursorX, cursorY, element.x, element.y, element.w, element.h) then
                selectLocation(location)
                showingLocationSelector = false
                return
            end
        end
    end
end

-- Seleccionar una ubicación y mostrar su primera cámara
function selectLocation(location)
    if not cameraLocations[location] or #cameraLocations[location] == 0 then 
        outputChatBox("No hay cámaras disponibles en esta ubicación.", 255, 0, 0)
        return 
    end
    
    currentLocation = location
    currentCamera = 1
    
    -- Activar la primera cámara de esta ubicación
    activateCurrentCamera()
end

-- Función para activar la cámara actual
function activateCurrentCamera()
    if not currentLocation or not currentCamera then return end
    
    local cameras = cameraLocations[currentLocation]
    if not cameras or #cameras == 0 then return end
    
    local cam = cameras[currentCamera]
    if not cam then return end
    
    -- Establecer interior y dimensión para la cámara
    setElementDimension(localPlayer, cam.dimension or 0)
    setElementInterior(localPlayer, cam.interior or 0)
    setCameraInterior(cam.interior or 0)
    
    -- Establecer posición de la cámara
    setCameraMatrix(cam.x, cam.y, cam.z, cam.lookX, cam.lookY, cam.lookZ)
end

function changeToCamera(cameraId)
    if not currentLocation then return end
    
    local cameras = cameraLocations[currentLocation]
    if not cameras or #cameras == 0 then return end
    
    if cameraId < 1 then cameraId = #cameras end
    if cameraId > #cameras then cameraId = 1 end
    
    currentCamera = cameraId
    activateCurrentCamera()
end

-- Actualizar la rotación de la cámara en cada frame
-- Función optimizada para actualizar rotación de cámara
function updateCameraRotation()
    if not camerasActive then return end
    
    local currentTime = getTickCount()
    local deltaTime = (currentTime - (lastFrameTime or currentTime)) / 1000
    lastFrameTime = currentTime
    
    -- Limitar deltaTime para evitar saltos después de lag
    deltaTime = math.min(deltaTime, 0.1)
    
    -- Calcular rotación suave
    local rotationChange = 0
    if isRotatingLeft then
        rotationChange = -rotationSpeed * deltaTime
    elseif isRotatingRight then
        rotationChange = rotationSpeed * deltaTime
    end
    
    if rotationChange ~= 0 then
        rotateCameraBy(rotationChange)
    end
end

-- Función para rotar la cámara un determinado ángulo
function rotateCameraBy(angle)
    local camX, camY, camZ, lookX, lookY, lookZ = getCameraMatrix()
    
    -- Calcular vector de dirección actual
    local dirX, dirY = lookX - camX, lookY - camY
    
    -- Rotar el vector de dirección según el ángulo especificado
    local rotatedDirX = dirX * math.cos(math.rad(angle)) - dirY * math.sin(math.rad(angle))
    local rotatedDirY = dirX * math.sin(math.rad(angle)) + dirY * math.cos(math.rad(angle))
    
    -- Actualizar la cámara con la nueva dirección
    setCameraMatrix(camX, camY, camZ, camX + rotatedDirX, camY + rotatedDirY, lookZ)
    
    -- Actualizar la posición actual de la cámara en la lista
    cameraLocations[currentLocation][currentCamera].lookX = camX + rotatedDirX
    cameraLocations[currentLocation][currentCamera].lookY = camY + rotatedDirY
    cameraLocations[currentLocation][currentCamera].lookZ = lookZ
end

-- Versiones simplificadas para teclas
function rotateCameraLeft()
    isRotatingLeft = true
end

function rotateCameraRight()
    isRotatingRight = true
end

function stopRotatingLeft()
    isRotatingLeft = false
end

function stopRotatingRight()
    isRotatingRight = false
end

function handleCameraControls(key, state)
    if not camerasActive then return end
    
    if key == "arrow_l" then
        if state then
            rotateCameraLeft()
        else
            stopRotatingLeft()
        end
    elseif key == "arrow_r" then
        if state then
            rotateCameraRight()
        else
            stopRotatingRight()
        end
    elseif state and key == "arrow_u" then
        changeToCamera(currentCamera + 1)
    elseif state and key == "arrow_d" then
        changeToCamera(currentCamera - 1)
    elseif state and key == "backspace" then
        exitCameraView()
    elseif state and key == "tab" then
        -- Alternar entre selector de ubicación y vista de cámara
        showingLocationSelector = not showingLocationSelector
    end
end

-- Función para obtener posiciones responsivas
local function getResponsivePos(relativeX, relativeY, relativeW, relativeH)
    return {
        x = screenX * relativeX,
        y = screenY * relativeY,
        w = screenX * relativeW,
        h = screenY * relativeH
    }
end

-- Función mejorada para renderizar UI responsiva
function renderUI()
    local panel = getResponsivePos(
        UI_CONFIG.controlPanel.x, 
        UI_CONFIG.controlPanel.y,
        UI_CONFIG.controlPanel.width, 
        UI_CONFIG.controlPanel.height
    )
    
    -- Fondo del panel de control responsivo
    if fileExists('data/Rectangle 1.png') then
        dxDrawImage(panel.x, panel.y, panel.w, panel.h, 'data/Rectangle 1.png')
    else
        dxDrawRectangle(panel.x, panel.y, panel.w, panel.h, tocolor(0, 0, 0, 180))
        dxDrawRectangle(panel.x, panel.y, panel.w, 3, tocolor(0, 150, 0, 255))
    end
    
    -- Calcular posiciones de botones responsivas
    local buttonSize = UI_CONFIG.buttons.size
    local spacing = UI_CONFIG.buttons.spacing
    
    local centerX = panel.x + panel.w / 2
    local centerY = panel.y + panel.h / 2
    
    -- Posiciones de botones calculadas dinámicamente
    local upBtn = {
        x = centerX - buttonSize/2,
        y = centerY - buttonSize * 1.5,
        w = buttonSize,
        h = buttonSize
    }
    
    local leftBtn = {
        x = centerX - buttonSize * 1.2,
        y = centerY - buttonSize/2,
        w = buttonSize,
        h = buttonSize
    }
    
    local rightBtn = {
        x = centerX + buttonSize * 0.2,
        y = centerY - buttonSize/2,
        w = buttonSize,
        h = buttonSize
    }
    
    local locationBtn = {
        x = centerX - buttonSize * 0.8,
        y = upBtn.y - buttonSize * 0.8,
        w = buttonSize * 1.6,
        h = buttonSize * 0.6
    }
    
    -- Dibujar botones con fallback si no existen las imágenes
    if fileExists('data/flechaArriba.png') then
        dxDrawImage(upBtn.x, upBtn.y, upBtn.w, upBtn.h, 'data/flechaArriba.png')
    else
        dxDrawRectangle(upBtn.x, upBtn.y, upBtn.w, upBtn.h, tocolor(0, 100, 0, 200))
        dxDrawText("↑", centerX, upBtn.y + upBtn.h/2, centerX, upBtn.y + upBtn.h/2, 
                   tocolor(255, 255, 255, 255), UI_CONFIG.fonts.title, "default-bold", "center", "center")
    end
    
    if fileExists('data/flechaIzquierda.png') then
        dxDrawImage(leftBtn.x, leftBtn.y, leftBtn.w, leftBtn.h, 'data/flechaIzquierda.png')
    else
        dxDrawRectangle(leftBtn.x, leftBtn.y, leftBtn.w, leftBtn.h, tocolor(0, 100, 0, 200))
        dxDrawText("←", leftBtn.x + leftBtn.w/2, leftBtn.y + leftBtn.h/2, leftBtn.x + leftBtn.w/2, leftBtn.y + leftBtn.h/2, 
                   tocolor(255, 255, 255, 255), UI_CONFIG.fonts.title, "default-bold", "center", "center")
    end
    
    if fileExists('data/flechaDerecha.png') then
        dxDrawImage(rightBtn.x, rightBtn.y, rightBtn.w, rightBtn.h, 'data/flechaDerecha.png')
    else
        dxDrawRectangle(rightBtn.x, rightBtn.y, rightBtn.w, rightBtn.h, tocolor(0, 100, 0, 200))
        dxDrawText("→", rightBtn.x + rightBtn.w/2, rightBtn.y + rightBtn.h/2, rightBtn.x + rightBtn.w/2, rightBtn.y + rightBtn.h/2, 
                   tocolor(255, 255, 255, 255), UI_CONFIG.fonts.title, "default-bold", "center", "center")
    end
    
    -- Botón cambiar ubicación responsivo
    dxDrawRectangle(locationBtn.x, locationBtn.y, locationBtn.w, locationBtn.h, tocolor(0, 120, 0, 200))
    dxDrawText("CAMBIAR\nUBICACIÓN", centerX, locationBtn.y + locationBtn.h/2, centerX, locationBtn.y + locationBtn.h/2, 
               tocolor(255, 255, 255, 255), UI_CONFIG.fonts.small, "default-bold", "center", "center")
    
    -- Texto de ayuda responsivo
    if camerasActive then
        local helpY = panel.y + panel.h + spacing
        dxDrawText("← → : Rotar | ↑: Cambiar cámara | TAB: Ubicaciones", centerX, helpY, centerX, helpY, 
                   tocolor(200, 255, 200, 200), UI_CONFIG.fonts.small, "default-bold", "center", "top")
        
        if currentLocation then
            local infoText = "Ubicación: " .. currentLocation .. " - Cámara " .. currentCamera .. " de " .. #cameraLocations[currentLocation]
            dxDrawText(infoText, centerX, helpY + 20, centerX, helpY + 20, 
                       tocolor(200, 255, 200, 200), UI_CONFIG.fonts.small, "default-bold", "center", "top")
        end
    end
    
    -- Almacenar posiciones para detección de clics
    currentUIElements = {
        upButton = upBtn,
        leftButton = leftBtn,
        rightButton = rightBtn,
        locationButton = locationBtn
    }
end

-- Verificar si un punto está dentro de un rectángulo
function isPointInRect(x, y, rectX, rectY, rectWidth, rectHeight)
    return (x >= rectX and x <= rectX + rectWidth and
            y >= rectY and y <= rectY + rectHeight)
end

-- Variables globales para elementos UI
currentUIElements = {}

-- Manejar clics mejorado y responsivo
function handleUIClicks(button, state)
    if not camerasActive or button ~= "left" then return end
    
    local cursorX, cursorY = getCursorPosition()
    if not cursorX or not cursorY then return end
    
    cursorX, cursorY = cursorX * screenX, cursorY * screenY
    
    -- Si estamos en el selector de ubicación, manejar esos clics
    if showingLocationSelector then
        handleLocationSelectorClicks(button, state)
        return
    end
    
    -- Verificar si tenemos elementos UI válidos
    if not currentUIElements then return end
    
    if state == "down" then
        -- Botón flecha arriba (cambiar cámara)
        local upBtn = currentUIElements.upButton
        if upBtn and isPointInRect(cursorX, cursorY, upBtn.x, upBtn.y, upBtn.w, upBtn.h) then
            changeToCamera(currentCamera + 1)
        end
        
        -- Botón cambiar ubicación
        local locBtn = currentUIElements.locationButton
        if locBtn and isPointInRect(cursorX, cursorY, locBtn.x, locBtn.y, locBtn.w, locBtn.h) then
            showingLocationSelector = true
        end
    end
    
    -- Botones de rotación (presionar y mantener)
    local leftBtn = currentUIElements.leftButton
    if leftBtn and isPointInRect(cursorX, cursorY, leftBtn.x, leftBtn.y, leftBtn.w, leftBtn.h) then
        if state == "down" then
            isRotatingLeft = true
        elseif state == "up" then
            isRotatingLeft = false
        end
    end
    
    local rightBtn = currentUIElements.rightButton
    if rightBtn and isPointInRect(cursorX, cursorY, rightBtn.x, rightBtn.y, rightBtn.w, rightBtn.h) then
        if state == "down" then
            isRotatingRight = true
        elseif state == "up" then
            isRotatingRight = false
        end
    end
end

-- Función principal para activar el sistema de cámaras
function activateCameraSystem(locations)
    if camerasActive then
        outputChatBox("El sistema de cámaras ya está activo.", 255, 255, 0)
        return
    end
    
    -- Validar y configurar ubicaciones
    cameraLocations = locations or {}
    camerasActive = true
    showingLocationSelector = false
    exitCooldown = false
    
    -- Configurar jugador
    showCursor(true)
    setElementFrozen(localPlayer, true)
    
    -- Guardar posición original
    originalX, originalY, originalZ = getElementPosition(localPlayer)
    originalInt = getElementInterior(localPlayer)
    originalDim = getElementDimension(localPlayer)
    
    -- Debug información
    outputChatBox(string.format("Sistema activado - Interior: %d, Dimensión: %d", 
                  originalInt, originalDim), 200, 255, 200)
    
    -- Seleccionar primera ubicación disponible
    local firstLocation = nil
    for location, cameras in pairs(cameraLocations) do
        if cameras and #cameras > 0 then
            firstLocation = location
            break
        end
    end
    
    if firstLocation then
        selectLocation(firstLocation)
    else
        showingLocationSelector = true
        outputChatBox("No se encontraron ubicaciones con cámaras disponibles.", 255, 255, 0)
    end
    
    -- Configurar eventos
    addEventHandler("onClientRender", root, renderCCTV)
    addEventHandler("onClientKey", root, handleCameraControls)
    addEventHandler("onClientClick", root, handleUIClicks)
    
    -- Inicializar sistemas
    scanLineOffset = 0
    noiseTimer = 0
    lastTick = getTickCount()
    lastFrameTime = getTickCount()
    isRotatingLeft = false
    isRotatingRight = false
    
    return true
end

-- Función mejorada para salir del sistema de cámaras
function exitCameraView()
    if not camerasActive then return end
    
    camerasActive = false
    exitCooldown = true
    
    -- Debug información de restauración
    if originalInt and originalDim then
        outputChatBox(string.format("Restaurando a: Interior %d, Dimensión %d", 
                      originalInt, originalDim), 200, 255, 200)
    end
    
    -- Restaurar cámara del jugador
    setCameraTarget(localPlayer)
    
    -- Restaurar posición con delay para evitar problemas
    setTimer(function()
        if originalInt then
            setElementInterior(localPlayer, originalInt)
        end
        if originalDim then
            setElementDimension(localPlayer, originalDim)
        end
        
        -- Posición segura cerca del marcador
        local markerX, markerY, markerZ = 1591.9124755859, -1687.1403808594, 19.007499694824
        setElementPosition(localPlayer, markerX, markerY, markerZ)
        
        -- Liberar jugador
        setElementFrozen(localPlayer, false)
        
        -- Desactivar cooldown después de 2 segundos
        setTimer(function()
            exitCooldown = false
        end, 2000, 1)
    end, 150, 1)
    
    -- Limpiar interfaz
    showCursor(false)
    removeEventHandler("onClientRender", root, renderCCTV)
    removeEventHandler("onClientKey", root, handleCameraControls)
    removeEventHandler("onClientClick", root, handleUIClicks)
    
    -- Resetear estados
    isRotatingLeft = false
    isRotatingRight = false
    currentUIElements = nil
    currentLocationElements = nil
end

-- Función toggleUI eliminada - ya no es necesaria con el nuevo sistema

-- Evento para cuando el servidor permite el acceso
addEvent("allowCameraAccess", true)
addEventHandler("allowCameraAccess", localPlayer, function(locations)
    activateCameraSystem(locations)
end)

-- Gestión mejorada del marcador
local function markerHit(hitElement, matchingDimension)
    if hitElement == localPlayer and matchingDimension and not exitCooldown then
        triggerServerEvent("checkPoliceAccess", localPlayer)
    end
end

local function markerLeave(leaveElement, matchingDimension)
    if leaveElement == localPlayer and matchingDimension and camerasActive then
        exitCameraView()
    end
end

-- Configurar eventos del marcador al iniciar el recurso
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Actualizar resolución en caso de cambio
    screenX, screenY = guiGetScreenSize()
    aspectRatio = screenX / screenY
    scaleX = screenX / baseWidth
    scaleY = screenY / baseHeight
    scale = math.min(scaleX, scaleY)
    
    -- Reconfigurar UI
    UI_CONFIG.buttons.size = math.max(60 * scale, 40)
    UI_CONFIG.buttons.spacing = math.max(10 * scale, 5)
    UI_CONFIG.fonts.title = math.max(1.2 * scale, 0.8)
    UI_CONFIG.fonts.normal = math.max(1.0 * scale, 0.7)
    UI_CONFIG.fonts.small = math.max(0.8 * scale, 0.6)
    
    -- Configurar marcador
    local marker = getElementByID("camaraMarker")
    if marker then
        addEventHandler("onClientMarkerHit", marker, markerHit)
        addEventHandler("onClientMarkerLeave", marker, markerLeave)
        outputChatBox("Sistema de cámaras CCTV cargado correctamente - Versión 2.0", 0, 255, 0)
    else
        outputChatBox("Error: No se pudo encontrar el marcador de cámaras", 255, 0, 0)
    end
end)

-- Cleanup al detener el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    if camerasActive then
        exitCameraView()
    end
    unloadFonts()
end)

-- Sistema mejorado - La UI se activa automáticamente desde el servidor cuando es necesario
-- toggleUI(true)