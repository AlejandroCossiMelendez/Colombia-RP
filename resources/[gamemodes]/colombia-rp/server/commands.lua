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

-- Comando para revivir jugador en el lugar donde murió (solo admin)
addCommandHandler("revivir", function(player, cmd, targetName)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
        return
    end
    
    if not targetName then
        outputChatBox("Uso: /revivir [nombre del jugador]", player, 255, 255, 0)
        return
    end
    
    local target = getPlayerFromName(targetName)
    if not target then
        outputChatBox("Jugador '" .. targetName .. "' no encontrado.", player, 255, 0, 0)
        return
    end
    
    -- Verificar que el jugador tenga un personaje seleccionado
    if not getElementData(target, "character:selected") then
        outputChatBox("El jugador " .. getPlayerName(target) .. " no tiene un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    -- Intentar revivir en el lugar donde murió
    if respawnAtDeathLocation(target) then
        outputChatBox("Has revivido a " .. getPlayerName(target) .. " en el lugar donde murió.", player, 0, 255, 0)
        outputChatBox("Un administrador te ha revivido en el lugar donde moriste.", target, 0, 255, 0)
        outputServerLog("[ADMIN] " .. getPlayerName(player) .. " revivió a " .. getPlayerName(target) .. " en el lugar donde murió")
    else
        outputChatBox("No se pudo revivir a " .. getPlayerName(target) .. ". El jugador no está muerto o no hay posición de muerte guardada.", player, 255, 0, 0)
    end
end)

