-- Sistema de vista previa de skins para personajes
-- Renderiza la skin real del personaje y la muestra en el navegador

local previewPeds = {}
local previewDimension = 9999
local previewInterior = 0
local previewPosition = {x = -2000, y = -2000, z = 100}
local renderTargets = {}
local isRendering = false

-- Función para crear un ped de preview y capturar su imagen
function createSkinPreview(characterId, skinId)
    -- Eliminar ped anterior si existe
    if previewPeds[characterId] and isElement(previewPeds[characterId]) then
        destroyElement(previewPeds[characterId])
    end
    
    -- Crear ped temporal con la skin
    local skinModel = tonumber(skinId) or 30
    local ped = createPed(skinModel, previewPosition.x, previewPosition.y, previewPosition.z, 0, false)
    
    if not ped then
        outputChatBox("Error al crear preview de skin " .. skinModel, 255, 0, 0)
        return false
    end
    
    -- Configurar ped
    setElementDimension(ped, previewDimension)
    setElementInterior(ped, previewInterior)
    setElementFrozen(ped, true)
    setElementAlpha(ped, 255)
    
    -- Aplicar animación si es posible
    setPedAnimation(ped, "COP_AMBIENT", "Coplook_loop", -1, true, false, false)
    
    -- Guardar referencia
    previewPeds[characterId] = ped
    
    -- Crear render target para capturar la imagen
    local renderTarget = dxCreateRenderTarget(200, 300, true)
    if not renderTarget then
        outputChatBox("Error al crear render target", 255, 0, 0)
        return false
    end
    
    renderTargets[characterId] = renderTarget
    
    -- Usar método de screenshot en lugar de render target
    -- Esperar un frame para que el ped se cargue completamente
    setTimer(function()
        if isElement(ped) then
            -- Usar función de screenshot
            takePedScreenshot(characterId, skinId)
        end
    end, 500, 1)
    
    return true
end

-- Función para capturar la imagen del ped
function capturePedImage(characterId, ped, renderTarget)
    if not isElement(ped) or not isElement(renderTarget) then
        return
    end
    
    -- Configurar render target
    dxSetRenderTarget(renderTarget, true)
    
    -- Limpiar con fondo transparente
    dxDrawRectangle(0, 0, 200, 300, tocolor(0, 0, 0, 0))
    
    -- Obtener posición del ped
    local px, py, pz = getElementPosition(ped)
    
    -- Calcular posición de la cámara para ver el ped de frente
    local distance = 2.5
    local angle = 0
    local camX = px + math.cos(math.rad(angle)) * distance
    local camY = py + math.sin(math.rad(angle)) * distance
    local camZ = pz + 0.5
    
    -- Renderizar el ped usando la cámara
    -- Nota: En MTA no podemos renderizar directamente un ped a un render target
    -- Necesitamos usar un método alternativo
    
    -- Restaurar render target
    dxSetRenderTarget()
    
    -- Obtener los píxeles del render target
    local pixels = dxGetTexturePixels(renderTarget)
    
    if pixels then
        -- Convertir a base64 (simplificado)
        -- En producción, usar una función adecuada de conversión
        local browserContent = getElementData(localPlayer, "character:browserContent")
        if not browserContent then
            -- Intentar obtener del browser del character GUI
            local characterBrowser = getElementData(localPlayer, "character:browser")
            if characterBrowser and isElement(characterBrowser) then
                browserContent = guiGetBrowser(characterBrowser)
            end
        end
        
        if browserContent and isElement(browserContent) then
            -- Enviar imagen al navegador
            -- Nota: dxGetTexturePixels devuelve una tabla, necesitamos convertirla
            executeBrowserJavascript(browserContent, string.format(
                "updateSkinPreviewImage(%d, '%s');",
                characterId,
                "data:image/png;base64," .. tostring(pixels)
            ))
        end
    end
end

-- Evento para solicitar preview de skin
addEvent("requestSkinPreview", true)
addEventHandler("requestSkinPreview", root, function(characterId, skinId)
    createSkinPreview(characterId, skinId)
end)

-- Función mejorada: usar screenshot del ped con cámara configurada
function takePedScreenshot(characterId, skinId)
    local skinModel = tonumber(skinId) or 30
    local ped = createPed(skinModel, previewPosition.x, previewPosition.y, previewPosition.z, 0, false)
    
    if not ped then
        return false
    end
    
    setElementDimension(ped, previewDimension)
    setElementInterior(ped, previewInterior)
    setElementFrozen(ped, true)
    
    -- Aplicar animación
    setPedAnimation(ped, "COP_AMBIENT", "Coplook_loop", -1, true, false, false)
    
    previewPeds[characterId] = ped
    
    -- Esperar a que el ped se cargue completamente
    setTimer(function()
        if isElement(ped) then
            local x, y, z = getElementPosition(ped)
            
            -- Configurar cámara para ver el ped de frente
            local camX = x + 2
            local camY = y
            local camZ = z + 0.5
            local lookX = x
            local lookY = y
            local lookZ = z + 0.5
            
            setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
            
            -- Esperar un frame para que la cámara se configure
            setTimer(function()
                if isElement(ped) then
                    -- Tomar screenshot
                    takePlayerScreenShot(localPlayer, 200, 300, "skin_preview_" .. characterId, 50)
                end
            end, 200, 1)
        end
    end, 800, 1)
    
    return true
end

-- Handler para cuando se toma el screenshot
addEventHandler("onClientScreenShot", root, function(resource, status, imageData, timestamp, tag)
    if tag and string.find(tag, "skin_preview_") then
        local characterId = tonumber(string.match(tag, "skin_preview_(%d+)"))
        if characterId and imageData then
            local browserContent = getElementData(localPlayer, "character:browserContent")
            if not browserContent then
                local characterBrowser = getElementData(localPlayer, "character:browser")
                if characterBrowser and isElement(characterBrowser) then
                    browserContent = guiGetBrowser(characterBrowser)
                end
            end
            
            if browserContent and isElement(browserContent) then
                executeBrowserJavascript(browserContent, string.format(
                    "updateSkinPreviewImage(%d, '%s');",
                    characterId,
                    "data:image/png;base64," .. imageData
                ))
            end
        end
    end
end)

-- Limpiar peds cuando se cierra la GUI
addEvent("hideCharacterGUI", true)
addEventHandler("hideCharacterGUI", resourceRoot, function()
    for characterId, ped in pairs(previewPeds) do
        if isElement(ped) then
            destroyElement(ped)
        end
    end
    previewPeds = {}
    
    for characterId, renderTarget in pairs(renderTargets) do
        if isElement(renderTarget) then
            destroyElement(renderTarget)
        end
    end
    renderTargets = {}
    
    -- Restaurar cámara solo si el jugador tiene personaje seleccionado
    if getElementData(localPlayer, "character:selected") then
        setCameraTarget(localPlayer, localPlayer)
    end
end)

