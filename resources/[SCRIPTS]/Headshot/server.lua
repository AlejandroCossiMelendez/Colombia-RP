function gameOver()
    local player = source
    -- Mantener al jugador sin cabeza cuando es asesinado con headshot
    setPedHeadless(player, true)
    
    -- Establecer la salud en 1, si se pone en cero da muerte definitiva
    setElementHealth(player, 1)
    
    -- Establecer que el jugador está muerto
    setElementData(player, "muerto", true)
    
    -- Enviar evento al cliente para que se maneje la animación y controles
    triggerClientEvent(player, "onClientMuerto", player)
    
    -- Notificar a los jugadores cercanos
    local x, y, z = getElementPosition(player)
    local nearbyPlayers = getElementsWithinRange(x, y, z, 20, "player")
    for _, nearbyPlayer in ipairs(nearbyPlayers) do
        if nearbyPlayer ~= player then
            outputChatBox("Un jugador ha recibido un disparo en la cabeza cerca de ti.", nearbyPlayer, 255, 0, 0)
        end
    end
end

addEvent ("onGameOver", true)
addEventHandler ("onGameOver", getRootElement(), gameOver)
