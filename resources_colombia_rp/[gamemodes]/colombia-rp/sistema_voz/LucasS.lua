--[[
]]


local screenW,screenH = guiGetScreenSize()
local resW,resH = 1366,768
local x,y =  (screenW/resW), (screenH/resH)



function SimpleStats()
        local Jogador_Falando = getElementData(localPlayer, "Falando_") or false
                                                                                                                                              -- Activado # = True
        dxDrawText("Servidor: #DAA520Bayadera Roleplay", x*320, y*719, x*460, y*696, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, true, false)		

        if Jogador_Falando == true then                                                                                                      -- Activado # = True
        dxDrawText("Voz: #00ff00Activado", x*320, y*700, x*460, y*677, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, true, false)
        else
        	                                                                                                                                     -- Activado # = True
        dxDrawText("Voz: #FF0000Desactivado", x*320, y*700, x*460, y*677, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, true, false)
    end
end
addEventHandler("onClientRender",getRootElement(),SimpleStats)





addEventHandler ( "onClientPlayerVoiceStart", root, function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
        setElementData(source, "Falando_", true);
    end 
end );

addEventHandler ( "onClientPlayerVoiceStop", root,function()
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
        setElementData(source, "Falando_", false);
    end
end);

