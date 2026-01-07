local marker = createMarker(1693.9884033203, -2294.8310546875, 13.377690315247 -1, "cylinder", 1.3, 0, 255, 0, 150)

-- Ya no necesitamos crear el texto 3D aquí, se renderiza desde el cliente
-- local markerText = createElement("text")
-- setElementPosition(markerText, 2305.7265625, -90.1865234375, 26.331750869751 + 0.5)
-- setElementData(markerText, "text", "Reclama tu kit de Bienvenida")

addEventHandler("onMarkerHit", marker, function(hitPlayer, matchingDimension)
    if isElement(hitPlayer) and getElementType(hitPlayer) == "player" and matchingDimension then
        -- Verificar si el jugador ya reclamó el kit
        if yaReclamoKit(hitPlayer) then
            exports.a_infobox:addBox(hitPlayer, "Ya has reclamado tu kit de bienvenida anteriormente.", "info")
        else
            triggerClientEvent(hitPlayer, "verificarKit", hitPlayer)
        end
    end
end)

function yaReclamoKit(player)
    local userID = exports.players:getUserID(player)

    if not userID then
        outputDebugString("Error: No se pudo obtener el userID del jugador.", 1)
        return false
    end

    local result = exports.sql:query_assoc_single("SELECT kit FROM wcf1_user WHERE userID = ".. userID)

    if result and result.kit == "reclamado" then
        return true
    end

    return false
end

function marcarKitReclamado(player)
    local userID = exports.players:getUserID(player)

    if not userID then
        outputDebugString("Error: No se pudo obtener el userID del jugador para marcar el kit.", 1)
        exports.a_infobox:addBox(player, "Error al procesar tu solicitud. Contacta a un administrador.", "error")
        return false
    end

    local query = string.format("UPDATE wcf1_user SET kit = 'reclamado' WHERE userID = ".. userID)
    local success = exports.sql:query_free(query)

    if success then
        outputDebugString("Kit marcado como reclamado para userID " .. userID, 3)
        return true
    else
        outputDebugString("Error al actualizar el kit para userID " .. userID .. ". Consulta: " .. query, 1)
        exports.a_infobox:addBox(player, "Error al guardar tu progreso. Contacta a un administrador.", "error")
        return false
    end
end

function darDinero(player)
    exports.players:giveMoney(player, 2000000)
    exports.a_infobox:addBox(player, "¡Has recibido $2,000,000 como parte de tu kit de bienvenida!", "success")
end

function darCarro(player, vehicleID)
    if yaReclamoKit(player) then
        exports.a_infobox:addBox(player, "Ya has reclamado tu kit de bienvenida. No puedes reclamarlo más de una vez.", "error")
        return
    end

    local x, y, z = getElementPosition(player)
    local carro = exports.vehicles:createVehicleFromKit(player, vehicleID, x, y, z, 0, 0, 0)
    
    if carro then
        -- Notificación con detalles del vehículo
        exports.a_infobox:addBox(player, "¡Has recibido una moto YZ para explorar la ciudad!", "success")
        
        -- Dar dinero y marcar como reclamado
        darDinero(player)
        marcarKitReclamado(player)
    else
        exports.a_infobox:addBox(player, "Error al crear tu vehículo. Contacta a un administrador.", "error")
    end
end

addEvent("darCarro", true)
addEventHandler("darCarro", root, function(vehicleID)
    darCarro(client, vehicleID)
end)

addEvent("darKitBienvenida", true)
addEventHandler("darKitBienvenida", root, function()
    darCarro(client, 468) -- Sanchez (moto YZ)
end)

addEvent("verificarKit", true)
addEventHandler("verificarKit", root, function()
    local puedeReclamar = not yaReclamoKit(client)
    triggerClientEvent(client, "mostrarKitPanel", client, puedeReclamar)
end)
