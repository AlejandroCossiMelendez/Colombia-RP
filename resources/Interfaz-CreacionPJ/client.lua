-- Sistema de Creación de Personajes - Capital RP - ESCALADO SIMPLE
-- Integrado con sistema existente de players/gui

-- Sistema de escalado SIMPLE y EFECTIVO (basado en Sistema-de-Seleccion)
local sx, sy = guiGetScreenSize()
local px, py = 1920, 1080  -- Resolución base de diseño
local x, y = (sx/px), (sy/py)  -- Factores de escalado

-- Función para actualizar escalado cuando cambie la resolución
local function updateScale()
    local newSX, newSY = guiGetScreenSize()
    if newSX ~= sx or newSY ~= sy then
        sx, sy = newSX, newSY
        x, y = (sx/px), (sy/py)
        outputDebugString("[CharCreation] Escalado actualizado: " .. string.format("%.2f", x) .. "x, " .. string.format("%.2f", y) .. "y")
    end
end

-- Variables del sistema
local interfaceVisible = false
local characterData = {
    name = "",
    age = 18,
    gender = 1, -- 1 = hombre, 2 = mujer
    skinColor = 1, -- 1 = claro, 0 = moreno
}

-- Estados de hover
local hoverStates = {
    closeButton = false,
    createButton = false,
    maleButton = false,
    femaleButton = false,
    lightSkinButton = false,
    darkSkinButton = false,
    leftArrow = false,
    rightArrow = false,
    resetButton = false,
}

-- Variables del slider de edad
local ageSlider = {
    dragging = false,
    x = 0,
    width = 320,
    minAge = 10,
    maxAge = 100,
}

-- Configuración ESCALADA (como Sistema-de-Seleccion)
local function getSettings()
    updateScale() -- Actualizar escalado
    return {
        ['PANEL-CREACION-PERSONAJE'] = {sx/2 + (-973*x), sy/2 + (-496*y), 715*x, 1053*y},
        ['PANEL-MOVIMIENTO-CAMARA'] = {sx/2 + (704*x), sy/2 + (386*y), 180*x, 60*y},
        ['BG-INFORMACION-PERSONAJE'] = {sx/2 + (336*x), sy/2 + (-242*y), 280*x, 140*y}
    }
end

-- Variables del input de nombre
local nameInput = {
    active = false,
    text = "",
    cursorTimer = 0,
    showCursor = true,
}

-- Variables del sistema de cámara (coordenadas exactas del usuario)
local cameraSystem = {
    active = false,
    angle = 0,
    npc = nil,
    originalCamMatrix = nil,
    centerX = 1836.3745117188,
    centerY = -2290.2387695312,
    centerZ = 19.965999603271,
    camX = 1833.5656738281,
    camY = -2288.6457519531,
    camZ = 19.8,  -- Reducido de 20.428693771362 para vista más baja
    lookX = 1919.1866455078,
    lookY = -2338.6330566406,
    lookZ = 7.3785228729248,
    interior = 0,
    dimension = 0,
}

-- Función para verificar si un punto está dentro de un rectángulo
local function isPointInRect(x, y, rx, ry, rw, rh)
    return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

-- Funciones del sistema de cámara
local function createPreviewNPC()
    if cameraSystem.npc and isElement(cameraSystem.npc) then
        destroyElement(cameraSystem.npc)
    end
    
    local skin = 0
    if characterData.gender == 1 then
        -- Hombres: siempre CJ (skin 0) tanto claro como moreno
        skin = 0
    else
        -- Mujeres: usar las skins del sistema original
        skin = characterData.skinColor == 1 and 10 or 30
    end
    
    cameraSystem.npc = createPed(skin, cameraSystem.centerX, cameraSystem.centerY, cameraSystem.centerZ)
    if cameraSystem.npc then
        setElementFrozen(cameraSystem.npc, true)
        setElementDimension(cameraSystem.npc, 0)
        setElementInterior(cameraSystem.npc, 0)
        setPedRotation(cameraSystem.npc, 0)  -- 0 grados para que mire hacia la cámara
        setElementAlpha(cameraSystem.npc, 255)
        -- Asegurar que el NPC esté bien posicionado en el suelo
        setElementPosition(cameraSystem.npc, cameraSystem.centerX, cameraSystem.centerY, cameraSystem.centerZ)
    end
