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

