

local screenW, screenH = guiGetScreenSize()

addEventHandler("onClientRender", root,
    function()
        dxDrawImage(screenW * 0.0230, screenH * 0.6490, screenW * 0.1808, screenH * 0.1172, ":imagen/img.png", 0, 0, 0, tocolor(254, 254, 254, 150), false)
    end
)