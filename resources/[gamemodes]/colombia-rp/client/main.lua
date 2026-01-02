-- Archivo principal del cliente
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("Colombia RP cargado correctamente", 0, 255, 0)
    
    -- Configurar nametags para que aparezcan arriba del jugador
    for _, player in ipairs(getElementsByType("player")) do
        setPlayerNametagShowing(player, true)
    end
end)

-- Configurar cámara de vista previa mientras espera login
function setupPreviewCamera()
    -- Configurar una cámara que muestre el mundo mientras el jugador no está logueado
    local camX, camY, camZ = 1959.55, -1714.46, 20
    local lookX, lookY, lookZ = 1959.55, -1714.46, 10
    setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
    fadeCamera(true, 1.0)
end

-- Cuando el jugador se une, configurar cámara de vista previa
addEventHandler("onClientPlayerJoin", root, function()
    if source == localPlayer then
        setTimer(function()
            if not getElementData(localPlayer, "character:selected") then
                setupPreviewCamera()
            end
        end, 500, 1)
    end
end)

-- Prevenir spawn automático hasta que el personaje esté seleccionado
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    local characterSelected = getElementData(localPlayer, "character:selected")
    outputChatBox("[DEBUG] Spawn detectado. Personaje seleccionado: " .. tostring(characterSelected), 255, 255, 0)
    
    if not characterSelected then
        -- No hacer spawn hasta que el personaje esté seleccionado
        fadeCamera(true, 1.0)
        setupPreviewCamera()
    else
        -- Si el personaje está seleccionado, activar cámara normal
        outputChatBox("[DEBUG] Activando cámara del jugador", 0, 255, 0)
        fadeCamera(true, 1.0)
        setCameraTarget(localPlayer, localPlayer)
    end
end)

-- Mantener cámara de vista previa si no está logueado
setTimer(function()
    if not getElementData(localPlayer, "character:selected") then
        if not isCameraOnPlayer(localPlayer) then
            setupPreviewCamera()
        end
    end
end, 5000, 0)

