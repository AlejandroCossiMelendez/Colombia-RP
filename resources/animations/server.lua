-- Sistema de Animaciones y Efectos - Servidor
-- Este archivo puede usarse para sincronizar animaciones entre jugadores si es necesario

-- Función para verificar si el jugador puede usar animaciones
function canPlayerUseAnimation(player)
    if not isElement(player) then return false end
    if not getElementData(player, "characterSelected") then return false end
    return true
end

-- Evento para sincronizar animaciones (opcional, para que otros jugadores vean las animaciones)
addEvent("onPlayerStartAnimation", true)
addEventHandler("onPlayerStartAnimation", root, function(animationName)
    if not canPlayerUseAnimation(source) then return end
    
    -- Aquí puedes agregar lógica para sincronizar animaciones entre jugadores
    -- Por ejemplo, hacer que otros jugadores vean la animación
end)

addEvent("onPlayerStopAnimation", true)
addEventHandler("onPlayerStopAnimation", root, function()
    if not canPlayerUseAnimation(source) then return end
    
    -- Lógica para detener animación sincronizada
end)

