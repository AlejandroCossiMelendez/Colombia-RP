-- ✅ Evento para obtener vehículos de la facción
addEvent("sacarvehfaccion", true)
addEventHandler("sacarvehfaccion", root, function()
    if not isElement(source) then return end -- Asegurar que el jugador es válido

    local factionID = nil
    for i = 1, 22 do
        if exports.factions:isPlayerInFaction(source, i) then
            factionID = -i
            break
        end
    end

    if not factionID then
        exports.a_infobox:addBox(source, "No perteneces a ninguna facción.", "error")
        return
    end

    -- 📌 Obtener los vehículos de la facción
    local query = exports.sql:query_assoc("SELECT vehicleID FROM vehicles WHERE characterID = " .. factionID)

    if not query then
        exports.a_infobox:addBox(source, "Error en la base de datos.", "error")
        return
    end

    local vehicles = {}
    local vehiclesInfo = {}
    
    for _, row in ipairs(query) do
        local vehID = tonumber(row.vehicleID)
        table.insert(vehicles, vehID)
        
        -- Obtener información adicional del vehículo
        local vehInfo = getVehicleInfoForClient(vehID)
        vehiclesInfo[tostring(vehID)] = vehInfo
    end

    -- 🚀 Enviar la lista de vehículos, la información y la facción al cliente
    triggerClientEvent(source, "showFactionVehiclesPanel", source, vehicles, factionID, vehiclesInfo)
end)

-- Función para obtener información del vehículo para el cliente
function getVehicleInfoForClient(vehID)
    if not vehID then return nil end
    
    -- Intentar obtener el vehículo
    local vehicle = nil
    
    -- Intentar obtener el vehículo directamente
    vehicle = exports.vehicles:getVehicle(vehID)
    
    -- Si no se pudo obtener el vehículo o no es un elemento válido
    if not isElement(vehicle) then
        -- Intentar obtener información de la base de datos
        local vehicleData = exports.sql:query_assoc_single("SELECT model, numberplate FROM vehicles WHERE vehicleID = " .. vehID)
        
        -- Si tenemos datos de la base de datos
        if vehicleData and vehicleData.model then
            local modelName = getVehicleNameFromModel(vehicleData.model) or "Desconocido"
            local plate = vehicleData.numberplate or "N/A"
            
            return {
                exists = false,
                model = vehicleData.model,
                modelName = modelName,
                plate = plate,
                fuel = "N/A",
                inUse = false
            }
        else
            -- Si no hay datos, devolver información genérica
            return {
                exists = false,
                model = "N/A",
                modelName = "Vehículo no disponible",
                plate = "N/A",
                fuel = "N/A",
                inUse = false
            }
        end
    end
    
    -- Si llegamos aquí, el vehículo existe y es válido
    local model = getElementModel(vehicle)
    local modelName = getVehicleNameFromModel(model) or "Desconocido"
    local plate = getVehiclePlateText(vehicle) or "N/A"
    
    -- Obtener nivel de combustible
    local fuel = "100%"
    local fuelLevel = getElementData(vehicle, "fuel")
    if fuelLevel then
        fuel = math.floor(tonumber(fuelLevel)) .. "%"
    end
    
    -- Verificar si está en uso (comprobar todos los asientos)
    local inUse = false
    for seat = 0, getVehicleMaxPassengers(vehicle) or 3 do
        if getVehicleOccupant(vehicle, seat) then
            inUse = true
            break
        end
    end
    
    -- Verificar si el vehículo ha sido movido de su posición original
    local originalPos = getElementData(vehicle, "position")
    local currentX, currentY, currentZ = getElementPosition(vehicle)
    local movedFromSpawn = false
    
    if originalPos then
        local distance = getDistanceBetweenPoints3D(currentX, currentY, currentZ, originalPos[1], originalPos[2], originalPos[3])
        movedFromSpawn = distance > 5 -- Si está a más de 5 unidades de su posición original
    end
    
    -- Verificar el tiempo desde el último uso
    local lastUsed = getElementData(vehicle, "lastUsed") or 0
    local currentTime = getTickCount()
    local timeSinceLastUse = (currentTime - lastUsed) / 1000 / 60 -- en minutos
    
    -- Un vehículo se considera en uso si:
    -- 1. Tiene ocupantes actualmente
    -- 2. Ha sido movido recientemente Y no ha pasado suficiente tiempo desde su último uso
    local actuallyInUse = inUse or (movedFromSpawn and timeSinceLastUse <= 5)
    
    -- Si el vehículo ha sido movido pero no tiene ocupantes y han pasado más de 5 minutos,
    -- considerarlo como disponible y actualizar su posición
    if movedFromSpawn and not inUse and timeSinceLastUse > 5 then
        setElementData(vehicle, "position", {currentX, currentY, currentZ})
    end
    
    -- Si el vehículo está siendo usado actualmente, actualizar su tiempo de uso
    if inUse then
        setElementData(vehicle, "lastUsed", currentTime)
    end
    
    return {
        exists = true,
        model = model,
        modelName = modelName,
        plate = plate,
        fuel = fuel,
        inUse = actuallyInUse,
        lastUsedMinutes = math.floor(timeSinceLastUse)
    }
