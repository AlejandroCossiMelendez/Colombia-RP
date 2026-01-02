-- Icono flotante del chaleco sobre la cabeza del jugador

local vestIconSize = 0.015 -- Tamaño muy pequeño del icono (1.5% de la pantalla)

function drawVestIcon()
    -- Solo mostrar si hay personaje seleccionado
    if not getElementData(localPlayer, "character:selected") then
        return
    end
    
    -- Dibujar icono sobre la cabeza de todos los jugadores que tengan chaleco
    for _, player in ipairs(getElementsByType("player")) do
        if player ~= localPlayer and isElementOnScreen(player) then
            local hasVest = getElementData(player, "has:vest")
            if hasVest then
                local x, y, z = getElementPosition(player)
                local screenX, screenY = getScreenFromWorldPosition(x, y, z + 0.5) -- Sobre la cabeza
                
                if screenX and screenY then
                    local screenW, screenH = guiGetScreenSize()
                    local iconSize = screenH * vestIconSize
                    
                    -- Dibujar icono pequeño del chaleco
                    dxDrawImage(screenX - iconSize/2, screenY - iconSize/2, iconSize, iconSize, 
                               "hud-rp/Hype_Hud/imgs/armor.png", 0, 0, 0, tocolor(7, 239, 247, 200), false)
                end
            end
        end
    end
end

addEventHandler("onClientRender", root, drawVestIcon)


