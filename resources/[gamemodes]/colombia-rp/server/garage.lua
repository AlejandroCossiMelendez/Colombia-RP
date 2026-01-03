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
    
    -- Verificar que el vehículo pertenece al jugador (incluir handbrake)
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
    
    -- Capturar el jugador y los datos antes del timer
    local player = source
    local playerCharId = characterId
    local vehModel = vehicleData.model
    local vehPlate = vehicleData.plate
    local vehLocked = vehicleData.locked
    local vehFuel = vehicleData.fuel or 100
    local vehId = vehicleId
    
    outputServerLog("[GARAGE] Timer iniciado para " .. getPlayerName(player) .. " - Vehículo ID: " .. vehId .. " (" .. vehPlate .. ")")
    
    -- Enviar datos del vehículo al cliente para spawn después de 20 segundos
    setTimer(function()
        outputServerLog("[GARAGE] Timer ejecutado para " .. (isElement(player) and getPlayerName(player) or "DESCONECTADO") .. " - Vehículo ID: " .. vehId)
        
        -- Verificar que el jugador sigue conectado
        if not isElement(player) or getElementType(player) ~= "player" then
            outputServerLog("[GARAGE] ERROR: El jugador se desconectó antes de que llegara el vehículo.")
            return
        end
        
        -- Obtener posición del jugador
        local px, py, pz = getElementPosition(player)
        local rotation = getPedRotation(player)
        local interior = getElementInterior(player)
        local dimension = getElementDimension(player)
        
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
            if vehDbId and tonumber(vehDbId) == vehId then
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
            outputChatBox("Tu vehículo ha sido movido a tu ubicación.", player, 0, 255, 0)
            outputServerLog("[GARAGE] Vehículo " .. vehPlate .. " movido para " .. getPlayerName(player))
        else
            -- Crear el vehículo desde la base de datos
            local vehicle = createVehicle(vehModel, frontX, frontY, frontZ, 0, 0, rotation)
            
            if vehicle then
                -- Configurar el vehículo
                setElementDimension(vehicle, dimension)
                setElementInterior(vehicle, interior)
                setVehiclePlateText(vehicle, vehPlate)
                setVehicleLocked(vehicle, vehLocked == 1)
                
                -- Restaurar combustible
                setElementData(vehicle, "vehicle:fuel", vehFuel)
                
                -- Guardar datos en elementData
                setElementData(vehicle, "vehicle:id", vehId)
                setElementData(vehicle, "vehicle:db_id", vehId)
                setElementData(vehicle, "vehicle:plate", vehPlate)
                setElementData(vehicle, "vehicle:owner_id", playerCharId)
                setElementData(vehicle, "vehicle:locked", vehLocked == 1)
                
                -- Restaurar estado del freno de mano
                local handbrake = vehicleData.handbrake or 0
                if handbrake == 1 then
                    setElementFrozen(vehicle, true)
                    setElementData(vehicle, "vehicle:handbrake", true)
                else
                    setElementFrozen(vehicle, false)
                    setElementData(vehicle, "vehicle:handbrake", false)
                end
                
                -- Actualizar posición en la base de datos
                executeDatabase("UPDATE vehicles SET x = ?, y = ?, z = ?, rot_z = ?, interior = ?, dimension = ? WHERE id = ?", 
                    frontX, frontY, frontZ, rotation, interior, dimension, vehId)
                
                local vehicleName = getVehicleNameFromModel(vehModel) or "Vehículo"
                outputChatBox("✓ Tu vehículo '" .. vehicleName .. "' ha llegado!", player, 0, 255, 0)
                outputChatBox("Matrícula: " .. vehPlate, player, 255, 255, 0)
                outputServerLog("[GARAGE] Vehículo " .. vehPlate .. " creado para " .. getPlayerName(player) .. " en " .. string.format("%.2f, %.2f, %.2f", frontX, frontY, frontZ))
            else
                outputChatBox("Error al crear el vehículo. Contacta a un administrador.", player, 255, 0, 0)
                outputServerLog("[GARAGE] ERROR: No se pudo crear el vehículo " .. vehPlate .. " para " .. getPlayerName(player))
            end
        end
    end, 20000, 1) -- 20 segundos
end)

