-- Sistema de Garaje
-- Comando /garaje para pedir vehículos

-- Función para obtener los vehículos de un jugador
function getPlayerVehicles(characterId)
    if not characterId then
        return {}
    end
    
    local query = queryDatabase("SELECT id, model, plate, fuel, locked FROM vehicles WHERE owner_id = ? ORDER BY id DESC", characterId)
    
    if query and #query > 0 then
        return query
    end
    
    return {}
end

-- Comando /garaje
addCommandHandler("garaje", function(player)
    local characterId = getElementData(player, "character:id")
    if not characterId then
        outputChatBox("Tu personaje no está completamente cargado.", player, 255, 0, 0)
        return
    end
    
    -- Obtener vehículos del jugador
    local vehicles = getPlayerVehicles(characterId)
    
    if #vehicles == 0 then
        outputChatBox("No tienes vehículos en tu garaje.", player, 255, 255, 0)
        return
    end
    
    -- Enviar vehículos al cliente
    triggerClientEvent(player, "garage:openPanel", player, vehicles)
end)

-- Evento para solicitar un vehículo del garaje
addEvent("garage:requestVehicle", true)
addEventHandler("garage:requestVehicle", root, function(vehicleId)
    if not isElement(source) or getElementType(source) ~= "player" then
        return
    end
    
    local characterId = getElementData(source, "character:id")
    if not characterId then
        outputChatBox("Tu personaje no está completamente cargado.", source, 255, 0, 0)
        return
    end
    
    -- Verificar que el vehículo pertenece al jugador
    local query = queryDatabase("SELECT * FROM vehicles WHERE id = ? AND owner_id = ?", vehicleId, characterId)
    
    if not query or #query == 0 then
        outputChatBox("Este vehículo no te pertenece.", source, 255, 0, 0)
        return
    end
    
    local vehicleData = query[1]
    
    -- Verificar dinero ($10,000,000)
    local cost = 10000000
    local playerMoney = getCharacterMoney(source)
    
    if playerMoney < cost then
        outputChatBox("No tienes suficiente dinero. Necesitas $" .. cost .. " y tienes $" .. playerMoney, source, 255, 0, 0)
        return
    end
    
    -- Cobrar el dinero
    if not takeCharacterMoney(source, cost) then
        outputChatBox("Error al procesar el pago.", source, 255, 0, 0)
        return
    end
    
    outputChatBox("Has pagado $" .. cost .. " por el servicio de garaje.", source, 0, 255, 0)
    outputChatBox("Tu vehículo llegará en 20 segundos...", source, 255, 255, 0)
    
    -- Enviar datos del vehículo al cliente para spawn después de 20 segundos
    setTimer(function()
        -- Verificar que el jugador sigue conectado
        if not isElement(source) or getElementType(source) ~= "player" then
            return
        end
        
        -- Obtener posición del jugador
        local px, py, pz = getElementPosition(source)
        local rotation = getPedRotation(source)
        local interior = getElementInterior(source)
        local dimension = getElementDimension(source)
        
        -- Calcular posición 5 metros delante del jugador
        local rotationRad = math.rad(rotation)
        local distanceFront = 5.0
        local frontX = px - math.sin(rotationRad) * distanceFront
        local frontY = py + math.cos(rotationRad) * distanceFront
        local frontZ = pz + 0.5 -- Pequeño offset para evitar que se hunda
        
        -- Verificar si el vehículo ya existe en el juego
        local existingVehicle = nil
        for _, veh in ipairs(getElementsByType("vehicle")) do
            local vehDbId = getElementData(veh, "vehicle:db_id") or getElementData(veh, "vehicle:id")
            if vehDbId and tonumber(vehDbId) == vehicleId then
                existingVehicle = veh
                break
            end
        end
        
        if existingVehicle and isElement(existingVehicle) then
            -- Si el vehículo ya existe, moverlo a la nueva posición
            setElementPosition(existingVehicle, frontX, frontY, frontZ)
            setElementRotation(existingVehicle, 0, 0, rotation)
            setElementDimension(existingVehicle, dimension)
            setElementInterior(existingVehicle, interior)
            outputChatBox("Tu vehículo ha sido movido a tu ubicación.", source, 0, 255, 0)
        else
            -- Crear el vehículo desde la base de datos
            local vehicle = createVehicle(vehicleData.model, frontX, frontY, frontZ, 0, 0, rotation)
            
            if vehicle then
                -- Configurar el vehículo
                setElementDimension(vehicle, dimension)
                setElementInterior(vehicle, interior)
                setVehiclePlateText(vehicle, vehicleData.plate)
                setVehicleLocked(vehicle, vehicleData.locked == 1)
                
                -- Restaurar combustible
                local fuel = vehicleData.fuel or 100
                setElementData(vehicle, "vehicle:fuel", fuel)
                
                -- Guardar datos en elementData
                setElementData(vehicle, "vehicle:id", vehicleId)
                setElementData(vehicle, "vehicle:db_id", vehicleId)
                setElementData(vehicle, "vehicle:plate", vehicleData.plate)
                setElementData(vehicle, "vehicle:owner_id", characterId)
                setElementData(vehicle, "vehicle:locked", vehicleData.locked == 1)
                
                -- Actualizar posición en la base de datos
                executeDatabase("UPDATE vehicles SET x = ?, y = ?, z = ?, rot_z = ?, interior = ?, dimension = ? WHERE id = ?", 
                    frontX, frontY, frontZ, rotation, interior, dimension, vehicleId)
                
                outputChatBox("✓ Tu vehículo '" .. (getVehicleNameFromModel(vehicleData.model) or "Vehículo") .. "' ha llegado!", source, 0, 255, 0)
                outputChatBox("Matrícula: " .. vehicleData.plate, source, 255, 255, 0)
            else
                outputChatBox("Error al crear el vehículo. Contacta a un administrador.", source, 255, 0, 0)
            end
        end
    end, 20000, 1) -- 20 segundos
end)

