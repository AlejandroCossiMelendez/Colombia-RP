BIND = "F10" -- Mude aqui a bind para efetuar a limpeza de tela

isScreenShowing = true

local screenWidth,screenHeight = guiGetScreenSize()
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        myScreenSource = dxCreateScreenSource ( screenWidth, screenHeight )         
    end
)

local screenW, screenH = guiGetScreenSize()
local resW, resH = 1920,1080
local x, y = (screenW/resW), (screenH/resH)

function cleanScreen()
    if isScreenShowing == false then
        if myScreenSource then
            dxUpdateScreenSource( myScreenSource )
            dxDrawImage( screenWidth - screenWidth,  screenHeight - screenHeight,  screenWidth, screenHeight, myScreenSource, 0, 0, 0, tocolor (255, 255, 255, 255), true)
            dxDrawImage( screenWidth - x*150, screenHeight - screenHeight, x*150, y*150, "logo.png", 0, 0, 0, tocolor ( 255, 255, 255, 255), true)    
        end
    end
end

addEventHandler("onClientRender", root, cleanScreen)
bindKey(BIND, "down",
function()
    if isScreenShowing then
        isScreenShowing = false
    else
        isScreenShowing = true
    end
end)