end

local function updateCamera()
    if not cameraSystem.active then return end
    
    setCameraMatrix(
        cameraSystem.camX,
        cameraSystem.camY,
        cameraSystem.camZ,
        cameraSystem.centerX,
        cameraSystem.centerY,
        cameraSystem.centerZ + 0.2  -- Ajustado para mirar un poquito hacia arriba (torso/cabeza)
    )
    setCameraInterior(0)
    fadeCamera(true, 1.0)
end

local function startCameraSystem()
    if cameraSystem.active then return end
    
    local x, y, z, lx, ly, lz = getCameraMatrix()
    cameraSystem.originalCamMatrix = {x, y, z, lx, ly, lz}
    
    cameraSystem.active = true
    cameraSystem.angle = 0  -- Ángulo inicial 0 para que mire hacia la cámara
    
    createPreviewNPC()
    updateCamera()
end

local function stopCameraSystem()
    if not cameraSystem.active then return end
    
    cameraSystem.active = false
    
    if cameraSystem.originalCamMatrix then
        setCameraMatrix(unpack(cameraSystem.originalCamMatrix))
        setCameraTarget(localPlayer)
    end
    
    if cameraSystem.npc and isElement(cameraSystem.npc) then
        destroyElement(cameraSystem.npc)
        cameraSystem.npc = nil
    end
end

local function rotateCameraLeft()
    cameraSystem.angle = cameraSystem.angle - 30
    if cameraSystem.angle < 0 then
        cameraSystem.angle = cameraSystem.angle + 360
    end
    
    if cameraSystem.npc and isElement(cameraSystem.npc) then
        setPedRotation(cameraSystem.npc, cameraSystem.angle)
    end
end

local function rotateCameraRight()
    cameraSystem.angle = cameraSystem.angle + 30
    if cameraSystem.angle >= 360 then
        cameraSystem.angle = cameraSystem.angle - 360
    end
    
    if cameraSystem.npc and isElement(cameraSystem.npc) then
        setPedRotation(cameraSystem.npc, cameraSystem.angle)
    end
end

local function resetCamera()
    cameraSystem.angle = 0  -- Reset a 0 grados para mirar hacia la cámara
    
    if cameraSystem.npc and isElement(cameraSystem.npc) then
        setPedRotation(cameraSystem.npc, cameraSystem.angle)
    end
end

-- Función para manejar el input de nombre
local function handleNameInput(character)
    if not nameInput.active then return end
    
    if character == "backspace" then
        if #nameInput.text > 0 then
            nameInput.text = nameInput.text:sub(1, -2)
            characterData.name = nameInput.text
        end
    elseif #character == 1 and #nameInput.text < 22 then
        if character:match("[a-zA-ZáéíóúÁÉÍÓÚñÑ ]") then
            nameInput.text = nameInput.text .. character
            characterData.name = nameInput.text
        end
    end
end

local function handleKeyInput(key, pressed)
    if not interfaceVisible or not nameInput.active then return end
    
    if key == "backspace" and pressed then
        if #nameInput.text > 0 then
            nameInput.text = nameInput.text:sub(1, -2)
            characterData.name = nameInput.text
        end
    end
end

-- Función para actualizar el slider de edad
local function updateAgeSlider()
    local settings = getSettings()
    local sliderX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769*x)
    local sliderY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (3*y)
    
    if ageSlider.dragging then
        local cursorX, cursorY = getCursorPosition()
        if cursorX and cursorY then
            cursorX = cursorX * sx
            local relativeX = cursorX - sliderX
            local usableWidth = (320*x) - (64*x)
            relativeX = math.max(0, math.min(usableWidth, relativeX))
            
            local percentage = relativeX / usableWidth
            characterData.age = math.floor(ageSlider.minAge + percentage * (ageSlider.maxAge - ageSlider.minAge))
        end
    end
end

