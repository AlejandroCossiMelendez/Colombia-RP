function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 35) then
    setElementModel(player, 61)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de avianca", player, 255, 0, 0)
 end
end
addCommandHandler("ravi", cambiarModelo)
