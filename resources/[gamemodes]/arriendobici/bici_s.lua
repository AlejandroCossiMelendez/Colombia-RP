function crearbici(player)
    local x, y, z = getElementPosition(player)
    local xr, yr, zr = getElementRotation(player)
    local dinero = getPlayerMoney(player)
    outputChatBox("Su dinero es de $" .. dinero, 0, 255, 0)
    if (dinero >= 150) then-- Si Es Mayor o igual , podra arrendar
    takePlayerMoney(player, 150)-- Esto es lo que le quita al jugador
    auto = createVehicle ( 509, x, y+2, z)-- El auto que se le ordena crear al ejecutar el comando
    setElementRotation(auto, xr, yr, zr)
    warpPedIntoVehicle( player, auto)
    outputChatBox("Ha arrendado su bicicleta con exito!. Valor= $150", player, 0, 255, 0)
	addEventHandler('onVehicleExit', auto, function(thePlayer)
  destroyElement(auto) -- También se puede destroyElement(source)
  outputChatBox("((Se ha terminado su tiempo))", player, 255, 0, 0)
end , false)

else 
    outputChatBox("((No tienes el dinero suficiente.))", player, 255, 0, 0)
end
end

addCommandHandler ("arrendarbici", crearbici )