--[[
Copyright (c) 2019 DownTown RolePlay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local teclaIBloqueada = false
local screenW, screenH = guiGetScreenSize()
local tiempoRestante = 0
local timerContador = nil
local arrestoActivo = false
local font = "default-bold"
local fontSize = 1.2
local textWidth = 0
local textHeight = 0

-- Función para bloquear la tecla I
function bloquearTeclaI(estado)
    teclaIBloqueada = estado
    
    if estado then
        -- Iniciar contador si se bloquea la tecla
        local tjail = getElementData(localPlayer, "tjail") or 0
        tiempoRestante = tjail * 60 -- Convertir minutos a segundos
        setElementData(localPlayer, "tiempoJailTotal", tiempoRestante)
        
        if timerContador and isTimer(timerContador) then
            killTimer(timerContador)
        end
        
        -- Iniciar el contador
        arrestoActivo = true
        timerContador = setTimer(function()
            if tiempoRestante > 0 then
                tiempoRestante = tiempoRestante - 1
            else
                -- Si el tiempo llega a cero, desactivamos el contador
                arrestoActivo = false
                if isTimer(timerContador) then
                    killTimer(timerContador)
                end
                removeEventHandler("onClientRender", root, dibujarContadorJail)
            end
        end, 1000, 0) -- Actualizar cada segundo
        
        -- Activar el renderizado del contador
        addEventHandler("onClientRender", root, dibujarContadorJail)
        
        -- Asegurarse de que la tecla I esté bloqueada
        toggleControl("inventory", false)
    else
        -- Detener contador si se desbloquea la tecla
        arrestoActivo = false
        if timerContador and isTimer(timerContador) then
            killTimer(timerContador)
            timerContador = nil
        end
        
        -- Desactivar el renderizado del contador
        removeEventHandler("onClientRender", root, dibujarContadorJail)
        
        -- Desbloquear la tecla I
        toggleControl("inventory", true)
    end
end
addEvent("bloquearTeclaI", true)
addEventHandler("bloquearTeclaI", root, bloquearTeclaI)

-- Función para dibujar el contador en la pantalla (con el mismo diseño que el contador de arresto)
function dibujarContadorJail()
    if arrestoActivo then
        -- Convertir el tiempo restante a formato horas:minutos:segundos
        local horas = math.floor(tiempoRestante / 3600)
        local minutos = math.floor((tiempoRestante % 3600) / 60)
        local segundos = tiempoRestante % 60
        
        -- Formatear el texto del contador
        local textoTiempo = ""
        if horas > 0 then
            textoTiempo = string.format("Tiempo restante de jail: %02d:%02d:%02d", horas, minutos, segundos)
        else
            textoTiempo = string.format("Tiempo restante de jail: %02d:%02d", minutos, segundos)
        end
        
        -- Calcular el ancho del texto para centrarlo
        textWidth = dxGetTextWidth(textoTiempo, fontSize, font)
        textHeight = dxGetFontHeight(fontSize, font)
        
        -- Dibujar un fondo semi-transparente para el texto
        dxDrawRectangle((screenW - textWidth - 20) / 2, 20, textWidth + 20, textHeight + 10, tocolor(0, 0, 0, 150))
        
        -- Dibujar el texto del contador
        dxDrawText(textoTiempo, (screenW - textWidth) / 2, 25, screenW, screenH, tocolor(255, 50, 50, 255), fontSize, font, "left", "top", false, false, false, true)
        
        -- Dibujar una barra de progreso
        local barraAncho = textWidth + 20
        local barraAlto = 5
        local tiempoTotal = getElementData(localPlayer, "tiempoJailTotal") or 1
        local progreso = tiempoRestante / tiempoTotal
        
        -- Fondo de la barra
        dxDrawRectangle((screenW - barraAncho) / 2, 25 + textHeight + 5, barraAncho, barraAlto, tocolor(100, 100, 100, 150))
        
        -- Barra de progreso
        dxDrawRectangle((screenW - barraAncho) / 2, 25 + textHeight + 5, barraAncho * progreso, barraAlto, tocolor(255, 50, 50, 200))
    end
end

-- Función para bloquear completamente la tecla I
function bloquearInventario(button, press)
    if teclaIBloqueada and (button == "i" or button == "I") then
        outputChatBox("No puedes usar la tecla I mientras estás en jail.", 255, 0, 0)
        return cancelEvent()
    end
end
addEventHandler("onClientKey", root, bloquearInventario)

-- Verificar estado al iniciar sesión
addEventHandler("onClientResourceStart", resourceRoot, function()
    local tjail = getElementData(localPlayer, "tjail")
    if tjail and tonumber(tjail) > 0 then
        bloquearTeclaI(true)
    end
end)

-- Asegurarse de que el control de inventario permanezca desactivado
function mantenerBloqueoInventario()
    if teclaIBloqueada then
        toggleControl("inventory", false)
    end
end
addEventHandler("onClientRender", root, mantenerBloqueoInventario)

-- Evento para actualizar el contador desde el servidor
addEvent("jail:actualizarContador", true)
addEventHandler("jail:actualizarContador", localPlayer, function(tiempoEnSegundos)
    -- Para evitar problemas con tiempos muy cortos, asegurar un mínimo de 1 segundo
    tiempoEnSegundos = math.max(1, tiempoEnSegundos)
    
    -- Actualizar el tiempo restante sin reiniciar el contador
    tiempoRestante = tiempoEnSegundos
    
    -- Actualizar también el tiempo total para la barra de progreso
    setElementData(localPlayer, "tiempoJailTotal", tiempoEnSegundos)
    
    -- Si el contador no está activo, activarlo
    if not arrestoActivo then
        arrestoActivo = true
        addEventHandler("onClientRender", root, dibujarContadorJail)
    end
end)
