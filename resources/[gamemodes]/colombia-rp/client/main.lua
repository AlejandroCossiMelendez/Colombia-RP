-- Archivo principal del cliente
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("Colombia RP cargado correctamente", 0, 255, 0)
end)

-- Prevenir spawn automático y mantener cámara desactivada hasta login
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    if not getElementData(localPlayer, "character:selected") then
        fadeCamera(false)
        setCameraMatrix(1959.55, -1714.46, 20, 1959.55, -1714.46, 10)
    end
end)

-- Cuando el jugador se une, asegurar que la cámara esté desactivada
addEventHandler("onClientPlayerJoin", root, function()
    if source == localPlayer then
        fadeCamera(false)
    end
end)

