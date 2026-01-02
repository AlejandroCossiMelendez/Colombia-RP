-- Archivo principal del cliente
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("Colombia RP cargado correctamente", 0, 255, 0)
end)

-- Prevenir spawn automático
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    if not getElementData(localPlayer, "character:selected") then
        setCameraMatrix(1959.55, -1714.46, 20, 1959.55, -1714.46, 10)
    end
end)