end

-- 🚗 Evento para pedir un vehículo con retraso de 20 segundos
addEvent("pedirvehf", true)
addEventHandler("pedirvehf", root, function(vehID)
    if not isElement(source) then return end -- Asegurar que el jugador es válido
    local player = source

    vehID = tonumber(vehID)
    if not vehID then
        exports.a_infobox:addBox(player, "ID de vehículo inválido.", "error")
        return
    end

    -- 📌 Verificar la facción del jugador
    local factionID = nil
    for i = 1, 22 do
        if exports.factions:isPlayerInFaction(player, i) then
            factionID = -i
            break
        end
    end

    if not factionID then
        exports.a_infobox:addBox(player, "No perteneces a ninguna facción.", "error")
        return
    end

    -- 📌 Verificar si el vehículo pertenece a la facción
    local sql = exports.sql:query_assoc_single("SELECT * FROM vehicles WHERE vehicleID = " .. vehID .. " AND characterID = " .. factionID)
    if not sql or not sql.vehicleID then
        exports.a_infobox:addBox(player, "Este vehículo no pertenece a tu facción.", "error")
        return
    end

    -- 📌 Verificar si el vehículo está disponible
    local vehicle = exports.vehicles:getVehicle(vehID)
    if not vehicle then
        exports.a_infobox:addBox(player, "El vehículo no está disponible. Intenta más tarde.", "error")
        return
    end

    -- Verificar si el vehículo está en uso (comprobar todos los asientos)
    local inUse = false
    for seat = 0, getVehicleMaxPassengers(vehicle) or 3 do
        if getVehicleOccupant(vehicle, seat) then
            inUse = true
            break
        end
    end
    
    if inUse then
        exports.a_infobox:addBox(player, "El vehículo ya está siendo utilizado por otro jugador.", "error")
        return
    end

    -- 🚀 Notificar y esperar 20 segundos antes de mover el vehículo
    exports.a_infobox:addBox(player, "El vehículo llegará en 20 segundos...", "info")

    setTimer(function()
        if not isElement(vehicle) or not isElement(player) then return end

        -- 📌 Verificar si alguien subió al vehículo mientras esperaba
        local occupied = false
        for seat = 0, getVehicleMaxPassengers(vehicle) or 3 do
            if getVehicleOccupant(vehicle, seat) then
                occupied = true
                break
            end
        end
        
        if occupied then
            exports.a_infobox:addBox(player, "El vehículo fue ocupado mientras esperabas. No se movió.", "error")
            return
        end

        -- 🚀 Teletransportar el vehículo cerca del jugador
        local x, y, z = getElementPosition(player)
        setElementPosition(vehicle, x, y + 2, z)
        setElementDimension(vehicle, getElementDimension(player))
        setElementInterior(vehicle, getElementInterior(player))
        
        -- Registrar el uso del vehículo
        setElementData(vehicle, "lastUsed", getTickCount())
        
        -- Guardar la nueva posición como posición actual
        setElementData(vehicle, "position", {x, y + 2, z})

        exports.a_infobox:addBox(player, "El vehículo ha llegado.", "success")
    end, 20000, 1) -- 20 segundos
end)