-- Función para verificar hover en botones
local function checkHoverStates()
    local cursorX, cursorY = getCursorPosition()
    if not cursorX or not cursorY then
        for k, v in pairs(hoverStates) do
            hoverStates[k] = false
        end
        return
    end
    
    local settings = getSettings()
    cursorX = cursorX * sx
    cursorY = cursorY * sy
    
    -- Botón cerrar
    local closeX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (399*x)
    local closeY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (493*y)
    hoverStates.closeButton = isPointInRect(cursorX, cursorY, closeX, closeY, 70*x, 70*y)
    
    -- Botón crear personaje
    local createX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (770*x)
    local createY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (327*y)
    hoverStates.createButton = isPointInRect(cursorX, cursorY, createX, createY, 320*x, 107*y)
    
    -- Botones de género
    local maleX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (873*x)
    local maleY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (115*y)
    hoverStates.maleButton = isPointInRect(cursorX, cursorY, maleX, maleY, 220*x, 58*y)
    
    local femaleX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (570*x)
    local femaleY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (110*y)
    hoverStates.femaleButton = isPointInRect(cursorX, cursorY, femaleX, femaleY, 220*x, 58*y)
    
    -- Botones de color de piel
    local lightX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (743*x)
    local lightY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (243*y)
    hoverStates.lightSkinButton = isPointInRect(cursorX, cursorY, lightX, lightY, 108*x, 108*y)
    
    local darkX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (592*x)
    local darkY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (243*y)
    hoverStates.darkSkinButton = isPointInRect(cursorX, cursorY, darkX, darkY, 108*x, 108*y)
    
    -- Botones de cámara
    local leftArrowX = settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (1097*x)
    local leftArrowY = settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (559*y)
    hoverStates.leftArrow = isPointInRect(cursorX, cursorY, leftArrowX, leftArrowY, 98*x, 98*y)
    
    local resetX = settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (980*x)
    local resetY = settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (559*y)
    hoverStates.resetButton = isPointInRect(cursorX, cursorY, resetX, resetY, 98*x, 98*y)
    
    local rightArrowX = settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (859*x)
    local rightArrowY = settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (559*y)
    hoverStates.rightArrow = isPointInRect(cursorX, cursorY, rightArrowX, rightArrowY, 98*x, 98*y)
    
    -- Input de nombre
    local nameInputX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (810*x)
    local nameInputY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (198*y)
    nameInput.active = isPointInRect(cursorX, cursorY, nameInputX, nameInputY, 400*x, 55*y)
end

