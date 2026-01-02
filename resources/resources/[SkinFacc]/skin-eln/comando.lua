function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 11) then
    setElementModel(player, 238)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de eln", player, 255, 0, 0)
 end
end
addCommandHandler("rtrabajoeln", cambiarModelo)
