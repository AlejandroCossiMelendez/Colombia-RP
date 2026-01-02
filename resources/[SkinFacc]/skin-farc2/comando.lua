function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 10) then
    setElementModel(player, 11)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de las farc", player, 255, 0, 0)
 end
end
addCommandHandler("rfarc1", cambiarModelo)