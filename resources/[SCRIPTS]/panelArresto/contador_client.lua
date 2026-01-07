-- Variables locales para el contador de arresto
local arrestoActivo = false
local tiempoRestante = 0
local screenW, screenH = guiGetScreenSize()
local font = "default-bold"
local fontSize = 1.2
local textWidth = 0
local textHeight = 0
local contadorTimer = nil

-- Función para iniciar el contador de arresto
function iniciarContadorArresto(tiempo)
    -- Detener contador anterior si existe
    detenerContadorArresto()
    
    arrestoActivo = true
    tiempoRestante = tiempo
    
    contadorTimer = setTimer(function()
        if tiempoRestante > 0 then
            tiempoRestante = tiempoRestante - 1
        else
            detenerContadorArresto()
        end
    end, 1000, 0)
    
    -- Agregar el event handler
    addEventHandler("onClientRender", root, dibujarContadorArresto)
end

-- Función para detener el contador de arresto
function detenerContadorArresto()
    arrestoActivo = false
    if isTimer(contadorTimer) then
        killTimer(contadorTimer)
        contadorTimer = nil
    end
    -- Intentar remover el event handler de forma segura
    pcall(removeEventHandler, "onClientRender", root, dibujarContadorArresto)
end

-- Función para dibujar el contador en la pantalla
function dibujarContadorArresto()
    if arrestoActivo then
        local horas = math.floor(tiempoRestante / 3600)
        local minutos = math.floor((tiempoRestante % 3600) / 60)
        local segundos = tiempoRestante % 60
        
        local textoTiempo = ""
        if horas > 0 then
            textoTiempo = string.format("Tiempo restante de arresto: %02d:%02d:%02d", horas, minutos, segundos)
        else
            textoTiempo = string.format("Tiempo restante de arresto: %02d:%02d", minutos, segundos)
        end
        
        textWidth = dxGetTextWidth(textoTiempo, fontSize, font)
        textHeight = dxGetFontHeight(fontSize, font)
        
        dxDrawRectangle((screenW - textWidth - 20) / 2, 20, textWidth + 20, textHeight + 10, tocolor(0, 0, 0, 150))
        dxDrawText(textoTiempo, (screenW - textWidth) / 2, 25, screenW, screenH, tocolor(255, 50, 50, 255), fontSize, font, "left", "top", false, false, false, true)
        
        local barraAncho = textWidth + 20
        local barraAlto = 5
        local progreso = tiempoRestante / (getElementData(localPlayer, "tiempoArrestoTotal") or 1)
        
        dxDrawRectangle((screenW - barraAncho) / 2, 25 + textHeight + 5, barraAncho, barraAlto, tocolor(100, 100, 100, 150))
        dxDrawRectangle((screenW - barraAncho) / 2, 25 + textHeight + 5, barraAncho * progreso, barraAlto, tocolor(255, 50, 50, 200))
    end
end

-- Eventos
addEvent("policia:iniciarContadorArresto", true)
addEventHandler("policia:iniciarContadorArresto", localPlayer, function(tiempo)
    setElementData(localPlayer, "tiempoArrestoTotal", tiempo)
    iniciarContadorArresto(tiempo)
end)

addEvent("policia:detenerContadorArresto", true)
addEventHandler("policia:detenerContadorArresto", localPlayer, detenerContadorArresto)

-- Limpiar al detener el recurso
addEventHandler("onClientResourceStop", resourceRoot, function()
    detenerContadorArresto()
end) 