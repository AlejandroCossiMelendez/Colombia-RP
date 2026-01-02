function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 51) then
    setElementModel(player, 252)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No tienes acceso al comando", player, 255, 0, 0)
 end
end
addCommandHandler("rcda", cambiarModelo)
