-- Cargar la fuente personalizada al inicio del recurso
local customFont = dxCreateFont("custom_font.ttf", 12) -- Cambia "fuente.ttf" por el nombre de tu archivo de fuente

-- Dibuja el texto flotante sobre los CJ desconectados
addEventHandler("onClientRender", root, function()
    for _, textElement in ipairs(getElementsByType("text")) do
        local x, y, z = getElementPosition(textElement)
        local text = getElementData(textElement, "text")
        
        if text then
            local camX, camY, camZ = getCameraMatrix()
            local dist = getDistanceBetweenPoints3D(camX, camY, camZ, x, y, z)
            
            -- Solo mostrar el texto si la distancia es menor a 15 (ajustado desde los 25 originales)
            if dist < 15 then
                -- Ajustar la altura del texto (bajamos 0.5 unidades)
                local sx, sy = getScreenFromWorldPosition(x, y, z - 0.5) -- Ajuste de altura para el texto flotante
                
                if sx and sy then
                    -- Escala del texto basada en la distancia (más cerca = más grande, más lejos = más pequeño)
                    local scale = 1 - (dist / 15) -- El texto se hace más pequeño cuanto más lejos esté el jugador
                    local alpha = 255 - (dist * 17) -- El texto se desvanece a medida que te alejas
                    alpha = math.max(alpha, 0) -- Evitamos que el alpha sea menor que 0

                    -- Dibujamos el texto usando la fuente personalizada
                    dxDrawText(text, sx - 100, sy - 50, sx + 100, sy + 50, tocolor(255, 255, 255, alpha), scale, customFont, "center", "center")
                end
            end
        end
    end
end)