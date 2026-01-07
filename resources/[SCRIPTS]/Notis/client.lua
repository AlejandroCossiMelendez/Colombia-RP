local screenW, screenH = guiGetScreenSize()
local notificacionVisible = false
local tiempoNotificacion = 5000 -- 5 segundos
local mensajeActual = ""
local anchoMinimo = 300 -- ancho mínimo
local altoNotificacion = 100 -- alto fijo

addEvent("mostrarNotificacionPolicia", true)
addEventHandler("mostrarNotificacionPolicia", root, function(mensaje)
    mensajeActual = tostring(mensaje)
    notificacionVisible = true
    
    -- Para debug - verificar si el mensaje llega
    
    -- Ocultar la notificación después de 5 segundos
    setTimer(function()
        notificacionVisible = false
    end, tiempoNotificacion, 1)
end)

addEventHandler("onClientRender", root, function()
    if notificacionVisible then
        -- Calcular el ancho necesario para el texto
        local anchoTexto = dxGetTextWidth(mensajeActual, 1.2, "default-bold")
        local anchoFinal = math.max(anchoMinimo, anchoTexto + 130)
        
        -- Posición de la notificación (ajustada más arriba)
        local x = screenW * 0.5 - (anchoFinal * 0.5)
        local y = screenH * 0.05 -- Movido más arriba
        
        -- Dibujar el fondo (ahora en azul oscuro)
        dxDrawRectangle(x, y, anchoFinal, altoNotificacion, tocolor(0, 0, 128, 230))
        
        -- Dibujar el ícono de policía
        dxDrawImage(x + 10, y + 25, 50, 50, "assets/policia.png")
        
        -- Dibujar el título "Policía:" en blanco
        dxDrawText("Policía:", x + 70, y + 5, x + anchoFinal - 10, y + 35, 
            tocolor(255, 255, 255, 255), 1.8, "default-bold", "left", "top", false)
        
        -- Dibujar el texto del mensaje
        dxDrawText(mensajeActual, x + 70, y + 35, x + anchoFinal - 10, y + 90, 
            tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "center", true)
    end
end)