-- 🔄 Evento para regenerar un vehículo de facción
addEvent("regenerarVehiculoFaccion", true)
addEventHandler("regenerarVehiculoFaccion", root, function(vehID)
    if not isElement(source) then return end -- Asegurar que el jugador es válido
    local player = source

    vehID = tonumber(vehID)
    if not vehID then
        exports.a_infobox:addBox(player, "ID de vehículo inválido.", "error")
        return
    end

    -- 📌 Verificar la facción del jugador
    local factionID = nil
    for i = 1, 22 do
        if exports.factions:isPlayerInFaction(player, i) then
            factionID = -i
            break
        end
    end

    if not factionID then
        exports.a_infobox:addBox(player, "No perteneces a ninguna facción.", "error")
        return
    end

    -- 📌 Verificar si el vehículo pertenece a la facción
    local sql = exports.sql:query_assoc_single("SELECT * FROM vehicles WHERE vehicleID = " .. vehID .. " AND characterID = " .. factionID)
    if not sql or not sql.vehicleID then
        exports.a_infobox:addBox(player, "Este vehículo no pertenece a tu facción.", "error")
        return
    end

    -- 📌 Verificar si el vehículo existe
    local vehicle = exports.vehicles:getVehicle(vehID)
    if not vehicle then
        exports.a_infobox:addBox(player, "El vehículo no está disponible. Intenta más tarde.", "error")
        return
    end

    -- 📌 Verificar si el vehículo está ocupado (comprobar todos los asientos)
    local inUse = false
    for seat = 0, getVehicleMaxPassengers(vehicle) or 3 do
        if getVehicleOccupant(vehicle, seat) then
            inUse = true
            break
        end
    end
    
    if inUse then
        exports.a_infobox:addBox(player, "No se puede regenerar un vehículo ocupado.", "error")
        return
    end

    -- 🔄 Regenerar el vehículo usando la lógica del comando proporcionado
    local success = true
    
    -- Verificar si tiene cepo (si existe esa funcionalidad)
    if getElementData(vehicle, "cepo") then
        fixVehicle(vehicle)
        exports.a_infobox:addBox(player, "El vehículo tiene un cepo puesto, vehículo reparado en su posición actual.", "warning")
    else
        -- Regenerar el vehículo directamente con la función nativa
        respawnVehicle(vehicle)
        
        -- Restaurar la matrícula si es necesario
        if not getElementData(vehicle, "tapada") == true then
            local plateText = tostring(string.format("%04d", vehID))
            setVehiclePlateText(vehicle, plateText)
        else
            setVehiclePlateText(vehicle, "TAPADA")
        end
        
        -- Guardar el vehículo si existe esa función
        if exports.vehicles and exports.vehicles.saveVehicle then
            exports.vehicles:saveVehicle(vehicle)
        end
        
        -- Congelar el vehículo para evitar que se mueva
        setElementFrozen(vehicle, true)
        
        -- Actualizar dimensión e interior para los ocupantes (si hay)
        for seat, occupant in pairs(getVehicleOccupants(vehicle) or {}) do
            setElementDimension(occupant, getElementDimension(vehicle))
            setElementInterior(occupant, getElementInterior(vehicle))
        end
    end
    
    if success then
        -- Actualizar los datos del vehículo
        local spawnX, spawnY, spawnZ = getElementPosition(vehicle)
        setElementData(vehicle, "position", {spawnX, spawnY, spawnZ})
        setElementData(vehicle, "lastUsed", 0) -- Reiniciar el tiempo de último uso
        
        -- Reparar el vehículo completamente
        fixVehicle(vehicle)
        
        exports.a_infobox:addBox(player, "El vehículo ha sido regenerado correctamente.", "success")
        outputChatBox("Regeneraste el vehículo con el ID " .. vehID .. " (" .. getVehicleName(vehicle) .. ").", player, 0, 255, 153)
    else
        exports.a_infobox:addBox(player, "No se pudo regenerar el vehículo. Intenta más tarde.", "error")
    end
end)

-- 🔄 Evento para actualizar la información de un vehículo específico
addEvent("requestVehicleInfo", true)
addEventHandler("requestVehicleInfo", root, function(vehID)
    if not isElement(source) or not vehID then return end
    
    local vehInfo = getVehicleInfoForClient(vehID)
    triggerClientEvent(source, "receiveVehicleInfo", source, vehID, vehInfo)
end)

-- 🔄 Evento para forzar la actualización de todos los vehículos
addEvent("forceRefreshAllVehicles", true)
addEventHandler("forceRefreshAllVehicles", root, function(vehiclesList)
    if not isElement(source) or not vehiclesList or type(vehiclesList) ~= "table" then return end
    
    local allVehiclesInfo = {}
    
    for _, vehID in ipairs(vehiclesList) do
        -- Obtener información actualizada del vehículo
        local vehInfo = getVehicleInfoForClient(vehID)
        
        -- Verificar si el vehículo existe
        local vehicle = exports.vehicles:getVehicle(vehID)
        
        -- Si el vehículo existe, actualizar su estado
        if isElement(vehicle) then
            -- Verificar si realmente está en uso (comprobar todos los asientos)
            local inUse = false
            for seat = 0, getVehicleMaxPassengers(vehicle) or 3 do
                if getVehicleOccupant(vehicle, seat) then
                    inUse = true
                    break
                end
            end
            
            -- Si no está en uso, actualizar su estado
            if not inUse then
                -- Verificar si ha pasado tiempo suficiente desde el último uso
                local lastUsed = getElementData(vehicle, "lastUsed") or 0
                local currentTime = getTickCount()
                local timeSinceLastUse = (currentTime - lastUsed) / 1000 / 60 -- en minutos
                
                -- Si han pasado más de 5 minutos desde el último uso, considerar el vehículo como disponible
                if timeSinceLastUse > 5 then
                    -- Actualizar la posición actual como posición de referencia
                    local x, y, z = getElementPosition(vehicle)
                    setElementData(vehicle, "position", {x, y, z})
                    
                    -- Marcar como no en uso en la información
                    vehInfo.inUse = false
                    vehInfo.lastUsedMinutes = math.floor(timeSinceLastUse)
                end
            else
                -- Si está en uso, actualizar el tiempo de último uso
                setElementData(vehicle, "lastUsed", getTickCount())
                vehInfo.inUse = true
                vehInfo.lastUsedMinutes = 0
            end
        end
        
        -- Guardar la información actualizada
        allVehiclesInfo[tostring(vehID)] = vehInfo
    end
    
    -- Enviar toda la información actualizada al cliente
    triggerClientEvent(source, "receiveAllVehiclesInfo", source, allVehiclesInfo)
end)

