function gameOver()
    local player = source
    setPedHeadless(player, true)
    --Establecer la salud en 1, si se pone en cero da muerte definitiva
    setElementHealth(player, 1)
end

addEvent ("onGameOver", true)
addEventHandler ("onGameOver", getRootElement(), gameOver)
