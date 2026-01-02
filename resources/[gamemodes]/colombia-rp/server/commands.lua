-- Sistema de Comandos del Servidor

-- Función para verificar si un jugador es admin
function isPlayerAdmin(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    local role = getElementData(player, "account:role")
    return role == "admin"
end

-- Comando para obtener coordenadas (solo admin)
addCommandHandler("coords", function(player, cmd)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
        return
    end
    
    local x, y, z = getElementPosition(player)
    local rotation = getPedRotation(player)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    
    -- Mostrar coordenadas en el chat
    outputChatBox("═══════════════════════════════════", player, 0, 255, 255)
    outputChatBox("Coordenadas actuales:", player, 255, 255, 0)
    outputChatBox("X: " .. string.format("%.2f", x), player, 255, 255, 255)
    outputChatBox("Y: " .. string.format("%.2f", y), player, 255, 255, 255)
    outputChatBox("Z: " .. string.format("%.2f", z), player, 255, 255, 255)
    outputChatBox("Rotación: " .. string.format("%.2f", rotation), player, 255, 255, 255)
    outputChatBox("Interior: " .. interior, player, 255, 255, 255)
    outputChatBox("Dimensión: " .. dimension, player, 255, 255, 255)
    outputChatBox("═══════════════════════════════════", player, 0, 255, 255)
    
    -- También mostrar en consola del servidor
    outputServerLog("[COORDS] " .. getPlayerName(player) .. " - X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ", Rotación: " .. rotation .. ", Interior: " .. interior .. ", Dimensión: " .. dimension)
end)

-- Comando alternativo más corto
addCommandHandler("pos", function(player, cmd)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
        return
    end
    
    local x, y, z = getElementPosition(player)
    local rotation = getPedRotation(player)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    
    -- Mostrar coordenadas en formato compacto
    local coordsString = string.format("Pos: %.2f, %.2f, %.2f | Rot: %.2f | Int: %d | Dim: %d", x, y, z, rotation, interior, dimension)
    outputChatBox(coordsString, player, 0, 255, 255)
    
    -- También mostrar en consola del servidor
    outputServerLog("[COORDS] " .. getPlayerName(player) .. " - " .. coordsString)
end)

-- Comando para revivir jugador en el lugar donde murió (solo admin) - Por ID de personaje
addCommandHandler("revivir", function(player, cmd, characterIdStr)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
        return
    end
    
    if not characterIdStr then
        outputChatBox("Uso: /revivir [ID del personaje]", player, 255, 255, 0)
        outputChatBox("Ejemplo: /revivir 1", player, 255, 255, 0)
        return
    end
    
    local characterId = tonumber(characterIdStr)
    if not characterId then
        outputChatBox("El ID debe ser un número. Uso: /revivir [ID del personaje]", player, 255, 0, 0)
        return
    end
    
    -- Buscar jugador con ese ID de personaje
    local target = nil
    for _, p in ipairs(getElementsByType("player")) do
        if getElementData(p, "character:selected") then
            local pCharId = getElementData(p, "character:id")
            if pCharId and tonumber(pCharId) == characterId then
                target = p
                break
            end
        end
    end
    
    if not target then
        outputChatBox("No se encontró ningún jugador con el ID de personaje " .. characterId .. ".", player, 255, 0, 0)
        return
    end
    
    -- Intentar revivir en el lugar donde murió
    if respawnAtDeathLocation(target) then
        local charName = getElementData(target, "character:name")
        local charSurname = getElementData(target, "character:surname")
        local displayName = (charName and charSurname) and (charName .. " " .. charSurname) or getPlayerName(target)
        
        outputChatBox("Has revivido a " .. displayName .. " (ID: " .. characterId .. ") en el lugar donde murió.", player, 0, 255, 0)
        outputChatBox("Un administrador te ha revivido en el lugar donde moriste.", target, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(player) .. " revivió al personaje ID " .. characterId .. " (" .. displayName .. ") en el lugar donde murió")
    else
        outputChatBox("No se pudo revivir al personaje ID " .. characterId .. ". El jugador no está muerto o no hay posición de muerte guardada.", player, 255, 0, 0)
    end
end)

-- Comando /changechar para cambiar de personaje
addCommandHandler("changechar", function(player, cmd)
    -- Verificar que el jugador tenga un personaje seleccionado
    if not getElementData(player, "character:selected") then
        outputChatBox("Error: No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    -- Enviar evento al cliente para abrir la GUI de selección de personajes
    triggerClientEvent(player, "showCharacterGUI", resourceRoot)
end)

-- Comando start (solo admin)
addCommandHandler("start", function(player, cmd, resourceName)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando. Solo administradores pueden usar /start.", player, 255, 0, 0)
        return
    end
    
    if not resourceName then
        outputChatBox("Uso: /start [nombre del recurso]", player, 255, 255, 0)
        return
    end
    
    -- Ejecutar el comando start
    local success = startResource(getResourceFromName(resourceName))
    if success then
        outputChatBox("Recurso '" .. resourceName .. "' iniciado correctamente.", player, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(player) .. " inició el recurso: " .. resourceName)
    else
        outputChatBox("Error al iniciar el recurso '" .. resourceName .. "'.", player, 255, 0, 0)
    end
end)

-- Comando stop (solo admin)
addCommandHandler("stop", function(player, cmd, resourceName)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando. Solo administradores pueden usar /stop.", player, 255, 0, 0)
        return
    end
    
    if not resourceName then
        outputChatBox("Uso: /stop [nombre del recurso]", player, 255, 255, 0)
        return
    end
    
    -- Ejecutar el comando stop
    local resource = getResourceFromName(resourceName)
    if resource then
        local success = stopResource(resource)
        if success then
            outputChatBox("Recurso '" .. resourceName .. "' detenido correctamente.", player, 0, 255, 0)
            outputServerLog("[ADMIN] " .. getPlayerName(player) .. " detuvo el recurso: " .. resourceName)
        else
            outputChatBox("Error al detener el recurso '" .. resourceName .. "'.", player, 255, 0, 0)
        end
    else
        outputChatBox("Error: No se encontró el recurso '" .. resourceName .. "'.", player, 255, 0, 0)
    end
end)

-- Comando restart (solo admin)
addCommandHandler("restart", function(player, cmd, resourceName)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando. Solo administradores pueden usar /restart.", player, 255, 0, 0)
        return
    end
    
    if not resourceName then
        outputChatBox("Uso: /restart [nombre del recurso]", player, 255, 255, 0)
        return
    end
    
    -- Ejecutar el comando restart
    local resource = getResourceFromName(resourceName)
    if resource then
        restartResource(resource)
        outputChatBox("Recurso '" .. resourceName .. "' reiniciado correctamente.", player, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(player) .. " reinició el recurso: " .. resourceName)
    else
        outputChatBox("Error: No se encontró el recurso '" .. resourceName .. "'.", player, 255, 0, 0)
    end
end)

-- Comando refresh (solo admin)
-- Comando /changechar para cambiar de personaje
addCommandHandler("changechar", function(player, cmd)
    -- Verificar que el jugador tenga un personaje seleccionado
    if not getElementData(player, "character:selected") then
        outputChatBox("Error: No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    -- Enviar evento al cliente para abrir la GUI de selección de personajes
    triggerClientEvent(player, "showCharacterGUI", resourceRoot)
end)

addCommandHandler("refresh", function(player, cmd, resourceName)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando. Solo administradores pueden usar /refresh.", player, 255, 0, 0)
        return
    end
    
    -- Si no se especifica recurso, refrescar todos
    if not resourceName then
        refreshResources(true)
        outputChatBox("Todos los recursos han sido refrescados.", player, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(player) .. " refrescó todos los recursos")
        return
    end
    
    -- Refrescar un recurso específico
    local resource = getResourceFromName(resourceName)
    if resource then
        -- Para refrescar un recurso específico, primero detenerlo y luego iniciarlo
        stopResource(resource)
        startResource(resource)
        outputChatBox("Recurso '" .. resourceName .. "' refrescado correctamente.", player, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(player) .. " refrescó el recurso: " .. resourceName)
    else
        outputChatBox("Error: No se encontró el recurso '" .. resourceName .. "'.", player, 255, 0, 0)
    end
end)