-- Función principal de renderizado ESCALADO COMPLETO
function renderUI()
    local settings = getSettings() -- Obtener configuraciones escaladas
    
    -- Panel principal (ESCALADO SIMPLE)
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (960*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (540*y), 700*x, 1053*y, 'data/BG-PRINCIPAL-1.png')
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (489*y), 318*x, 120*y, 'data/HEADER-TITULO-CAPITAL-RP-1.png')
    
    -- Textos del header (ESCALADOS)
    dxDrawText('CAPITAL RP', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (435.5*y), nil, nil, tocolor(26, 26, 26, 255), x, getFigmaFont('Oswald-Bold', 20), 'center', 'center')
    dxDrawText('CREAR PERSONAJE', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (338*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Poppins-ExtraBold', 20), 'center', 'center')
    dxDrawText('PERSONALIZA TU IDENTIDAD', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (286.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Inter-Regular', 13.333), 'center', 'center')
    
    -- Campo de nombre (ESCALADO SIMPLE)
    dxDrawText('NOMBRE COMPLETO', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (235*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-Bold', 20), 'center', 'center')
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (810*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (198*y), 400*x, 55*y, 'data/INPUT-NOMBRECOMPLETO.png')
    
    -- Texto del input de nombre (ESCALADO)
    local nameText = characterData.name
    if nameInput.active and nameInput.showCursor then
        nameText = nameText .. "|"
    end
    if nameText == "" or nameText == "|" then
        nameText = nameInput.active and "|" or "Escribe tu nombre aquí..."
    end
    local textColor = (nameText == "Escribe tu nombre aquí...") and tocolor(150, 150, 150, 255) or tocolor(255, 255, 255, 255)
    dxDrawText(nameText, settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (170*y), nil, nil, textColor, x, getFigmaFont('Inter-Regular', 16), 'center', 'center')
    
    -- Campo de edad (ESCALADO SIMPLE)
    dxDrawText('EDAD', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (107.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-SemiBold', 16.666), 'center', 'center')
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (670*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (97*y), 120*x, 120*y, 'data/INPUTCIRCLE-EDAD.png')
    dxDrawText(tostring(characterData.age), settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (37*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Inter-Bold', 24), 'center', 'center')
    
    -- Slider de edad (ESCALADO SIMPLE)
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (3*y), 320*x, 16*y, 'data/SLIDER-EDAD.png')
    
    local percentage = (characterData.age - ageSlider.minAge) / (ageSlider.maxAge - ageSlider.minAge)
    local sliderColorWidth = percentage * (320*x)
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (2*y), sliderColorWidth, 16*y, 'data/SLIDERCOLOR-EDAD.png')
    
    local sliderCircleX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769*x) + (percentage * ((320*x) - (64*x)))
    dxDrawImage(sliderCircleX, settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (21*y), 64*x, 64*y, 'data/CIRCLESLIDER-EDAD.png')
    
    dxDrawText('10', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (24.5*y), nil, nil, tocolor(255, 255, 255, 153), x, getFigmaFont('Inter-Regular', 13.333), 'center', 'center')
    dxDrawText('100', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (450.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (24.5*y), nil, nil, tocolor(255, 255, 255, 153), x, getFigmaFont('Inter-Regular', 13.333), 'center', 'center')
    
    -- Campo de género (ESCALADO SIMPLE)
    dxDrawText('GENERO', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (62.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-SemiBold', 16.666), 'center', 'center')
    
    -- Botones de género con hover (ESCALADOS)
    local maleImage = (characterData.gender == 1 or hoverStates.maleButton) and 'data/HOVERBOTONSELECT-HOMBRE.png' or 'data/BOTONSELECT-HOMBRE.png'
    local femaleImage = (characterData.gender == 2 or hoverStates.femaleButton) and 'data/HOVERBOTONSELECT-MUJER.png' or 'data/BOTONSELECT-MUJER.png'
    
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (873*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (115*y), 220*x, 58*y, maleImage)
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (570*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (110*y), 220*x, 58*y, femaleImage)
    
    dxDrawText('HOMBRE', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (763.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (142.5*y), nil, nil, tocolor(255, 255, 255, 204), x, getFigmaFont('Inter-SemiBold', 16.666), 'center', 'center')
    dxDrawText('MUJER', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (459.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (138.5*y), nil, nil, tocolor(255, 255, 255, 204), x, getFigmaFont('Inter-SemiBold', 16.666), 'center', 'center')
    
    -- Campo de color de piel (ESCALADO)
    dxDrawText('TONO DE PIEL', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (202.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-SemiBold', 16.666), 'center', 'center')
    
    -- Botones de color de piel con hover (ESCALADOS)
    local lightImage = (characterData.skinColor == 1 or hoverStates.lightSkinButton) and 'data/HOVERBOTON-CLARO.png' or 'data/BOTON-CLARO.png'
    local darkImage = (characterData.skinColor == 0 or hoverStates.darkSkinButton) and 'data/HOVERBOTON-MORENO.png' or 'data/BOTON-MORENO.png'
    
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (743*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (243*y), 108*x, 108*y, lightImage)
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (592*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (243*y), 108*x, 108*y, darkImage)
    
    dxDrawText('CLARO', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (689.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (242.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Inter-Medium', 10.666), 'center', 'center')
    dxDrawText('MORENO', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (538.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (242.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Inter-Medium', 10.666), 'center', 'center')
    
    -- Botón crear personaje con hover (ESCALADO)
    local createImage = hoverStates.createButton and 'data/HOVERBOTON-CREAR-PERSONAJE.png' or 'data/BOTON-CREAR-PERSONAJE.png'
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (770*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (327*y), 320*x, 107*y, createImage)
    dxDrawText('CREAR PERSONAJE', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (610.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 + (369.5*y), nil, nil, tocolor(26, 26, 26, 255), x, getFigmaFont('Oswald-Bold', 16.666), 'center', 'center')
    
    -- Botón cerrar (ESCALADO)
    dxDrawImage(settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (399*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (493*y), 70*x, 70*y, 'data/BOTONCIRCLE-CERRARPANEL.png')
    dxDrawText('X', settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (364.5*x), settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (463.5*y), nil, nil, tocolor(255, 255, 255, 204), x, getFigmaFont('Inter-SemiBold', 12), 'center', 'center')
    
    -- Panel de movimiento de cámara (ESCALADO)
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (1110*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (570*y), 360*x, 120*y, 'data/BG-MOVIMIENTO-CAMARA.png')
    
    -- Botones de cámara con hover (ESCALADOS)
    local leftArrowImg = hoverStates.leftArrow and 'data/HOVERCIRCLE-FLECHA-IZQUIERDA.png' or 'data/CIRCLE-FLECHA-IZQUIERDA.png'
    local resetImg = hoverStates.resetButton and 'data/HOVERCIRCLE-RESET.png' or 'data/CIRCLE-RESET.png'
    local rightArrowImg = hoverStates.rightArrow and 'data/HOVERCIRCLE-FLECHA-DERECHA.png' or 'data/CIRCLE-FLECHA-DERECHA.png'
    
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (1097*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (559*y), 98*x, 98*y, leftArrowImg)
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (980*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (559*y), 98*x, 98*y, resetImg)
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (859*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (559*y), 98*x, 98*y, rightArrowImg)
    
    -- Iconos de los botones de cámara (ESCALADOS)
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (854*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (554*y), 88*x, 88*y, 'data/ICON-FLECHA-DERECHA.png')
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (965*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (544*y), 68*x, 68*y, 'data/ICON-RESET.png')
    dxDrawImage(settings['PANEL-MOVIMIENTO-CAMARA'][1] + sx/2 - (1092*x), settings['PANEL-MOVIMIENTO-CAMARA'][2] + sy/2 - (554*y), 88*x, 88*y, 'data/ICON-FLECHA-IZQUIERDA.png')
    
    -- Panel de información del personaje (ESCALADO)
    dxDrawImage(settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (940*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (775*y), 560*x, 280*y, 'data/BG-INFORMACION-PERSONAJE.png')
    dxDrawText('INFORMACION DEL PERSONAJE', settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (660*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (722.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-Bold', 20), 'center', 'center')
    
    -- Información dinámica del personaje (ESCALADA)
    local displayName = characterData.name ~= "" and characterData.name or "Sin nombre"
    local displayGender = characterData.gender == 1 and "Hombre" or "Mujer"
    local displaySkin = characterData.skinColor == 1 and "Claro" or "Moreno"
    
    -- Columna izquierda (ESCALADA)
    dxDrawText('NOMBRE:', settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (900*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (658.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Poppins-ExtraBold', 14), 'left', 'center')
    dxDrawText(displayName, settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (900*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (638.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-Regular', 12), 'left', 'center')
    
    dxDrawText('EDAD:', settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (900*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (598.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Poppins-ExtraBold', 14), 'left', 'center')
    dxDrawText(tostring(characterData.age) .. " años", settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (900*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (578.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-Regular', 12), 'left', 'center')
    
    -- Columna derecha (ESCALADA)
    dxDrawText('GENERO:', settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (650*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (658.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Poppins-ExtraBold', 14), 'left', 'center')
    dxDrawText(displayGender, settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (650*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (638.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-Regular', 12), 'left', 'center')
    
    dxDrawText('TONO:', settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (650*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (598.5*y), nil, nil, tocolor(255, 255, 255, 255), x, getFigmaFont('Poppins-ExtraBold', 14), 'left', 'center')
    dxDrawText(displaySkin, settings['BG-INFORMACION-PERSONAJE'][1] + sx/2 - (650*x), settings['BG-INFORMACION-PERSONAJE'][2] + sy/2 - (578.5*y), nil, nil, tocolor(255, 215, 0, 255), x, getFigmaFont('Inter-Regular', 12), 'left', 'center')
    
    -- Actualizar estados
    checkHoverStates()
    updateAgeSlider()
    
    -- Actualizar cursor del input de nombre
    nameInput.cursorTimer = nameInput.cursorTimer + 1
    if nameInput.cursorTimer >= 30 then
        nameInput.showCursor = not nameInput.showCursor
        nameInput.cursorTimer = 0
    end
end

-- Función para manejar clics
local function handleClick(button, state)
    if not interfaceVisible or button ~= "left" or state ~= "down" then return end
    
    local cursorX, cursorY = getCursorPosition()
    if not cursorX or not cursorY then return end
    
    cursorX = cursorX * sx
    cursorY = cursorY * sy
    
    -- Botón cerrar
    if hoverStates.closeButton then
        hideCreateCharacterInterface()
        if exports.gui then
            if exports.players:isLoggedIn() then
                exports.gui:show('characters', false, false, true)
            else
                exports.gui:show('characters', true, true, true)
            end
        end
        return
    end
    
    -- Botón crear personaje
    if hoverStates.createButton then
        createCharacter()
        return
    end
    
    -- Botones de género
    if hoverStates.maleButton then
        characterData.gender = 1
        if cameraSystem.active then
            createPreviewNPC()
        end
        return
    end
    
    if hoverStates.femaleButton then
        characterData.gender = 2
        if cameraSystem.active then
            createPreviewNPC()
        end
        return
    end
    
    -- Botones de color de piel
    if hoverStates.lightSkinButton then
        characterData.skinColor = 1
        if cameraSystem.active then
            createPreviewNPC()
        end
        return
    end
    
    if hoverStates.darkSkinButton then
        characterData.skinColor = 0
        if cameraSystem.active then
            createPreviewNPC()
        end
        return
    end
    
    -- Slider de edad
    local settings = getSettings()
    local sliderX = settings['PANEL-CREACION-PERSONAJE'][1] + sx/2 - (769*x)
    local sliderY = settings['PANEL-CREACION-PERSONAJE'][2] + sy/2 - (21*y)
    if isPointInRect(cursorX, cursorY, sliderX, sliderY, 320*x, 64*y) then
        ageSlider.dragging = true
        return
    end
    
    -- Botones de cámara
    if hoverStates.leftArrow then
        rotateCameraLeft()
        return
    end
    
    if hoverStates.rightArrow then
        rotateCameraRight()
        return
    end
    
    if hoverStates.resetButton then
        resetCamera()
        return
    end
end

-- Función para manejar liberación del mouse
local function handleClickUp(button, state)
    if button == "left" and state == "up" then
        ageSlider.dragging = false
    end
end

-- Función helper para mostrar notificaciones
local function showNotification(message, type)
    -- Intentar usar a_infoBox si está disponible
    local infoBox = getResourceFromName("a_infoBox")
    if infoBox and getResourceState(infoBox) == "running" then
        pcall(function()
            -- Convertir tipos para a_infoBox
            local boxType = "info"
            if type == "Error" then
                boxType = "error"
            elseif type == "Sucess" then
                boxType = "success"
            end
            exports.a_infoBox:addBox(localPlayer, message, boxType)
        end)
    end
    
    -- Siempre mostrar en chat como fallback
    local color = {255, 255, 255}
    if type == "Error" then
        color = {255, 0, 0}
    elseif type == "Sucess" then
        color = {0, 255, 0}
    end
    outputChatBox(message, color[1], color[2], color[3])
end

-- Función para crear el personaje
function createCharacter()
    if not characterData.name or characterData.name == "" then
        showNotification("Debes escribir un nombre completo", "Error")
        return
    end
    
    if #characterData.name < 5 then
        showNotification("El nombre debe tener al menos 5 caracteres", "Error")
        return
    end
    
    if #characterData.name > 22 then
        showNotification("El nombre no puede superar los 22 caracteres", "Error")
        return
    end
    
    -- Verificar formato del nombre (Nombre Apellido)
    local nameParts = {}
    for part in characterData.name:gmatch("%S+") do
        table.insert(nameParts, part)
    end
    
    if #nameParts < 2 then
        showNotification("El nombre debe tener formato: Nombre Apellido", "Error")
        return
    end
    
    if characterData.age < 10 or characterData.age > 100 then
        showNotification("La edad debe estar entre 10 y 100 años", "Error")
        return
    end
    
    -- Si llegamos aquí, todo está correcto
    triggerServerEvent("gui:createCharacter", localPlayer, characterData.name, characterData.age, characterData.gender, characterData.skinColor)
    -- NO cerramos la interfaz aquí, esperamos la respuesta del servidor
end

-- Función para mostrar/ocultar la interfaz
function toggleInterface()
    interfaceVisible = not interfaceVisible
    
    if interfaceVisible then
        characterData = {
            name = "",
            age = 18,
            gender = 1,
            skinColor = 1,
        }
        nameInput.text = ""
        nameInput.active = true
        
        -- Marcar que está en creación de personajes para deshabilitar inventario
        setElementData(localPlayer, "character_creation_active", true)
        
        addEventHandler('onClientRender', root, renderUI)
        addEventHandler('onClientClick', root, handleClick)
        addEventHandler('onClientClick', root, handleClickUp)
        addEventHandler('onClientCharacter', root, handleNameInput)
        addEventHandler('onClientKey', root, handleKeyInput)
        showCursor(true)
        
        if exports["Hud-capital"] then
            triggerEvent("hud:ocultar", localPlayer)
        end
        showChat(false)
        
        startCameraSystem()
    else
        -- Quitar marca de creación de personajes
        setElementData(localPlayer, "character_creation_active", false)
        
        removeEventHandler('onClientRender', root, renderUI)
        removeEventHandler('onClientClick', root, handleClick)
        removeEventHandler('onClientClick', root, handleClickUp)
        removeEventHandler('onClientCharacter', root, handleNameInput)
        removeEventHandler('onClientKey', root, handleKeyInput)
        showCursor(false)
        
        if exports["Hud-capital"] then
            triggerEvent("hud:mostrar", localPlayer)
        end
        showChat(true)
        
        for k, v in pairs(hoverStates) do
            hoverStates[k] = false
        end
        ageSlider.dragging = false
        
        stopCameraSystem()
    end
end

-- Event handlers para integración
addEvent("players:characterCreationResult", true)
addEventHandler("players:characterCreationResult", localPlayer,
    function(code, characterID)
        if code == 0 then
            -- Éxito - cerrar interfaz y hacer spawn
            showNotification("¡Personaje creado exitosamente!", "Sucess")
            hideCreateCharacterInterface()
            
            -- Si recibimos el ID del personaje, spawnearlo automáticamente
            if characterID then
                -- Marcar que estamos en proceso de spawn directo
                setElementData(localPlayer, "direct_spawn_process", true)
                outputDebugString("[CharCreation] Activando bloqueo de interfaz characters")
                
                -- Bloquear TODAS las interfaces de characters por 5 segundos
                setTimer(function()
                    setElementData(localPlayer, "direct_spawn_process", nil)
                end, 5000, 1)
                
                -- Esperar un momento para que se complete la creación y luego spawnear
                setTimer(function()
                    if exports.players then
                        -- Usar la función de spawn directamente
                        triggerServerEvent("players:spawn", localPlayer, characterID)
                    end
                end, 500, 1)
            end
        elseif code == 1 then
            -- Error: nombre ya existe - NO cerrar interfaz
            showNotification("Ya existe un personaje con ese nombre", "Error")
        else
            -- Error desconocido - NO cerrar interfaz
            showNotification("Error desconocido al crear el personaje", "Error")
        end
    end
)

function showCreateCharacterInterface()
    if not interfaceVisible then
        toggleInterface()
    end
end

function hideCreateCharacterInterface()
    if interfaceVisible then
        toggleInterface()
    end
end

addEvent("showNewCharacterInterface", true)
addEventHandler("showNewCharacterInterface", localPlayer, showCreateCharacterInterface)

addEvent("hideNewCharacterInterface", true)
addEventHandler("hideNewCharacterInterface", localPlayer, hideCreateCharacterInterface)

addEvent("players:characters", true)
addEventHandler("players:characters", localPlayer,
    function(chars, spawn, login, ip)
        if not chars or #chars == 0 then
            setTimer(showCreateCharacterInterface, 1000, 1)
        end
    end
)

-- Función de inicialización
addEventHandler("onClientResourceStart", resourceRoot, function()
    local componentes_hud = {"weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted"}
    for _, componente in ipairs(componentes_hud) do
        setPlayerHudComponentVisible(componente, false)
    end
    
    outputDebugString("[CharCreation] Sistema escalado iniciado - " .. sx .. "x" .. sy .. " - Escala: " .. string.format("%.2f", x))
end)

addCommandHandler("testinterface", function()
    outputChatBox("Probando interfaz escalada...", 0, 255, 255)
    showCreateCharacterInterface()
end)
