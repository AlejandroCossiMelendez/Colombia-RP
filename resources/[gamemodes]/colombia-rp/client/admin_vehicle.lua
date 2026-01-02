-- Sistema de creación de vehículos para el panel de admin
-- Calcula la posición delante del jugador usando la cámara

-- Evento para calcular la posición del vehículo delante del jugador
addEvent("admin:calculateVehiclePosition", true)
addEventHandler("admin:calculateVehiclePosition", root, function(vehicleId, adminX, adminY, adminZ, adminRotation, adminInterior, adminDimension)
    -- Obtener posición actual del jugador (más precisa que la del servidor)
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    
    -- Intentar obtener la dirección desde la cámara
    local camX, camY, camZ, lookX, lookY, lookZ = getCameraMatrix()
    local dirX, dirY, dirZ
    
    if camX and camY and camZ and lookX and lookY and lookZ then
        -- Calcular vector de dirección desde la cámara hacia donde mira
        dirX = lookX - camX
        dirY = lookY - camY
        dirZ = lookZ - camZ
        
        -- Normalizar el vector de dirección
        local length = math.sqrt(dirX * dirX + dirY * dirY + dirZ * dirZ)
        if length > 0.01 then
            dirX = dirX / length
            dirY = dirY / length
            dirZ = dirZ / length
        else
            -- Si la dirección de la cámara no es válida, usar la rotación del ped
            local rotationRad = math.rad(adminRotation)
            dirX = -math.sin(rotationRad)
            dirY = math.cos(rotationRad)
            dirZ = 0
        end
    else
        -- Si no hay cámara válida, usar la rotación del ped
        local rotationRad = math.rad(adminRotation)
        dirX = -math.sin(rotationRad)
        dirY = math.cos(rotationRad)
        dirZ = 0
    end
    
    -- Calcular posición 5 metros delante usando la posición del jugador
    local distanceFront = 5.0
    local frontX = playerX + dirX * distanceFront
    local frontY = playerY + dirY * distanceFront
    local frontZ = playerZ + dirZ * distanceFront
    
    -- Verificar altura del suelo en la posición calculada
    local hit, hitX, hitY, hitZ = processLineOfSight(frontX, frontY, playerZ + 20, frontX, frontY, playerZ - 50, true, true, false, true, false, false, false, false, localPlayer)
    if hit and hitZ then
        frontZ = hitZ + 0.5
    else
        -- Si no hay suelo detectado, usar la altura del jugador + un pequeño offset
        frontZ = playerZ + 0.5
    end
    
    -- Asegurar que la altura mínima sea razonable
    if frontZ < 5.0 then
        frontZ = playerZ + 0.5
    end
    
    -- Calcular rotación del vehículo basada en la dirección
    local vehicleRotation = math.deg(math.atan2(-dirX, dirY))
    if vehicleRotation < 0 then
        vehicleRotation = vehicleRotation + 360
    end
    
    -- Debug: mostrar información
    outputChatBox("Calculando posición del vehículo...", 255, 255, 0)
    outputChatBox("Tu posición: " .. string.format("%.2f, %.2f, %.2f", playerX, playerY, playerZ), 255, 255, 255)
    outputChatBox("Posición vehículo: " .. string.format("%.2f, %.2f, %.2f", frontX, frontY, frontZ), 255, 255, 255)
    outputChatBox("Distancia: " .. string.format("%.2f", getDistanceBetweenPoints3D(playerX, playerY, playerZ, frontX, frontY, frontZ)) .. " metros", 255, 255, 255)
    
    -- Enviar al servidor para crear el vehículo
    triggerServerEvent("admin:createVehicleAtPosition", localPlayer, vehicleId, frontX, frontY, frontZ, vehicleRotation, adminInterior, adminDimension)
end)