-- Función para registrar el uso de vehículos cuando un jugador entra
addEventHandler("onVehicleEnter", root, function(player, seat)
    if not isElement(source) then return end
    
    -- Registrar el tiempo de uso
    setElementData(source, "lastUsed", getTickCount())
    
    -- Guardar la posición actual
    local x, y, z = getElementPosition(source)
    setElementData(source, "position", {x, y, z})
end)

-- Función para detectar cuando un jugador sale del vehículo
addEventHandler("onVehicleExit", root, function(player, seat)
    if not isElement(source) then return end
    
    -- Verificar si el vehículo está completamente vacío
    local isEmpty = true
    for i = 0, getVehicleMaxPassengers(source) or 3 do
        if getVehicleOccupant(source, i) then
            isEmpty = false
            break
        end
    end
    
    -- Si el vehículo está vacío, actualizar su estado
    if isEmpty then
        -- Actualizar la posición actual
        local x, y, z = getElementPosition(source)
        setElementData(source, "position", {x, y, z})
        
        -- Actualizar el tiempo de último uso (con un pequeño retraso para que se considere disponible inmediatamente)
        local timeAgo = getTickCount() - (6 * 60 * 1000) -- 6 minutos atrás
        setElementData(source, "lastUsed", timeAgo)
        
        -- Notificar al cliente que salió del vehículo para actualizar su interfaz
        if isElement(player) then
            local vehID = getElementData(source, "vehicleID") or getElementData(source, "id")
            if vehID then
                -- Actualizar inmediatamente este vehículo
                setTimer(function()
                    if isElement(player) then
                        local vehInfo = getVehicleInfoForClient(vehID)
                        triggerClientEvent(player, "receiveVehicleInfo", player, vehID, vehInfo)
                        
                        -- Buscar todos los vehículos de la facción del jugador
                        local factionID = nil
                        for i = 1, 22 do
                            if exports.factions:isPlayerInFaction(player, i) then
                                factionID = -i
                                break
                            end
                        end
                        
                        if factionID then
                            -- Obtener todos los vehículos de la facción
                            local query = exports.sql:query_assoc("SELECT vehicleID FROM vehicles WHERE characterID = " .. factionID)
                            if query then
                                local vehiclesList = {}
                                for _, row in ipairs(query) do
                                    table.insert(vehiclesList, tonumber(row.vehicleID))
                                end
                                
                                -- Actualizar todos los vehículos de la facción
                                if #vehiclesList > 0 then
                                    local allVehiclesInfo = {}
                                    for _, vID in ipairs(vehiclesList) do
                                        local vInfo = getVehicleInfoForClient(vID)
                                        allVehiclesInfo[tostring(vID)] = vInfo
                                    end
                                    
                                    -- Enviar la información actualizada al cliente
                                    triggerClientEvent(player, "receiveAllVehiclesInfo", player, allVehiclesInfo)
                                end
                            end
                        end
                    end
                end, 500, 1)
            end
        end
    end
end)

-- Función para actualizar la posición de los vehículos cuando se mueven
addEventHandler("onElementDataChange", root, function(dataName, oldValue, newValue)
    if getElementType(source) == "vehicle" and dataName == "position" then
        -- No hacer nada, solo para evitar que se sobrescriba la posición
        return
    end
end)

-- Inicializar los datos de posición para todos los vehículos al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    -- Obtener todos los vehículos
    local allVehicles = getElementsByType("vehicle")
    
    for _, vehicle in ipairs(allVehicles) do
        -- Si el vehículo no tiene posición guardada, guardar la actual
        if not getElementData(vehicle, "position") then
            local x, y, z = getElementPosition(vehicle)
            setElementData(vehicle, "position", {x, y, z})
        end
        
        -- Si el vehículo no tiene tiempo de último uso, inicializarlo
        if not getElementData(vehicle, "lastUsed") then
            setElementData(vehicle, "lastUsed", 0)
        end
    end
end)
