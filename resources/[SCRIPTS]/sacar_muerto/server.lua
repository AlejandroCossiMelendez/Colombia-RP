-- Script para sacar jugadores con poca vida (1 HP) de vehículos
-- Autor: Claude

-- Función para verificar la vida de los jugadores periódicamente
function checkPlayerHealth()
    for _, player in ipairs(getElementsByType("player")) do
        local health = getElementHealth(player)
        
        -- Si el jugador tiene 1 de vida o menos y está en un vehículo
        if health <= 1 then
            local vehicle = getPedOccupiedVehicle(player)
            if vehicle then
                -- Obtener la posición del vehículo
                local vx, vy, vz = getElementPosition(vehicle)
                local _, _, vrot = getElementRotation(vehicle)
                
                -- Calcular posición al lado del vehículo (2 unidades de distancia)
                local angle = math.rad(vrot + 90) -- 90 grados a la derecha del vehículo
                local offsetX = math.sin(angle) * 2
                local offsetY = math.cos(angle) * 2
                
                -- Sacar al jugador del vehículo y colocarlo a un lado
                removePedFromVehicle(player)
                setElementPosition(player, vx + offsetX, vy + offsetY, vz)
                
                -- Opcional: Notificar al jugador
                outputChatBox("Has sido sacado del vehículo debido a tu estado crítico", player, 255, 0, 0)
            end
        end
    end
end

-- Ejecutar la verificación cada segundo
setTimer(checkPlayerHealth, 1000, 0)
