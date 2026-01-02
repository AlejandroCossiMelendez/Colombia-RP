local screenW, screenH = guiGetScreenSize()
local ActonNil = true
local ActosOff = false
local ActosOn = false 

addEventHandler("onClientRender", root,
    function()
        if ActonNil then
            dxDrawText("Ak: N/A", screenW * 0.8456, screenH * 0.0485, screenW * 0.9609, screenH * 0.0767, tocolor(255, 255, 255, 255), 1.20, "default-bold", "left", "top", false, false, false, false, false)
        elseif ActosOn then
            dxDrawText("Ak: ON", screenW * 0.8346, screenH * 0.0485, screenW * 0.9609, screenH * 0.0767, tocolor(5, 255, 0, 255), 1.20, "default-bold", "left", "top", false, false, false, false, false)
        elseif ActosOff then
            dxDrawText("Ak: OFF", screenW * 0.8456, screenH * 0.0485, screenW * 0.9609, screenH * 0.0767, tocolor(255, 0, 0, 255), 1.20, "default-bold", "left", "top", false, false, false, false, false)
        end
    end
)

addEvent("ActosOnPuma", true)
addEventHandler("ActosOnPuma", getRootElement(), 
    function()
        ActosOff = false
        ActonNil = false
        ActosOn = true
    end
)

addEvent("ActosOffPuma", true)
addEventHandler("ActosOffPuma", getRootElement(), 
    function()
        ActosOff = true
        ActonNil = false
        ActosOn = false
    end
) 

local screenW, screenH = guiGetScreenSize()
local ActonNil = true
local ActosOff = false
local ActosOn = false 


addEventHandler("onClientRender", root,
    function()
    if ActosOn == false and  ActosOff == false and ActonNil == true then
        dxDrawText("Robos: N/A", screenW * 0.7626, screenH * 0.0485, screenW * 0.9609, screenH * 0.0767, tocolor(255, 255, 255, 255), 1.20, "default-bold", "left", "top", false, false, false, false, false)
	elseif ActosOn == true then
        dxDrawText("Robos: ON", screenW * 0.7626, screenH * 0.0485, screenW * 0.9609, screenH * 0.0767, tocolor(5, 255, 0, 255), 1.20, "default-bold", "left", "top", false, false, false, false, false)
	elseif ActosOff == true then
        dxDrawText("Robos: OFF", screenW * 0.7626, screenH * 0.0485, screenW * 0.9609, screenH * 0.0767, tocolor(255, 0, 0, 255), 1.20, "default-bold", "left", "top", false, false, false, false, false)
	end
end
)

addEvent("ActosOnByPuma", true)
addEventHandler("ActosOnByPuma", getRootElement(), 
function()
     ActosOff = false
     ActonNil = false
     ActosOn = true
end)

addEvent("ActosOffByPuma", true)
addEventHandler("ActosOffByPuma", getRootElement(), 
function()
     ActosOff = true
     ActonNil = false
     ActosOn = false
end)